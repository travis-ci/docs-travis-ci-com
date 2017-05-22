---
title: Customizing the Build
layout: en
permalink: /user/customizing-the-build/
redirect_from:
  - /user/build-configuration/
  - /user/build-lifecycle/
  - /user/how-to-skip-a-build/
  - /user/repository-providers/
---

<div id="toc"></div>




## Limiting Concurrent Builds

The maximum number of concurrent builds depends on the total system load, but
one situation in which you might want to set a particular limit is:

- if your build depends on an external resource and might run into a race
  condition with concurrent builds.

You can set the maximum number of concurrent builds in the settings pane for
each repository.

![Settings -> Limit concurrent builds](/images/screenshots/concurrent-builds-how-to.png)

Or using the command line client:

```bash
$ travis settings maximum_number_of_builds --set 1
```

## Building only the latest commit

> BETA Build auto-cancellation. Please give us feedback on this new feature on [GitHub](https://github.com/travis-ci/beta-features/issues/8)
{: .beta}

If you are only interested in building the most recent commit on each branch you can use this new feature to automatically cancel older builds in the queue that are *not yet running*.

The *Auto Cancellation Setting* is in the Settings tab of each repository, and you can enable it separately for:

* *pushes* - which build your branch and appear in the *Build History* tab of your repository.

* *pull requests* - which build the future merge result of your feature branch against its target and appear in the *Pull Requests* tab of your repository.

![Auto cancellation setting](/images/autocancellation.png "Auto cancellation setting")

For example, in the following screenshot, we pushed commit `ca31c2b` to the branch `MdA-fix-notice` while builds #226 and #227 were queued. With the auto cancellation feature on, the builds #226 and #227 were automatically cancelled:  

![Auto cancellation example](/images/autocancellation-example.png "Auto cancellation example")


## Git Clone Depth

Travis CI clones repositories to a depth of 50 commits, which is only really useful if you are performing git operations.

> Please note that if you use a depth of 1 and have a queue of jobs, Travis CI won't build commits that are in the queue when you push a new commit.

You can set the depth in `.travis.yml`:

```yml
git:
  depth: 3
```

## Git LFS Skip Smudge

You can disable the download of LFS objects when cloning ([`git lfs smudge
--skip`](https://github.com/git-lfs/git-lfs/blob/master/docs/man/git-lfs-smudge.1.ronn))
by setting the following in `.travis.yml`:

``` yml
git:
  lfs_skip_smudge: true
```



## Skipping a build

If you don't want to run a build for a particular commit for any reason, add `[ci skip]` or `[skip ci]` to the git commit message.

Commits that have `[ci skip]` or `[skip ci]` anywhere in the commit messages are ignored by Travis CI.


## Custom Hostnames

If your build requires setting up custom hostnames, you can specify a single host or a
list of them in your .travis.yml. Travis CI will automatically setup the
hostnames in `/etc/hosts` for both IPv4 and IPv6.

```yaml
addons:
  hosts:
  - travis.dev
  - joshkalderimis.com
```

## What repository providers or version control systems can I use?

Build and test your open source projects hosted on GitHub on [travis-ci.org](https://travis-ci.org/).

Build and test your private repositories hosted on GitHub on [travis-ci.com](https://travis-ci.com/).

Travis CI currently does not support git repositories hosted on Bitbucket or GitLab, or other version control systems such as Mercurial.

## Troubleshooting

Check out the list of [common build problems](/user/common-build-problems/).
