---
title: Disable Job Logs
layout: en

---

## Disable build job logs
To increase security, repository owners have the option to have control over the availability of public Travis CI build job logs. For example, users can choose to disable access to old job logs and prevent security or confidential details from leaking into the log’s historical data.  

You can choose to enable or limit access using the following security settings. 

### Enabling access to old build jobs
This setting allows you to increase security by preventing access to old job logs older than 360 days. Or, in the case of a necessity, users can explicitly enable access to public and private old job log repositories.  

The following are the available configurations:
* If this setting is ON, it enables access to build job logs older than 365 days. 
* If this setting is OFF, access to build job logs older than 365 days is unavailable via UI or API calls. 

### Limiting access to build job logs
Similarly, this setting allows you to restrict access to build job logs for any user without write/push access rights to the repository. Limit job log visibility to only those that needed it. Enable this setting and ensure job logs are only available to users with respective read or write access to the individual repository.

The following are the available configurations:
* If this setting is ON, it allows access to build job logs only for users with write/push permissions to this repository. Limits access to build job logs via UI and API. 
* If this setting is OFF, users with read access to the repository can access the build job logs. 

Please note that the '*Limiting access to build job logs*' repository setting applies only to users with ‘write/push’ permissions.

### Disable logs Options 

|                                                                                                | Public repository                                                                                                                                                                                                                                                                                                                       | Private repository                                                                                |
|------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| **Access to logs only for write/push users OFF, Access to old logs OFF (default settings)**        | Users with **read access** to the repository can see build job logs for public repo not older than the last 365 days.                                                                                                                                                                                                                           | Users with **read access** to the repository can see the build job logs not older than the last 365 days.   |
| **Access to logs only for write/push users ON, Access to old logs OFF**                            | Users with **write access** to the repository will see the build job logs not older than the last 365 days.                                                                                                                                                                                                                                       | Users with **write access** to the repository will see the build job logs not older than the last 365 days. |
| **Access to logs only for write/push users ON, Access to old logs ON**                             | Users with **write access** to the repository will see the build job logs, full history                                                                                                                                                                                                                                                     | Users with **write access** to the repository will see the build job logs, full history.              |
| **Access to logs only for write/push users OFF,  Access to old logs ON(state of today's product)** | Users with **read access** to the repository see all build job logs and full history. In this case, even anonymous Users are treated as Users with read access because everybody can view the public repository in the original VCS. That collaboration pattern must still be available as an option to the repository owners. | Users with **read access** to the repository can see build job logs and full history.                    |
 
