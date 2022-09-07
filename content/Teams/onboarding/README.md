# Team member onboarding

<!-- omit in toc -->

- [Team member onboarding](#team-member-onboarding)
  - [Team Background](#team-background)
  - [People relevant to Prometheus who you should know about:](#people-relevant-to-prometheus-who-you-should-know-about)
  - [Thanos](#thanos)
  - [Talks](#talks)
  - [First days (accounts & access)](#first-days-accounts--access)
  - [First weeks](#first-weeks)
    - [General](#general)
    - [Watch these talks](#watch-these-talks)
    - [[optional] Additional information & Exploration](#optional-additional-information--exploration)
    - [Who’s Who?](#whos-who)
    - [First project](#first-project)
  - [First Months](#first-months)
    - [Second project](#second-project)
  - [Glossary](#glossary)

Welcome to the Monitoring Team! We created this document to help guide you through your onboarding.

Please fork this repo and propose changes to the content as a pull request if something is not accurate, outdated or unclear. Use your fork to track the progress of your onboarding tasks, i.e. by keeping a copy in your fork with comments about your completion status. Please read the doc thoroughly and check off each item as you complete it. We consistently want to improve our onboarding experience and your feedback helps future team members.

This documents contains some links to Red Hat internal documents and you won't be able to access them without a Red Hat associate login. We are still trying to keep as much information as possible in the open.

## Team Background

Team Monitoring mainly focuses on Prometheus, Thanos, Observatorium, and their integration into Kubernetes and OpenShift. We are also responsible for the hosted multi-tenant Observability service which powers such services as OpenShift Telemetry and OSD metrics.

Prometheus is a monitoring project initiated at SoundCloud in 2012. It became public and widely usable in early 2015. Since then, it found adoption across many industries. In early 2016 development diversified away from SoundCloud as CoreOS hired one of the core developers. Prometheus is not a single application but an entire ecosystem of well-separated components, which work well together but can be used individually.

CoreOS was acquired by Red Hat in early 2018. The CoreOS monitoring team became the Red Hat Monitoring Team, which has evolved into the “Observability group”. The teams were divided into two teams:

1. The In-Cluster Observability Team
2. The Observability Platform team (aka RHOBS or Observatorium team)

You may encounter references to these two teams. In early 2021 we decided to combine the efforts of these teams more closely in order to avoid working in silos and ensure we have a well functioning end-to-end product experience across both projects. We are, however, still split into separate scrum teams for efficiency. We are now collectively known as the “Monitoring Team” and each team works together across the various domains.

We work on all important aspects of the upstream eco-system and a seamless monitoring experience for Kubernetes using Prometheus. Part of that is integrating our open source efforts into the OpenShift Container Platform (OCP), the commercial Red hat Kubernetes distribution.

## People relevant to Prometheus who you should know about:

- Julius Volz ([@juliusv](https://github.com/juliusv)): Previously worked at Soundcloud where he developed prometheus. Now working as an independent contractor and organizing [PromCon](http://promcon.io/) (Prometheus community conference). He also worked with weave.works on a prototype for remote/long-term time series storage, with Influxdb on Flux PromQL support. Contributed new Prometheus UI in React. He also created a new company [PromLens](https://promlens.com/), for a rich PromQL UI.
- Bjoern Rabenstein ([@beorn7](https://github.com/beorn7)): Worked at SoundCloud but now works at Grafana. He's active again upstream and the maintainer of pushgateway and client_golang (the Go client Prometheus library).
- Frederic Branczyk ([@brancz](https://github.com/brancz)): Joined CoreOS in 2016 to work around Prometheus. Core Team member since then and one of the minds behind our team's vision. Left Red Hat in 2020 to start his new company around continuous profiling (PolarSignals). Still very active in upstream.
- Julien Pivotto ([@roidelapluie](https://github.com/roidelapluie)): prometheus/prometheus maintainer. Very active in other upstream projects (Alertmanager, …).

## Thanos

Thanos is a monitoring system, which was created based on Prometheus principles. It is a distributed version of Prometheus where every piece of Prometheus like scraping, querying, storage, recording, alerting, and compaction can be deployed as separate horizontally scalable components. This allows more flexible deployments and capabilities beyond single clusters. Thanos also supports object storage as the main storage option, allowing cheap long term retention for metrics. At the end it exposes the same (yet extended) Prometheus APIs and uses gRPC to communicate between components.

Thanos was created because of the scalability limits of Prometheus in 2017. At that point a similar project Cortex was emerging too, but it was over complex at that time. In November 2017, Fabian Reinartz ([@fabxc](https://github.com/fabxc), consulting for Improbable at that time) and Bartek Plotka ([@bwplotka](https://github.com/bwplotka)), teamed up to create Thanos based on the Prometheus storage format. Around February 2018 the project was shown at Prometheus Meetup in London, and in Summer 2018 announced on PromCon 2018. In 2019, our team in Red Hat, led at that point by Frederic Branczyk [@brancz](https://github.com/brancz), contributed essential pieces allowing Thanos to receive remote-write (push model) for Prometheus metrics. Since then, we could leverage Thanos for Telemetry gathering and then in in-cluster Monitoring, too.

When working with it you will most likely interact with Bartek Plotka ([@bwplotka](https://github.com/bwplotka)) and other team members.

These are the people you’ll be in most contact with when working upstream. If you run into any communication issues, please let us know as soon as possible.

## Talks

Advocating about sane monitoring and alerting practices (especially focused on Kubernetes environments) and how Prometheus implements them is part of our team’s work. That can happen internally or on public channels. If you are comfortable giving talks on the topic or some specific work we have done, let us know so we can plan ahead to find you a speaking opportunity at meetups or conferences. If you are not comfortable, but want to break this barrier let us know as well, we can help you get more comfortable in public speaking slowly step by step. If you want to submit a CFP for a talk please add it to this [spreadsheet](https://docs.google.com/spreadsheets/d/1eo_JVND3k4ZnL25kgnhITSE2DBkyw8fwg3MyCXMjdYU/edit#gid=1880565406) and inform your manager.

## First days (accounts & access)

1. Follow up on [administrative tasks](https://docs.google.com/document/d/1bJSrlyc-e7bcOxV4sjx3FesMNVgdwNxUzMvIYywbt-0).
2. Understand the meetings the team attends to:

Ask your manager to be added to the [Observability Program](https://calendar.google.com/calendar/u/0?cid=cmVkaGF0LmNvbV91N3YwbGt2cnRuM2wwbWJmMnF2M2VkMm12MEBncm91cC5jYWxlbmRhci5nb29nbGUuY29t) calendar. Ensure you attend the following recurring meetings:

* Team syncs
* Sprint retro/planning
* Sprint reviews
* Weekly architecture call
* 1on1 with manager
* Weekly 1on1 with your mentor ([mentors are tracked here](https://docs.google.com/spreadsheets/d/1SpdBbZChBNuPHVtbCjOch1mfZGUuCjkrp7yyCClL9kk/edit#gid=0))

## First weeks

Set up your computer and development environment and do some research. Feel free to come back to these on an ongoing basis as needed. There is no need to complete them all at once.

### General

1. Review our product documentation (this is very important): [Understanding the monitoring stack | Monitoring | OpenShift Container Platform 4.10](https://docs.openshift.com/container-platform/4.10/monitoring/monitoring-overview.html#understanding-the-monitoring-stack_monitoring-overview)
2. Review our team’s process doc: [Monitoring Team Process](https://docs.google.com/document/d/1vbDGcjMjJMTIWcua5Keajla9FzexjLKmVk7zoUc0_MI/edit#heading=h.n0ac5lllvh13)
3. Review how others should formally submit requests to our team: [Requests: Monitoring Team](https://docs.google.com/document/d/10orRGt5zlmZ-XsXQNY-sg6lOzWDCrPmHP68Oi-ETU9I)
4. If you haven’t already, buy this book and make a plan to finish it over time (you can expense it): *“Site Reliability Engineering: How Google Runs Production Systems”*. Online version of the book can be found here: [https://sre.google/books/](https://sre.google/books/).
5. Ensure you attend a meeting with your team lead or architect to give a general overview of our in-cluster OpenShift technology stack.
6. Ensure you attend a meeting with your team lead or architect to give a general overview of our hosted Observatorium/Telemetry stack.
7. Bookmark this spreadsheet for reference of all [OpenShift release dates](https://docs.google.com/spreadsheets/d/19bRYespPb-AvclkwkoizmJ6NZ54p9iFRn6DGD8Ugv2c/edit#gid=0). Alternatively, you can add the [OpenShift Release Dates](https://calendar.google.com/calendar/embed?src=c_188dvhrfem5majheld63i20a7rslg%40resource.calendar.google.com&ctz=America%2FNew_York) calendar.

### Watch these talks

* [Prometheus introduction](https://www.youtube.com/watch?v=PzFUwBflXYc) by Julius Volz (project’s cofounder) @ KubeCon EU 2020
* [The Zen of Prometheus](https://www.youtube.com/watch?v=Nqp4fjw_omU), by Kemal (ex-Observability Platform team) @ PromCon 2020
* [The RED Method: How To Instrument Your Services](https://www.youtube.com/watch?v=zk77VS98Em8) by Tom Wilkie @ GrafanaCon EU 2018
* [Thanos: Prometheus at Scale](https://www.youtube.com/watch?v=q9j8vpgFkoY) by Lucas and Bartek (Observability Platform team) @ DevConf 2020
* [Instrumenting Applications and Alerting with Prometheus](https://www.youtube.com/watch?v=sHKWD8XnmmY), from Simon (Cluster Observability team) @ OSSEU 2019
* [PromQL for mere mortals](https://www.youtube.com/watch?v=hTjHuoWxsks) by Ian Billett (Observability Platform team)@ PromCon 2019
* [Life of an alert (Alertmanager)](https://www.youtube.com/watch?v=PUdjca23Qa4), @ PromCon 2018
* [Best practices and pitfalls](https://www.youtube.com/watch?v=_MNYuTNfTb4) @ PromCon 2017
* [Deep Dive: Kubernetes Metric APIs using Prometheus](https://www.youtube.com/watch?v=cIoOAbzhR7k)
* [Monitoring Kubernetes with prometheus-operator](https://www.youtube.com/watch?v=MuHPMXCGiLc) by Lili @ Cloud Native Computing Berlin meetup 2021
* [Using Jsonnet to Package Together Dashboards, Alerts and Exporters](https://www.youtube.com/watch?v=b7-DtFfsL6E) by Tom Wilkie(Grafana Labs) @ Kubecon, Europe 2018
* [(Internal) Observatorium Deep Dive](https://drive.google.com/drive/u/0/folders/1NHhgoYi5y58wJpi_qp49tx1V9TQcRQTj), January 2021 by Kemal
* [(Internal) How to Get Reviewers to Block your Changes](https://drive.google.com/file/d/1KOWv5A2qAoO1CfbfhCIJW1wcOnGpfTST/view), March 2022 by Assaf

### [optional] Additional information & Exploration

* [https://www.linkedin.com/learning/](https://www.linkedin.com/learning/)
  * Red Hat has a corporate subscription to LinkedIn Learning that has great introductory courses to many topics relevant to our team
* [Prometheus Monitoring](https://www.youtube.com/channel/UC4pLFely0-Odea4B2NL1nWA/videos) channel on Youtube
* PromLabs [PromQL cheat sheet](https://promlabs.com/promql-cheat-sheet/)
* [Prometheus-example-app](https://github.com/brancz/prometheus-example-appPrometheus-example-apphttps://github.com/brancz/prometheus-example-app)
* [Kubernetes-sample-controller](https://github.com/kubernetes/sample-controller)

The team uses various tools, you should get familiar with them by reading through the documentation and trying them out:

* [Go](https://golang.org/)
* [Jsonnet](https://jsonnet.org/)
* [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/)
* [Kubernetes](https://kubernetes.io/)
* [Thanos](https://thanos.io/)
* [Observatorium](https://github.com/observatorium)

### Who’s Who?

* For all the teams and people in OpenShift Engineering, see this [Team Member Tracking spreadsheet](https://docs.google.com/spreadsheets/d/1M4C41fX2J1nBXhqPdtwd8UP4RAx98NA4ByIUv-0Z0Ds/edit?usp=drive_web&ouid=116712625969749019622). Bookmark this and refer to it as needed.
* Schedule a meeting with your manager to go over the team organizational structure

### First project

Your first project should ideally:

* Provide an interesting set of related tasks that make you familiar with various aspects of internal and external parts of Prometheus and OpenShift.
* Encourage discussion with other upstream maintainers and/or people at Red Hat.
* Be aligned with the area of Prometheus and more generally the monitoring stack you want to work on.
* Have a visible impact for you and others

Here’s a list of potential starter projects, talk to us to discuss them in more detail and figure out which one suits you.

(If you are not a new hire, please add/remove projects as appropriate)

* Setup Prometheus, Alertmanager, and node-exporter
  * As binaries on your machine (Bonus: Compile them yourself)
  * As containers
* Setup Prometheus as a StatefulSet on vanilla Kubernetes (minikube or your tool of choice)
* Try the Prometheus Operator on vanilla Kubernetes (minikube or your tool of choice)
* Try kube-prometheus on vanilla Kubernetes
* Try the cluster-monitoring-operator on Openshift (easiest is through the cluster-bot on slack)

During the project keep the feedback cycles with other people as long or short as you feel confident. If you are not sure, ask! Try to briefly check in with the team regularly.

Try to submit any coding work in small batches. This makes it easier for us to review and realign quickly.

Everyone gets stuck sometimes. There are various smaller issues around the Prometheus and Alertmanager upstream repositories and the different monitoring operators. If you need a bit of distance, tackle one of them for a while and then get back to your original problem. This will also help you to get a better overview. If you are still stuck, just ask someone and we’ll discuss things together.

## First Months

* If you will be starting out working more closely with the in-cluster stack be sure to review this document as well: [In-Cluster Monitoring Onboarding](https://docs.google.com/document/d/16Uzd8OLkBdN0H4KxqQIr7HTPYZWHKz3WdGtOlB6Rcdk/edit#). Otherwise if you are starting out more focused on the Observatorium service, review this doc: [Observatorium Platform Onboarding](https://docs.google.com/document/d/1RXSJYpx2x3bje6fwy2PEUSOgDrBlxq24A5vh2mHcxnk/edit#)
* Try to get *something* (anything) merged into one of our repositories
* Begin your 2nd project
* Create a PR for the the master onboarding doc (this one) with improvements you think would help others

### Second project

After your starter project is done, we’ll discuss how it went and what your future projects will be. By then you'll hopefully have a good overview which areas you are interested in and what their priority is. Discuss with your team lead or manager what your next project will be.

## Glossary

Our team's glossary can be found [here](https://docs.google.com/document/d/1bJSrlyc-e7bcOxV4sjx3FesMNVgdwNxUzMvIYywbt-0/edit#heading=h.9lupa64ck0pj).
