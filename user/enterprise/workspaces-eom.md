---
title: Enterprise Workspaces & Cache
layout: en_enterprise

---

This page contains operations manual level information about Workspaces and Cache in Trravis CI Enterprise.

## Cache vs Workspaces

Cache, aka Build Cache, is configured file bucket which serves a purpose as a cache for build artifacts. Users of Travis CI enterprise may put or pull to/from the Cache the build artifacts.
**Cache is meant for utilizing items between builds**.

Workspaces, aka Build Workspaces, is a kind of cache, but with specific goal in mind: serves a purpose to share artifacts/files between **jobs within the same build**. The main use case is 
when a binary or library (or other dependency) requires rebuilding before any other build job within build may progress. Workspaces are introduced in Travis CI Enterprise after [version 3.0.53](https://enterprise-changelog.travis-ci.com/release-3-0-53-283095).

Both features are technically specifically configured file buckets.

### Workspaces configuration

Workspaces are configured much like Cache - in Travis CI Enterprsie platform admin.

