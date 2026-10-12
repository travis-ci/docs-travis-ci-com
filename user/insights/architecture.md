---
title: Travis Insights Architecture
layout: en_insights

---

Travis Insights is designed with a simple concept in mind, plugins connect Travis Insights to your various tools, and Travis Insights extracts valuable insights from that flow of data.

## Integrations

Integrations (also known as plugins) are the core of the Travis Insights tool.  They provide connections to the various tools in your development and operations environments, allowing the tool to gain insight into your processes and tooling.  Generally, the more tools you can connect via integrations, the better the data in the system will be, and the more relevant the recommendations and insights it provides will be.

### Categories
Plugins come in various "categories" that indicate what types of tools/data they handle. Currently, supported categories are:


| Category                  | Supported Plugins                                |
|:-------------------------:|:------------------------------------------------:|
| Infrastructure Provider   | AWS, Azure, GCP                                  |
| Infrastructure Monitoring | CloudWatch, DataDog, NewRelic                    |
| Cluster Monitoring        | Kubernetes  +                                    |
| Uptime Monitoring         | Pingdom                                          |
| APM                       | DataDog, NewRelic                                |
| Network Monitoring        |                                                  |
| Database Monitoring       |                                                  |
| Synthetic Monitoring      | Pingdom                                          |
| Operational Intelligence  | Travis Insights                                  |
| CDN                       | CloudFlare                                       |
| DNS                       | CloudFlare                                       |
| Source Control            | BitBucket, Github                                |
| Deployment Pipeline       | CircleCI, TeamCity                               |
| Log Aggregation           |                                                  |
| Error Tracking            | Rollbar                                          |


>  '+' Plugins that need installation.

## Environment Score
Once your scans are complete, a holistic view of your environment is compiled and scored based on the number and criticality of outstanding notifications versus the complexity and size of your environment. In general, one should try to increase their score percentage by addressing the issues noted in the various notifications displayed on their dashboard. Note that the larger and more complex the environment, the less impact each individual item will have on the overall score.

