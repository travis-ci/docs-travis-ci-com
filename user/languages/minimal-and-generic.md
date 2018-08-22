---
title: Minimal and Generic images
layout: en

---

## What This Guide Covers

Travis CI supports many popular programming languages, but can never hope to support them all. `language: minimal` and `language: generic` are images running Ubuntu Trusty  that are not tailored to any particular programming language. Both are available on both sudo-enabled and container-based infrastructure. As their names suggest, one is optimized be faster and use less disk space, the other to have more languages and services available.

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

## Defaults

As neither `minimal` or `generic` are tailed to one particular language, there are no default `install` or `script` commands, so remember to configure these in your `.travis.yml`.

## Minimal

The `minimal` image contains:

* [version control tools](/user/reference/trusty/#version-control)
* [essential build tools such as gcc and make](/user/reference/trusty/#compilers--build-toolchain)
* [network tools such as curl and essential](/user/reference/trusty/#networking-tools)
* [Docker](/user/reference/trusty/#docker)

For specific details of what is on the image consult the [update diff](https://stackmeta-production.herokuapp.com/diff/travis-ci-connie-trusty-1499451964/travis-ci-connie-trusty-1503972833?items=bin-lib.SHA256SUMS,system_info.json,dpkg-manifest.json,TRAVIS_COOKBOOKS_SHA,PACKER_TEMPLATES_SHA&format=text).

## Generic

The `generic` image contains everything from `minimal`, and also the usual [databases and services](/user/reference/trusty/#databases-and-services)

For specific details of what is on the image consult the [update diff](https://stackmeta-production.herokuapp.com/diff/travis-ci-garnet-trusty-1499451966/travis-ci-garnet-trusty-1503972833?items=bin-lib.SHA256SUMS,system_info.json,dpkg-manifest.json,TRAVIS_COOKBOOKS_SHA,PACKER_TEMPLATES_SHA&format=text).


## Aliases

Setting the `language` key to `bash`, `sh` or `shell` is equivalent to `language: minimal`.
