---
title: Cargo Releases
layout: en
deploy: v2
provider: cargo
---

Travis CI can automatically release your Rust crate to [crates.io](https://crates.io)
after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
language: rust
deploy:
  provider: cargo
  token: <token>
```
{: data-file=".travis.yml"}

The API token can be obtained by logging in to your [crates.io](https://crates.io)
account, and generating a new token at <https://crates.io/me>.

{% include deploy/providers/cargo.md %}

{% include deploy/shared.md %}
