---
title: Disable Job Logs Availability
layout: en

---

## Disable build job logs availability
To increase security, repository owners have the option to have control over the availability of public Travis CI build job logs. For example, users can choose to disable access to old job logs and prevent security or confidential details from leaking into the log’s historical data.  

You can choose to enable or limit access using the following security settings. 

### Enable access to old build jobs
{{ site.data.snippets.enabling_access_jobs_logs }}

### Limit access to build job logs
{{ site.data.snippets.limiting_access_jobs_logs }}

### Disable logs Options 

|                                                                                                | Public repository                                                                                                                                                                                                                                                                                                                       | Private repository                                                                                |
|------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| **Access to logs only for write/push users OFF, Access to old logs OFF (default settings)**        | Users with **read access** to the repository can see build job logs for public repo not older than the last 365 days.                                                                                                                                                                                                                           | Users with **read access** to the repository can see the build job logs not older than the last 365 days.   |
| **Access to logs only for write/push users ON, Access to old logs OFF**                            | Users with **write access** to the repository will see the build job logs not older than the last 365 days.                                                                                                                                                                                                                                       | Users with **write access** to the repository will see the build job logs not older than the last 365 days. |
| **Access to logs only for write/push users ON, Access to old logs ON**                             | Users with **write access** to the repository will see the build job logs, full history                                                                                                                                                                                                                                                     | Users with **write access** to the repository will see the build job logs, full history.              |
| **Access to logs only for write/push users OFF,  Access to old logs ON** | Users with **read access** to the repository see all build job logs and full history. In this case, even anonymous Users are treated as Users with read access because everybody can view the public repository in the original VCS. | Users with **read access** to the repository can see build job logs and full history.                    |
 
