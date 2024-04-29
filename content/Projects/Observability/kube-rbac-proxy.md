# kube-rbac-proxy

`kube-rbac-proxy`, as the name suggests, is an HTTP proxy that sits in front of a workload and performs authentication and authorization of incoming requests using the `TokenReview` and `SubjectAccessReview` resources of the Kubernetes API.

## Workflow

The purpose of `kube-rbac-proxy` is to distinguish between calls made by same or different user(s) (or service account(s)) to endpoint(s) and protect them from unauthorized resource access based on their trusted identity (e.g. tokens, TLS certificates, etc.) or the RBACs they hold, respectively. Once the request is authenticated and/or authorized, the proxy forwards the response from the server to the client unmodified.

### [**Authentication**](https://github.com/brancz/kube-rbac-proxy/blob/74181c75b8b6fbcde7eff1ca5fae353faac5cfae/pkg/authn/config.go#L33-L39)

kube-rbac-proxy can be configured with one of the 2 mechanisms for authentication:

* [OpenID Connect](https://github.com/brancz/kube-rbac-proxy/blob/52e49fbdb75e009db4d02e3986e51fdba0526378/pkg/authn/oidc.go#L45-L63) where kube-rbac-proxy validates the client-provided token against the configured OIDC provider. This mechanism isn't used by the monitoring components.

* Kubernetes API using bearer tokens or mutual TLS:
  * [Delegated authentication](https://github.com/kubernetes/apiserver/blob/8ad2e288d62d02276033ea11ee1efd94bb627836/pkg/authentication/authenticatorfactory/delegating.go#L102-L112) relies on Bearer tokens. The token represents the identity of the user or service account that is making the request and kube-rbac-proxy uses a [`TokenReview` request](https://github.com/kubernetes/apiserver/blob/21bbcb57c672531fe8c431e1035405f9a4b061de/plugin/pkg/authenticator/token/webhook/webhook.go#L51-L53) to verify the identity of the client.
  * If kube-rbac-proxy is configured with a client certificate authority, it can also verify the identify of the client presenting a TLS certificate. Some monitoring components use this [mechanism](#downstream-usage) which avoids a round-trip communication with the Kubernetes API server.

In the case of a failed authentication, an [HTTP `401 Unauthorized` status code](https://github.com/brancz/kube-rbac-proxy/blob/9efde2a776fd516cfa082cc5f2c35c7f9e0e2689/pkg/filters/auth_test.go#L290) is returned (note the distinction between *authentication* and *unauthorized* here). Note that anonymous access is always disabled, and the proxy doesn't rely on HTTP headers to authenticate the request but it can add them if started with `--auth-header-fields-enabled`.

Refer to [this page](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) for more information on authentication in Kubernetes.

### [**Authorization**](https://github.com/brancz/kube-rbac-proxy/blob/1c7f88b5e951d25a493a175e93515068f5c77f3b/pkg/authz/auth.go#L31C1-L37)

Once authentication is done, `kube-rbac-proxy` must then decide whether to allow the user's request to go through or not. A [`SubjectAccessReview` request is created](https://github.com/kubernetes/apiserver/blob/21bbcb57c672531fe8c431e1035405f9a4b061de/plugin/pkg/authorizer/webhook/webhook.go#L57-L59) for the API server, which allows for the review of the subject's access to a particular resource. Essentially, it checks whether the authenticated user or service account has sufficient permissions to perform the desired action on the requested resource, based on the RBAC permissions granted to it. If so, the request is forwarded to the endpoint, otherwise it is rejected. It is worth mentioning that the HTTP verbs are internally mapped to their [corresponding RBAC verbs](https://github.com/brancz/kube-rbac-proxy/blob/ccd5bc7fec36f9db0747033c2d698cc75a0e314c/pkg/proxy/proxy.go#L49-L60). Note that static authorization (as described in the [downstream usage](#downstream-usage) section) without SubjectAccessReview is also possible.

Once the request is authenticated and authorized, it is forwarded to the endpoint. The response from the endpoint is then forwarded back to the client. If the request fails at any point, the proxy returns an error response to the client. If the authorization step fails, i.e., the client doesn't have the required permissions to access the requested resource, `kube-rbac-proxy` returns an [HTTP `403 Forbidden` status code](https://github.com/brancz/kube-rbac-proxy/blob/9efde2a776fd516cfa082cc5f2c35c7f9e0e2689/pkg/filters/auth_test.go#L300) to the client and does not forward the request to the endpoint.

## Downstream usage

### Inter-component communication

In the context of monitoring, we're talking here about metric scrapes. These communications are usually secured using Mutual TLS (mTLS), which is a two-way authentication mechanism (see [configuring Prometheus to scrape metrics](https://rhobs-handbook.netlify.app/products/openshiftmonitoring/collecting_metrics.md/)).

Initially, the server (Prometheus) provides its digital certificate to the client which validates the server's identity. The process is then reciprocated, as the client shares its digital certificate for authentication by the server. Following the successful completion of these authentication steps, a secure channel for encrypted communication is established, ensuring that data transfer between the entities is duly safeguarded.

```yaml
apiVersion: apps/v1
kind: Deployment
...
spec:
  template:
    spec:
      containers:
      - name: kube-rbac-proxy
        image: quay.io/brancz/kube-rbac-proxy:v0.8.0
        args:
        - "--tls-cert-file=/etc/tls/private/tls.crt"
        - "--tls-private-key-file=/etc/tls/private/tls.key"
        - "--client-ca-file=/etc/tls/client/client-ca.crt"
        ...
```

CMO specifies the aforementioned CA certificate in the [metrics-client-ca](https://github.com/openshift/cluster-monitoring-operator/blob/6795f509e77cce6d24e5a3e371a432ca22e1a8e7/assets/cluster-monitoring-operator/metrics-client-ca.yaml) ConfigMap which is used to define client certificates for every `kube-rbac-proxy` container that's safeguarding a component. The component's `Service` endpoints are secured using the generated TLS `Secret` annotating it with the `service.beta.openshift.io/serving-cert-secret-name`. Internally, this requests the [`service-ca`](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.1/html/authentication/configuring-certificates#understanding-service-serving_service-serving-certificate) controller to generate a `Secret` containing a certificate and key pair for the `${service.name}.${service.namespace}.svc`. These TLS manifests are then used in various component `ServiceMonitors` to define their TLS configurations, and within CMO to ensure a "mutual" acknowledgement between the two.

Static authorization involves configuring `kube-rbac-proxy` to allow access to certain resources or non-resources which are evaluated against the `Role` or `ClusterRole` RBAC permissions the user or the service account has. The example below demonstrates how this can be employed to give access to a known `ServiceAccount` to the `/metrics` endpoint. `/metrics` endpoints exposed by various monitoring components are protected this way. Note that after the initial user or service account authentication, the request is matched against a comma-separated list of paths, as defined by the [`--allow-path`](https://github.com/brancz/kube-rbac-proxy/blob/067e14a2d1ecdfe8c18da6b0a0507cd4684e2c1c/cmd/kube-rbac-proxy/app/options/options.go#L83) flag, [like so](https://github.com/openshift/cluster-monitoring-operator/blob/4e8efd9864bff3ff46499e86fef8bba1e0178f54/assets/alertmanager/alertmanager.yaml#L96).

```yaml
apiVersion: v1
kind: Secret
...
stringData:
  # "path" is the path to match against the request path.
  # "resourceRequest" is a boolean indicating whether the request is for a resource or not.
  # "user" is the user to match against the request user.
  # "verb" is the verb to match against the corresponding request RBAC verb.
  config.yaml: |-
    "authorization":
      "static":
      - "path": "/metrics"
        "resourceRequest": false
        "user":
          "name": "system:serviceaccount:openshift-monitoring:prometheus-k8s"
        "verb": "get"
```

For more details, refer to the `kube-rbac-proxy`'s [static authorization](https://github.com/brancz/kube-rbac-proxy/blob/4a44b610cd12c4cfe076a2b306283d0598c1bb7a/examples/static-auth/README.md#L169) example.

For more information on collecting metrics in such cases, refer to [this section](https://rhobs-handbook.netlify.app/products/openshiftmonitoring/collecting_metrics.md/#exposing-metrics-for-prometheus) of the handbook.

### Securing API endpoints

`kube-rbac-proxy` is also used to secure API endpoints such as Prometheus, Alertmanager and Thanos. In this case, the proxy is configured to authenticate requests based on bearer tokens and to perform authorization with `SubjectAccessReview`.

The following components use the same method in their `kube-rbac-proxy` configurations `Secrets` to authorize the `/metrics` endpoint and restrict it to `GET` requests only:

* `alertmanager-kube-rbac-proxy-metric` (`alertmanager`)
* `openshift-user-workload-monitoring` (`alertmanager-user-workload`)
* `kube-state-metrics-kube-rbac-proxy-config` (`kube-state-metrics`)
* `node-exporter-kube-rbac-proxy-config` (`node-exporter`)
* `openshift-state-metrics-kube-rbac-proxy-config` (`openshift-state-metrics`)
* `kube-rbac-proxy` (`prometheus-k8s`) (additionally the `/federate` endpoint, for the telemeter as well as its own client)
* `prometheus-operator-kube-rbac-proxy-config` (`prometheus-operator`)
* `prometheus-operator-uwm-kube-rbac-proxy-config` (`prometheus-operator`)
* `kube-rbac-proxy-metrics` (`prometheus-user-workload`)
* `telemeter-client-kube-rbac-proxy-config` (`telemeter-client`)
* `thanos-querier-kube-rbac-proxy-metrics` (`thanos-querier`)
* `thanos-ruler-kube-rbac-proxy-metrics` (`thanos-ruler`)

On the other hand, the example below depicts restricted access to a resource, i.e., `monitoring.coreos.com/prometheusrules` in the `openshift-monitoring` namespace.

```yaml
apiVersion: v1
kind: Secret
...
stringData:
  # "resourceAttributes" describes attributes available for resource request authorization.
  # "rewrites" describes how SubjectAccessReview may be rewritten on a given request.
  # "rewrites.byQueryParameter" describes which HTTP URL query parameter is to be used to rewrite a SubjectAccessReview 
  # on a given request.
  config.yaml: |-
    "authorization":
      "resourceAttributes":
        "apiGroup": "monitoring.coreos.com"
        "namespace": "{{ .Value }}"
        "resource": "prometheusrules"
      "rewrites":
        "byQueryParameter":
          "name": "namespace"
```

The following components use the same method in their `kube-rbac-proxy` configuration `Secrets` to authorize the respective resources:
* `alertmanager-kube-rbac-proxy` (`alertmanager`): `prometheusrules`
* `alertmanager-kube-rbac-proxy-tenancy` (`alertmanager-user-workload`): `prometheusrules`
* `kube-rbac-proxy-federate` (`prometheus-user-workload`): `namespaces`
* `thanos-querier-kube-rbac-proxy-rules` (`thanos-querier`): `prometheusrules`
* `thanos-querier-kube-rbac-proxy` (`thanos-querier`): `pods`

Note that all applicable omitted configuration settings are interpreted as wildcards.

## Configuration

Details on configuring `kube-rbac-proxy` under different scenarios can be found in the repository's [/examples](https://github.com/brancz/kube-rbac-proxy/tree/9f436d46699dfd425f2682e4338069642b682892/examples) section.

## Debugging

In addition to enabling debug logs or compiling a custom binary with debugging capabilities (`-gcflags="all=-N -l"`), users can:
* [put the CMO into unmanaged state](https://github.com/openshift/cluster-monitoring-operator/blob/e1803adfa64f9ef424cd6e10790791adbed25eb4/hack/local-cmo.sh#L68-L103) to enable a higher verbose level using `-v=12` (or higher), or,
* grep [the audit logs](https://docs.openshift.com/container-platform/4.13/security/audit-log-view.html) for more information about requests or responses concerning `kube-rbac-proxy`.
