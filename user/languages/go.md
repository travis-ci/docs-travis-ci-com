---
title: Building a Go Project
layout: en

swiftypetags:
  - golang
  - go lang
  - go
---

<div id="toc">
</div>

<aside markdown="block" class="ataglance">

| Go                                          | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#Dependency-Management) | `go get -t ./...`                         |
| [Default `script`](#Default-Build-Script)   | `make` or `go test`                       |
| [Matrix keys](#Build-Matrix)                | `go`, `env`                               |
| Support                                     | [Travis CI](mailto:support@travis-ci.com) |

Minimal example:

```yaml
  language: go
  go:
    - 1.6
```
</aside>

## What This Guide Covers

{{ site.data.snippets.trusty_note_no_osx }}

Go builds are not available on the OS X environment.

The rest of this guide covers configuring Go projects in Travis CI. If you're
new to Travis CI please read our [Getting Started](/user/getting-started/) and
[build configuration](/user/customizing-the-build/) guides first.

## Specifying a Go version to use

You can use any tagged version of Go, a version with `x` in place of the minor
or patch level to use the latest for a given major or minor version, or use
`master` to get the latest version from source. All go version management is
handled by [gimme](https://github.com/travis-ci/gimme).


```yaml
language: go

go:
  - 1.x
  - 1.6
  - 1.7.x
  - master
```
{: data-file=".travis.yml"}


## Go Import Path

The project source code will be placed in `GOPATH/src/github.com/user/repo` by
default, but if [vanity imports](https://golang.org/cmd/go/#hdr-Remote_import_paths)
are necessary (especially for [`internal` package imports](https://golang.org/cmd/go/#hdr-Internal_Directories)),
`go_import_path:` may be specified at the top level of the config, e.g.:

```yaml
go_import_path: example.org/pkg/foo
```
{: data-file=".travis.yml"}

## Dependency Management

The default install step depends on the version of go:

* if go version is greater than or equal to `1.2`

  ```
  go get -t ./...
  ```

* if go version is older than `1.2`

  ```
  go get ./...
  ```

*  or if any of the following files are present, the default install step is `true`:

    - `GNUMakefile`
    - `Makefile`
    - `BSDmakefile`
    - `makefile`

### godep support

There is support included for [godep](https://github.com/tools/godep) when used
with vendored dependencies such that the `GOPATH` will be prefixed with
`${TRAVIS_BUILD_DIR}/Godeps/_workspace` and `PATH` will be prefixed with
`${TRAVIS_BUILD_DIR}/Godeps/_workspace/bin`. Additionally, if the
`Godeps/_workspace/src` directory does not exist,`godep` will be installed and
a `godep restore` will be run.

It is important to note that using the older style `Godeps.json` at the top
level is not supported.

All of the `godep` integration steps are performed prior to the separate
`go get` and makefile steps listed above.

Note that the `godep` support is only activated if a custom `install` step is
not specified.

### Installing Private Dependencies

As `go get` uses HTTPS to clone dependencies from GitHub rather than SSH, it
requires a different workaround from our [recommended way of handling private
dependencies](/user/private-dependencies).

When cloning via HTTPS, git uses curl under the covers, which in turn allows
you to specify a [.netrc](http://manpages.ubuntu.com/manpages/precise/man5/netrc.5.html)
file, where you can store custom authentication credentials for specific
domains, github.com for instance.

Go to your [GitHub account](https://github.com/settings/applications) and
create a personal access token.

![Screenshot of GitHub personal token](/images/personal-token.jpg)

Make sure to give it the `repo` scope, which allows accessing private
repositories.

To reduce access rights of the token, you can also create a separate user
account with access to only the repositories you need for a particular project.

Copy the token and store it in a .netrc in your repository, with the following
data:

```
machine github.com
  login <username>
  password <token>
```

Add this to your repository and add the following steps to your .travis.yml:

```yaml
before_install:
  - cp .netrc ~
  - chmod 600 .netrc
```
{: data-file=".travis.yml"}

You can leave out the second step if your .netrc already has access permissions
set only for the owner. That's a requirement for it to be read from curl.

## Default Build Script

Go projects assume that either Make or Go build tool are used by default. In
case there is a Makefile in the repository root, the default command Travis CI
will use to run your project test suite is

```bash
make
```

In case there is no Makefile, it will be

```bash
go test -v ./...
```

instead.

These default commands can be overridden as described in the [general build
configuration](/user/customizing-the-build/) guide. For example, to omit the
`-v` flag, override the `script:` key in `.travis.yml` like this:

```yaml
script: go test ./...
```
{: data-file=".travis.yml"}

The arguments passed to the default `go test` command may be overridden by
specifying `gobuild_args:` at the top level of the config, e.g.:

```yaml
gobuild_args: -x -ldflags "-X main.VersionString v1.2.3"
```
{: data-file=".travis.yml"}

which will result in the script step being:

```bash
go test -x -ldflags "-X main.VersionString v1.2.3" ./...
```

To build by running Scons without arguments, use this:

```yaml
script: scons
```
{: data-file=".travis.yml"}

## Build Matrix

For Go projects, `env` and `go` can be given as arrays
to construct a build matrix.

## Environment Variable

The version of Go a job is using is available as:

```
TRAVIS_GO_VERSION
```

Please note that this will expand to the real Go version, for example `1.7.4`,
also when `go: 1.7.x` was specified. Comparing this value in for example the
deploy section could look like this:

```yaml
deploy:
  ...
  on:
    condition: $TRAVIS_GO_VERSION =~ ^1\.7\.[0-9]+$
```
{: data-file=".travis.yml"}

## Examples

- [Go AMQP client](https://github.com/streadway/amqp/blob/master/.travis.yml)
- [mrb/hob](https://github.com/mrb/hob/blob/master/.travis.yml)
- [tsuru/tsuru](https://github.com/tsuru/tsuru/blob/master/.travis.yml)
