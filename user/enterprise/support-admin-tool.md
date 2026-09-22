---
title: Support Admin Tool
layout: en_enterprise

---

> The tool is only visible to Platform maintainers from TCIE 3.x as **Admin-v2**. The tool must be configured with a list of GitHub handles that allow **admin** access.

> The tool is only accessible via a web browser.

## Log out users Forcefully from Travis
To increase security and prevent unauthorized access, Travis CI introduces the new **“Log out user and revoke all tokens”** option, which allows admin users to log out of any unwanted user manually. 

### Log out Users
Travis CI admin users can now click the **“Logout”** button next to the **“Log out user and revoke all tokens”** option in the User view to log out specific users manually.

By clicking the **“Logout”** button, Travis CI invalidates all Travis authentication tokens and logs out the selected user from all Travis CI platforms. This prevents access via web browser, public API, and Travis Cli. 

Logged-out users cannot access Travis CI via the web browser or travis-cli tool without re-accessing the system. Any build automation based on an API token associated with such a user will cease to work.

### Why must I log out of my user and revoke all tokens?

Consider the following: The user gets suspended, e.g., in the GHE server (3rd-party app), and Travis CI is not notified of the action; therefore, no action is taken on Travis CI's side. At the same time, such users may still have a valid Travis Web UI browser, travis-cli access tokens, and a working Travis API authentication token.

Such a situation may be valid and desired. However, there are cases, like a person leaving a company or team, when it is simply a security matter to revoke all accesses for such users. Travis CI cannot react automatically since no automated notification has been sent out, e.g., the GHE server account is suspended. If you are considering a less drastic approach, consider manually [suspending a user](/user/enterprise/user-management/) instead of logging out and revoking all tokens. 

Suspended users still have access to Travis CI via browser or travis-cli (assuming they have valid Travis access tokens in these tools) but cannot trigger builds.

### Auth tokens

The following environment variables are used to manage the token's life.

- `WEB_TOKEN_EXPIRES_IN_HOURS`
- `AUTH_TOKEN_EXPIRES_IN_DAYS`
- `AUTH_CLI_TOKEN_EXPIRES_IN_DAYS`

These tokens can be set using the admin console `kubectl kots admin-console -n tci-enterprise-kots` under the "Advanced Setting" menu.

## Re-access Travis CI

To re-access Travis CI, users must log in using a 3rd-party authenticator such as GitHub (browser, travis-cli), GitLab, or  BitBucket (browser). Only with access can users see the private repositories, build history, build job logs, and obtain new Travis API tokens.

Please note: if such users (logged out and tokens revoked) are, e.g., suspended in the GHE server, they will be unable to successfully use their GHE server account to log into Travis CI UI or travis-cli.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
