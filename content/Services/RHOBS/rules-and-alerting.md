# Rules and alerting capabilities

## Overview

As explained in more details [here](README.md), RHOBS features a deployment of [Observatorium](../../Projects/Observability/observatorium.md).

Through the Observatorium API, tenants are able to **write**, **read** and **delete** their own Prometheus [recording](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) and [alerting](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) rules via the [Observatorium Rules API](https://observatorium.io/docs/design/rules-api.md/).

In addition to this, each of the RHOBS instances has an [Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/) deployed, which makes possible for tenants to configure custom alert routing configuration to route firing alerts to their specified receivers.

## Goal

This page aims to provide a simple tutorial of how a tenant can create an alerting rule via the Observatorium Rules API and configure Alertmanager properly to get alerted via a desired receiver.

For this tutorial we will be using the `rhobs` tenant in the **MST stage environment**. URLs may change slightly in case another tenant is used.

### Authenticate against the Observatorium API

To have access to the [Observatorium API](https://github.com/observatorium/api), the tenant making the requests needs to be correctly authenticated. For this you will need to run [token-refresher](https://github.com/observatorium/token-refresher) - a helper that fetches and refreshes OAuth2 access tokens via OIDC. You can run a local instance of token-refresher:

```bash
docker run -p 8080:8080 quay.io/observatorium/token-refresher --oidc.client-id=<your-client-id> --oidc.client-secret=<your-client-secret> --oidc.audience=observatorium --url=https://observatorium.api.stage.openshift.com --log.level=debug --oidc.issuer-url=https://sso.redhat.com/auth/realms/redhat-external
```

Where you will need to provide your `--oicd.client-id` and `--oidc.client-secret` credentials. For this tutorial we will be using `https://observatorium.api.stage.openshift.com` as target URL to proxy the requests. All requests will then have the access token in the Authorization HTTP header.

Now that we have set up token-refresher, let's start creating an alerting rule.

### Create an alerting rule

A tenant can create and list recording and alerting rules via the Observatorium Rules API. For this tutorial we will be creating an alerting rule, to also make use of the alerting capabilities that are available in Observatorium.

If you want to get more details about how to interact with the Rules API and its different endpoints, refer to the [upstream documentation](https://observatorium.io/docs/design/rules-api.md/).

In your local environment, create an alerting rule YAML file with the definition of the alert you want to add. Note that the file should be defined following the [Observatorium OpenAPI specification](https://github.com/observatorium/api/blob/main/rules/spec.yaml). The file should be in Prometheus [recording](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) and/or [alerting](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) rules format.

For example, you can create a file named `alerting-rule.yaml`:

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
```

Now send a `PUT` request to `/api/v1/rules/raw` endpoint, specifying the YAML file, to **create** your alerting rule using the Rules API:

```bash
curl -X PUT --data-binary @alerting-rule.yaml --header "Content-Type: application/yaml" http://localhost:8080/api/metrics/v1/rhobs/api/v1/rules/raw
```

Besides checking if you've got a 200 response, you can also list the rules for the tenant (in this case, `rhobs`):

```bash
curl http://localhost:8080/api/metrics/v1/rhobs/api/v1/rules/raw
```

Note that in the response a `tenant_id` label for the particular tenant was added automatically. Since Rules/Observatorium API is tenant-aware, this extra validation step is also performed. Also, in the case of Rules expressions, the `tenant_id` labels are injected into the PromQL query, which ensures that only data from a specific tenant is selected during evaluation.

### How to update and delete an alerting rule

As mentioned in the [upstream docs](https://observatorium.io/docs/design/rules-api.md/#example-request) that each time a `PUT` request is made to the `/api/v1/rules/raw` endpoint, the rules contained in the request will overwrite all the other rules for that tenant.

Make sure to grab your existing raw rules and append to that the new rules you want to create.

Using the example above, in case we want to create a second alerting rule, a new `alert` should be added to the file:

```yaml
groups:
- interval: 30s
  name: test-firing-alert
  rules:
  - alert: TestFiringAlert
    annotations:
      dashboard: https://grafana.stage.devshift.net/d/Tg-mH0rizaSJDKSADX/api?orgId=1&refresh=1m
      description: Test firing alert!!
      message: Message of firing alert here
      runbook: https://github.com/rhobs/configuration/blob/main/docs/sop/observatorium.md
      summary: Summary of firing alert here
    expr: vector(1)
    for: 1m
    labels:
      severity: page
- interval: 30s
  name: test-new-firing-alert
  rules:
  - alert: TestNewFiringAlert
    annotations:
      dashboard: https://grafana.stage.devshift.net/d/Tg-mH0rizaSJDKSADX/api?orgId=1&refresh=1m
      description: Test new firing alert!!
      message: Message of new firing alert here
      runbook: https://github.com/rhobs/configuration/blob/main/docs/sop/observatorium.md
      summary: Summary of new firing alert here
    expr: vector(1)
    for: 1m
    labels:
      severity: page
```

If you want to delete rule(s) for a tenant you can make a `PUT` request to the same `/api/v1/rules/raw` endpoint with an empty body. Note that it is currently not possible to delete a specific rule. By making a `PUT` request with an empty body you will be deleting all rules for that tenant.

### Create a routing configuration in Alertmanager

Now that the alerting rule is correctly created, you can start to configure Alertmanager.

#### Configure alertmanager.yaml

Create a merge request to [app-interface/resources/rhobs](https://gitlab.cee.redhat.com/service/app-interface/-/tree/master/resources/rhobs):

* Choose the desired environment (`production`/`stage`) folder. For this tutorial, we will be using the `stage` environment.
* Modify the `alertmanager-routes-<instance>-secret.yaml` file with the desired configuration.
* After changing the file, open a merge request with the updated configuration file.

The `alertmanager-routes-<instance>-secret.yaml` already contains basic configuration, such as a customized template for slack notifications and a few receivers. For this tutorial, a `slack-monitoring-alerts-stage` receiver was configured with a route matching the `rhobs` tenant_id:

```yaml
routes:
- matchers:
  - tenant_id = 0fc2b00e-201b-4c17-b9f2-19d91adc4fd2
  receiver: slack-monitoring-alerts-stage
```

For more information about how to configure Alertmanager, check out the [official Alertmanager documentation](https://prometheus.io/docs/alerting/latest/configuration/).

#### Check the alerting rule state

It is also possible to check all rule groups for a tenant by querying `/api/v1/rules`. This endpoint returns the processed and evaluated rules from [Thanos Rule](https://thanos.io/tip/components/rule.md/#rule-aka-ruler), which is different than the `/api/v1/rules/raw` endpoint, that returns the unprocessed/raw rules.

`/api/v1/rules` supports only `GET` requests and proxies to the upstream read endpoint (in this case, [Thanos Querier](https://thanos.io/tip/components/query.md/)).

Thanos Ruler evaluates the Prometheus rules - in this case for example, it checks which alerting rules will be triggered, the last time they were evaluated and more.

You can check the `/api/v1/rules` endpoint:

```bash
curl http://localhost:8080/api/metrics/v1/rhobs/api/v1/rules
```

For example, if `TestFiringAlert` is already firing, the response will contain a `"state": "firing"` entry for this alert:

```json
"alerts": [
  {
    "labels": {
      "alertname": "TestFiringAlert",
      "severity": "page",
      "tenant_id": "0fc2b00e-201b-4c17-b9f2-19d91adc4fd2"
    },
    "annotations": {
      "dashboard": "https://grafana.stage.devshift.net/d/Tg-mH0rizaSJDKSADX/api?orgId=1&refresh=1m",
      "description": "Test firing alert",
      "message": "Message of firing alert here",
      "runbook": "https://github.com/rhobs/configuration/blob/main/docs/sop/observatorium.md",
      "summary": "Summary of firing alert here"
    },
    "state": "firing",
    "activeAt": "2022-03-02T10:13:39.051462148Z",
    "value": "1e+00",
    "partialResponseStrategy": "ABORT"
  }
],
```

If the alert has already the `"state": "firing"` entry, with the Alertmanager having the routing configuration for a specific receiver (in our case, slack), it should be possible to see the alert showing up on slack, in the configured slack channel.

#### Configure secrets in Vault

In case you want to configure a receiver (e.g. slack, pagerduty) to receive alert notifications, it is likely necessary that you'd need to provide secrets so that Alertmanager has push access to. Currently, we recommend that you store the desired secrets in `Vault` and embed them via app-sre templating. Refer to https://vault.devshift.net/ui/vault/ to create a new secret or to retrieve an existing one. You can them embed this secret in your Alertmanager configuration file using the following syntax:

```yaml
{{{ vault('app-sre/integrations-input/alertmanager-integration', 'slack_api_url') }}}
```

Where `app-sre/integrations-input/alertmanager-integration` is the path of the stored secret in Vault and `slack_api_url` is the key.

You can refer to the app-interface [documentation](https://gitlab.cee.redhat.com/service/app-interface/-/tree/master#example-manage-a-templated-configmap-via-app-interface-openshiftnamespace-1yml) to get more information about this.

Once your MR is merged with the desired Alertmanager configuration, the configuration file is reloaded by the Observatorium Alertmanager instances. To get your MR merged an approval from `app-sre` is necessary.

#### Testing the route configuration

If you want to test your Alertmanager configuration to verify that the configured receivers are receiving the right alert, we recommend the use of [amtool](https://github.com/prometheus/alertmanager#amtool).

Note that the original configuration file in `app-interface` is a file of type `Secret`. In this case, you should aim to test the data what is under `alertmanager.yaml` [key](https://gitlab.cee.redhat.com/service/app-interface/-/blob/2f76e75628e4211b4a886301956afcc79d76d9e2/resources/rhobs/stage/alertmanager-routes-mst.secret.yaml#L8). There may be also `app-interface` specific annotation (e.g. how the `slack_url` is [constructed](https://gitlab.cee.redhat.com/service/app-interface/-/blob/2f76e75628e4211b4a886301956afcc79d76d9e2/resources/rhobs/stage/alertmanager-routes-mst.secret.yaml#L12) by retrieving a `Vault` secret) - which may prompt the validation by `amtool` to fail.

After installing `amtool` correctly, you can check the configuration of the `alertmanager.yaml` file with:

```bash
amtool check-config alertmanager.yaml
```

It is also possible to check the configuration against specific receivers.

For our example, we have `slack-monitoring-alerts-stage` receiver configured.

To check that the configured route matches the RHOBS `tenant_id`, we can run:

```bash
amtool config routes test --config.file=alertmanager.yaml --verify.receivers=slack-monitoring-alerts-stage tenant_id=0fc2b00e-201b-4c17-b9f2-19d91adc4fd2
```

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

*Note: As of today, tenants are unable to access the Alertmanager UI. Please reach out to @observatorium-support in the #forum-observatorium to get help if needed.*
