# Rules and alerting capabilities

## Overview

As explained in more details [here](README.md), RHOBS features a deployment of [Observatorium](../../Projects/Observability/observatorium.md).

Through the Observatorium API, tenants are able to **write** and **read** their own Prometheus [recording](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) and [alerting](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) rules via the [Observatorium Rules API](https://github.com/observatorium/observatorium/tree/main/docs/design/rules-api.md).

Besides that, each one of the RHOBS instances has an [Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/) deployed, which makes possible to tenants to configure their own alerts, including a custom routing configuration to the desired receivers.

## Goal

This page aims to provide a simple tutorial of how a tenant can create an alerting rule via the Observatorium Rules API and configure Alertmanager properly to get alerted via a desired receiver.

For this tutorial we will be using the `rhobs` tenant in the **stage environment**. URLs may change slightly in case another tenant is used.

*Note: Make sure the tenant you are using is correctly authenticated and authorized.*

### Create an alerting rule

A tenant can create and list recording and alerting rules via the Observatorium Rules API. For this tutorial we will be creating an alerting rule, to also make use of the alerting capabilities that are available in Observatorium.

If you want to get more details about how to interact with the Rules API and its different endpoints, refer to the [upstream documentation](https://observatorium.io/docs/design/rules-api.md/).

In your local environment, create an alerting rule YAML file with the definition of the alert you want to add. Note that the file should be defined following the [Observatorium OpenAPI specification](https://github.com/observatorium/api/blob/main/rules/spec.yaml). The syntax is based on the Prometheus [recording](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) and [alerting](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) rules syntax.

For example:

```yaml
groups:
- interval: 30s
  name: test-firing-alert
  rules:
  - alert: TestFiringAlert
    annotations:
      dashboard: https://grafana.stage.devshift.net/d/Tg-mH0rizaSJDKSADX/api?orgId=1&refresh=1m
      description: Test firing alert
      message: Message of firing alert here
      runbook: https://github.com/rhobs/configuration/blob/main/docs/sop/observatorium.md
      summary: Summary of firing alert here
    expr: vector(1)
    for: 1m
    labels:
      severity: page
      tenant_id: 0fc2b00e-201b-4c17-b9f2-19d91adc4fd2
```

Now send a `PUT` request to `/api/v1/rules/raw` endpoint, specifying the YAML file, to **create** your alerting rule using the Rules API:

```bash
curl -X PUT --data-binary @yourfile.yaml --header "Content-Type: application/yaml" https://observatorium.api.stage.openshift.com/api/metrics/v1/rhobs/api/v1/rules/raw
```

Besides checking if you've got a 200 response, you can also list the rules for the tenant (in this case, `rhobs`):

```bash
curl https://observatorium.api.stage.openshift.com/api/metrics/v1/rhobs/api/v1/rules/raw
```

*Note: The endpoint URLs above refer to the stage environment. To make use of the URLs in production, use `https://observatorium.api.openshift.com` instead.*

### Create a routing configuration in Alertmanager

Now that the alerting rule is correctly created, you can start to configure Alertmanager.

#### Configure alertmanager.yaml

Create a merge request to [app-interface/resources/rhobs](https://gitlab.cee.redhat.com/service/app-interface/-/tree/master/resources/rhobs):

* Choose the desired environment (`production`/`stage`) folder. For this tutorial, we will be using the `stage` environment.
* Modify the `alertmanager-routes-<namespace>-secret.yaml` file with the desired configuration.
* After changing the file, open a merge request with the updated configuration file.

The `alertmanager-routes-<namespace>-secret.yaml` already contains basic configuration, such as a customized template for slack notifications and a few receivers. For this tutorial, a `slack-monitoring-alerts-stage` receiver was configured with a route matching the `rhobs` tenant_id:

```yaml
routes:
- matchers:
  - tenant_id = 0fc2b00e-201b-4c17-b9f2-19d91adc4fd2
  receiver: slack-monitoring-alerts-stage
```

For more information about how to configure Alertmanager, check out the [official Alertmanager documentation](https://prometheus.io/docs/alerting/latest/configuration/).

#### Configure secrets in Vault

In case you want to configure a receiver (e.g. slack, pagerduty) to receive alert notifications, it is likely necessary that you'd need to provide secrets so that Alertmanager has push access to. Currently, we recommend that you store the desired secrets in `Vault` and embed them via app-sre templating. Refer to https://vault.devshift.net/ui/vault/ to create a new secret or to retrieve an existing one. You can them embed this secret in your Alertmanager configuration file using the following syntax:

```yaml
{{{ vault('app-sre/integrations-input/alertmanager-integration', 'slack_api_url') }}}
```

Where `app-sre/integrations-input/alertmanager-integration` is the path of the stored secret in Vault and `slack_api_url` is the key.

You can refer to the app-interface [documentation](https://gitlab.cee.redhat.com/service/app-interface/-/tree/master#example-manage-a-templated-configmap-via-app-interface-openshiftnamespace-1yml) to get more information about this.

Once your MR is merged with the desired Alertmanager configuration, the configuration file is reloaded by the Observatorium Alertmanager instances. To get your MR merged an approval from `app-sre` is necessary.

You can then check if the created alerting rule is showing correctly on the configured receiver.

## Summary

After this tutorial, you should be able to:

1. Create an alerting rule through Observatorium Rules API.
2. Setup Observatorium Alertmanager instances with the desired routing configuration.
3. Check that the integration works properly on the configured receiver.

## Additional resources

In case problems occur or if you want to have a general overview, here is a list of links that can help you:

| Stage                                                                                                                                                                         | Production                                                                                                                                                                                          |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Alertmanager UI](https://observatorium-alertmanager-mst.api.stage.openshift.com)                                                                                             | [Alertmanager UI](https://observatorium-alertmanager.api.openshift.com)                                                                                                                             |
| [Alertmanager logs](https://console-openshift-console.apps.app-sre-stage-0.k3s7.p1.openshiftapps.com/k8s/ns/observatorium-mst-stage/pods/observatorium-alertmanager-0/logs)   | [Alertmanager logs](https://console-openshift-console.apps.telemeter-prod.a5j2.p1.openshiftapps.com/k8s/ns/observatorium-mst-production/pods/observatorium-alertmanager-0)                          |
| [Thanos Rule logs](https://console-openshift-console.apps.app-sre-stage-0.k3s7.p1.openshiftapps.com/k8s/ns/observatorium-metrics-stage/pods/observatorium-thanos-rule-0/logs) | [Thanos Rule logs](https://console-openshift-console.apps.telemeter-prod.a5j2.p1.openshiftapps.com/k8s/ns/observatorium-metrics-production/pods/observatorium-thanos-metric-federation-rule-0/logs) |
