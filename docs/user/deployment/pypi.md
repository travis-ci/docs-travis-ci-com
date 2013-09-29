---
title: PyPI deployment
layout: en
permalink: pypi/
---

Travis CI can automatically release your Python package to [PyPI](https://pypi.python.org/) after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: pypi
      user: "Your username"
      password: "Your password"


However, this is almost certainly not ideal.
Instead, you will most likely want to only release to PyPI when you release a new version of your package.
To do this, add `tags: tags` to the `on` section of your `.travis.yml` like so:

    deploy:
      provider: pypi
      user: ...
      password: ...
      on:
        - tags: true

Assuming you have the Travis CI command line client installed, you can encrypt your password like this:

    travis encrypt --add deploy.password

You will be prompted to enter your password on the command line.

You can also have the `travis` tool set up everything for you:

    $ travis setup pypi

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to release from

You can explicitly specify the branch to release from with the **on** option:

    deploy:
      provider: pypi
      user: ...
      password: ...
      on:
        branch: production

Alternatively, you can also configure Travis CI to release from all branches:

    deploy:
      provider: pypi
      api_key: ...
      on:
        all_branches: true

By default, Travis CI will only release from the **master** branch.

Builds triggered from Pull Requests will never trigger a release.

### Releasing build artifacts

After your tests ran and before the release, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts that are supposed to be released, too. There is now an option to skip the clean up:

    deploy:
      provider: pypi
      user: ...
      password: ...
      skip_cleanup: true

### Conditional releases

it is possible to make releases conditional using the **on** option:

    deploy:
      provider: pypi
      user: ...
      password: ...
      on:
        branch: staging
        python: 2.7

The above configuration will trigger a release if the staging branch is passing on Python 2.7.

You can also add custom conditions:

    deploy:
      provider: pypi
      user: ...
      password: ...
      on:
        condition: "$cc = gcc"

available conditions are:

* **all_branches** - when set to true, trigger release from any branch if passing
* **branch** - branch or list of branches to release from if passing
* **condition** - custom condition or list of custom conditions
* **jdk** - jdk version to release from if passing
* **node** - nodejs version to release from if passing
* **perl** - perl version to release from if passing
* **php** - php version to release from if passing
* **python** - python version to release from if passing
* **ruby** - ruby version to release from if passing
* **repo** - only trigger a build for the given repository, to play nice with forks

### Running commands before and after release

Sometimes you want to run commands before or after releasing a package. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

    before_deploy: "echo 'ready?'"
    deploy:
      ..
    after_deploy:
      - ./after_deploy_1.sh
      - ./after_deploy_2.sh
