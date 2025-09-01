# Sending metrics via Telemetry

## Targeted audience

This document is intended for OpenShift developers that want to ship new metrics to the Red Hat Telemetry service.

## Background

Before going to the details, a few words about [Telemetry](https://rhobs-handbook.netlify.app/services/rhobs/use-cases/telemetry.md/) and the process to add a new metric..

**What is Telemetry?**

Telemetry is a system operated and hosted by Red Hat that allows to collect data from connected clusters to enable subscription management automation, monitor the health of clusters, assist with support, and improve customer experience.

**What does sending metrics via Telemetry mean?**

You should send the metrics via Telemetry when you want and need to see these metrics for **all** OpenShift clusters. This is primarily for gaining insights on how OpenShift is used, troubleshooting and monitoring the fleet of clusters. Users can already see these metrics in their clusters via Prometheus even when not available via Telemetry.

**How are metrics shipped via Telemetry?**

Only metrics which are already collected by the [in-cluster monitoring stack](https://rhobs-handbook.netlify.app/products/openshiftmonitoring/telemetry.md/#in-cluster-monitoring-stack) can be shipped via Telemetry. The `telemeter-client` pod running in the `openshift-monitoring` namespace collects metrics from the `prometheus-k8s` service every 4m30s using the `/federate` endpoint and ships the samples to the Telemetry endpoint using a custom protocol.

**How long will it take for my new telemetry metrics to show up?**

Please start this process and involve the monitoring team as early as possible. The process described in this document includes a thorough review of the underlying metrics and labels. The monitoring team will try to understand your use case and perhaps propose improvements and optimizations. Metric, label and rule names will be reviewed for [following best practices](https://prometheus.io/docs/practices/naming/). This can take several review rounds over multiple weeks.

## Requirements

Shipping metrics via Telemetry is only possible for components running in namespaces with the `openshift.io/cluster-monitoring=true` label. In practice, it means that your component falls into one of these 2 categories:
* Your operator/operand is included in the OCP payload (e.g. it is a core/platform component).
* Your operator/operand is deployed via OLM and has been certified by Red Hat.

Your component should already be instrumented and scraped by the [in-cluster monitoring stack](#in-cluster-monitoring-stack) using `ServiceMonitor` and/or `PodMonitor` objects.

## Sending metrics via Telemetry step-by-step

The overall process is as follows:
1. Request approval from the monitoring team.
2. Configure recording rules using `PrometheusRule` objects.
3. Modify the configuration of the Telemeter client in the [Cluster Monitoring Operator](https://github.com/openshift/cluster-monitoring-operator/) repository to collect the new metrics.
4. Synchronize the Telemeter server's configuration from the Cluster Monitoring Operator project.
5. Wait for the Telemeter server's configuration to be rolled out to production.

### Request approval

The first step is to identify which metrics you want to send via Telemetry and what is the [cardinality](https://rhobs-handbook.netlify.app/products/openshiftmonitoring/telemetry.md/#what-is-the-cardinality-of-a-metric) of the metrics (e.g. how many timeseries it will be in total). Typically you start with metrics that show how your component is being used. In practice, we recommend to start shipping not more than:
* 1 to 3 metrics.
* 1 to 10 timeseries per metric.
* 10 timeseries in total.

If you are above these limits, you have 2 choices:
* (recommended) aggregate the metrics before sending. For instance: sum all values for a given metric.
* request an exception from the monitoring team. The exception requires approval from upper management so make sure that your request is motivated!

Finally your metric **MUST NOT** contain any personally identifiable information (names, email addresses, information about user workloads).

Use the following information to file 1 JIRA ticket per metric in the [MON project](https://issues.redhat.com//secure/CreateIssueDetails!init.jspa?pid=12323177&issuetype=3&labels=telemetry-review-request&summary=Send+metric+...+via+Telemetry&description=h1.%20Request%20for%20sending%20data%20via%20telemetry%0A%0AThe%20goal%20is%20to%20collect%20metrics%20about%20...%20because%20...%0A%0Ah2.%20%3CMetric%20name%3E%0A%0A%3CMetric%20name%3E%20represents%20...%0A%0ALabels%0A%2A%20%3Clabel%201%3E%2C%20possible%20values%20are%20...%0A%2A%20%3Clabel%202%3E%2C%20possible%20values%20are%20...%0A%0AThe%20cardinality%20of%20the%20metric%20is%20at%20most%20%3CX%3E.%0A%0AComponent%20exposing%20the%20metric%3A%20https%3A%2F%2Fgithub.com%2F%3Corg%3E%2F%3Cproject%3E%0Ah2.&priority=4):

* Type: `Task`
* Title: `Send metric <metric name> via Telemetry`
* Label: `telemetry-review-request`
* Description template:

```
h1. Request for sending data via telemetry

The goal is to collect metrics about ... because ...

<Metric name> represents ...

Labels
* <label 1>, possible values are ...
* <label 2>, possible values are ...

The cardinality of the metric is at most <X>.

Component exposing the metric: https://github.com/<org>/<project>
```

Reach out to `@team-telemetry` on the `#forum-openshift-monitoring` or `#forum-observatorium` Slack channels for an explicit approval (e.g. in-cluster and RHOBS team leads).

### Configure recording rules

Recording rules are required to reduce the [cardinality](https://rhobs-handbook.netlify.app/products/openshiftmonitoring/telemetry.md/#what-is-the-cardinality-of-a-metric) of the metrics being shipped.

Even for low-cardinality metrics, we require to aggregate them before shipping to Telemetry to remove unnecessary labels such as `instance` or `pod`. This will also protect the telemetry backend against future label additions to the underlying metrics.

Let's take a concrete example: each Prometheus pod exposes a `prometheus_tsdb_head_series` metric which tracks the number of active timeseries. There can be up to 4 Prometheus pods in a given cluster (2 pods in `openshift-monitoring` and 2 in `openshift-user-workload-monitoring` when user-defined monitoring is enabled). To reduce the number of timeseries shipped via Telemetry, we configure the following recording rule to sum the values by `namespace` and `job` labels:

```
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: cluster-monitoring-operator-prometheus-rules
  namespace: openshift-monitoring
spec:
  groups:
  - name: openshift-monitoring.rules
    rules:
    - expr: |-
        sum by (job,namespace) (
          max without(instance) (
            prometheus_tsdb_head_series{namespace=~"openshift-monitoring|openshift-user-workload-monitoring"}
          )
        )
      record: openshift:prometheus_tsdb_head_series:sum
```

Your `PrometheusRule` object(s) should be created by your operator with your `ServiceMonitor` and/or `PodMonitor` objects.

Recording rule names should follow the [`level:metric:operations` pattern](https://prometheus.io/docs/practices/rules/).

### Modify the Telemeter client's configuration

1. Clone the [cluster-monitoring-operator](https://github.com/openshift/cluster-monitoring-operator) repository locally.

2. Modify the [/manifests/0000_50_cluster-monitoring-operator_04-config.yaml](https://github.com/openshift/cluster-monitoring-operator/blob/master/manifests/0000_50_cluster-monitoring-operator_04-config.yaml) file to add the metric to the allowed list. Include comments to:
* Identify the team owning the metric.
* Provide a short description.
* (optional) Indicate which team(s) will consume the metric, it helps knowing who to contact if changes are made in the future.

```
    #
    # owners: (@openshift/openshift-team-monitoring)
    #
    # openshift:prometheus_tsdb_head_series:sum tracks the total number of active series
    - '{__name__="openshift:prometheus_tsdb_head_series:sum"}'
```

3. Run

```bash
make --always-make docs
```

4. Commit the changes into Git and open a pull request in the openshift/cluster-monitoring-operator repository linking to the initial JIRA ticket.

5. Ask for a review on the `#forum-monitoring` Slack channel.

### Synchronize the Telemeter server's configuration

Once the pull request in the cluster-monitoring-operator repository is merged, the configuration of the Telemetry server needs to be synchronized.

1. Clone the [rhobs/configuration](https://github.com/rhobs/configuration) repository.

2. Run

```bash
make whitelisted_metrics && make
```

3. Commit the changes into Git and open a pull request in the rhobs/configuration repository.

4. Ask for a review on the `#forum-observatorium` Slack channel.

Once merged, the updated configuration should be rolled out to the production Telemetry within a few days. After this happens, clusters running the next (e.g. `master`) OCP version should start sending the new metric(s) to Telemetry.

## Frequently asked questions (FAQ)

### What is the cardinality of a metric?

A given metric may have different labels (aka dimensions) that helps refining the characteristics of the thing being measured. Each unique combination of a metric name + optional key/value pairs represents a timeseries in the Prometheus parlance. And the total number of active timeseries for a given metric name represents the cardinality of the metric.

For example, consider a component exposing a fictuous `my_component_ready` metric:

```
my_component_ready 1
```

The metric has no label but because Prometheus will automatically attach target labels such as `pod` and `instance`, the total cardinality could be 1 (single replica), 2 (2 replicas), ...

To find out the current cardinality of a metric on a live cluster, you can run this PromQL query:

```
count(my_component_ready)
```

Now consider another metric tracking HTTP requests:

```
http_requests_total{method="GET", code="200", path="/"} 10
http_requests_total{method="GET", code="404", path="/foo"} 1
http_requests_total{method="POST", code="200", path="/"} 12
http_requests_total{method="POST", code="500", path="/login"} 2
```

While you may think that the cardinality is 4 because there are 4 timeseries, this isn't true because we can't really predict in advance all values for the `code` and `path` labels. This is what is called a high-cardinality metric. An even worse case would be a metric with a `userid` or `ip` label (we would say that this metric has unbounded cardinality).

On top of that, pod churn (e.g. pods being rolled-out because of version upgrades) also increase the cardinality because the values of target-based labels (such `pod` and `instance`) would change.

Because Prometheus keeps all active timeseries in-memory for indexing, the more timeseries, the more memory is required. The same is true for the Telemeter server. Which is why we want to keep the cardinality of metrics shipped via Telemetry under a reasonable value (typically less than 5).

### Why is there a limit on the number of metrics that can be collected?

See the previous section. Every metric shipped to Telemetry has to be multiplied by the number of connected clusters that may be sending that metric. Pushing too many metrics from a single cluster may cause service degradation and resource exhaustion on both the in-cluster monitoring stack and on the Telemetry server side.

### Will Telemetry automatically collect alerts?

Yes, the Telemeter client is already configured to collect and send firing alerts. On Telemetry side, the alerts can be queried using the `alerts` metric.

### How do I ship metrics via Telemetry for older OCP releases?

Once you have updated the `telemeter-client` configuration in the `master` branch, you can create backports to older OCP releases. The procedure follows the usual OCP backport process which involves creating bug tickets in the `OCPBUGS` project (preferably assigned to your component) and opening pull requests in openshift/cluster-monitoring-operator against the desired `release-4.x` branches.

### How do I get access to Telemetry?

Check https://gitlab.cee.redhat.com/data-hub/dh-docs/-/blob/master/docs/interacting-with-telemetry-data.adoc

### How do I instrument my component for Prometheus?

Please refer to the following links for more details:
* [Metric and label naming](https://prometheus.io/docs/practices/naming/) (upstream Prometheus documentation).
* [Instrumentation](https://prometheus.io/docs/practices/instrumentation/) (upstream Prometheus documentation).
* [Instrumenting Kubernetes](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-instrumentation/instrumentation.md)

You can also reach out to the OpenShift monitoring team for advice.

### How does the in-cluster monitoring stack scrape metrics from my component?

If your component's metrics aren't already collected by the in-cluster monitoring stack, you need to deploy at least one [ServiceMonitor](https://prometheus-operator.dev/docs/operator/api/#monitoring.coreos.com/v1.ServiceMonitor) or one [PodMonitor](https://prometheus-operator.dev/docs/operator/api/#monitoring.coreos.com/v1.PodMonitor) resource in your component's namespace.

If your component is deployed by the Cluster Version Operator (CVO), it is enough to add the manifest to the CVO payload.

Again you can reach out to the OpenShift monitoring team for advice.

### How is the communication secured between the Telemeter client and server?

The Telemetry client authenticates against the Telemeter server using the cluster's pull secret. The Telemeter server verifies that the pull secret is valid and matches with the cluster's identifier. The Telemetry protocol uses HTTPS for encryption.

Finally the Telemeter server will only allow metrics which are explicitly allowed by its running configuraiton.

## Glossary

### Telemetry

Also know as Telemetry or Telemeter server. A service operated by Red Hat that receives metrics from all OCP connected clusters.

### Telemeter client

The `telemeter-client` pod runnning in the `openshift-monitoring` namespace. It is responsible for collecting the platform metrics at regular intervals (every 4m30s) and sending them to the Telemetry server.

### In-cluster monitoring stack

The `prometheus-k8s-0` and `prometheus-k8s-1` pods running in the `openshift-monitoring` namespace. They are in charge of collecting metrics from the OpenShift components (operators+operands) and evaluating the associated alerting and recording rules. The Prometheus pods are configured using `ServiceMonitor`, `PodMonitor` and `PrometheusRule` custom resources coming from namespaces with the `openshift.io/cluster-monitoring=true` label.
