---
title: RubyGems Deployment
layout: en
permalink: rubygems/
---

Travis CI can automatically release your Ruby gem to [RubyGems](https://rubygems.org/) after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: rubygems
      api_key: "YOUR API KEY"

However, this is almost certainly not ideal.
Instead, you will most likely want to only release to RubyGems when you relase a new version of your gem.
To do this, add `tags: tags` to the `on` section ofyour `.travis.yml` like so:

    deploy:
      provider: rubygems
      api_key: "YOUR API KEY"
      on:
        - tags: true

You can retrieve your api key by following [these instructions](http://guides.rubygems.org/rubygems-org-api/). It is recommended to encrypt that key.
Assuming you have the Travis CI command line client installed, you can do it like this:

    travis encrypt --add deploy.api_key

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

    $ travis setup rubygems

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

## Pre-releasing

Instead of releasing for each new version of your gem, you can have Travis CI create a [prelease](http://guides.rubygems.org/patterns/#prerelease-gems) for each build.

This gives your gem's users the option to download a newer, possibly more unstable version of your gem.

To enable this, add the following line to your gemspec, underneath your existing `version` line:

    s.version = "#{s.version}-alpha-#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV['TRAVIS']

If your gem's current version is 1.0.0, then Travis CI will create a prerelease with the version 1.0.0-alpha-20, where `20` is the build number.

### Gem to release

By default, we will try to release a gem by the same name as the repository. For example, if you release a gem from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to release the gem named *travis-chat*.

You can explicitly set the name via the **gem** option:

    deploy:
      provider: rubygems
      api_key: ...
      gem: my-gem-123

It is also possible to release different branches to different gems:

    deploy:
      provider: rubygems
      api_key: ...
      gem:
        master: my-gem
        old: my-gem-old

If these gems belong to different RubyGems accounts, you will have to do the same for the API key:

    deploy:
      provider: rubygems
      api_key:
        master: ...
        old: ...
      gem:
        master: my-gem
        old: my-gem-old

### Gemspec to use

If you like, you can specify can alternate option with the `gemspec` option:

    deploy:
        provider: rubygems
        api_key: ...
        gemspec: my-gemspec.gemspec

### Branch to release from

If you have branch specific options, as [shown above](#Gem-to-release), Travis CI will automatically figure out which branches to release from. Otherwise, it will only release from your **master** branch.

You can also explicitly specify the branch to release from with the **on** option:

    deploy:
      provider: rubygems
      api_key: ...
      on:
        branch: production

Alternatively, you can also configure it to release from all branches:

    deploy:
      provider: rubygems
      api_key: ...
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a release.

### Releasing build artifacts

After your tests ran and before the release, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts that are supposed to be released, too. There is now an option to skip the clean up:

    deploy:
      provider: rubygems
      api_key: ...
      skip_cleanup: true

### Conditional releases

it is possible to make releases conditional using the **on** option:

    deploy:
      provider: rubygems
      api_key: ...
      on:
        branch: staging
        rvm: 2.0.0

The above configuration will trigger a release if the staging branch is passing on ruby 2.0.0.

You can also add custom conditions:

    deploy:
      provider: rubygems
      api_key: ...
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
