---
title: Plugin Data
layout: en_insights

---
## Plugin types

Here you'll find schema information for each of our supported plugins. Use this data when writing probes to create references to infrastructure items that you're looking to probe.

Every tool has its own methodology for creating credentials and connecting with Travis Insights. Most of the time, we just need a read-only API key.

All tools include a set of default probes, listed below each plugin description.

## Infrastructure Provider

### AWS Infrastructure
#### Register the plugin
To register AWS plugins, you need the Public and the Private Key as access identifiers.

![reg-AWS](/user/images-insights/aws_infrastructure.png)

#### Available probes for the plugin
- One of your autoscaling groups is using simple EC2 health checks.
- Several of your instances are being exposed directly to the internet, or you are heavily using manual elastic ips.
- Some of your ACLs only have the default setup (disabled).
- Some of your autoscaling configurations aren't using instance monitoring.
- Some of your autoscaling groups are not associated with any ELBs.
- Some of your autoscaling groups are not fully utilizing tagging.
- Some of your autoscaling groups are not using multiple availability zones.
- Some of your autoscaling groups create externally exposed instances.
- Some of your autoscaling groups have no instances.
- Some of your autoscaling groups have no launch configurations.
- Some of your CloudFormation stacks are currently in an errored or unrun state.
- Some of your CloudFormation stacks are not making appropriate usage of tagging.
- Some of your CloudFront distributions are not active.
- Some of your CloudFront distributions don't have S3 origins.
- Some of your CloudFront distributions have no geo-restrictions.
- Some of your customer gateways are misconfigured and are unavailable for use.
- Some of your database clusters are misconfigured and are unavailable for use.
- Some of your database clusters are not in sync.
- Some of your database clusters are not using encrypted storage.
- Some of your database clusters aren't enabled in multiple availability zones.
- Some of your database clusters have short backup retention periods.
- Some of your databases are not configured correctly and are unavailable for use.
- Some of your databases are not configured to automatically keep up to date with new versions.
- Some of your databases are not configured to use encrypted storage.
- Some of your databases are not configured to use multiple availability zones.
- Some of your databases are on the publically accessible network.
- Some of your databases have not had their option groups applied yet.
- Some of your databases have not had their parameter groups applied yet.
- Some of your databases have short backup retention periods.
- Some of your DB clusters are not enabled in multiple availability zones.
- Some of your ElasticBeanstalk environments are misconfigured and are unavailable for use.
- Some of your ElasticBeanstalk environments are unhealthy and are unavailable for use.
- Some of your ELBs are empty.
- Some of your ELBs aren't enabled with multiple availability zones.
- Some of your instances are directly exposed to the internet.
- Some of your instances are not using EBS root volumes.
- Some of your instances are still in EC2 Classic.
- Some of your instances are using launch-wizard security groups.
- Some of your instances are using the default security group.
- Some of your instances aren't using descriptive naming techniques.
- Some of your instances aren't using tagging functionality effectively.
- Some of your internet gateways are misconfigured and are unavailable for use.
- Some of your NAT gateways are misconfigured and are unavailable for use.
- Some of your OpsWorks stacks are not using EBS root volumes on their instances.
- Some of your reserved database instances are not using the best available rate.
- Some of your reserved instance types are not the most discounted rate.
- Some of your route tables are empty.
- Some of your route tables are misconfigured and are unavailable for use.
- Some of your security groups have an excessive number of ingress permissions.
- Some of your security groups have wide-open egress permissions.
- Some of your subnets are almost full.
- Some of your subnets are misconfigured and are unavailable for use.
- Some of your subnets don't have route tables associated with them.
- Some of your users do not have multi-factor authentication enabled.
- Some of your virtual private gateways are misconfigured and are unavailable for use.
- Some of your VPC peering connections are misconfigured and are unavailable for use.
- Some of your VPCs are not using NAT gateways.
- Some of your VPCs don't have route tables.
- Some of your VPCs have no external internet access via an internet gateway.
- Some of your VPCs only have the default ACLs.
- Some of your VPN connections are misconfigured and are unavailable for use.
- Some of your VPN connections are not up and are unavailable for use.
- Some of your VPN connections have no customer gateway.
- Some of your VPN connections have no VPN gateway.
- You are heavily reusing your security groups.
- You are not currently using any ELBs.
- You aren't using autoscaling extensively.
- You have a lot of unused security groups.
- Your instances are not geographically distributed among multiple availability zones.
- Your subnets are not geographically distributed across multiple availability zones.


### Azure
#### Register the plugin

To connect with Azure, you need an Azure Service Principal Application ID, the Service Password, and an Azure Tenant ID.

![azure-reg](/user/images-insights/Azure.png) 

#### Available probes for the plugin
- Some of your security contacts do not have a phone number.
- Some of your security contacts do not have an email.
- Some of your security contacts do not receive notifications about alerts.
- Some of your security contacts do not send alerts to admins.
- Some of your SQL databases did not enable auditing.
- Some of your SQL databases did not enable extended auditing.
- Some of your SQL databases did not enable threat detection.
- Some of your SQL databases did not set up email addresses for alerts.
- Some of your SQL databases do not email account admins on alerts.
- Some of your SQL databases have disabled alerts.
- Some of your SQL servers did not enable auditing.
- Some of your SQL servers did not enable extended auditing.
- Some of your SQL servers did not enable threat detection.
- Some of your SQL servers did not enable transparent data encryption.
- Some of your SQL servers did not set up email addresses for alerts.
- Some of your SQL servers do not email account admins on alerts.
- Some of your SQL servers do not have firewall rules.
- Some of your SQL servers have disabled alerts.
- Some of your VM disks are not encrypted.
- You do not have any jit network access policies.
- You do not have any network security groups.
- You do not have any security contacts.
- You do not have any waf policies.
- You have some active alerts.

### Google Cloud Platform Infrastructure
#### Register the plugin

You need the JSON key from Google Console to connect with the GCP Infrastructure.

![gcp-reg](/user/images-insights/gcp.png) 

#### Available probes for the plugin
- The auto-create subnetwork is disabled in Some of the networks.
- Billing is started as there are multiple no of the instance is started.
- Default networks exist in a project.
- Ensure that SSH access is restricted from the internet.
- Ensure the VPC Flow logs option is enabled for every subnet in VPC Network.
- IP forwarding is enabled on Some of the Instances.
- Legacy Authorization is set to Enabled on Kubernetes Engine Clusters.
- Not any instances are created in your gcp.
- One of the instance groups is distributed to multiple zones.
- One of your instances is not using healthcheck.
- Private google access is disabled for some subnetworks in VPC network.
- Access to rdp is restricted from the internet in some firewalls.
- Several of your instances are exposed to external ip.
- Some of the instances are either terminated or error.
- Some of your firewalls are disabled.
- Some of your instances are using autoscaling groups.
- Some of your instances cannot forward ip.
- Some of your instances sso not have any tags.
- Some of your instances do not have integrity monitoring.
- Some of your instances groups are not fully utilizing tagging.
- Some of your managed zones in cloud dns don't have dnssec.
- SSL health check is not enabled in some of your instances.
- Stackdriver logging is set to disable on Kubernetes engine clusters.
- Stackdriver monitoring is set to disable on Kubernetes engine clusters.
- The TCP health check is inactive.
- The TCP health check is not active in some instances.
- There are no health checks.

## Infrastructure Monitoring - APM

### AWS Cloud Monitoring
You can register this plugin with the same parameters as the [AWS infrastructure](#aws-infrastructure), and it also has the same available probes.

### DataDog Monitoring
#### Register the plugin

Register this plugin with the DataDog API Key.

![datalog-reg](/user/images-insights/datadog.png) 

#### Available probes for the plugin
- Some of your instances are consistently near maxing out their memory resources.
- Some of your metrics have too long names.
- IO activities are are bounding your CPU.
- Your CPU is being bounded by the hypervisor stealing cycles.
- Your disk has gone above 80% full.
- You have used over 80% of your system's available INodes.
- Your system is consistently using only a small portion of its available memory.
- Your system resorted to using swap memory.
- Your system's load average has risen above 70%.

### NewRelic
#### Register the plugin

Copy the API Key to register this plugin.

![newrelic-reg](/user/images-insights/newrelic.png) 

#### Available probes for the plugin
- Parsing and interpreting HTML structures for some of your applications is slow.
- Some of your applications apdex_score exceed the set threshold.
- Some of your applications are not in a healthy state.
- Some of your applications do not have an assigned alert policy.
- Some of your application´s response time is slow.
- Some of your applications use default naming.
- There are no alert policies defined.

## Cluster Monitoring
### Kubernetes Cluster

#### Register the plugin

You have to generate a Key 

![kubernetes-reg](/user/images-insights/kubernetes.png)

#### Available probes for the plugin
- Check if there is publicly accessible LoadBalancer.
- Ensure if all Pods have a readiness Probe.
- Ensure if all Pods have Startup Probe.
- Some of your Kubernetes deployments do not have defined limits.
- Some of your Kubernetes deployments do not have requests defined.
- Some of your pods allow privilege escalation.
- Some of your pods are down.
- Some of your pods can run as root.
- Some of your pods do not have a liveness probe.
- Some of your pods do not have a readiness probe.
- Some of your pods do not have a security context.
- Some of your pods do not have a startup probe.
- Some of your pods share host IPC.
- Some of your pods share host networks.
- Some of your pods share host pids.
- You do not have any load balancers.

## Uptime Monitoring - Synthetic Monitoring

### Pingdom Uptime Monitoring
#### Register the plugin

![pingdom-reg](/user/images-insights/pingdom.png) 

#### Available probes for the plugin
- Some of your alerts have caused charges on your account.
- Some of your services are down.
- Some of your services were unavailable for too much time.

## Operational Intelligence

### Travis Insights
These probes automatically run in the application without registering any plugin.

#### Available probes for the plugin
- You need more plugins.
- You need some deployment pipeline plugins.
- You need some infrastructure monitoring plugins.
- You need some VCS plugins.

## CDN

### CloudFlare
#### Register the plugin

![cloudflare-reg](/user/images-insights/cloudflare.png) 

#### Available probes for the plugin
- Data lag is too high.
- DNS Firewall data lag is too high.
- DNS Firewall response time average is too high.
- DNSSEC is disabled.
- The average response time is too high.
- You have deleted and/or deactivated zones.

## Source Control 

### BitBucket
#### Register the plugin

![bitbucket-reg](/user/images-insights/bitbucket.png)

#### Available probes for the plugin
- Some of your repositories lack descriptions.
- Some of your repositories are missing issues.
- Some of your repositories are not updated in the last 14 days.
- Some of your repositories are not updated in the last 30 days.
- Some of your repositories are not updated in the last 7 days.
- Some of your repositories are public.
- Some of your repositories do not have a wiki.
- There are too many open pull requests.

### GitHub
#### Register the plugin

![github-reg](/user/images-insights/github.png) 

#### Available probes for the plugin
- Some of your repositories lack descriptions.
- Some of your repositories are public.
- You have some bugs assigned which are in an open state.
- Your rate limit status for all non-search-related resources is less than 500.

### Gitlab
#### Register the plugin

![gitlab-reg](/user/images-insights/gitlab.png) 

#### Available probes for the plugin
- AutoDevops is not enabled in repositories.
- Some jobs are too slow.
- Some of your deployments are failing.
- Some of your jobs are dead.
- Some of your jobs failed.
- Some of your jobs are failing.
- Some of your jobs in the last 10 days have been too slow.
- Some of your jobs in the last 14 days failed.
- Some of your jobs in the last 2 days have been too slow.
- Some of your jobs in the last 30 days failed.
- Some of your jobs in the last 7 days failed.
- Some of your pages domains have an expired cert.
- Some of your pipelines are failing.
- Some of your projects lack descriptions.
- Some of your projects have disabled issues.
- Some of your projects have disabled jobs.
- Some of your projects have disabled merge requests.
- Some of your projects have a disabled wiki.
- Some of your projects have public jobs.
- Some of your runners are offline or paused.
- There are too many enqueued jobs.
- There are too many pending jobs.
- You have too many enqueued jobs.

## Deployment Pipeline

### CircleCI
#### Register the plugin

![circleci-reg](/user/images-insights/circleci.png) 

#### Available probes for the plugin
- Some of your builds failed.
- Some of your builds are failing.
- Some of your builds in the last 5 hours are too slow.
- Some of your builds in the last 5 minutes are too slow.

### TeamCity
#### Register the plugin

![teamcity-reg](/user/images-insights/teamcity.png) 

#### Available probes for the plugin
- Some of your builds in the last 14 days are failing.
- Some of your builds in the last 2 hours are too slow.
- Some of your builds in the last 30 days are failing.
- Some of your builds in the last 7 days are failing.
- There are too many enqueued builds.
- There are too many failing builds.

### Bamboo CI
#### Register the plugin

![bamboo-reg](/user/images-insights/bamboo.png) 

#### Available probes for the plugin
- Some of your builds are failing.
- Some of your builds in the last 14 days are failing.
- Some of your builds in the last 2 hours are failing.
- Some of your builds in the last 30 days are failing.
- Some of your builds in the last 7 days are failing.
- There are too many enqueued builds.

### Buddy CI
#### Register the plugin

![buddy-reg](/user/images-insights/buddy.png) 

#### Available probes for the plugin
- Some of your builds in the last 14 days are failing.
- Some of your builds in the last 2 hours are too slow.
- Some of your builds in the last 30 days are failing.
- Some of your builds in the last 7 days are failing.
- There are too many failing builds.
- You have too many tags. It looks like some of them might be unused.

### Travis CI
#### Register the plugin

![travis-reg](/user/images-insights/travis.png) 

#### Available probes for the plugin
- Some of your builds failed.
- Some of your builds in the last 14 days are failing.
- Some of your builds in the last 2 hours are too slow.
- Some of your builds in the last 30 days are failing.
- Some of your builds in the last 7 days are failing.
- There are too many failing builds.

## Error Tracking

### Rollbar
#### Register the plugin

![rollbar-reg](/user/images-insights/rollbar.png) 

#### Available probes for the plugin
- Failed deployments rate is too high.
- Some of your issues happen too often.
- You have failed deployments during the last 14 days.
- You have failed deployments during the last 7 days.

## Others

### AppDynamics
#### Register the plugin

![appdynamicsreg-reg](/user/images-insights/appdynamicsreg.png) 

#### Available probes for the plugin
- Not all health rules are enabled for some of your applications.
- Some of your email digests are disabled.
- There are some abnormalities detected in your apps.


### Artifactory
#### Register the plugin

![artifactoryreg-reg](/user/images-insights/artifactoryreg.png) 

#### Available probes for the plugin
- 

### Assembla
#### Register the plugin

![assemblareg-reg](/user/images-insights/assemblareg.png) 

#### Available probes for the plugin
- Some of your milestones are overdue.
- Some of your uncompleted milestones do not have a due date.
- You have too many active tickets.
- You have too many open milestones.
- You have too many open tickets.
- You have too many unassigned tickets.
- You have too many unread mentions.

### Azure Application Insights
#### Register the plugin

![appinsightsreg-reg](/user/images-insights/appinsightsreg.png)

#### Available probes for the plugin
- Page view average duration is too high.
- Requests´ average duration is too high.

### Azure DevOps
#### Register the plugin

![azuredevopsreg-reg](/user/images-insights/azuredevopsreg.png)

#### Available probes for the plugin
- Some of your builds failed.
- Some of your builds are failing.
- Some of your deployments are failing.
- Some of your projects lack a description.
- Some of your projects are public.

### Cloudbees
#### Register the plugin

![cloudbeesreg-reg](/user/images-insights/cloudbeesreg.png)

#### Available probes for the plugin
- There are some active alerts.
- You have failed builds.
- You have failing builds.

### CodeClimate
#### Register the plugin

![clodeclimatereg-reg](/user/images-insights/clodeclimatereg.png)

#### Available probes for the plugin
- Test coverage is bad in some repos.
- There are some failed builds.
- There are some failing builds.

### DynECT
#### Register the plugin

![dynectreg-reg](/user/images-insights/dynectreg.png)

#### Available probes for the plugin
- There are some DNS services that were abused.
- There are some failed tasks.
- There are some stalled tasks.
- There are some tasks that block other zone changes.

### GoDaddy
#### Register the plugin

![godaddyreg-reg](/user/images-insights/godaddyreg.png)

#### Available probes for the plugin
- There are some subscriptions that will expire within less than 30 days.
- You have domains that will expire soon.

### Google Cloud Source Repositories
#### Register the plugin

![googlecouldsourcerepositoriesreg-reg](/user/images-insights/googlecouldsourcerepositoriesreg.png)

#### Available probes for the plugin
- 

### Heroku
#### Register the plugin

![herokureg-reg](/user/images-insights/herokureg.png)

#### Available probes for the plugin
- There are apps under maintenance.
- There are failed dynos.
- There are failed or too big invoices.
- There are failing builds.
- There are failing releases.
- There are failing test runs.
- There are unshielded spaces.
- You have no configured domains.

### Okta
#### Register the plugin

![oktareg-reg](/user/images-insights/oktareg.png)

#### Available probes for the plugin
- No trusted origins were defined.
- Some of your apps do not have labels.
- Some of your apps do not have saml auth enabled.
- Some of your apps have accessibility issues.
- There are some users who have never logged in.
- There are some users who have not activated their accounts.
- There are some users who have not changed their password since last year.
- Your password length requirement violates security rules.
- Your password lockout max attempts requirement violates security rules.
- Your password maz age requirement violates security rules.
- Your password requirement regarding a new password violates security rules. 

### OneLogin
#### Register the plugin

![oneloginreg-reg](/user/images-insights/oneloginreg.png)

#### Available probes for the plugin
- Defined refresh token expiration time is greater than half of a year.
- More than one of the events which take place are of a high or very high-risk score.
- There are no rules defined for gaining more control over the risk scoring of events.
- There are some events with a high-risk score.
- There are some events with a medium-risk score.
- There are some users who have never logged in.

### PagerDuty
#### Register the plugin

![pagerdutyreg-reg](/user/images-insights/pagerdutyreg.png)

#### Available probes for the plugin
- Multiple notification rules are not applied to users.
- No escalation policies are applied.
- There are some unresolved incidents with high urgency.

### Sentry
#### Register the plugin

![sentryreg-reg](/user/images-insights/sentryreg.png)

#### Available probes for the plugin
- You do not have any releases during the last 7 days.
- You have releases without git ref.
- You have unresolved issues.

### Sonarqube
#### Register the plugin

![sonarqubereg-reg](/user/images-insights/sonarqubereg.png)

#### Available probes for the plugin
- Some of your projects are too complex. 
- Some of your projects have a too big technical debt.
- Some of your projects have a too high technical debt ratio.
- Some of your projects have a too low-security rating. 
- Some of your projects have too complex security classes.
- Some of your projects have too complex functions.
- Some of your projects have too many bugs.
- Some of your projects have too many new violations.
- There are too many failing tests.
- There is not enough coverage in your projects.
- There is too much duplication in your projects.
- You have too many critical issues.

### Sysdig
#### Register the plugin

![sysdigreg-reg](/user/images-insights/sysdigreg.png)

#### Available probes for the plugin
- 

### Zendesk
#### Register the plugin

![zendeskreg-reg](/user/images-insights/zendeskreg.png)

#### Available probes for the plugin
- Some of your groups do not have any descriptions.
- Some of your jobs have failed.
- Some of your tickets were reopened several times and still are not solved.
- You have too many admins.
- You have too many groups.

> If you have some important tooling that you think we've missed, [let us know!](mailto:feedback@srenity.io)
