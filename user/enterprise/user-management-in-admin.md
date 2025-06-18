---
title: User Management Commands
layout: en_enterprise

---

Travis CI Enterprise (TCIE) offers a new tab for admin users, the **User Activity** tab, where admin users can see active users and suspend or unsuspend specific users. This section describes how to obtain and use an Organizational-level token.

## Obtain Organization-level token

A new token authorization method was introduced in Travis API **org.token**. An organization-level access token that grants permissions to perform platform-level administrative commands via APIs.

Travis CI Enterprise platform admin users require a list of active and inactive user accounts to make informed decisions about whether to suspend accounts. TCIE admin users can now obtain and regenerate organization-level tokens (OTP secured). Each token has a predefined permission. Currently, there are two possible usages for Organization-level tokens: checking user activity and suspending or unsuspending users in the organization. 

## How to use Organization-level tokens

Navigate to the API Tokens section at the bottom of the Travis admin V2 Organization page. Under the Organization tab, scroll down to the **API** section.

This section displays the API key of the Organization. 
Click the “Copy” button to copy the token. 
Click the “Re-generate” button to generate a new token.

The token is hidden by default, and by clicking the **View** button, the token is displayed. 

> Note: This section is for admin users only. 

Users can now use the following new API endpoint:
```
/org/:id/user_activity
```

Here is an example of using the command for looking for active users since Feb. 21st, 2025:
```
curl -L -v -s -k -X GET \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -H "Travis-API-Version: 3" \
     -H "Authorization: org.token 89:xxxxxxx" \
     "https://[instance]org/89/user_activity?date=2025-02-21&status=active"
```

Using a GET request allows users to retrieve a list of active and inactive users for a specified time between the current date and any specified date.

The status parameter accepts the `active` or `inactive` values. And enter the `date` param using the `yyyy-mm-dd` format. 

## Suspending and Unsuspending Users

The following new endpoints were introduced and can be used to suspend or unsuspend users.

```
/org/:id/suspend
/org/:id/unsuspend
/users/suspend
/users/unsuspend`
```
To suspend users based on their Travis CI ID, use the following:
```
{ "user_ids" : [1,2...]}
```

To suspend users based on their VCS TYPE and ID, use the following:
```
{ "vcs_type":"github", "vcs_ids": [100,101..]}
``` 

### Bulk Suspension
Travis CIE admin users can bulk suspend users via API or CLI by providing a list of users with their VCS IDs. 


## User Activity

![User Activity Tab](/user/images/user-activity-tab-tcie.png)

The new **User Activity** tab, available from the top bar, was introduced to Travis CI Enterprise, allowing admin users to manage Enterprise users within the organization.

In this section, you can obtain a CSV file containing a list of active and inactive users for a specified date. Simply, enter a `Date From` to generate a list of Active and Inactive users. 

## Suspend Users

![Suspend Users](/user/images/suspend-users-screen.png)

With the list you generated, you can select a subset of users for suspension by uploading a CSV file containing only the users you want to suspend. 

Once the file is uploaded, you can suspend all users from the uploaded file.

Use the **Suspend** button to suspend any user from the list.  

You can also unsuspend users by viewing the Suspend users list and clicking the **Unsuspend** button. 

> Note: The old Enterprise Users page is now a section of the new User Activity page.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
