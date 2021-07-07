# RHOBS: Telemeter

> For RHOBS Overview see [this document](README.md)

Telemeter is the metric only hard tenant of RHOBS service designed for centralized Openshift Telemetry pipelined for Openshift Container Platform. It is an essential part of gathering the real time telemetry for remote health monitoring, automation and billing purposes.

*Official Openshift Documentation*: https://docs.openshift.com/container-platform/4.6/support/remote_health_monitoring/about-remote-health-monitoring.html#telemetry-about-telemetry_about-remote-health-monitoring

## Product Managers

* Blair Rampling
* Christian Heidenreich

## Support

To escalate issues use, depending on issue type:

* For questions related to the service or kind of data it ingests use `telemetry-sme@redhat.com` (internal) mail address. For quick questions you can try to use `#forum-telemetry` on CoreOS Slack.
* For functional bugs or feature requests use Bugzilla, with Product: `Openshift Container Platform` and `Telemeter` component ([example bug](https://bugzilla.redhat.com/show_bug.cgi?id=1914956)). You can additionally notify us about new bug on `#forum-telemetry` on CoreOS Slack.
* For functional bugs or feature request for historical storage (Data Hub) use PNT Jira project

> For the managing team: See our internal [agreement document](https://docs.google.com/document/d/1iAhzVxm2ovqkWxJCLplwR7Z-1gzXhfRKcHqXnpQh9Hg/edit#).

### Escalations

For urgent escalation use:

* For Telemeter Service Unavailability: `@app-sre-ic` and `@observatorium-oncall` on CoreOS Slack.
* For Historical Data (DataHub) Service Unavailability: `@data-hub-ic` on CoreOS Slack.

## Service Level Agreement

![SLO](../../../assets/slo-def.png)

#### Metrics SLIs

| API      | SLI Type     | SLI Spec                               | Period | SLI Implementation             | Dashboard                                                                                           |
|----------|--------------|----------------------------------------|--------|--------------------------------|-----------------------------------------------------------------------------------------------------|
| `/write` | Availability | The % of successful (non 5xx) requests | 28d    | Metrics from Observatorium API | [Dashboard](https://grafana.app-sre.devshift.net/d/Tg-mH0rizaSJDKSADJ/telemeter?orgId=1&refresh=1m) |
| `/write` | Latency      | The % of requests under X latency      | 28d    | Metrics from Observatorium API | [Dashboard](https://grafana.app-sre.devshift.net/d/Tg-mH0rizaSJDKSADJ/telemeter?orgId=1&refresh=1m) |

Read Metrics TBD.

*Agreements*:

> NOTE: No entry for your case (e.g dev/staging) means zero formal guarantees.

| SLI                   | Date of Agreement | Tier               | SLO                                                                             | Notes                                                                                                                                                                                                           |
|-----------------------|-------------------|--------------------|---------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `/write` Availability | 2020/2019         | Internal (default) | 99% success rate for incoming [requests](#write-limits)                         | This depends on SSO RedHat com SLO (98.5%). In worst case (everyone needs to refresh token) we have below 98.5%, in the avg case with caching being 5m (we cannot change it) ~99% (assuming we can preserve 5m) |
| `/write` Latency      | 2020/2019         | Internal (default) | 95% of [requests](#write-limits) < 250ms, 99% of [requests](#write-limits) < 1s |                                                                                                                                                                                                                 |

##### Write Limits

Within our SLO the write request to be valid it has to match following criteria:

* Valid remote write requests using official remote write protocol (See conformance test)
* Valid credentials: (explanation TBD)
* Max samples: TBD
* Max series: TBD
* Rate limit: TBD

TODO: Provide example tune-ed client Prometheus configurations for remote write

### Escalation
