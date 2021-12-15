# Observatorium

Observatorium is an observability system designed to enable the ingestion, storage (short and long term) and querying capabilities for three major observability signals: metrics, logging and tracing. It unifies horizontally scalable, multi-tenant systems like Thanos, Loki, and in the future, Jaeger to deploy them in a single stack with consistent APIs. On top of that it's designed to be managed as a service thanks to consistent tenancy, authorization and rate limiting across all three signals.

### Official Documentation

https://observatorium.io

### APIs

TBD(https://github.com/rhobs/handbook/issues/22)

#### Read: Metrics

* GET /api/metrics/v1/api/v1/query
* GET /api/metrics/v1/api/v1/query_range
* GET /api/metrics/v1/api/v1/series
* GET /api/metrics/v1/api/v1/labels
* GET /api/metrics/v1/api/v1/label/<name>/values

### Notable Talks/Blog Posts

* 04.2021: [Upstream-First High Scale Prometheus Ecosystem](https://www.youtube.com/watch?v=r0fRFH_921E&list=PLj6h78yzYM2PZb0QuIkm6ZY-xTuNA5zRO&index=6)

### Bug Trackers

https://github.com/observatorium/observatorium/issues

### Communication Channels

The CNCF Slack workspace's ([join here](https://cloud-native.slack.com/messages/CHY2THYUU)) channels:

* `#observatorium` for user related things.
* `#observatorium-dev` for developer related things.

### Proposal Process

TBD

### Our Usage

We use Observatorium as a Service for our [Red Hat Observability Service (RHOBS)](../../Services/RHOBS).

We also know of several other companies installing Observatorium on their own (as of 2021.07.07):

* RHACM
* Managed Tenants until they can get access to RHBOBS (e.g. Kafka Team)
* IBM
* GitPod

### Maintainers

https://github.com/observatorium/observatorium/blob/main/docs/community/maintainers.md
