---
title: Minimal and Generic images
layout: en

---

## What This Guide Covers

Travis CI supports many popular programming languages, but can never hope to support them all. `language: minimal` and `language: generic` are images running Ubuntu Trusty that are not tailored to any particular programming language. Both are available on both sudo-enabled and container-based infrastructure. As their names suggest, one is optimized be faster and use less disk space, the other to have more languages and services available.

> Note that `language: minimal` is not the same as omitting the `language` key, if you do that the default language is set to Ruby.

<aside markdown="block" class="ataglance">

| Ruby              | Default                                                           |
|:------------------|:------------------------------------------------------------------|
| Default `install` | N/A                                                               |
| Default `script`  | N/A                                                               |
| Matrix keys       | N/A                                                               |
| Support           | [Travis CI](mailto:support@travis-ci.com?Subject=Minimal%20image) |

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

As neither `minimal` or `generic` are tailored to one particular language, there are no default `install` or `script` commands, so remember to configure these in your `.travis.yml`.

## Minimal

The `minimal` image contains:

* [version control tools](/user/reference/trusty/#version-control)
* [essential build tools such as gcc and make](/user/reference/trusty/#compilers--build-toolchain)
* [network tools such as curl and essential](/user/reference/trusty/#networking-tools)
* [Docker](/user/reference/trusty/#docker)
* [python](/user/reference/trusty/#python-images)

## Generic

The `generic` image contains everything from `minimal`, and also the usual databases, services and language runtimes:

* [version control tools](/user/reference/trusty/#version-control)
* [essential build tools such as gcc and make](/user/reference/trusty/#compilers--build-toolchain)
* [network tools such as curl and essential](/user/reference/trusty/#networking-tools)
* [Docker](/user/reference/trusty/#docker)
* [databases and services](/user/reference/trusty/#databases-and-services)
* [go](/user/reference/trusty/#go-images)
* [jvm](/user/reference/trusty/#jvm-clojure-groovy-java-scala-images)
* [node_js](/user/reference/trusty/#javascript-and-nodejs-images)
* [php](/user/reference/trusty/#php-images)
* [ruby](/user/reference/trusty/#ruby-images)

For specific details of what is on the image consult the [build update](/user/build-environment-updates/2017-12-12/#2017-12-12).


## Aliases

Setting the `language` key to `bash`, `sh` or `shell` is equivalent to `language: minimal`.
