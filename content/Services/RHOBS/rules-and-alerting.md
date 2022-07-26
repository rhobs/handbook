# Rules and alerting capabilities

## Overview

As explained in more details [here](README.md), RHOBS features a deployment of [Observatorium](../../Projects/Observability/observatorium.md).

Through the Observatorium API, tenants are able to **create**, **read**, **update** and **delete** their own Prometheus [recording](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) and [alerting](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) rules via the [Observatorium Rules API](https://observatorium.io/docs/design/rules-api.md/).

In addition to this, each of the RHOBS instances has an [Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/) deployed, which makes possible for tenants to configure custom alert routing configuration to route firing alerts to their specified receivers.

## Goal

This page aims to provide a simple tutorial of how a tenant can create an alerting rule via the Observatorium Rules API and configure Alertmanager properly to get alerted via a desired receiver.

For this tutorial we will be using the `rhobs` tenant in the **MST stage environment**. URLs may change slightly in case another tenant is used.

### Authenticate against the Observatorium API

To have access to the [Observatorium API](https://github.com/observatorium/api), the tenant making the requests needs to be correctly authenticated. For this you can install [obsctl](https://github.com/observatorium/obsctl) which is a dedicated CLI tool to interact with Observatorium instances as tenants. It uses the provided credentials to fetch OAuth2 access tokens via OIDC and saves both the token and credentials for multiple tenants and APIs, locally.

You can get up and running quickly with the following steps,

* Make sure you have Go 1.17+ on your system and install obsctl,

  ```bash
  go install github.com/observatorium/obsctl@latest
  ```

* Add your desired Observatorium API,

  ```bash
  obsctl context api add --name='staging-api' --url='https://observatorium-mst.api.stage.openshift.com'
  ```

* Save credentials for a tenant under the API you just added (you will need your own OIDC Client ID and Client Secret),

  ```bash
  obsctl login --api='staging-api' --oidc.audience='observatorium' --oidc.client-id='<CLIENT_ID>' --oidc.client-secret='<SECRET>' --oidc.issuer-url='https://sso.redhat.com/auth/realms/redhat-external' --tenant='rhobs'
  ```

* Verify that you are using the correct API + tenant combination or "context" (in this case it would be `staging-api/rhobs`),

  ```bash
  obsctl context current
  ```

For this tutorial we will be using `https://observatorium-mst.api.stage.openshift.com` as our target Observatorium API.

Now that we have set up obsctl, let's start creating an alerting rule.

### Create an alerting rule

A tenant can create and list recording and alerting rules via the Observatorium Rules API. For this tutorial we will be creating an alerting rule, to also make use of the alerting capabilities that are available in Observatorium.

If you want to get more details about how to interact with the Rules API and its different endpoints, refer to the upstream [documentation](https://observatorium.io/docs/design/rules-api.md/) or [OpenAPI spec](https://observatorium.io/docs/api).

In your local environment, create an Prometheus alerting rule YAML file with the definition of the alert you want to add. Note that the file should be defined following the [Observatorium OpenAPI specification](https://github.com/observatorium/api/blob/main/rules/spec.yaml). The file should be in Prometheus [recording](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) and/or [alerting](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) rules format.

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

Now to set this rule file, you can use obsctl,

```bash
obsctl metrics set --rule.file=/path/to/alerting-rule.yaml
```

obsctl uses the credentials you saved earlier, to make an authenticated `application/yaml` `PUT` request to the `api/v1/rules/raw` endpoint of the Observatorium API, which **creates** your alerting rule.

obsctl should print out the response, which, if successful, would be: `successfully updated rules file`.

Besides checking this response, you can also list or **read** the configured rules for your tenant by,

```bash
obsctl metrics get rules.raw
```

This would make a `GET` request to `api/v1/rules/raw` endpoint and return the rules you configured in YAML form. This endpoint will immediately reflect any newly set rules.

Note that in the response a `tenant_id` label for the particular tenant was added automatically. Since Observatorium API is tenant-aware, this extra validation step is also performed. Also, in the case of rules expressions, the `tenant_id` labels are injected into the PromQL query, which ensures that only data from a specific tenant is selected during evaluation.

You can also check your rule's configuration, health, and resultant alerts by,

```bash
obsctl metrics get rules
```

This would make a `GET` request to `api/v1/rules` endpoint, and return rules you configured in [Prometheus HTTP API format JSON response](https://prometheus.io/docs/prometheus/latest/querying/api/#rules). You can read more about checking rule state [here](#check-the-alerting-rule-state).

Note that this endpoint does not reflect newly set rules immediately and might take up to a minute to sync.

### How to update and delete an alerting rule

As mentioned in the [upstream docs](https://observatorium.io/docs/design/rules-api.md/#example-request) that each time a `PUT` request is made to the `/api/v1/rules/raw` endpoint, the rules contained in the request will overwrite all the other rules for that tenant. Thus, each time you use `obsctl metrics set --rule.file=<file>` it will overwrite all other rules for a tenant with the new rule file.

Make sure to grab your existing rules YAML file and append any new rules or groups you want to create, to this file.

Using the example above, in case you want to create a second alerting rule, a new `alert` rule should be added to the file,

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

And then this new file can be set via `obsctl metrics set --rule.file=/path/to/alerting-rule.yaml` to **update** your rules configuration.

Similarly, if you want to **delete** a rule, you can remove that from your existing rule file, before setting it with obsctl.

If you want to **delete** all rule(s) for a tenant, you can run `obsctl metrics set --rule.file=` with an empty file.

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

It is possible to check all rule groups for a tenant by querying `/api/v1/rules` endpoint (i.e by running `obsctl metrics get rules`). `/api/v1/rules` supports only `GET` requests and proxies to the upstream read endpoint (in this case, [Thanos Querier](https://thanos.io/tip/components/query.md/)).

This endpoint returns the processed and evaluated rules from Observatorium's [Thanos Rule](https://thanos.io/tip/components/rule.md/#rule-aka-ruler) in [Prometheus HTTP API format JSON](https://prometheus.io/docs/prometheus/latest/querying/api/#rules).

It is different from `api/v1/rules/raw` endpoint (which can be queried by running `obsctl metrics get rules.raw`) in a few ways,
* `api/v1/rules/raw` only returns the unprocess/raw rule file YAML that was configured whereas `api/v1/rules` returns processed JSON rules with health and alert data.
* `api/v1/rules/raw` immediately reflects changes to rules, whereas `api/v1/rules` can take up to a minute to sync with new changes.

Thanos Ruler evaluates the Prometheus rules - in this case for example, it checks which alerting rules will be triggered, the last time they were evaluated and more.

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

In case you want to configure a receiver (e.g. slack, pagerduty) to receive alert notifications, it is likely necessary that you'd need to provide secrets so that Alertmanager has push access to. Currently, you have to store the desired secrets in `Vault` and embed them via app-sre templating. Refer to https://vault.devshift.net/ui/vault/ to create a new secret or to retrieve an existing one. You can them embed this secret in your Alertmanager configuration file using the following syntax:

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
