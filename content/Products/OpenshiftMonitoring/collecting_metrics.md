# Collecting metrics with Prometheus

This document explains how to ingest metrics into the OpenShift Platform monitoring stack. **It only applies for the OCP core components and Red Hat certified operators.**

For user application monitoring, please refer to the [official OCP documentation](https://docs.openshift.com/container-platform/latest/monitoring/enabling-monitoring-for-user-defined-projects.html).

## Targeted audience

This document is intended for OpenShift developers that want to expose Prometheus metrics from their operators and operands. Readers should be familiar with the architecture of the [OpenShift cluster monitoring stack](https://docs.openshift.com/container-platform/latest/monitoring/monitoring-overview.html#understanding-the-monitoring-stack_monitoring-overview).

## Exposing metrics for Prometheus

Prometheus is a monitoring system that pulls metrics over HTTP, meaning that monitored targets need to expose an HTTP endpoint (usually `/metrics`) which will be queried by Prometheus at regular intervals (typically every 30 seconds).

To avoid leaking sensitive information to potential attackers, all OpenShift components scraped by the in-cluster monitoring Prometheus should follow these requirements:
* Use HTTPS instead of plain HTTP.
* Implement proper authentication (e.g. verify the identity of the requester).
* Implement proper authorization (e.g. authorize requests issued by the Prometheus service account or users with GET permission on the metrics endpoint).

As described in the [Client certificate scraping](https://github.com/openshift/enhancements/blob/master/enhancements/monitoring/client-cert-scraping.md) enhancement proposal, we recommend that the components rely on client TLS certificates for authentication/authorization. This is more efficient and robust than using bearer tokens because token-based authn/authz add a dependency (and additional load) on the Kubernetes API.

To this goal, the Cluster monitoring operator provisions a TLS client certificate for the in-cluster Prometheus. The client certificate is issued for the `system:serviceaccount:openshift-monitoring:prometheus-k8s` Common Name (CN) and signed by the `kubernetes.io/kube-apiserver-client` [signer](https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#kubernetes-signers). The certificate can be verified using the certificate authority (CA) bundle located at the `client-ca-file` key of the `kube-system/extension-apiserver-authentication` ConfigMap.

> In practice the Cluster Monitoring Operator creates a CertificateSigningRequest object for the `prometheus-k8s` service account which is automatically approved by the cluster-policy-controller. Once the certificate is issued by the controller, CMO provisions a secret named `metrics-client-certs` which contains the TLS certificate and key (respectively under `tls.crt` and `tls.key` keys in the secret). CMO also rotates the certificate before it gets expired.

There are several options available depending on which framework your component is built.

### library-go

If your component already relies on `*ControllerCommandConfig` from `github.com/openshift/library-go/pkg/controller/controllercmd`, it should automatically expose a TLS-secured `/metrics` endpoint which has an hardcoded authorizer for the `system:serviceaccount:openshift-monitoring:prometheus-k8s` service account ([link](https://github.com/openshift/library-go/blob/24668b1349e6276ebfa9f9e49c780559284defed/pkg/controller/controllercmd/builder.go#L277-L279)).

Example: the [Cluster Kubernetes API Server Operator](https://github.com/openshift/cluster-kube-apiserver-operator/).

### kube-rbac-proxy sidecar

The "simplest" option when the component doesn't rely on `github.com/openshift/library-go` (and switching to library-go isn't an option) is to run a [`kube-rbac-proxy`](https://github.com/openshift/kube-rbac-proxy) sidecar in the same pod as the application being monitored.

Here is an example of a container's definition to be added to the Pod's template of the Deployment (or Daemonset):

```yaml
  - args:
    - --secure-listen-address=0.0.0.0:8443
    - --upstream=http://127.0.0.1:8081
    - --config-file=/etc/kube-rbac-proxy/config.yaml
    - --tls-cert-file=/etc/tls/private/tls.crt
    - --tls-private-key-file=/etc/tls/private/tls.key
    - --client-ca-file=/etc/tls/client/client-ca-file
    - --logtostderr=true
    - --allow-paths=/metrics
    image: quay.io/brancz/kube-rbac-proxy:v0.11.0 # usually replaced by CVO by the OCP kube-rbac-proxy image reference.
    name: kube-rbac-proxy
    ports:
    - containerPort: 8443
      name: metrics
    resources:
      requests:
        cpu: 1m
        memory: 15Mi
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop:
        - ALL
    terminationMessagePolicy: FallbackToLogsOnError
    volumeMounts:
    - mountPath: /etc/kube-rbac-proxy
      name: secret-kube-rbac-proxy-metric
      readOnly: true
    - mountPath: /etc/tls/private
      name: secret-kube-rbac-proxy-tls
      readOnly: true
    - mountPath: /etc/tls/client
      name: metrics-client-ca
      readOnly: true
[...]
  - volumes:
    # Secret created by the service CA operator.
    # We assume that the Kubernetes service exposing the application's pods has the
    # "service.beta.openshift.io/serving-cert-secret-name: kube-rbac-proxy-tls"
    # annotation.
    - name: secret-kube-rbac-proxy-tls
      secret:
        secretName: kube-rbac-proxy-tls
    # Secret containing the kube-rbac-proxy configuration (see below).
    - name: secret-kube-rbac-proxy-metric
      secret:
        secretName: secret-kube-rbac-proxy-metric
    # ConfigMap containing the CA used to verify the client certificate.
    - name: metrics-client-ca
      configMap:
        name: metrics-client-ca
```

> Note: The `metrics-client-ca` ConfigMap needs to be created by your component and synced from the `kube-system/extension-apiserver-authentication` ConfigMap.

Here is a Secret containing the kube-rbac-proxy's configuration (it allows only HTTPS requets to the `/metrics` endpoint for the Prometheus service account):

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret-kube-rbac-proxy-metric
  namespace: openshift-example
stringData:
  config.yaml: |-
    "authorization":
      "static":
      - "path": "/metrics"
        "resourceRequest": false
        "user":
          "name": "system:serviceaccount:openshift-monitoring:prometheus-k8s"
        "verb": "get"
type: Opaque
```

Example: [node-exporter](https://github.com/openshift/cluster-monitoring-operator/blob/e51a06ffdb974003d4024ade3545f5e5e6efe157/assets/node-exporter/daemonset.yaml#L65-L98) from the Cluster Monitoring operator.

### controller-runtime (>= v0.16.0)

Starting with v0.16.0, the `controller-runtime` framework provides a way to expose and secure a `/metrics` endpoint using TLS with minimal effort.

Refer to https://pkg.go.dev/sigs.k8s.io/controller-runtime/pkg/metrics/server for details about TLS configuration and check the next section to understand how it needs to be configured.

### Roll your own HTTPS server

> You don't use `library-go`, `controller-runtime` >= v0.16.0 or don't want to run a `kube-rbac-proxy` sidecar.

In such situations, you need to implement your own HTTPS server for `/metrics`. As explained before, it needs to require and verify the TLS client certificate using the root CA stored under the `client-ca-file` key of the `kube-system/extension-apiserver-authentication` ConfigMap.

In practice, the server should:
* Set TLSConfig's `ClientAuth` field to `RequireAndVerifyClientCert`.
* Reload the root CA when the source ConfigMap is updated.
* Reload the server's certificate and key when they are updated.

Example: https://github.com/openshift/cluster-monitoring-operator/pull/1870

## Configuring Prometheus to scrape metrics

To tell the Prometheus pods running in the `openshift-monitoring` namespace (e.g. `prometheus-k8s-{0,1}`) to scrape the metrics from your operator/operand pods, you should use `ServiceMonitor` and/or `PodMonitor` custom resources.

The workflow is:
* Add the `openshift.io/cluster-monitoring: "true"` label to the namespace where the scraped targets live.
  * **Important: only OCP core components and Red Hat certified operators can set this label on namespaces.**
* In case of ServiceMonitor:
  * Create a Service object selecting the scraped pods.
  * Create a ServiceMonitor object targeting the Service.
* In case of PodMonitor:
  * Create a PodMonitor object targeting the pods.

Below is an fictitious example using a ServiceMonitor object to scrape metrics from pods deployed in the `openshift-example` namespace.

**Service manifest**

```yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    # This annotation tells the service CA operator to provision a Secret
    # holding the certificate + key to be mounted in the pods.
    # The Secret name is "<annotation value>" (e.g. "secret-my-app-tls").
    service.beta.openshift.io/serving-cert-secret-name: tls-my-app-tls
  labels:
    app.kubernetes.io/name: my-app
  name: metrics
  namespace: openshift-example
spec:
  ports:
  - name: metrics
    port: 8443
    targetPort: metrics
  # Select all Pods in the same namespace that have the `app.kubernetes.io/name: my-app` label.
  selector:
    app.kubernetes.io/name: my-app
  type: ClusterIP
```

**ServiceMonitor manifest**

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-app
  namespace: openshift-example
spec:
  endpoints:
  - interval: 30s
    # Matches the name of the service's port.
    port: metrics
    scheme: https
    tlsConfig:
      # The CA file used by Prometheus to verify the server's certificate.
      # It's the cluster's CA bundle from the service CA operator.
      caFile: /etc/prometheus/configmaps/serving-certs-ca-bundle/service-ca.crt
      # The name of the server (CN) in the server's certificate.
      serverName: my-app.openshift-example.svc
      # The client's certificate file used by Prometheus when scraping the metrics.
      # This file is located in the Prometheus container.
      certFile: /etc/prometheus/secrets/metrics-client-certs/tls.crt
      # The client's key file used by Prometheus when scraping the metrics.
      # This file is located in the Prometheus container.
      keyFile: /etc/prometheus/secrets/metrics-client-certs/tls.key
  selector:
    # Select all Services in the same namespace that have the `app.kubernetes.io/name: my-app` label.
    matchLabels:
      app.kubernetes.io/name: my-app
```

## Configuring Prometheus rules

In a similar way, you can configure the Prometheus pods with recording and alerting rules based on the metrics being collected. To do so, you should create `PrometheusRule` objects in your operator/operand namespace which will also be picked up by the Prometheus operator.
