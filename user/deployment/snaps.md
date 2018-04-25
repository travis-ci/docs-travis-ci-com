---
title: Snap Store
layout: en
permalink: /user/deployment/snaps/
---

Travis CI can automatically upload and release your built snap to the [snap store](https://snapcraft.io) after a successful build.

Snaps are a new packaging and delivery system for Ubuntu, Debian, Fedora, openSuse and other [Linux distros](https://snapcraft.io/docs/core/install). Snaps are secure, they bundle all their dependencies and they are designed to be part of the upstream development workflow in a seamless way. This means that no distro maintainers are involved, and that the delivery to the store can be fully automated. The snaps installed in the users' machines are auto-updated, so a few hours after you push a new snap to the store, all your users will get the most recent version.

All it takes is the following in your `.travis.yml`:

```yaml
deploy:
  provider: snap
  snap: my.snap
  channel: edge
```
{: data-file=".travis.yml"}

In order for Travis CI to have permission to upload and release the snap on your behalf, you need to export a login token by installing Snapraft:

```bash
sudo snap install snapcraft --classic
```

Now export a login covering the ability to push this specific snap, as well as release to the channel you selected (in this example, `edge`):

```bash
snap export-login --snaps my-snap-name --channels edge -
```

(note the final `-`, which requests the login be exported to stdout instead of a file.) Copy the token, and put it into the `$SNAP_TOKEN` environment variable in Travis CI:

```bash
travis env set SNAP_TOKEN "<token>"
```

If you use a different environment variable, you'll need to specify the `token` option for the provider:

```yaml
deploy:
  provider: snap
  snap: my.snap
  channel: edge
  token: $MY_SNAP_TOKEN
```
{: data-file=".travis.yml"}

This example is almost certainly not ideal, as you probably want to upload a snap built during CI. Set `skip_cleanup` to `true` to prevent Travis CI from deleting it before the `deploy` step.

```yaml
deploy:
  provider: snap
  snap: my.snap
  channel: edge
  skip_cleanup: true
```
{: data-file=".travis.yml"}

Note that the `edge` channel is intended for crowdtesting with your community of early adopters. With this deployment setup in Travis, every time a pull request lands, a new snap will be published to edge. Your testers can install it in any of the supported Linux distros with:

```bash
sudo snap install my-snap-name --edge
```

After that, they will be always ready to provide early feedback and help making a more stable release.

There are plenty of [tutorials](https://tutorials.ubuntu.com/) and [videos](https://www.youtube.com/snapcraftio) that will help you packaging your project as a snap.
