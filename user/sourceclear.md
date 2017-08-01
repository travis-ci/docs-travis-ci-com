---
title: Using SourceClear with Travis CI
layout: en

---

[SourceClear](https://www.sourceclear.com) is security for open-source code.

When you add SourceClear to your TravisCI projects you'll get automated security analysis inside every build. You’ll get complete analysis of your open-source dependencies, including security vulnerabilities, out-of-date libraries, and license reports.

## Creating your Authentication Token

In order to set up the SourceClear agent for Travis-CI, you must be logged into [SourceClear](http://app.sourceclear.com/login), and then perform the following steps:

**1.** From the left sidebar, select **Agents**, then **New Agent**.

**2.** In the agent setup page, select **Travis-CI**

**3.** Select **Create Authentication Token**, and copy it to your clipboard. You will use this to authenticate with SourceClear during scans.

## Setting the Environment Variable

Setting an environment variable in Travis-CI occurs on a per repository basis:

**1.** Select the repository you wish to scan from your Travis-CI environment >
**More Options** > **Settings**

**2.** On the Environment Variables page, add `SRCCLR_API_TOKEN` and assign your authentication token to it. Make sure to toggle the button labeled **Display value** in build log\* to the **OFF** position to ensure your token is kept secret.

<img src="/images/srcclr-travis.png" alt="SourceClear" width="100%"/>

## Configuring your Travis-CI repository

In order to scan using SourceClear, add the following to your `.travis.yml` file:

```yaml
addons:
    srcclr: true
```

If you want verbose output during the scan, you can add the `debug` key:

```yaml
addons:
    srcclr:
        debug: true
```

Commit these changes to trigger a build for your repository, and SourceClear will perform a scan, displaying results to your SourceClear environment.

If you wish to add SourceClear scanning to other repositories, simply add the installation and scan code above to whatever `.travis.yml` files you wish, as well as the `SRCCLR_API_TOKEN` environment variable and you will be able to perform scans on each new build.
