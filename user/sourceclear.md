---
title: Using SourceClear with Travis CI
layout: en
permalink: /user/sourceclear/
---
[SourceClear](https://www.sourceclear.com) is security for open-source code.

When you add SourceClear to your TravisCI projects you'll get automated security analysis inside every build. You’ll get complete analysis of your open-source dependencies, including security vulnerabilities, out-of-date libraries, and license reports. Here is how to do it!

## Creating your Authentication Token

In order to set up the SourceClear agent for Travis-CI, you must be
logged into [SourceClear](http://srcclr.com/login), and then perform the
following steps:

----------------------

**NOTE:** By default, the agent you create will not be visible to team members.
In order to allow visibility, you must go to the agent page and select a group
from the *Groups dropdown. After you have done so, members of the selected
group will be able to view the agent information.

----------------------

**1.** From the left sidebar, select the team for which you wish to create the
agent for and then select **Agents**, and then **New Agent**

**2.** In the agent setup page, select **Travis-CI** under the **Continuous
Integration** header.

**3.** Select **Create Authentication Token**, and then copy the value which
appears. You will use this to authenticate with SourceClear during scans.

## Setting the Environment Variable

Setting an environment variable in Travis-CI occurs on a per repository basis, and can be performed by following these steps:

**1.** Select the repository you wish to scan from your Travis-CI environment >
**More Options** > **Settings**

**2.** You will be taken to a page with the heading **Environment Variables**.
Here you will add `SRCCLR_API_TOKEN` as the name and then paste your agent API
token for the value. Make sure to toggle the button labeled *Display value in
build log* to the **OFF** position to ensure your token is kept secret.

<img src="/images/srcclr-travis.png" width="100%"/>

## Configuring your Travis-CI repository

In order to scan using SourceClear, add the following to your `.travis.yml` file:

```
addons:
    srcclr: true
```

Commit these changes to trigger a build for your repository, and SourceClear will perform a scan, displaying results to your SourceClear environment

If you wish to add SourceClear scanning to other repositories, simply add the installation and scan code above to whatever `.travis.yml` files you wish, as well as the `SRCCLR_API_TOKEN` environment variable and you will be able to perform scans on each new build.
