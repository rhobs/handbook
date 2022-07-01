# Team member onboarding

<!-- omit in toc -->

- [Team member onboarding](#team-member-onboarding)
  - [Team Background](#team-background)
  - [People relevant to Prometheus who you should know about:](#people-relevant-to-prometheus-who-you-should-know-about)
  - [Thanos](#thanos)
  - [Talks](#talks)
  - [First days (accounts & access)](#first-days-accounts--access)
    - [Tickets & tracking bugs](#tickets--tracking-bugs)
    - [JIRA](#jira)
    - [Bugzilla](#bugzilla)
    - [Spinning up OpenShift clusters](#spinning-up-openshift-clusters)
    - [Administrative things](#administrative-things)
    - [Meetings](#meetings)
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

1. Meet with your manager to get your temporary access token.
2. Follow the instructions you received to get your SSO access setup. This will enable you to access the VPN, your Red Hat email etc. Be sure to setup 2-Factor Auth using the Google Authenticator app or similar as described in the instructions provided by IT.
3. Ensure you are added to the **team-monitoring@redhat.com mailing list.** mailing list (request to be added by Assaf Muller)
4. Join the observability-announce mailing list ([https://groups.google.com/a/redhat.com/g/observability-announce](https://groups.google.com/a/redhat.com/g/observability-announce))
5. Join the **aos-devel@redhat.com **mailing list [https://post-office.corp.redhat.com/mailman/listinfo](https://post-office.corp.redhat.com/mailman/listinfo) (requires VPN)
6. Get in touch with your mentor ([mentors are tracked here](https://docs.google.com/spreadsheets/d/1SpdBbZChBNuPHVtbCjOch1mfZGUuCjkrp7yyCClL9kk/edit#gid=0))
7. Join the following communication channels:
   1. [Setup slack using this guide](https://source.redhat.com/groups/public/atomicopenshift/atomicopenshift_wiki/openshift_slack#jive_content_id_Quickstart)
   2. Ask your manager or another team member to add you to the private **[#team-monitoring](https://coreos.slack.com/archives/G79AW9Q7R/p1621409351049200)** and **[#observability-team](https://coreos.slack.com/archives/C02BY4191B6)** channels.
   3. Ask your manager or team lead to add you to the @monitoring-team alias in slack. You can also add yourself in Slack in "More" -> "People & user groups" -> "User groups" searching for "@monitoring-team" and then going to "Edit Members".
   4. Join the public channels:
      * **[#forum-monitoring](https://coreos.slack.com/archives/C0VMT03S5)**
      * **[#forum-telemetry](https://coreos.slack.com/archives/CEG5ZJQ1G)**
      * [#forum-observatorium](https://coreos.slack.com/archives/C010A637DGB)
   5. Join the following channels in the public [kubernetes slack](https://kubernetes.slack.com/): 4. **[#prometheus-operator-dev](https://kubernetes.slack.com/archives/C01B03QCSMN)** 5. #prometheus-operator 6. (optionally) #prometheus
   6. [CNCF Slack](https://slack.cncf.io): 7. #prometheus 8. #thanos 9. #thanos-dev
   7. IRC: #prometheus, #prometheus-dev
   8. More info: https://prometheus.io/community/
8. If you don’t have one already, create a GitHub account.
9. [Request access](https://source.redhat.com/groups/public/atomicopenshift/atomicopenshift_wiki/openshift_onboarding_checklist_for_github) to the Openshift Github organization
   * (Requires to have a JIRA account set up already - see below)
   * Note: full name of the team: OpenShift Monitoring
10. Request access to the [rhobs](https://github.com/rhobs) organization by asking in #[team-monitoring](https://coreos.slack.com/archives/G79AW9Q7R/p1621409351049200) slack
11. Request to be added to the [team-monitoring github team](https://github.com/orgs/openshift/teams/openshift-team-monitoring/members) by creating a Jira ticket to the [OpenShift's Developer Productivity Platform team (DPP)](https://source.redhat.com/groups/public/atomicopenshift/atomicopenshift_wiki/dev_productivity_platform_team_home). Don't use GitHub's request option for that because it needs to be tracked internally.
    * Note that this would only work after you are added to the Openshift Github organization.
    * The ticket cannot be open directly in https://issues.redhat.com, instead under the VPN go to https://devservices.dpp.openshift.com/support -> Github -> "Something else? Create a general Github question/request ticket and indicate your Github username. That creates a ticket that is printed at the end of the process.
    * Example ticket [here](https://issues.redhat.com/browse/DPP-8352)
12. Ensure your manager adds you to the [team PTO calendar](https://calendar.google.com/calendar/u/0?cid=cmVkaGF0LmNvbV91N3YwbGt2cnRuM2wwbWJmMnF2M2VkMm12MEBncm91cC5jYWxlbmRhci5nb29nbGUuY29t) and that you can access it.
13. Bookmark our team’s [Google Drive Folder](https://drive.google.com/drive/folders/1PJHtAtxBUHxbmMx1xftrNSOJEIoYVhyO)
14. Join the Prometheus [User mailing list](https://groups.google.com/forum/#!forum/prometheus-users)
15. Join the Prometheus [Developer mailing list](https://groups.google.com/forum/#!forum/prometheus-developers)

Try to help out and be visible in the slack channels and mailing lists you were instructed to join, but don’t make it your job to stay on top of every single discussion.

### Tickets & tracking bugs

Watch the [Bugzilla & Jira introduction](https://drive.google.com/file/d/1mDLQCJSO56ae4lZtxKIFxEsGMxh24zyl/view?usp=sharing)

### JIRA

A Red Hat Customer Portal account is required for logging in to several Red Hat services, https://issues.redhat.com being among them. To access employee-restricted resources such as internal Jira issues, this account needs to be linked to your employee login (Kerberos). Follow the [checklist](https://source.redhat.com/groups/public/atomicopenshift/atomicopenshift_wiki/openshift_onboarding_checklist_for_red_hat_customer_portal_account_setup) to make sure your account is properly set up. It might take 24 hours or so to sync your account after its been linked to customer portal.

Ensure you can access our [project](https://issues.redhat.com/projects/MON/issues). Used for all sprint planning & internal issue tracking. You can SSO with your Red Hat email. Contact Rory Thrasher or the DPP Team if you have issues.

Add a unique image as your avatar :)

### Bugzilla

[Bugzilla](https://bugzilla.redhat.com) is a legacy system that we must use as the official source-of-truth for all bug tracking, customer issues, and backporting. In the in-cluster team you will need to get familiar with this system as you will use it on a daily basis. For observability-platform we use it less often, but there can be times where Telemeter bugs are reported there. All info on how to do the following tasks are in this doc: [Bugzilla Bug Boss Cheat Sheet](https://docs.google.com/document/d/1QMqJHUDXPVkElhBs3r71zfU6xEjC7FW6_S_JFmvtzqc/edit#)

1. Read the above doc carefully
2. Create your Bugzilla account
3. Request and ensure the necessary permissions are granted (ask your manager)
4. Read the [OpenShift Bugzilla Process documentation](https://source.redhat.com/groups/public/atomicopenshift/atomicopenshift_wiki/openshift_bugzilla_process)
5. Make sure you are aware to hit “show advanced fields” for doc text fields and others. Alternatively you can set it in *Preferences > General Preferences > Initially hide the advanced fields in bug editor: Off*. (The fields "Doc Type" and "Doc Text" are hidden otherwise. If these fields are not set, one will get emails about "Action required for your OpenShift Container Platform bugs - Missing doc text" on otherwise resolved issues.)

### Spinning up OpenShift clusters

There are several ways to create an OpenShift cluster or to use an existing one. You can choose the method which is most suitable for your particular use-case.

* There is a global OpenShift cluster which gets recycled daily. The credentials for accessing it are posted in the [forum-ui-clusters](https://coreos.slack.com/archives/CUNC2JA2U) channel.
* Short-lived clusters (up to 2 hours) can be provisioned using the **cluster-bot** Slack app. Type in *help* for instructions on how to interact with cluster-bot.
* Clusters which last up to a day can be created using the CLI. Review the documentation for [AWS](https://docs.google.com/document/d/1j7bhLXT_cIAjpMh_x2jeegtpE7495Mj5A-EcQsgZEDo/edit#) and [GCP](https://docs.google.com/document/d/1qm37EKkjgoPtjW4909UClzvsjQO5VSpPUvFO_hW_PEg) and request your accounts. Note: for GCP the project name is openshift-gce-devel

### Administrative things

1. Review all the onboarding instructions/documentation sent to your email by the People Team (HR).
2. Submit an[Employee Badge Request Form](https://redhat.service-now.com/rh_ess/cat_item.do?&sysparm_document_key=sc_cat_item,ac8bb875a82282004c7185ae62325874)
3. Register for new hire orientation NHO (you will get an email about this from HR)
4. Speak with your manager about any additional equipment you need (e.g. keyboard, mouse, etc)
5. Login to Rover (our company directory) and update your profile [https://rover.redhat.com/people/profile/](https://rover.redhat.com/people/profile/). Be sure to do the following:
   * Add a short bio
   * Bookmark Rover for future reference
6. Add yourself in [https://spaces.redhat.com/display/OBS/Monitoring+Team](https://spaces.redhat.com/display/OBS/Monitoring+Team)

### Meetings

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

Below is a glossary of terms and acronyms which may be unfamiliar to you.

If what you’re looking for is missing, consider checking the [Abbreviations, Acronyms, and Initialisms Dictionary](https://source.redhat.com/groups/public/red-hat-dictionary-or-lexicon) page on the Source.

<table>
  <tr>
   <td>Bug boss
   </td>
   <td>Temporary bugzilla default assignee
   </td>
   <td><a href="https://docs.google.com/document/d/1QMqJHUDXPVkElhBs3r71zfU6xEjC7FW6_S_JFmvtzqc/edit?usp=sharing">https://docs.google.com/document/d/1QMqJHUDXPVkElhBs3r71zfU6xEjC7FW6_S_JFmvtzqc/edit?usp=sharing</a>
   </td>
  </tr>
  <tr>
   <td>CMO
   </td>
   <td>Cluster monitoring operator
   </td>
   <td><a href="https://github.com/openshift/cluster-monitoring-operator">https://github.com/openshift/cluster-monitoring-operator</a>
   </td>
  </tr>
  <tr>
   <td>CNO
   </td>
   <td>Cluster network operator
   </td>
   <td><a href="https://github.com/openshift/cluster-network-operator">https://github.com/openshift/cluster-network-operator</a>
   </td>
  </tr>
  <tr>
   <td>CRC
   </td>
   <td>Run OpenShift on your laptop
   </td>
   <td><a href="https://github.com/code-ready/crc">https://github.com/code-ready/crc</a>
   </td>
  </tr>
  <tr>
   <td>CU
   </td>
   <td>Case User (Customer)
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>CVE
   </td>
   <td>Common Vulnerabilities and Exposures
   </td>
   <td>Unique ID assigned to security issues
<p>
<a href="https://en.wikipedia.org/wiki/Common_Vulnerabilities_and_Exposures">https://en.wikipedia.org/wiki/Common_Vulnerabilities_and_Exposures</a>
   </td>
  </tr>
  <tr>
   <td>CVO
   </td>
   <td>Cluster version operator
   </td>
   <td><a href="https://github.com/openshift/cluster-version-operator">https://github.com/openshift/cluster-version-operator</a>
   </td>
  </tr>
  <tr>
   <td>EKS
   </td>
   <td>Amazon Elastic Kubernetes Service
   </td>
   <td><a href="https://aws.amazon.com/de/eks/?whats-new-cards.sort-by=item.additionalFields.postDateTime&amp;whats-new-cards.sort-order=desc&amp;eks-blogs.sort-by=item.additionalFields.createdDate&amp;eks-blogs.sort-order=desc">https://aws.amazon.com/de/eks/?whats-new-cards.sort-by=item.additionalFields.postDateTime&amp;whats-new-cards.sort-order=desc&amp;eks-blogs.sort-by=item.additionalFields.createdDate&amp;eks-blogs.sort-order=desc</a>
   </td>
  </tr>
  <tr>
   <td>IHAC
   </td>
   <td>I Have A Customer
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Observatorium
   </td>
   <td>Distribution of Metrics, Logging and Tracing in one installation
   </td>
   <td><a href="https://github.com/observatorium">https://github.com/observatorium</a>
   </td>
  </tr>
  <tr>
   <td>OCP
   </td>
   <td>OpenShift container platform
   </td>
   <td>Official name for OpenShift product<a href="https://www.openshift.com/products/container-platform"> https://www.openshift.com/products/container-platform</a>
   </td>
  </tr>
  <tr>
   <td>OLM
   </td>
   <td>OpenShift Lifecycle Manager
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>OSD
   </td>
   <td>OpenShift Dedicated
   </td>
   <td>Red Hat’s hosted OpenShift on AWS<a href="https://www.openshift.com/products/dedicated/"> https://www.openshift.com/products/dedicated/</a>
   </td>
  </tr>
  <tr>
   <td>Project X
   </td>
   <td>(Closed) internal initiative to bring Observatorium and In-Cluster Projects closer together, integrate them better.
   </td>
   <td><a href="https://docs.google.com/document/d/1lX0Tl77NFp9m1ZhV3ya1iOQSLZUI0fYbliTt0H_WGJA/edit">https://docs.google.com/document/d/1lX0Tl77NFp9m1ZhV3ya1iOQSLZUI0fYbliTt0H_WGJA/edit</a>
   </td>
  </tr>
  <tr>
   <td>RFE
   </td>
   <td>Request for Enhancement
   </td>
   <td><a href="https://issues.redhat.com/projects/RFE/summary">https://issues.redhat.com/projects/RFE/summary</a>
   </td>
  </tr>
  <tr>
   <td>ROSA
   </td>
   <td>Red Hat OpenShift Service on AWS
   </td>
   <td>Installation, monitoring, management, maintenance, and upgrades are performed by Red Hat site reliability engineers (SRE) covering the complete stack including the control plane, worker nodes and key services. https://www.openshift.com/products/amazon-openshift
   </td>
  </tr>
  <tr>
   <td>RMO
   </td>
   <td>Route monitor operator
   </td>
   <td><a href="https://github.com/openshift/route-monitor-operator">https://github.com/openshift/route-monitor-operator</a>
   </td>
  </tr>
  <tr>
   <td>Slack duty
   </td>
   <td>In-cluster team rotation to answer or delegate answering questions on<a href="https://app.slack.com/client/T027F3GAJ/C0VMT03S5"> forum-monitoring</a><span style="text-decoration:underline;"> </span>slack channel
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td>Supportshell
   </td>
   <td>Server for accessing support cases attachments
   </td>
   <td><a href="https://source.redhat.com/groups/public/supportshell/supportshell_wiki/support_shell_main">https://source.redhat.com/groups/public/supportshell/supportshell_wiki/support_shell_main</a>
   </td>
  </tr>
  <tr>
   <td>OEP
   </td>
   <td>OpenShift Enhancement Proposal
   </td>
   <td>Document for writing down and discussing OpenShift changes &amp; enhancements,
<p>
<a href="https://github.com/openshift/enhancements/">https://github.com/openshift/enhancements</a><span style="text-decoration:underline;">/</span>
   </td>
  </tr>
  <tr>
   <td>SLO
   </td>
   <td>Service Level Objective
   </td>
   <td><a href="https://en.wikipedia.org/wiki/Service-level_objective">https://en.wikipedia.org/wiki/Service-level_objective</a>
   </td>
  </tr>
  <tr>
   <td>SCC
   </td>
   <td>Security Context Constraints
   </td>
   <td><a href="https://docs.openshift.com/enterprise/3.0/admin_guide/manage_scc.html">https://docs.openshift.com/enterprise/3.0/admin_guide/manage_scc.html</a>
   </td>
  </tr>
  <tr>
   <td>UWM
   </td>
   <td>User Workload Monitoring
   </td>
   <td>
   </td>
  </tr>
</table>

Also see [https://source.redhat.com/groups/public/red-hat-dictionary-or-lexicon](https://source.redhat.com/groups/public/red-hat-dictionary-or-lexicon)
