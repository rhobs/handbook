# Thanos

Thanos is a horizontally scalable, multi-tenant monitoring system in a form of distributed time series database that supports Prometheus data format.

### Official Documentation

https://thanos.io/tip/thanos/getting-started.md

### APIs

* Querying: Prometheus APIs, Remote Read
* Series: Prometheus APIs, gRPC SeriesAPI
* Metric Metadata: Prometheus API, gRPC MetricMetadataAPI
* Rules, Alerts: Prometheus API, gRPC RulesAPI
* Targets: Prometheus API, gRPC TargetsAPI
* Exemplars: Prometheus API, gRPC ExemplarsAPI
* Receiving: Prometheus Remote Write

### Tutorials

https://katacoda.com/thanos

### Notable Talks/Blog Posts

* 12.2020: [Absorbing Thanos Infinite Powers for Multi-Cluster Telemetry](https://www.youtube.com/watch?v=6Nx2BFyr7qQ)
* 12.2020: [Turn It Up to a Million: Ingesting Millions of Metrics with Thanos Receive](https://www.youtube.com/watch?v=5MJqdJq41Ms)
* 02.2019: [FOSDEM + demo](https://fosdem.org/2019/schedule/event/thanos_transforming_prometheus_to_a_global_scale_in_a_seven_simple_steps/)
* 03.2019: [Alibaba Cloud user story](https://www.youtube.com/watch?v=ZS6zMksfipc)
* [CloudNative Deep Dive](https://www.youtube.com/watch?v=qQN0N14HXPM)
* [CloudNative Intro](https://www.youtube.com/watch?v=m0JgWlTc60Q)
* [Prometheus in Practice: HA with Thanos](https://www.slideshare.net/ThomasRiley45/prometheus-in-practice-high-availability-with-thanos-devopsdays-edinburgh-2019)

* [Banzai Cloud user story](https://banzaicloud.com/blog/multi-cluster-monitoring/)

### Bug Trackers

https://github.com/thanos-io/thanos/issues

### Communication Channels

The CNCF Slack workspace's ([join here](https://cloud-native.slack.com/messages/CHY2THYUU)) channels:

* `#thanos` for user related things.
* `#thanos-dev` for developer related things.

### Proposal Process

https://thanos.io/tip/contributing/contributing.md/#adding-new-features--components

### Our Usage

We use Thanos in many places within Red Hat, notably:

* In [Prometheus Operator (sidecar)](prometheusOp.md)
* In Openshift Platform Monitoring (PM) (see [CMO](openshiftcmo.md))
* In Openshift User Workload Monitoring (UWM)
* In [RHOBS](RHOBS) (so [Observatorium](observatorium.md))

### Maintainers

https://thanos.io/tip/thanos/maintainers.md/#core-maintainers-of-this-repository
