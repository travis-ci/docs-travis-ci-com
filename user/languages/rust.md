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
and [general build configuration](/user/customizing-the-build/) guides first.

### Supported Rust versions

Travis supports all three [release channels][channels] of Rust: stable, beta, and nightly.
Furthermore, you can test against a specific Rust release by using its version number.

[channels]: http://doc.rust-lang.org/book/release-channels.html

Travis also installs the appropriate Cargo version that comes with each Rust version.

### Choosing the Rust version

By default, we download and install the latest stable Rust release at the start of the
build. If you're just testing stable, this is all that you need:

```yaml
language: rust
```

The Rust version that is specified in the .travis.yml is available during the
build in the `TRAVIS_RUST_VERSION` environment variable.

You can also test against a particular Rust release:

```yaml
language: rust
rust:
  - 1.0.0
  - 1.1.0
```

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

This will test all three channels, but any breakage in nightly will not fail your overall build.

## Default test script

Travis CI uses Cargo to run your build and tests by default. The exact commands
run are:

    $ cargo build --verbose
    $ cargo test --verbose

If you wish to override this, you can use the `script` setting:

    language: rust
    script: make all

