# Alerting guidelines

Please refer to the [Alerting Consistency](https://github.com/openshift/enhancements/blob/master/enhancements/monitoring/alerting-consistency.md) OpenShift enhancement proposal for the recommendations.

## Identifying alerting rules without a namespace label

The enhancement proposal mentioned above states the following for OCP built-in alerts

> Alerts SHOULD include a namespace label indicating the source of the alert.

Unfortunately this isn't something that we can verify by static analysis. But we can still use the Telemetry data to identify OCP alerts that don't respect this statement.

First, run this command against a live cluster to return the list of all OCP alert names:

```bash
curl -sk -H "Authorization: Bearer $(oc create token prometheus-k8s -n openshift-monitoring)" \
https://$(oc get routes -n openshift-monitoring thanos-querier -o jsonpath='{.status.ingress[0].host}')/api/v1/rules \
| jq -cr '.data.groups | map(.rules) | flatten | map(select(.type =="alerting")) | map(.name) | unique |join("|")'
```

Then from https://telemeter-lts.datahub.redhat.com, extract the list of all alerts matching the names that fired without a namespace label, grouped by minor release:

```
count by (alertname,version) (
  alerts{alertname=~"<insert the list of names returned by the previous command>",namespace=""} *
  on(_id) group_left(version) max by(_id, version) (
    label_replace(id_version_ebs_account_internal:cluster_subscribed{version=~"4.1(2|3|4).*"}, "version", "$1", "version", "^(4.\\d+).*$")
  )
)
```
