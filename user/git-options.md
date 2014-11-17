---
title: Specifying Git options
layout: en
permalink: git-options/
---

Travis CI allows to specify a few git options in the `.travis.yml` file:

* git depth - to make cloning a repository faster we specify a git clone depth, which defaults to 50. You can learn more about the depth option in [git clone docs](http://git-scm.com/docs/git-clone). To change the default you can specify a `git` hash with a `depth` property set to a desired number. We don't support disabling the depth option at the moment, so if you need to clone the entire history, you can set the depth to a large value, like `999999`:

  ```
git:
  depth: 100
  ```
* disabling submodules - by default Travis CI will fetch submodules for a cloned repository. To disable it you can set a `submodules` property to `false`:

  ```
git:
  submodules: false
  ```

* git strategy - by default we clone a repository using a `git clone` command. Depending on the size of repository and a specific use case it may be beneficial to fetch a repository as a tarball. You can achieve it by setting a `strategy` option in a `git` hash:

  ```
git:
  strategy: 'tarball'
  ```

  a few things to note:

  * repository fetched as a tarball will lack the `.git` directory, which means that it's a shallow clone and no git operations can be performed
  * submodules are not supported with the tarball strategy
