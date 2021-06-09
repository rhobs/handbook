# Configuring Clients for Red Hat’s Observatorium Instance

- **Authors:**
  - [`@squat`](https://github.com/squat)
  - [`@spaparaju`](https://github.com/spaparaju)

## Overview

Teams that have identified a need for collecting their logs and/or metrics into a centralized service that offers querying and dashboarding may choose to send their data to Red Hat’s hosted Observatorium instance. This document details how to configure clients, such as Prometheus, to remote write data for tenants who have been onboarded to Observatorium following the team’s onboarding doc: [Onboarding a Tenant into Observatorium (internal)](https://docs.google.com/document/d/1pjM9RRvij-IgwqQMt5q798B_4k4A9Y16uT2oV9sxN3g/edit).

## 0. Register Service Accounts and Configure RBAC

Before configuring any clients, follow the steps in the [Observatorium Tenant Onboarding doc (internal)](https://docs.google.com/document/d/1pjM9RRvij-IgwqQMt5q798B_4k4A9Y16uT2oV9sxN3g/edit) to register the necessary service accounts and give them the required permissions on the Observatorium platform. The result of this process should be an OAuth client ID and client secret pair for each new service account. Save these credentials somewhere secure.

## 1. Remote Writing Metrics from the Cluster Monitoring Stack to Observatorium

This section describes the process of sending metrics collected by the Cluster Monitoring stack on an OpenShift cluster to Observatorium.

### Background

In order to remote write metrics from a cluster to Observatorium using the OpenShift Cluster Monitoring stack, the cluster’s Prometheus servers must be configured to authenticate and make requests to the correct URL. The OpenShift Cluster Monitoring ConfigMap exposes a user-editable field for configuring the Prometheus servers to remote write. Observatorium relies on OAuth to authenticate the incoming requests. Native [OAuth support for remote write](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#oauth2) was added in Prometheus v2.27.0. However, if you are using an older version of Prometheus that does not support OAuth, follow the instructions under [Process for Prometheus version < 2.27.0](#process-for-prometheus-version-2.27.0) heading.

### Process for Prometheus v2.27.0+

> NOTE: This is not working yet as support for authentication using OAuth is not yet merged in Prometheus Operator (GH issue: [#4036](https://github.com/prometheus-operator/prometheus-operator/issues/4036)).

The OpenShift Cluster Monitoring stack provides a ConfigMap that can be used to modify the configuration and behavior of the components. You need to modify the “cluster-monitoring-config” ConfigMap in the cluster to include a remote-write configuration for Prometheus as shown below. Please replace `<tenant>`, `<your_client_id>`, and `<your_client_secret>` with appropriate values.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    prometheusK8s:
      retention: 2h
      remoteWrite:
      - url: https://observatorium-mst.api.stage.openshift.com/api/metrics/v1/<tenant>/api/v1/receive
        oauth2:
          client_id: <your_client_id>
          client_secret: <your_client_secret>
          token_url: https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
        queueConfig:
          max_samples_per_send: 500
          batch_send_deadline: 60s
        write_relabel_configs:
          - source_labels: [__name__]
          - regex: metric_name.*
```

### Process for Prometheus version < 2.27.0

Since Prometheus v2.26.x doesn’t support OAuth for remote write, it won’t be able to directly authenticate with Observatorium and because the Cluster Monitoring stack is, for all intents and purposes, immutable, the Prometheus Pods cannot be configured with sidecars to do the authentication. For this reason, the Prometheus servers must be configured to remote write through an authentication proxy running on the cluster that in turn is pointed at Observatorium and is able to perform an OAuth flow and set the received access token on proxied requests.

#### 1. Configure the Cluster Monitoring Stack

The OpenShift Cluster Monitoring stack provides a ConfigMap that can be used to modify the configuration and behavior of the components. The first step is to modify the “cluster-monitoring-config” ConfigMap in the cluster to include a remote-write configuration for Prometheus as shown below:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    prometheusK8s:
      retention: 2h
      remoteWrite:
      - url: http://token-refresher.openshift-monitoring.svc.cluster.local
        queueConfig:
          max_samples_per_send: 500
          batch_send_deadline: 60s
        write_relabel_configs:
          - source_labels: [__name__]
          - regex: metric_name.*
```

#### 2. Deploy the Observatorium Token-Refresher Proxy

Because Prometheus does not have built-in support for acquiring OAuth2 access tokens for authorization, which are required by Observatorium, the in-cluster Prometheus must remote-write its data through a proxy that is able to fetch access tokens and set them as headers on outbound requests. The Observatorium stack provides such a proxy, which may be deployed to the “openshift-monitoring” namespace and guarded by a NetworkPolicy so that only Prometheus can use the access tokens. The following snippet shows an example of how to deploy the proxy for the stage environment:

```bash
export TENANT=<your-tenant>
export CLIENT_ID=<your-client-id>
export CLIENT_SECRET=<your-client-secret>
# For staging:
export STAGING=true
cat <<EOF | oc apply -f -
apiVersion: v1
kind: Secret
metadata:
  labels:
    app.kubernetes.io/component: authentication-proxy
    app.kubernetes.io/name: token-refresher
  name: token-refresher
  namespace: openshift-monitoring
type: Opaque
stringData:
  CLIENT_ID: $CLIENT_ID
  CLIENT_SECRET: $CLIENT_SECRET
  ISSUER_URL: https://sso.redhat.com/auth/realms/redhat-external
  URL: "https://observatorium-mst.api$([ -n "$STAGING" ] && echo .stage).openshift.com/api/metrics/v1/$TENANT/api/v1/receive"
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/component: authentication-proxy
    app.kubernetes.io/name: token-refresher
    app.kubernetes.io/version: master-2020-12-04-5504078
  name: token-refresher
  namespace: openshift-monitoring
spec:
  ports:
    - name: http
      port: 80
      targetPort: 8080
  selector:
    app.kubernetes.io/component: authentication-proxy
    app.kubernetes.io/name: token-refresher
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/component: authentication-proxy
    app.kubernetes.io/name: token-refresher
    app.kubernetes.io/version: master-2020-12-04-5504078
  name: token-refresher
  namespace: openshift-monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/component: authentication-proxy
      app.kubernetes.io/name: token-refresher
  template:
    metadata:
      labels:
        app.kubernetes.io/component: authentication-proxy
        app.kubernetes.io/name: token-refresher
        app.kubernetes.io/version: master-2020-12-04-5504078
    spec:
      containers:
      - args:
        - --oidc.audience=observatorium-telemeter
        - --oidc.client-id=\$\(CLIENT_ID\)
        - --oidc.client-secret=\$\(CLIENT_SECRET\)
        - --oidc.issuer-url=\$\(ISSUER_URL\)
        - --url=\$\(URL\)
        env:
        - name: CLIENT_ID
          valueFrom:
            secretKeyRef:
              name: token-refresher
              key: CLIENT_ID
        - name: CLIENT_SECRET
          valueFrom:
            secretKeyRef:
              name: token-refresher
              key: CLIENT_SECRET
        - name: ISSUER_URL
          valueFrom:
            secretKeyRef:
              name: token-refresher
              key: ISSUER_URL
        - name: URL
          valueFrom:
            secretKeyRef:
              name: token-refresher
              key: URL
        image: quay.io/observatorium/token-refresher:master-2021-02-24-1e01b9c
        name: token-refresher
        ports:
        - containerPort: 8080
          name: http
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  labels:
    app.kubernetes.io/component: authentication-proxy
    app.kubernetes.io/name: token-refresher
  name: token-refresher
  namespace: openshift-monitoring
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/component: authentication-proxy
      app.kubernetes.io/name: token-refresher
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          prometheus: k8s
EOF
```

## 2. Using Grafana to Read Metrics from Observatorium

This section describes the process of querying metrics from Observatorium using an existing Grafana server.

### Background

In order to query metrics from Observatorium using a Grafana server, the Grafana server must be configured with Observatorium as a datasource and with the proper authentication parameters. Grafana supports configuring generic OAuth authentication providers, which allows the server to natively authenticate with sso.redhat.com, without the need for an intermediate proxy.

### Process

#### 1. Configure a New OAuth Provider in Grafana

Begin by defining a new OAuth provider for sso.redhat.com in the Grafana server. The example snippet shown below could be added to the configuration of an existing Grafana server:

```json
"routes": [
  {
    "path": "example",
    "url": "https://api.example.com",
    "jwtTokenAuth": {
      "url": "https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token",
      "params": {
        "grant_type": "client_credentials",
        "client_id": "{{ .JsonData.clientId }}",
        "client_secret": "{{ .SecureJsonData.clientSecret }}"
      }
    }
  }
]
```
