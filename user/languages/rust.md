---
title: Building a Rust Project
layout: en
permalink: /user/languages/rust/
---
<div id="toc">
</div>

### What this guide covers

This guide covers build environment and configuration topics specific to Rust
projects. Please make sure to read our [Getting started](/user/getting-started/)
and [general build configuration](/user/build-configuration/) guides first.

### Supported Rust versions

We currently download the requested version of Rust (by default the latest
nightly), and as a result we support any released version of Rust as well as the
latest nightly and beta.

We also download and install the latest version of [Cargo](http://crates.io)

### Choosing the Rust version to test against

By default, we download and install the latest Rust nightly at the start of the
build, but you can also select a Rust version to test against with the `rust`
setting:


    language: rust
    rust: beta

The chosen version is passed to the official `rustup.sh` script as the value of the
`--spec` option - and therefor supports any channel name (such as beta and nightly) in
addition to other selection criteria supported by `rustup.sh`.

The Rust version that is specified in the .travis.yml is available during the
build in the `TRAVIS_RUST_VERSION` environment variable.

## Default test script

Travis CI uses Cargo to run your build and tests by default. The exact commands
run are:

    $ cargo build --verbose
    $ cargo test --verbose

If you wish to override this, you can use the `script` setting:

    language: rust
    script: make all

