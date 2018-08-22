---
title: Minimal and Generic images
layout: en

---

## What This Guide Covers

Travis CI supports many popular programming languages, but can never hope to support them all. `language: minimal` and `language: generic` are images running Ubuntu Trusty  that are not tailored to any particular programming language. Both are avaialble on both sudo-enabled and container-based infrastructure. As their names suggest, one is optimized be faster and use less disk space, the other to have more languages and services available.

> Note that `language: minimal` is not the same as omitting the `language` key, if you do that the default language is set to Ruby.

<aside markdown="block" class="ataglance">

| Ruby              | Default                                   |
|:------------------|:------------------------------------------|
| Default `install` | N/A                                       |
| Default `script`  | N/A                                       |
| Matrix keys       | N/A                                       |
| Support           | [Travis CI](mailto:support@travis-ci.com) |

Examples:

```yaml
language: minimal
```
{: data-file=".travis.yml"}


```yaml
language: generic
```
{: data-file=".travis.yml"}

</aside>

## Aliases

Setting the `language` key to `bash`, `sh` or `shell` is equivalent to `language: minimal`.
