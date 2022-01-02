---
title: Snap Store
layout: en
deploy: v2
provider: snap
---

Travis CI can automatically upload and release your app to the [Snap Store](https://snapcraft.io) after a successful build.

[Snapcraft](https://snapcraft.io/) lets you distribute to all Ubuntu releases
and a [growing set of Linux distributions](https://docs.snapcraft.io/core/install)
with a single artefact.

{% capture content %}
  The `snap` value should be a string that matches exactly one file when the
  deployment starts. If the name of the snap file is not known ahead of time,
  you can use a shell glob pattern, e.g. `*.snap`.
{% endcapture %}

{% include deploy/providers/snap.md content=content %}

## Obtaining credentials

If you have not done so already, [enable snap support](https://docs.snapcraft.io/core/install) on your system.

```bash
sudo snap install snapcraft --classic
```

Login tokens can specify how, when, and where they can be used, thus minimising
damage from compromise.

Export a token that can only upload this snap to the channel you are going to
upload to (in this example, `edge`):

```bash
snapcraft export-login --snaps my-snap-name --channels edge -
```

The token will be printed out.

> Note: The final `-` requests the login be exported to stdout instead of a file. It is required.

> Note: The `edge` channel is intended for the bleeding edge: your every commit to master will be built and uploaded.

## Using uploaded Snaps

Your community of early-adopters and testers can install your app in any of the
[supported Linux distributions](https://docs.snapcraft.io/core/install) with:

```bash
sudo snap install my-snap-name --edge
```

Each upload gets a monotonically increasing integer. When you're ready, you can
release one of these built commits to the stable channel for public discovery
in the [Snap storefront](https://snapcraft.io/store). For example, you could
promote the very first upload to stable:

```bash
snapcraft release my-snap-name 1 stable
```

{% include deploy/shared.md %}
