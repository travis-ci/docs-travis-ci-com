---
title: User Management Commands
layout: en_enterprise

---

Following user management options are available in Travis Ci Enterprise (TCIE) versions.

These commands are run via the command line on the platform instance.

## User Information in TCIE 3.x

List basic information about users and their status.

`kubectl exec -it [travis-api-pod]j /app/bin/users`  - list every user.

`kubectl exec -it [travis-api-pod]j /app/bin/users --active` - list every active user.

`kubectl exec -it [travis-api-pod]j /app/bin/users --suspended` - list every suspended user.

## User Information in TCIE 2.x

List basic information about users and their status.

`travis users`  - list every user.

`travis users --active` - list every active user.

`travis users --suspended` - list every suspended user.

## Suspend and Unsuspend Users in TCIE 3.x

Suspend or unsuspend users. Builds triggered by suspended users are blocked by `travis-gatekeeper`.

`kubectl exec -it [travis-api-pod]j /app/bin/suspend <login>` - suspend a user where `<login>` is the user's GitHub login.

`kubectl exec -it [travis-api-pod]j /app/bin/unsuspend <login>` - unsuspend a user where `<login>` is the user's GitHub login.

## Suspend and Unsuspend Users in TCIE 2.x

Suspend or unsuspend users. Builds triggered by suspended users are blocked by `travis-gatekeeper`.

`travis suspend <login>` - suspend a user where `<login>` is the user's GitHub login.

`travis unsuspend <login>` - unsuspend a user where `<login>` is the user's GitHub login.

**Please note**: Using the `suspend` command does not restrict access to the Enterprise platform.
It removes a seat restriction for an archived user. If a *suspended* user logs into the platform, the seat restriction would be imposed once more.

## Difference between Active, Inactive, and Suspended Users

* Active User: User with a GitHub OAuth token and not marked as suspended.
* Inactive User: User without a GitHub OAuth token and not marked as suspended.
* Suspended User: User marked as suspended having a GitHub OAuth token or not.

## Syncing a User in TCIE 3.x

To sync a user (not technically part of User Management, but a related task):

To sync one user: `kubectl exec -it [travis-github-sync-pod] bundle exec bin/schedule users [login]` 

To sync all users: `kubectl exec -it [travis-github-sync-pod] bundle exec bin/schedule users`

> Please note: pod used for synchronizing users is `github-sync-pod` not `travis-api-pod`

## Syncing a User in TCIE 2.x

To sync a user (not technically part of User Management, but a related task):

To sync one user: `travis sync_users --logins=<login>` 

To sync all users: `travis sync_users`
