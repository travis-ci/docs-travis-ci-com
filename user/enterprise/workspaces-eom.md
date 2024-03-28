---
title: Enterprise Workspaces & Cache
layout: en_enterprise

---

This page contains operations manual level information about Workspaces and Cache in Travis CI Enterprise.

## Cache vs Workspaces

Cache, aka Build Cache, is configured file bucket which serves a purpose as a cache for build artifacts. Users of Travis CI Enterprise may put or pull to/from the Cache the build artifacts.
**Cache is meant for items used in different builds**.

Workspaces, aka Build Workspaces, is a kind of cache, but with specific goal in mind: serves a purpose to share artifacts/files between **jobs within the same build**. The main use case is 
when a binary or library (or other dependency) requires rebuilding before any other build job within build may progress. Workspaces are introduced in Travis CI Enterprise starting from 
[version 3.0.53](https://enterprise-changelog.travis-ci.com/release-3-0-53-283095).

Both features are technically specifically configured file buckets, accessed during a running build.

### Workspaces configuration

Workspaces are configured much like Cache - in the Travis CI Enterprise platform admin application. The configuration is technically propagated to travis-build service during runtime.

There's a new menu called "Workspaces UI Settings", where specific configuration items must be provided in order to enable feature for the end users.

![TCIE Workspaces Settings](/images/tcie-3.x-workspaces-config.png)

> **Please note**
> 
> Workspaces are meant for short-lived artifacts.
>
> It is recommended to:
> 
> - use separate file bucket than the one used for cache, both for security and maintenance reasons
> - have a file bucket configured with auto-cleanup policy (TCIE is not performing any housekeeping on the file bucket) - default recommended time is 3 hours, which equals default max time of a single job running uninterrupted under certain conditions
> - make sure your infrastructure hosting build image instances has connectivity to the file bucket configured for workspaces

### Workspaces usage

Please see [our documentation](/user/using-workspaces) for end-user facing usage instructions for Workspaces.

Please read also [about build stages](/user/build-stages/) in order to create streamlined set of jobs, which can be used e.g. for pre-building a short lived artifact in first steps of build pipeline. 
