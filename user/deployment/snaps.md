---
title: Snap Store
layout: en
permalink: /user/deployment/snaps/
---

Travis CI can automatically upload and release your app to the [Snap Store](https://snapcraft.io) after a successful build.

[Snapcraft](https://snapcraft.io/) lets you distribute to all Ubuntu releases and a [growing set of Linux distributions](https://docs.snapcraft.io/core/install) with a single artefact. You publish and update at your pace while still reaching everyone; you're not locked to the release cycle of Ubuntu or any other distribution. The updates apply automatically and roll back if anything goes wrong. They're secure; each update is cryptographically signed and is tamper-proof once installed. The applications are locked down using the same container primitives found in Docker and LXD.

To upload your snap, add the following to your `.travis.yml`:

```yaml
dist: xenial

deploy:
  provider: snap
  snap: my_*.snap
  channel: edge
  skip_cleanup: true
```
{: data-file=".travis.yml"}

The `snap` value should be a string that matches exactly one file when the deployment starts.
If the name of the snap file is not known ahead of time, you can use a shell glob pattern, as shown
in the example above.

## Providing credentials to upload the snap

To upload snaps from Travis CI, export a Snap Store login token. You can do this with the snapcraft command-line tool, once you have [enabled snap support](https://docs.snapcraft.io/core/install) on your system.

```bash
sudo snap install snapcraft --classic
```

Login tokens can specify how, when, and where they can be used, thus minimising damage from compromise. For Travis CI, export a token that can only upload this snap to the channel you specified above (in this example, `edge`):

```bash
snapcraft export-login --snaps my-snap-name --channels edge -
```

_Note: The final `-` requests the login be exported to stdout instead of a file. It is required._

The token will be printed out. Copy and put it into the Travis CI environment variable `$SNAP_TOKEN`.

You can do this with our [CLI client](https://github.com/travis-ci/travis.rb#readme)

```bash
# in the repository root
travis env set SNAP_TOKEN "<token>"
```

or on the [Settings page](https://docs.travis-ci.com/user/environment-variables#defining-variables-in-repository-settings).

_Note: The `edge` channel is intended for the bleeding edge: your every commit to master will be built and uploaded._

Your community of early-adopters and testers can install your app in any of the [supported Linux distributions](https://docs.snapcraft.io/core/install) with:

```bash
sudo snap install my-snap-name --edge
```

Each upload gets a monotonically increasing integer. When you're ready, you can release one of these built commits to the stable channel for public discovery in the [Snap storefront](https://snapcraft.io/store). For example, you could promote the very first upload to stable:

```bash
snapcraft release my-snap-name 1 stable
```
