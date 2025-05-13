---
title: Cargo Releases
layout: en
deploy: v2
provider: cargo
---

Travis CI can automatically release your Rust crate to [crates.io](https://crates.io)
after a successful build.

{% capture content %}
  The API token can be obtained by logging in to your [crates.io](https://crates.io)
  account, and generating a new token at <https://crates.io/me>.
{% endcapture %}

{% include deploy/providers/cargo.md content=content %}
{% include deploy/shared.md tags=true %}
