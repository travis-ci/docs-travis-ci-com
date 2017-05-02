---
title: Building a Go Project
layout: en
permalink: /user/languages/go/
swiftypetags:
  - golang
  - go lang
  - go
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Go projects. Please make sure to read our
[Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

Go builds are not available on the OSX environment.

## CI environment for Go Projects

Travis CI VMs are 64 bit and currently provide

- recent versions of Go
- core GNU build toolchain (autotools, make), cmake, scons

Go projects on travis-ci.org assume you use Make or straight Go build tool by default.

## Specifying a Go version to use

You can use any tagged version of Go, a version with `x` in place of the minor
or patch level to use the latest for a given major or minor version, or use
`master` to get the latest version from source.

```yaml
language: go

go:
  - 1.x
  - 1.6
  - 1.7.x
  - master
```

All go version management is handled by [gimme](https://github.com/travis-ci/gimme).

For precise versions pre-installed on the VM, please consult "Build system information" in the build log.

## Go Import Path

The project source code will be placed in `GOPATH/src/github.com/user/repo` by default, but if [vanity imports](https://golang.org/cmd/go/#hdr-Remote_import_paths) are necessary (especially for [`internal` package imports](https://golang.org/cmd/go/#hdr-Internal_Directories)), `go_import_path:` may be specified at the top level of the config, e.g.:

```yaml
go_import_path: example.org/pkg/foo
```

## Dependency Management

By default the install step defers to `go get ./...` or `go get -t ./...` if the version of go is greater than or equal
to `1.2`.  If any of the following files are present, the default install step will be simply `true`:

- `GNUMakefile`
- `Makefile`
- `BSDmakefile`
- `makefile`

If you need to perform special tasks before your tests can run, override the `install:` key in your `.travis.yml`:

```yaml
install: make get-deps
```

It is also possible to specify a list of operations, for example, to `go get` remote dependencies:

```yaml
install:
  - go get github.com/bmizerany/assert
  - go get github.com/mrb/hob
```

See [general build configuration guide](/user/customizing-the-build/) to learn more.

### `godep` support

There is support included for [godep](https://github.com/tools/godep) when used with vendored dependencies such that the
`GOPATH` will be prefixed with `${TRAVIS_BUILD_DIR}/Godeps/_workspace` and `PATH` will be prefixed with
`${TRAVIS_BUILD_DIR}/Godeps/_workspace/bin`.  Additionally, if the `Godeps/_workspace/src` directory does not exist,
`godep` will be installed and a `godep restore` will be run.

It is important to note that using the older style `Godeps.json` at the top level is not supported.

All of the `godep` integration steps are performed prior to the separate `go get` and makefile steps listed above.

Note that the `godep` support is only activated if a custom `install` step is not specified.

### Installing Private Dependencies

As `go get` uses HTTPS to clone dependencies from GitHub rather than SSH, it
requires a different workaround from our [recommended way of handling private
dependencies](/user/private-dependencies).

When cloning via HTTPS, git uses curl under the covers, which in turn allows you
to specify a [.netrc](http://manpages.ubuntu.com/manpages/precise/man5/netrc.5.html) file, where you can
store custom authentication credentials for specific domains, github.com for
instance.

Go to your [GitHub account](https://github.com/settings/applications) and create
a personal access token.

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

You can leave out the second step if your .netrc already has access permissions
set only for the owner. That's a requirement for it to be read from curl.

## Default Test Script

Go projects on travis-ci.org assume that either Make or Go build tool are used by default. In case there is a Makefile
in the repository root, the default command Travis CI will use to run your project test suite is

```bash
make
```

In case there is no Makefile, it will be

```bash
go test -v ./...
```

instead.

Projects that find this sufficient can use a very minimalistic .travis.yml file:

```yaml
language: go
```

This can be overridden as described in the [general build configuration](/user/customizing-the-build/) guide. For example,
to omit the `-v` flag, override the `script:` key in `.travis.yml` like this:

```yaml
script: go test ./...
```

The arguments passed to the default `go test` command may be overridden by specifying `gobuild_args:` at the top level
of the config, e.g.:

```yaml
gobuild_args: -x -ldflags "-X main.VersionString v1.2.3"
```

which will result in the script step being:

```bash
go test -x -ldflags "-X main.VersionString v1.2.3" ./...
```

To build by running Scons without arguments, use this:

```yaml
script: scons
```

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

## Examples

- [Go AMQP client](https://github.com/streadway/amqp/blob/master/.travis.yml)
- [mrb/hob](https://github.com/mrb/hob/blob/master/.travis.yml)
- [tsuru/tsuru](https://github.com/tsuru/tsuru/blob/master/.travis.yml)
