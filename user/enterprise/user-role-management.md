---
title: User Role Management
layout: en_enterprise

---

_Available from Travis CI Enterprise 3.1.0_

Travis CI introduces the new User Role Management feature to increase security and functionality. This feature offers more granular access control management, adding more strict access rights management while continuing to protect vital information that may be present in the CI/CD build job logs. 

This feature allows Travis CI administrators to execute permission limits on user privileges to the minimum functionality necessary to work (on an as-needed basis) to protect particular build job logs.

## Enable User Role Management

From the Travis CI Enterprise admin console, open the `Config` menu, expand the `Advanced Settings` menu on the left, and click on the `Users Roles Management`.

![Member Management menu](/images/enterprise-user-management-menu.png)

To enable the setting, select the `Enabled` option and save the settings.

![Member Management option](/images/enterprise-user-management-setting.png)

## Travis CI Roles

New Travis CI Users are created via the “**sign-in with…**” functionality, linking a third-party application (GitHub, Assembla, BitBucket, or GitLab) to Travis CI. See the [Onboarding guide](/user/onboarding/) for more information.


In Travis CI, user access to Travis CI repositories and accounts functionalities and the following are the different types of user roles:
- Admin:
  - Repository: manages repository settings, triggers builds, and can utilize various functions around builds. 
  - Account: able to activate repositories in Travis CI and billing.
- Push (Write) User:
  - Repository: triggers builds and can utilize various functions around builds. 
  - Account: able to request repository activation in Travis CI.
- Pull (Read) User:
  - Repository: cannot trigger builds and has limited functionality around builds
  - Account: able to request repository activation in Travis CI
- Owner: an owner is an admin user for the owned Repository and accounts. An owner can be a user or an organization. 


This feature authorizes admin users to handle regular users to their liking. Regular users must still log in using a version control system (VCS). Therefore, the User Management functionality allows admin users to identify regular user roles for those with access to Travis CI.  


## Member Management Tab

The Member Management tab presents a list of users with their respective roles.

Travis CI admin users are presented with a list of users and have access to change or assign the roles of regular users. Admin users can use the “**Sync org**” or "**Sync users**” to update the list of users. 

The following are the available fields where each user can be associated with several roles.   
- Name: displays the user’s name.
- Login: displays the login email for the user.
- Old Role: displays the previous authorization permissions for the selected user.
- New Role: Shows the role or number of roles assigned to the selected user. Allows admin users to choose or change the role or roles for the selected user.
	- All: Enables all four options. 
- Admin: Has all account and repository permissions.
- Account Settings Editor: Access to create and edit account settings. 
- Account Settings Admin: Unlimited access to manage the account and can manage account plans, billings, and contacts.
- Account Plan Viewer: Can invoice, use, and view the account plans. 
- Can Build: Check the checkbox to authorize the selected user to build.

![Member Management Tab](/images/enterprise-member-management-tab.png)

## User Management Tab

The User Management tab lists the users who have access to the repository, and Travis CI admin users can assign repository connection roles.

The following are the available fields where each user can be associated with several roles.   
- Name: displays the user’s name.
- Login: displays the login email for the user.
- New Role: Shows the role or number of roles assigned to the selected user. Allows admin users to choose or change the role or roles for the selected user.

![User Managemenet Tab](/images/enterprise-user-management-tab-updated.png)

The available roles and their current permissions are shown in the table below:

| **Role** | **Permissions (Technical)** | **Permission Description** |
|---|---|---|
| _Repository.Settings.Editor_ | _repository.settings.create_, _repository.settings.update_, _repository.settings.delete_ | Can fully manage the repository settings |
| _Repository.Settings.Viewer_ | _repository.settings.read_ | Can read the repository settings |
| _Repository.Builds.Restarter_ | _repository.build.restart_ | Can restart the repository builds |
| _Repository.Builds.Triggerer_ | _repository.build.create_, _repository.build.cancel_ | Can create and cancel the repository builds |
| _Repository.Builds.Cancel_ | _repository.build.cancel_ | Can cancel the repository builds |
| _Repository.Logs.Viewer_ | _repository.log.view_ | Can view the repository logs |
| _Repository.Logs.Admin_ | _repository.log.delete_, _repository.log.view_ | Can delete and view the repository logs |
| _Repository.Builds.Debugger_ | _repository.build.debug_ | Can debug the repository builds |
| _Repository.Cache.Editor_ | _repository.cache.delete_, _repository.cache.view_ | Can delete and view the repository caches |
| _Repository.Cache.Viewer_ | _repository.cache.view_ | Can view the repository caches |
| _Repository.Collaborator_ | _repository.build.create_, _repository.build.cancel_, _repository.build.restart_, _repository.log.delete_, _repository.log.view_, _repository.build.debug_, _repository.cache.view_ | Can fully manage builds and logs. Can view the repository caches |
| _Repository.Admin_ | _repository.settings.create_, _repository.settings.update_, _repository.settings.delete_, _repository.build.create_, _repository.build.cancel_, _repository.build.restart_, _repository.log.delete_, _repository.log.view repository.build.debug_, _repository.cache.delete_, _repository.cache.view_, _repository.cache.view_ | Has unlimited access to manage the repository. He can fully manage repositories and builds, logs, and caches. |
| _Repository.Reader_ | _repository.log.view_, _repository.cache.view_ | Can view the repository logs and caches |
| _Account.Settings.Editor_ | _accounts.settings.edit_, _account.settings.create_ | Can create and edit accounts settings |
| _Account.Settings.Admin_ | _account.settings.delete_, _accounts.settings.edit_, _account.settings.create_, _account.plan.create_, _account.plan.invoices_, _account.plan.usage_, _account.billing.view_, _account.contact.view_, _account.billing.update_, _account.contact.update_ | Has unlimited access to manage the account. Can fully manage account plans, billings, and contacts |
| _Account.Plan.Viewer_ | _account.plan.invoices_, _account.plan.usage_, _account.plan.view_ | Can create invoices, usage, and view the account plans |
| _Account.Plan.Editor_ | _account.plan.create_, _account.plan.invoices_, _account.plan.usage_ | Can fully manage the account plans |
| _Account.Billing.Editor_ | _account.billing.view_, _account.contact.view_, _account.billing.update_, _account.contact.update_ | Can view and update the account billings and contacts |
| _Account.Billing.Viewer_ | _account.billing.view_, _account.contact.view_ | Can view the account billings and contacts |
| _Account.Admin_ | all perms (including Repository object permissions) | Has all the account and the repository permissions |


## Travis Admin and extended VCS synchronization logic

All Travis CI Admin users can access the additional Repository and Account (personal or organizational) settings screen, where they can configure the new roles and permissions assigned to a single user, either at the Account or the Repository level. 

The new permission system implemented in Travis CI updates the modified roles and permissions after every synchronization with the version control system (VCS). The goal of the new permission system is to upgrade any modifications made by Admin users with access to these settings to single users’ roles and permissions. 

The process for the new permission system is as follows:

1. Synchronization with a version control system. Occurs daily or on-demand.
2. The new systems’ mapping assigns a correct Travis CI role according to the existing role from the VSC provider.
3. The new roles and permission system records new roles and permission updates in the database and checks for any modification to user settings.
4. The new roles and permission system assigns each existing system user the default set of settings (roles and permissions) obtained from the VSC access rights during the VCS synchronization.
5. The new roles and permissions service creates or updates the new roles and permissions.  


> **Note**: If errors occur, unprocessed requests are queued to retry sync with VCS, and error logs are recorded.  

> **Note**: Suspending or unsuspending a user’s repository access removes the user’s build-triggering access and assigns the respective Repository Reader role.

> **Note**: Suspending or unsuspending a user’s account access removes the user from all Admin and editing roles and allows the user to be only a Plan Viewer and Billing Viewer. 


When existing Travis CI users log in, the user's current membership and permissions are checked against the new permissions service to check for any role or permission modifications.   

The following table displays the action executed for each specific modification of settings for user accounts and repositories.

| **Permission Modifications** | **Action executed** |
|---|---|
| User permissions creation | The new permission service creates the user and adds the new permissions. |
| User permissions were not modified  | The new permission service does not modify permissions. |
| User permissions are extended | The new permission service updates the permissions to match permissions received from version control system synchronization. |
| User permissions are restricted | The new permissions service |
| User access is removed from Repository | All TCI roles and permissions for user repository access are removed. If the removed user has a personal account and invites collaborators to his personal repositories, Travis CI directly maps the collaborators' access rights to the owners' Travis CI Repository. |
| User access is removed from Account | All TCI Roles and permissions, in the context of the users' Travis CI account, are removed. |


## Roles and Permissions

The following tables display the new roles and permissions for repositories and accounts. 

### Roles

| **Previous Repository Roles** | **New Roles** | **Permissions** |
|---|---|---|
| admin user | _Repository.Settings.Editor_ | _repository.settings.create_, _repository.settings.update_, _repository.settings.delete_, _repository.settings.read_ |
| admin user | _Repository.Settings.Viewer_ | _repository.settings.read_ |
| admin user, push user | _Repository.Builds.Restarter_ | _repository.build.restart_ |
| admin user, push user | _Repository.Builds.Triggerer_ | _repository.build.create_, _repository.build.cancel_ |
| admin user, push user | _Repository.Builds.Cancel_ | _repository.build.cancel_ |
| admin user, push user, pull user, anonymous (for public repos) | _Repository.Logs.Viewer_ | _repository.log.view_ |
| admin user | _Repository.Logs.Admin_ | _repository.log.delete_, _repository.log.view_ |
| admin user, push user | _Repository.Builds.Debugger_ | _repository.build.debug_ |
| admin user | _Repository.Cache.Editor_ | _repository.cache.delete_, _repository.cache.view_ |
| admin user, push user, pull user | _Repository.Cache.Viewer_ | _repository.cache.view_ |
| push user | _Repository.Collaborator_ | _repository.build.create_, _repository.build.cancel_, _repository.build.restart_, _repository.log.delete_, _repository.log.view_, _repository.build.debug_, _repository.cache.view_ |
| admin user | _Repository.Admin_ | _repository.settings.create_, _repository.settings.update_, _repository.settings.delete_, _repository.build.create_, _repository.build.cancel_, _repository.build.restart_, _repository.log.delete_, _repository.log.view_, _repository.build.debug_, _repository.cache.delete_, _repository.cache.view_, _repository.cache.view_, _repository.scan.view_ |
| pull user | _Repository.Reader_ | _repository.log.view_, _repository.cache.view_, _repository.build.restart_ |
| pull user | _Repository.State.Editor_ | _repository.state.update_ | 


### Accounts

| **Previous Account Roles** | **New Roles** | **Permissions** |
|---|---|---|
| admin | _Account.Settings.Editor_ | _account.settings.edit_, _account.settings.create_ |
| admin | _Account.Settings.Admin_ | _account.settings.delete_, _accounts.settings.edit_, _account.settings.create_, _account.plan.create_, _account.plan.invoices_, _account.plan.usage_, _account.billing.view_, _account.billing.update_, _account.contact.view_, _account.contact.update_ |
| admin,push user | _Account.Plan.Viewer_ | _account.plan.invoices_, _account.plan.usage_, _account.plan.view_ |
| admin | _Account.Plan.Editor_ | _account.plan.create_, _account.plan.invoices_, _account.plan.usage_ |
| admin | _Account.Billing.Editor_ | _account.billing.view_, _account.contact.view_, _account.billing.update_, _account.contact.update_ |
| admin, push user | _Account.Billing.Viewer_ | _account.billing.view_, _account.contact.view_ |
| admin | _Account.Admin_ | all permissions (including both Account and Repository object permissions) |



The following tables show the Travis CI roles and permissions corresponding to those taken from each version control system.  

#### GitHub 

The following table displays GitHub repository roles.

| **GitHub Role** | **Travis CI Role** |
|-----------------|--------------------|
| Admin           | admin user         |
| Read            | pull user          |
| Triage          | pull user          |
| Write           | push user          |
| Maintain        | push user          |


The following table displays GitHub organization roles.

| **GitHub Role**  | **Travis CI Role** |
|------------------|--------------------|
| Owner            | admin user         |
| Member           | push user          |
| Moderator        | push user          |
| Billing Manager  |                    |
| Security Manager | push user          |


#### Assembla

| **Assembla Role** | **Travis CI Role** |
|-----------------|--------------------|
| Owner           | admin user         |
| Member          | push user          |
| Watcher         | read user          |


#### GitLab

| **GitLab Role** | **Travis CI Role** |
|-----------------|--------------------|
| Owner           | admin user         |
| Maintainer      | admin user         |
| Developer       | push user          |
| Reporter        | pull user          |
| Guest           | pull user          |


#### Bitbucket

| **Bitbucket Role** | **Travis CI Role** |
|-----------------|--------------------|
| Admin           | admin user         |
| Read            | pull user          |
| Write           | push user          |



## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
