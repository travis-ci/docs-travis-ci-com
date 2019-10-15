---
title: User Management Commands
layout: en_enterprise

---

These commands are run via the command line on the platform instance.

## User Information

List basic information about users and their status.

`travis users`  - list every user.

`travis users --active` - list every active user.

`travis users --suspended` - list every suspended user.

## Suspend and Unsuspend Users

Suspend or unsuspend users. Builds triggered by suspended users are blocked by `travis-gatekeeper`.

`travis suspend <login>` - suspend a user where `<login>` is the user's GitHub login.

`travis unsuspend <login>` - unsuspend a user where `<login>` is the user's GitHub login.

**Please note**: Using the `suspend` command does not restrict access to the Enterprise platform.
It removes a seat restriction for an archived user. If a *suspended* user logs into the platform, the seat restriction would be imposed once more.

## Difference between Active, Inactive, and Suspended Users

* Active User: User with a GitHub OAuth token and not marked as suspended.
* Inactive User: User without a GitHub OAuth token and not marked as suspended.
* Suspended User: User marked as suspended having a GitHub OAuth token or not.

## Syncing a User

To sync a user (not technically part of User Management, but a related task):

To sync one user: `travis sync_users --logins=<login>` 
To sync all users: `travis sync_users`
