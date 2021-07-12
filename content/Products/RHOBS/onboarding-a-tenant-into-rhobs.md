# Onboarding a Tenant into Red Hat’s Observability Service

- **Authors:**
  - [`@squat`](https://github.com/squat)

## Overview

Teams that have identified a need for collecting their logs and/or metrics into a centralized service that offers querying and dashboarding may choose to send their data to Red Hat’s hosted Observatorium instance. This document details the steps required to become a new tenant.

Tenants who have been onboarded to the platform should consider validating their service accounts following the instructions in the [Testing Service Accounts for New Observatorium Tenants (internal)](https://docs.google.com/document/u/1/d/1CJsdGDnduA35Me6i3atHGDJnXzMOyWVKoqaAvFkdIbU/edit) doc.

Once tenants have been onboarded to the platform and have validated their credentials, they can configure their clients to access Observatorium, following the instructions in the [Configuring Clients for Observatorium](configuring-clients-for-rhobs.md) doc.

## 1. Collect Requirements

The first step is to collect information about the team’s requirements. The following questions should be answered:

1. What resources need to be collected? Logs? Metrics? Both?
2. What volume of data will be collected? XGb of logs per day? Xk metrics time series per day?
3. What is the expected or forecasted growth in collected data? X% growth in data per month?
4. How many users will require read access? X team members? The entire OpenShift org?
5. How many clients will be emitting data? 1 Prometheus server?
6. How long should data be retained? 2 weeks?
7. How many independent service accounts do you need to write data into the platform?

## 2. Create a Customer Portal Account

Create a Red Hat customer portal account to group all users from your team who should have access to the data. Note: any member of your account will be able to read the data collected by Observatorium for your tenant. https://sso.redhat.com

## 3. Create Service Accounts for Reading/Writing Data

All requests reading and writing data into the Observatorium platform must be authenticated and authorized. For this reason, each tenant must provision service accounts for their data writers, e.g. Prometheus, Promtail, etc, and their data readers, e.g. Grafana to be able to make requests. Services that would also like to test their configuration in a staging environment should create additional service accounts for the staging Observatorium instance. Services must have at least one service account, which they may choose to reuse among all of their data clients. If services would like to authenticate each client independently, then an additional service account is needed for each client. These service accounts, both for production and staging, must be created in the production external SSO environment, that is, sso.redhat.com. Service accounts may be requested via a ticket for the IT User team in Service Now at the URL help.redhat.com. The service account request should specify the following requirements:

1. define two new service accounts in the production sso.redhat.com: observatorium-<tenant>, observatorium-<tenant>-staging;
2. enable the clients to use the client credentials grant flow;
3. add observatorium-telemeter to the allowed audience field of the observatorium-<tenant> account;
4. add observatorium-telemeter-staging to the allowed audience field of the observatorium-<tenant>-staging account;
5. set the email addresses of the accounts to: <your-email>@redhat.com;
6. set the preferred_username of the observatorium-<tenant> account to: service-account-observatorium-<tenant>; and
7. set the preferred_username of the observatorium-<tenant>-staging account to: service-account-observatorium-<tenant>-staging.
8. append one new allowed callback URL to the list of allowed callback URLs for the observatorium-telemeter service account: https://observatorium.api.openshift.com/oidc/<tenant>/callback
9. append one new allowed callback URL to the list of allowed callback URLs for the observatorium-telemeter-staging service account: https://observatorium.api.stage.openshift.com/oidc/<tenant>/callback

## 4. Authorize Service Accounts

Service accounts must be given access to read and/or write data into Observatorium for your tenant. To accomplish this, first log into the OpenShift Cluster Manager (OCM) API with every service account into the corresponding environment using the [OCM CLI tool](https://github.com/openshift-online/ocm-cli/blob/master/README.adoc):

```shell
ocm login --client-id=<client-id-staging> --client-secret=<client-secret-staging> --url=staging && ocm whoami
ocm login --client-id=<client-id-production> --client-secret=<client-secret-production> --url=production && ocm whoami
```

Next, submit a merge request against the [OCM resources repository in GitLab (internal)](https://gitlab.cee.redhat.com/service/ocm-resources) adding a file corresponding to the newly created service account in the appropriate environment, including the ID of the Red Hat customer portal account from step 2. Two roles are available for writing logs and metrics respectively: `ObservatoriumLogsCreator` and `ObservatoriumMetricsCreator`. Similarly, two roles are available for reading logs and metrics respectively: `ObservatoriumLogsGetter` and `ObservatoriumMetricsGetter`. For example, to authorize a service account to write metrics to the production Observatorium instance, create a new file in `data/uhc-production/users/service-account-observatorium-<tenant>.yaml` with the following contents:

```yaml
---
$schema: /user-1.yaml
user_id: "service-account-observatorium-<tenant>"
kerberos_id: "N/A"
roles:
- ObservatoriumMetricsCreator:
    scope: "Organization"
    organization_id: "<organization-id>"
environment: "uhc-production"
```

To determine the organization ID for the customer portal account created in step 2, first log into the Red Hat customer portal, and then go to https://cloud.redhat.com/openshift/token to obtain an offline access token. Finally you can execute the following command using the OCM CLI tool:

```shell
ocm login --token=”<your token>” && ocm get /api/accounts_mgmt/v1/current_account | jq -r '.organization.id'
```

## 5. Create a Jira Ticket

Next, create a ticket in the OBS board in issues.redhat.com. The Observability team will review the request and prioritize it for a coming sprint. Please include the following data:
* Title: Onboard <YOUR SERVICE> Onto Observatorium
* Description:
  * Description of your service
  * Explanation of why you need would benefit from sending data to Observatorium
  * All of the answers to the collected requirements from section 1
  * The organization ID of the new customer portal account from section 2
  * A link to the Service Now ticket from section 3
  * The email address specified in the service account in section 3
  * A link to the merge request from section 4
