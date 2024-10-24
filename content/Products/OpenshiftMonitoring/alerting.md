# Alerting

## Targeted audience

This document is intended for OpenShift developers that want to write alerting rules for their operators and operands.

## Configuring alerting rules

You configure alerting rules based on the metrics being collected for your component(s). To do so, you should create `PrometheusRule` objects in your operator/operand namespace which will also be picked up by the Prometheus operator (provided that the namespace has the `openshift.io/cluster-monitoring="true"` label for layered operators).

Here is an example of a PrometheusRule object with a single alerting rule:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: cluster-example-operator-rules
  namespace: openshift-example-operator
spec:
  groups:
  - name: operator
    rules:
    - alert: ClusterExampleOperatorUnhealthy
      annotations:
        description: Cluster Example operator running in pod {{$labels.namespace}}/{{$labels.pods}} is not healthy.
        summary: Operator Example not healthy
      expr: |
        max by(pod, namespace) (last_over_time(example_operator_healthy[5m])) == 0
      for: 15m
      labels:
        severity: warning
```

You can choose to configure all your alerting rules into a single `PrometheusRule` object or split them into different objects (one per component). The mechanism to deploy the object(s) depends on the context: it can be deployed by the Cluster Version Operator (CVO), the Operator Lifecycle Manager (OLM) or your own operator.

## Guidelines

Please refer to the [Alerting Consistency](https://github.com/openshift/enhancements/blob/master/enhancements/monitoring/alerting-consistency.md) OpenShift enhancement proposal for the recommendations applying to OCP built-in alerting rules.

If you need a review of alerting rules from the OCP monitoring team, you can reach them on the `#forum-openshift-monitoring` channel.

## Identifying alerting rules without a namespace label

The enhancement proposal mentioned above states the following for OCP built-in alerts:

> Alerts SHOULD include a namespace label indicating the source of the alert.

Unfortunately this isn't something that we can verify by static analysis because the namespace label can come from the PromQL result or be added statically. Nevertheless we can still use the Telemetry data to identify OCP alerts that don't respect this statement.

First, create an OCP cluster from the latest stable release. Once it is installed, run this command to return the list of all OCP built-in alert names:

```bash
curl -sk -H "Authorization: Bearer $(oc create token prometheus-k8s -n openshift-monitoring)" \
https://$(oc get routes -n openshift-monitoring thanos-querier -o jsonpath='{.status.ingress[0].host}')/api/v1/rules \
| jq -cr '.data.groups | map(.rules) | flatten | map(select(.type =="alerting")) | map(.name) | unique |join("|")'
```

Then from https://telemeter-lts.datahub.redhat.com, retrieve the list of all alerts matching the names that fired without a namespace label, grouped by minor release:

```
count by (alertname,version) (
  alerts{alertname=~"<insert the list of names returned by the previous command>",namespace=""} *
  on(_id) group_left(version) max by(_id, version) (
    label_replace(id_version_ebs_account_internal:cluster_subscribed{version=~"4.\d\d.*"}, "version", "$1", "version", "^(4.\\d+).*$")
  )
)
```

You should now track back the non-compliant alerts to their component of origin and file bugs against them ([example](https://issues.redhat.com/browse/OCPBUGS-17191)).

The exercise should be done at regular intervals, at least once per release cycle.
