# Red Hat Observability Service

*Other Documents:*

* [Initial Design for RHOBS (Internal Content)](https://docs.google.com/document/d/1cSz_ZbS35mk8Op92xhB9ijW1ivOtJuD1uAzPiBdSUqs/edit)
* [Initial FAQ (Internal Content)](https://docs.google.com/document/d/1_xnJBS3v7n4m229L3tqCqBXzZy55yu6dxCJY-vh_Egs/edit)
* [Multi-Regional RHOBS (Internal Content)](https://docs.google.com/document/d/1w1rA7vm3nmUfgRNWtsA2SYpia_1d1UdTXuXXWx2SxqA/edit)

## What

Red Hat Observability Service (RHOBS) is a managed, centralized, multi-tenant, scalable backend for observability data. Functionally it is an internal deployment of [Observatorium](../../Projects/Observability/observatorium.md) project. RHOBS is designed to allow ingesting, storing and consuming (visualisations, import, alerting, correlation) observability signals like metrics, logging and tracing.

This document provides the basic overview of the RHOBS service. If you want to learn about RHOBS architecture, check the [Design document](design.md).

### Background

With the amount of managed Openshift clusters, for Red Hat’s own use as well as for customers, there is a strong need to take the observability of those clusters and of their workloads to the multi-cluster level.

Particularly the reasons can be formulated as follows:

* Managing observability and alerting for applications running on more than one cluster, which is a default nowadays (cluster as a cattle).
* Need to offload data and observability services from edge cluster to reduce complexity and cost of edge cluster (e.g. remote health capabilities, alerting, ).
* Allow offloading teams from maintaining their own observability service or persistent stacks.

It’s worth noting that there is also a significant benefit to collecting and using multiple signals within one system:

* Correlating signals and creating a smooth and richer debugging UX.
* Sharing common functionality, like rate limiting, retries, auth, etc, which allows a consistent integration and management experience for users.

The Openshift Monitoring Team began preparing for this shift in 2018 with the [Telemeter](use-cases/telemetry.md) Service. In particular, while creating the second version of the Telemeter Service, we put effort into developing and contributing to open source systems and integration to design [“Observatorium”](../../Projects/Observability/observatorium.md): a multi-signal, multi-tenant system that can be operated easily and cheaply as a Service either by Red Hat or on-premise. After extending the scope of the RHOBS, Telemeter become the first "tenant" of the RHOBS.

In Summer 2020, the Monitoring Team together with the OpenShift Logging Team added a logging signal to [“Observatorium”](../../Projects/Observability/observatorium.md) and started to manage it for internal teams as the RHOBS.

### Current Design

RHOBS is running in production and has already been offered to various internal teams, with more extensions and expansions coming in the near future.

There is currently no plan to offer RHOBS to external customers, however anyone is welcome to deploy and manage an RHOBS-like-service on their own using [Observatorium](../../Projects/Observability/observatorium.md). This project is used by RHOBS as the regional instances. More on that in the [design overview](design.md)

### Owners

RHOBS was initially designed by `Monitoring Group` and its metric signal is managed and supported by `Monitoring` Group team (OpenShift organization) together with AppSRE team (Service Delivery organization).

Other signals are managed by others team (each together with AppSRE help):

* Logging signal: OpenShift Logging Team
* Tracing signal: OpenShift Tracing Team

Telemeter part client side is maintained by In-cluster Monitoring team, but managed by corresponding client cluster owner.

### Metric Label Restrictions

There is small set of reserved label name that are reserved on RHOBS side. If remote write request contains series with those labels, they will be overridden (not honoured).

Restricted labels:

* `tenant_id`: Internal tenant ID in form of UUID that is injected to all series in various placed and constructed from tenant authorization (HTTP header).
* `receive`: Special label used internally.
* `replica` and `rule_replica`: Special label used internally to replicate receive and rule data for reliability.

Special labels:

* `prometheus_replica`: Use this label for Agent/Prometheus unique scraper ID if you scrape and push from multiple of replicas scraping the same data. RHOBS is configured to deduplicate metrics based on this.

Recommended labels:

* `_id` for cluster ID (in form of lowercase UUID) is the common way of identifying clusters.
* `prometheus` is a name of Prometheus (or any other scraper) that was used to collect metrics.
* `job` is scrape job name that is usually dynamically set to abstracted service name representing microservice (usually deployment/statefulset name)
* `namespace` is Kubernetes namespace. Useful to make sure identify same microservices across namespaces.
* For more "version" based granularit (warning - every pod rollout creates new time series).
  * `pod` is a pod name
  * `instance` is an IP:port (useful when pod has sidecars)
  * `image` is image name and tag.

### Support

For support see:

* [RHOBS escalation flow](use-cases/observability.md#support) and [RHOBS SLA](use-cases/observability.md#service-level-agreement).
* [Telemeter escalation flow](use-cases/telemetry.md#support) and [Telemeter SLA](use-cases/telemetry.md#service-level-agreement).
