---
title: Adding Plugins
layout: en_insights

---

Once you have an account, the next step is connecting all of your toolings via plugins. After that, you can log in and go to the [Plugins](https://srenitydashboard.io/plugins) tab to start adding plugins.

It is necessary to provide a name when adding a plugin because you can add multiple plugins from the same tool. 

![add-plugin](/user/images-insights/addPlugin.png)

Every tool has its own methodology for creating credentials and integrating with Travis Insights. Generally, Travis Insights just need a read-only API key for most types of plugins.  However, instructions for each plugin type will be populated in the right-hand navigation bar on the [Plugins](https://srenitydashboard.io/plugins) page as you add them.

To add the plugin, you must **Test Connection** to check if the information provided is working; if not, you get a **Connection Failed** status. Next, check if all data is correct; when all is correct you get a **Connection Succeeded!** message, and you can finish registering the plugin. Once a plugin is added, any of the private information (keys, tokens, etc.) will be displayed, and all that information is kept encrypted in Travis Insights.

## Plugins Information

The plugins list displays registered plugins with relevant information about their general status.

![plugin-messages](/user/images-insights/pluginMessages.png)

A drop-down list at the top of the plugins list lets you decide which plugins to display, All Plugins, Active Plugins, or Inactive Plugins.

The plugins list columns display the following information:

- **Plugin:** The plugin name set during its registration. Order the plugins alphabetically using the arrow next to the column's name.
- **Key ID:** Shows IDs according to the information used to connect with the company/contributor.
- **Product:** The general name of the company/contributor.
- **Category:** Travis Insights classify products in different categories (Infrastructure, Monitoring, Source Control, etc.) Find more information [here](../architecture#integrations).
- **Last Scan:** Shows the date and time of the last scan for the plugin (yyyy-mm-dd hh:mm:ss.sssss). 
- **Scan Status:** Displays status messages.

  - *Successful:* All plugin probes were able to run successfully.
  - *Partial:* Some of the plugin probes failed during the scan.
  - *Error:* The system encountered an issue that didn't let Travis Insights finish the scan. 
  - *In Progress:* The probes scan is taking place.

- **Scan Details:** The last scan results are listed in the link view. Review this window to check if there were some errors during the scan. In addition, you can see the logs of the notification, the plugin, and all related probes.

    ![scanlog](/user/images-insights/scanLog.png)

- **Plugin Status:** shows if it is an Active or Inactive plugin.

At the top of the plugins list, you have the option to **deactivate** or **delete** any plugin; clicking the "Toggle" button deactivates selected plugins. At the top of the plugins list, you will find a drop-down menu, select if you want to display _"All Plugins"_, _"Active Plugins"_, or _"Inactive Plugins"_. **Active Plugins** is selected by default.



Travis Insights supports different technologies, and it works with the following plugin types at this time: 

- [AWS CloudWatch Monitoring](../plugin-types#aws-cloud-monitoring) 
- [AWS Infrastructure](../plugin-types#aws-infrastructure)
- [AppDynamics](../plugin-types#appdynamics)
- [Artifactory](../plugin-types#artifactory)
- [Assembla](../plugin-types#assembla)
- [Azure](../plugin-types#azure)
- [Azure Application Insights](../plugin-types#azure-application-insights)
- [Azure DevOps](../plugin-types#azure-devops)
- [Bamboo CI](../plugin-types#bamboo-ci)
- [Bitbucket](../plugin-types#bitbucket)
- [Buddy CI](../plugin-types#buddy-ci)
- [Circle CI](../plugin-types#circleci) 
- [Cloudbees](../plugin-types#cloudbees)
- [Cloudflare](../plugin-types#cloudflare)
- [CodeClimate](../plugin-types#codeclimate)
- [DataDog Monitoring](../plugin-types#datadog-monitoring)
- [DynECT](../plugin-types#dynect)
- [GCP Infrastructure](../plugin-types#google-cloud-platform-infrastructure)
- [GitHub](../plugin-types#github)
- [Gitlab](../plugin-types#gitlab)
- [GoDaddy](../plugin-types#godaddy)
- [Google Cloud Source Repositories](../plugin-types#google-cloud-source-repositories)
- [Heroku](../plugin-types#heroku) 
- [Kubernetes Cluster](../plugin-types#kubernetes-cluster)
- [NewRelic](../plugin-types#newrelic)
- [Okta](../plugin-types#okta)
- [OneLogin](../plugin-types#onelogin)
- [PagerDuty](../plugin-types#pagerduty)
- [Pingdom Uptime Monitoring](../plugin-types#pingdom-uptime-monitoring) 
- [Rollbar](../plugin-types#rollbar)
- [Sentry](../plugin-types#sentry)
- [Sonarqube](../plugin-types#sonarqube)
- [Sysdig](../plugin-types#sysdig)
- [TeamCity](../plugin-types#teamcity)
- [Travis CI](../plugin-types#travis-ci)
- [Zendesk](../plugin-types#zendesk)
