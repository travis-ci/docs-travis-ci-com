---
title: Building a Rust Project
layout: en

---

### What This Guide Covers

<aside markdown="block" class="ataglance">

| Rust                                        | Default                                       |
|:--------------------------------------------|:----------------------------------------------|
| [Default `install`](#dependency-management) | `cargo build --verbose`                       |
| [Default `script`](#default-build-script)   | `cargo build --verbose; cargo test --verbose` |
| [Matrix keys](#build-matrix)                | `rust`, `env`                                 |
| Support                                     | [Travis CI](mailto:support@travis-ci.com)     |

Minimal example:

```yaml
language: rust
```
{: data-file=".travis.yml"}

</aside>

{{ site.data.snippets.all_note }}

The rest of this guide covers configuring Rust projects in Travis CI. If you're
new to Travis CI please read our [Tutorial](/user/tutorial/) and
[build configuration](/user/customizing-the-build/) guides first.

## Choosing a Rust version

By default, we download and install the latest stable Rust release at the start
of the build (thanks to `rustup`). The [`minimal` profile][profiles] is used
and includes the following language tools `cargo`, `rustc`, and `rustup`.

[profiles]: https://blog.rust-lang.org/2019/10/15/Rustup-1.20.0.html#profiles

If you want additional language tools like `rustfmt` or `clippy`, please
install them in `before_install`.

To test against specific Rust releases:

```yaml
language: rust
rust:
  - 1.0.0
  - 1.1.0
```
{: data-file=".travis.yml"}

Travis CI also supports all three Rust [release channels][channels]: `stable`,
`beta`, and `nightly`.

[channels]: https://doc.rust-lang.org/book/appendix-07-nightly-rust.html#choo-choo-release-channels-and-riding-the-trains

The Rust team appreciates testing against the `beta` and `nightly` channels,
even if you are only targeting `stable`. A full configuration looks like this:

```yaml
language: rust
rust:
  - stable
  - beta
  - nightly
jobs:
  allow_failures:
    - rust: nightly
  fast_finish: true
```
{: data-file=".travis.yml"}

This will runs your tests against all three channels, but any breakage in
`nightly` will not fail the rest of build.

## Dependency Management

Travis CI uses Cargo to install your dependencies:

```bash
cargo build --verbose
```

You can cache your dependencies so they are only recompiled if they or the
compiler were upgraded:

```yaml
cache: cargo
```
{: data-file=".travis.yml"}

This adds the following directories to the cache:

- `$TRAVIS_HOME/.cache/sccache`
- `$TRAVIS_HOME/.cargo/`
- `$TRAVIS_HOME/.rustup/`
- `target`

In addition, it adds the following command to the `before_cache`
phase of the job in order to reduce cache size:

    rm -rf "$TRAVIS_HOME/.cargo/registry/src"

This means that, if you override the `before_cache` step for another reason, you should add the step above in order to reduce the cache size:

```yaml
before_cache:
  - rm -rf "$TRAVIS_HOME/.cargo/registry/src"
  ⋮ # rest of your existing "before_cache"
```

## Default Build Script

Travis CI uses Cargo to run your build, the default commands are:

```bash
cargo test --verbose
```

You can always configure different comands if you need to. For example,
if your project is a
[workspace](http://doc.crates.io/manifest.html#the-workspace-section), you
should pass `--all` to the build commands to build and test all of the member
crates:

```yaml
language: rust
script:
  - cargo build --verbose --all
  - cargo test --verbose --all
```
{: data-file=".travis.yml"}

## Environment variables

The Rust version that is specified in the `.travis.yml` is available during the
build in the `TRAVIS_RUST_VERSION` environment variable.
