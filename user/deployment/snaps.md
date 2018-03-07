---
title: Ubuntu Snap Store
layout: en
permalink: /user/deployment/snaps/
---

Travis CI can automate the continuous delivery to the [Snaps](https://snapcraft.io) Store.

Snaps are a new packaging and delivery system for Ubuntu, Debian, Fedora, openSuse and other [Linux distros](https://snapcraft.io/docs/core/install). Snaps are secure, they bundle all their dependencies and they are designed to be part of the upstream development workflow in a seamless way. This means that no distro maintainers are involved, and that the delivery to the store can be fully automated. The snaps installed in the users' machines are auto-updated, so a few hours after you push a new snap to the store, all your users will get the most recent version.

To automate continuous delivery of snaps to the Ubuntu store:

1. [Encrypt](https://docs.travis-ci.com/user/encrypting-files) your snapcraft credentials with Travis CI
2. Add the encrypted credentials to the repository where you have the `snapcraft.yaml` metadata for your package.
3.  Run `snapcraft` and `snapcraft push` in your `.travis.yml`:

    ```yaml
    deploy:
      skip_cleanup: true
      provider: script
      script: docker run -v $(pwd):$(pwd) -w $(pwd) snapcore/snapcraft sh -c "apt update && snapcraft && snapcraft push *.snap --release edge"
      on:
        branch: master
    ```

The `snapcraft enable-ci travis` command will assist you getting the credential, encrypting it and adding the right script to the deploy section of your `.travis.yml` file. Here is a [tutorial that will guide you setting up the continuous delivery from Travis CI](https://tutorials.ubuntu.com/tutorial/continuous-snap-delivery-from-travis-ci#0) on your project.

Note that the `edge` channel is intended for crowdtesting with your community of early adopters. With this deployment script in Travis, every time a pull request lands into the master branch, a new snap will be published to edge. Your testers can install it in any of the supported Linux distros with:

```bash
sudo snap install my-snap-name --edge
```

After that, they will be always ready to provide early feedback and help making a more stable release.

You can adjust the Travis script and the `snapcraft` calls to fit your development process. For example, you could install the snap and run user acceptance tests before releasing to edge, to make sure that there are no regressions in master. Also, there are three other channels in the store: `beta`, `candidate` and `stable`. You can run different tests suites with Travis for each channel on your way to stable.

There are plenty of [tutorials](https://tutorials.ubuntu.com/) and [videos](https://www.youtube.com/snapcraftio) that will help you packaging your project as a snap.
