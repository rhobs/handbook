# Frequently asked questions

This serves as a collection of resources that relate to FAQ around configuring/debugging the in-cluster monitoring stack. Particularly it applies to two OpenShift Projects:

* [Platform Cluster Monitoring - PM](https://docs.openshift.com/container-platform/latest/monitoring/understanding-the-monitoring-stack.html#understanding-the-monitoring-stack_understanding-the-monitoring-stack)
* [User Workload Monitoring - UWM](https://docs.openshift.com/container-platform/latest/monitoring/enabling-monitoring-for-user-defined-projects.html)

## How can I (as a monitoring developer) troubleshoot support cases?

See this [presentation](https://docs.google.com/presentation/d/1SY0xHNO-QMvhMi1kRSJlZuYnkuZ3nFLJvWjG0CM7wgw/edit) to understand which tools are at your disposal.

## How do I understand why targets aren't discovered and metrics are missing?

Both `PM` and `UWM` monitoring stacks rely on the `ServiceMonitor` and `PodMonitor` custom resources in order to tell Prometheus which endpoints to scrape.

The examples below show the namespace `openshift-monitoring`, which can be replaced with `openshift-user-workload-monitoring` when dealing with `UWM`.

A detailed description of how the resources are linked exists [here](https://prometheus-operator.dev/docs/operator/troubleshooting/#troubleshooting-servicemonitor-changes), but we will walk through some common issues to debug the case of missing metrics.

1. Ensure the `serviceMonitorSelector` in the `Prometheus` CR matches the key in the `ServiceMonitor` labels.
2. The `Service` you want to scrape *must* have an explicitly named port.
3. The `ServiceMonitor` *must* reference the `port` by this name.
4. The label selector in the `ServiceMonitor` must match an existing `Service`.

Assuming this criteria is met but the metrics don't exist, we can try debug the cause.

There is a possibility Prometheus has not loaded the configuration yet. The following metrics will help to determine if that is in fact the case or if there are errors in the configuration:

```bash
prometheus_config_last_reload_success_timestamp_seconds
prometheus_config_last_reload_successful
```

If there are errors with reloading the configuration, it is likely the configuration itself is invalid and examining the logs will highlight this.

```bash
oc logs -n openshift-monitoring prometheus-k8s-0 -c <container-name>
```

Assuming that the reload was a success then the Prometheus should see the configuration.

```bash
oc exec -n openshift-monitoring prometheus-k8s-0 -c prometheus -- curl http://localhost:9090/api/v1/status/config | grep "<service-monitor-name>"
```

If the `ServiceMonitor` does not exist in the output, the next step would be to investigate the logs of both `prometheus` and the `prometheus-operator` for errors.

Assuming it does exist then we know `prometheus-operator` is doing its job. Double check the `ServiceMonitor` definition.

Check the service discovery endpoint to ensure Prometheus can discover the target. It will need the appropriate RBAC to do so. An example can be found [here](https://github.com/openshift/cluster-monitoring-operator/blob/23201e012586d4864ca23593621f843179c47412/assets/prometheus-k8s/role-specific-namespaces.yaml#L35-L50).

## How do I troubleshoot the TargetDown alert?

First of all, check the [TargetDown runbook](https://github.com/openshift/runbooks/blob/master/alerts/cluster-monitoring-operator/TargetDown.md).

We have, in the past seen cases where the `TargetDown` alert was firing when all endpoints appeared to be up. The following commands fetch some useful metrics to help identify the cause.

As the alert fires, get the list of active targets in Prometheus

```bash
oc exec -n openshift-monitoring prometheus-k8s-0 -c prometheus -- curl http://localhost:9090/api/v1/targets?state=active > targets.prometheus-k8s-0.json

oc exec -n openshift-monitoring prometheus-k8s-1 -c prometheus -- curl http://localhost:9090/api/v1/targets?state=active > targets.prometheus-k8s-1.json
```

---

Reports all targets that Prometheus couldn’t connect to with some reason (timeout, refused, …)

A `dialer_name` can be passed as a label to limit the query to interesting components. For example `{dialer_name=~".+openshift-.*"}`.

```bash
oc exec -n openshift-monitoring prometheus-k8s-0 -c prometheus -- curl http://localhost:9090/api/v1/query --data-urlencode 'query=rate(net_conntrack_dialer_conn_failed_total{}[1h]) > 0' > net_conntrack_dialer_conn_failed_total.prometheus-k8s-0.json

oc exec -n openshift-monitoring prometheus-k8s-1 -c prometheus -- curl http://localhost:9090/api/v1/query --data-urlencode 'query=net_conntrack_dialer_conn_failed_total{} > 1' > net_conntrack_dialer_conn_failed_total.prometheus-k8s-1.json
```

---

Identify targets that are slow to serve metrics and may be considered as down.

```bash
oc exec -n openshift-monitoring prometheus-k8s-0 -c prometheus -- curl http://localhost:9090/api/v1/query --data-urlencode 'sort_desc(max by(job) (max_over_time(scrape_duration_seconds[1h])))' > slow.prometheus-k8s-0.json

oc exec -n openshift-monitoring prometheus-k8s-1 -c prometheus -- curl http://localhost:9090/api/v1/query --data-urlencode 'sort_desc(max by(job) (max_over_time(scrape_duration_seconds[1h])))' > slow.prometheus-k8s-1.json
```

## How do I troubleshoot high CPU usage of Prometheus?

Often, when "high" CPU usage or spikes are identified it can be a symptom of expensive rules.

A good place to start the investigation is the `/rules` endpoint of Prometheus and analyse any queries which might contribute to the problem by identifying excessive rule evaluation times.

A sorted list of rule evaluation times can be gathered with the following:

```bash
oc -n openshift-monitoring exec -c prometheus prometheus-k8s-0 -- curl -s 'http://localhost:9090/api/v1/rules' | jq -r '.data.groups[] | .rules[] | [.evaluationTime, .health, .name] | @tsv' | sort
```

An overview of the timeseries database can be retrieved with:

```bash
oc -n openshift-monitoring exec -c prometheus prometheus-k8s-0 -- curl -s 'http://localhost:9090/api/v1/status/tsdb' | jq
```

Within Prometheus, the `prometheus_rule_evaluation_duration_seconds` metric can be used to view evalutation time by quantile for each instance. Additionally, the `prometheus_rule_group_last_duration_seconds` can be used to determine the longest evaluating rulegroups.

## How do I retrieve CPU profiles?

In cases where excessive CPU usage is being reported, it might be useful to obtain [Pprof profiles](https://github.com/google/pprof/blob/02619b876842e0d0afb5e5580d3a374dad740edb/doc/README.md) from the Prometheus containers over a short time span.

To gather CPU profiles over a period of 30 minutes, run the following:

```bash
SLEEP_MINUTES=5
duration=${DURATION:-30}
while [ $duration -ne 0 ]; do
  for i in 0 1; do
	echo "Retrieving CPU profile for prometheus-k8s-$i..."
	oc exec -n openshift-monitoring prometheus-k8s-$i -c prometheus -- curl -s http://localhost:9090/debug/pprof/profile?seconds="$duration" > cpu.prometheus-k8s-$i.$(date +%Y%m%d-%H%M%S).pprof;
  done
  echo "Sleeping for $SLEEP_MINUTES minutes..."
  sleep $(( 60 * $SLEEP_MINUTES ))
  (( --duration ))
done
```

## How do I debug high memory usage?

The following queries might prove useful for debugging.

Calculate the ingestion rate over the last two minutes:

```bash
oc -n openshift-monitoring exec -c prometheus prometheus-k8s-0 \
-- curl -s http://localhost:9090/api/v1/query --data-urlencode \
'query=sum by(pod,job,namespace) (max without(instance) (rate(prometheus_tsdb_head_samples_appended_total{namespace=~"openshift-monitoring|openshift-user-workload-monitoring"}[2m])))' > samples_appended.json
```

Calculate "non-evictable" memory:

```bash
oc -n openshift-monitoring exec -c prometheus prometheus-k8s-0 \
-- curl -s http://localhost:9090/api/v1/query --data-urlencode \
'query=sort_desc(sum by (pod,namespace) (max without(instance) (container_memory_working_set_bytes{namespace=~"openshift-monitoring|openshift-user-workload-monitoring", container=""})))' > memory.json
```

## How do I get memory profiles?

In cases where excessive memory is being reported, it might be useful to obtain [Pprof profiles](https://github.com/google/pprof/blob/02619b876842e0d0afb5e5580d3a374dad740edb/doc/README.md) from the Prometheus containers over a short time span.

To gather memory profiles over a period of 30 minutes, run the following:

```bash
SLEEP_MINUTES=5
duration=${DURATION:-30}
while [ $duration -ne 0 ]; do
  for i in 0 1; do
	echo "Retrieving memory profile for prometheus-k8s-$i..."
	oc exec -n openshift-monitoring prometheus-k8s-$i -c prometheus -- curl -s http://localhost:9090/debug/pprof/heap > heap.prometheus-k8s-$i.$(date +%Y%m%d-%H%M%S).pprof;
  done
  echo "Sleeping for $SLEEP_MINUTES minutes..."
  sleep $(( 60 * $SLEEP_MINUTES ))
  (( --duration ))
done
```
