---
title: Building a Rust Project
layout: en

---

<div id="toc">
</div>

## What this guide covers

This guide covers build environment and configuration topics specific to Rust
projects. Please make sure to read our [Getting started](/user/getting-started/)
and [general build configuration](/user/customizing-the-build/) guides first.

## Supported Rust versions

Travis CI supports all three [release channels][channels] of Rust: stable, beta, and nightly.
Furthermore, you can test against a specific Rust release by using its version number.

[channels]: http://doc.rust-lang.org/book/release-channels.html

Travis CI also installs the appropriate language tools that come with each Rust version.
As of Rust 1.16.0, these include `cargo`, `rustc`, `rustdoc`, `rust-gdb`, `rust-lldb`, and `rustup`.

## Choosing a Rust version

By default, we download and install the latest stable Rust release at the start of the
build. If you're just testing stable, this is all that you need:

```yaml
language: rust
```
{: data-file=".travis.yml"}

The Rust version that is specified in the .travis.yml is available during the
build in the `TRAVIS_RUST_VERSION` environment variable.

You can also test against a particular Rust release:

```yaml
language: rust
rust:
  - 1.0.0
  - 1.1.0
```
{: data-file=".travis.yml"}

The Rust team appreciates testing against the `beta` and `nightly` channels, even if you
are only targeting stable. A full configuration looks like this:

```yaml
language: rust
rust:
  - stable
  - beta
  - nightly
matrix:
  allow_failures:
    - rust: nightly
```
{: data-file=".travis.yml"}

This will test all three channels, but any breakage in nightly will not fail your overall build.

## Default test script

Travis CI uses Cargo to run your build and tests by default. The exact commands
run are:

```bash
$ cargo build --verbose
$ cargo test --verbose
```

If you wish to override this, you can use the `script` setting:

```yaml
language: rust
script: make all
```
{: data-file=".travis.yml"}

For example, if your project is a [workspace](http://doc.crates.io/manifest.html#the-workspace-section),
you should pass `-all` to the build commands to build and test all of the member crates:

```yaml
language: rust
script:
  - cargo build --verbose --all
  - cargo test --verbose --all
```  
{: data-file=".travis.yml"}
