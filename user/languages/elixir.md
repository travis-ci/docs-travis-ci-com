---
title: Building an Elixir Project
layout: en

---

### What This Guide Covers

<aside markdown="block" class="ataglance">

| Elixir            | Default                                   |
|:------------------|:------------------------------------------|
| Typical `install` | `mix local.rebar --force; mix local.hex --force; mix deps.get` |
| Typical `script`  | `mix test`                                |
| Matrix keys       | `env`, `elixir`, `otp_release`            |
| Support           | [Travis CI](mailto:support@travis-ci.com) |

Minimal example:

```yaml
language: elixir
elixir: '1.5.2'
otp_release: '19.0'
```
{: data-file=".travis.yml"}

</aside>

{{ site.data.snippets.trusty_note_no_osx }}

The rest of this guide covers build environment and configuration topics
specific to Elixir projects. Please make sure to read our
[Tutorial](/user/tutorial/) and
[general build configuration](/user/customizing-the-build/) guides first.

Elixir builds are not available on the OS X environment.

## CI Environment for Elixir Projects

To choose the Elixir VM, declare in your `.travis.yml`:

```yaml
language: elixir
```
{: data-file=".travis.yml"}

### Specify which Elixir version to build with

You can specify Elixir version to build with by the `elixir` key.

For example,

```yaml
elixir: '1.5.2'
```

or

```yaml
elixir: '1.5'
```

The former points to the specific release indicated, while
the latter points to the latest development branch build which
has latest patches but may be occasionally be broken.
See [this GitHub issue comment](https://github.com/elixir-lang/elixir/issues/6618#issuecomment-333374372)
for more details.

### Specifying OTP Release version

Note that Elixir has requirements regarding the underlying
Erlang OTP Release version.

If the specified OTP Release version (implicity or explicitly)
does not meet this requirement, Travis CI will choose one
for you.

You can also override this OTP Release choice by adding the `otp_release`.
For example:

```yaml
language: elixir
elixir:
  - '1.2.2'
otp_release:
  - '18.2.1'
```
{: data-file=".travis.yml"}

To test multiple Elixir versions with different OTP release versions:

```yaml
language: elixir

elixir:
  - '1.0.5'
otp_release: '17.4'

matrix:
  include:
    - elixir: '1.2'
      otp_release: '18.0'
```
{: data-file=".travis.yml"}


## Build Matrix

For elixir projects, `env`, `elixir` and `otp_release` can be given as arrays
to construct a build matrix.

## Default commands

By default, the install command is

```bash
mix local.rebar --force # for Elixir 1.3.0 and up
mix local.hex --force
mix deps.get
```

and the script command is

```bash
mix test
```

## Environment Variables

The version of Elixir a job is using is available as:

```
TRAVIS_ELIXIR_VERSION
```

As with the Erlang VM, the version of OTP release a job is using is available as:

```
TRAVIS_OTP_RELEASE
```
