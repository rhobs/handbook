# Kube State Metrics

`kube-state-metrics` (KSM) is a service that listens to the Kubernetes API server and generates metrics about the state of the objects. It's an add-on agent to generate and expose cluster-level metrics.

### Official Documentation

- Overview: [`README.md`](https://github.com/kubernetes/kube-state-metrics/tree/main/docs)
- Resource-wise documentation: [`/docs`](https://github.com/kubernetes/kube-state-metrics/tree/main/docs)
- Design documentation: [`/docs/design`](https://github.com/kubernetes/kube-state-metrics/tree/main/docs/design)
- Developer documentation: [`/docs/developer`](https://github.com/kubernetes/kube-state-metrics/tree/main/docs/developer)

### Informational Media

- [PromCon 2017: Lightning Talk - `kube-state-metrics` - Frederic Branczyk](https://www.youtube.com/watch?v=nUkHeY48mIQ)
- [Intro and Deep Dive: Kubernetes SIG Instrumentation - David Ashpole & Han Kang, Frederic Branczyk](https://youtu.be/NzoG--2UqEk?t=888)
- [Episode 38: Custom Resources in `kube-state-metrics`](https://www.youtube.com/watch?v=rkaG4M5mo-8)
- [`kube-state-metrics` on Google Cloud](https://cloud.google.com/stackdriver/docs/managed-prometheus/exporters/kube_state_metrics)

### Bug Trackers

- [`/issues`](https://github.com/kubernetes/kube-state-metrics/issues)
- [`issues.redhat.com`](https://issues.redhat.com/browse/MON-2858?jql=project%20%3D%20MON%20AND%20issuetype%20in%20(Bug%2C%20Epic%2C%20Story%2C%20Task%2C%20Sub-task)%20AND%20resolution%20%3D%20Unresolved%20AND%20text%20~%20%22kube-state-metrics%22%20ORDER%20BY%20priority%20DESC%2C%20updated%20DESC)

### Get Involved

- [`#kube-state-metrics`](https://kubernetes.slack.com/archives/CJJ529RUY)
- [`#sig-instrumentation`](https://kubernetes.slack.com/archives/C20HH14P7)
- [SIG Instrumentation Biweekly Minutes](https://docs.google.com/document/d/1FE4AQ8B49fYbKhfg4Tx0cui1V0eI4o3PxoqQPUwNEiU)

### Internal Usages

- [`cluster-monitoring-operator/assets/kube-state-metrics/`](https://github.com/openshift/cluster-monitoring-operator/tree/master/assets/kube-state-metrics)
- [`openshift-state-metrics/`](https://github.com/openshift/openshift-state-metrics)

### Maintainers

- [`/OWNERS.md`](https://github.com/kubernetes/kube-state-metrics/blob/main/OWNERS)

### Miscellaneous

- [`/releases`](https://github.com/kubernetes/kube-state-metrics/releases)
