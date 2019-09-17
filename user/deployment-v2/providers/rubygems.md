---
title: RubyGems Deployment
layout: en
deploy: v2
provider: rubygems
---

Travis CI can automatically release your Ruby gem to [RubyGems](https://rubygems.org/) after a successful build.

{% include deploy/providers/rubygems.md %}

You can retrieve your api key by following [these instructions](http://guides.rubygems.org/rubygems-org-api).

## Pre-releasing

Instead of releasing for each new version of your gem, you can create a
[prerelease](http://guides.rubygems.org/patterns#prerelease-gems) for each
build.

This gives your gem's users the option to download a newer, possibly more
unstable version of your gem. To enable this, add the following line to your
gemspec, underneath your existing `version` line:

```
s.version = "#{s.version}-alpha-#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV['TRAVIS']
```

If your gem's current version is `1.0.0`, the prerelease version will be
1.0.0-alpha-20, where `20` is the build number.

### Specifying the gem name

By default, we will try to release a gem by the same name as the repository name.

You can explicitly set the name via the `gem` option:

```yaml
deploy:
  provider: rubygems
  # ⋮
  gem: <name>
```
{: data-file=".travis.yml"}

In order to release gems based on the current branch use separate deploy
configurations:

```yaml
deploy:
  - provider: rubygems
    # ⋮
    gem: <name-1>
    on:
      branch: master
  - provider: rubygems
    # ⋮
    gem: <name-2>
    on:
      branch: staging
```
{: data-file=".travis.yml"}

Or using YAML references:

```yaml
deploy:
  - &deploy
    provider: rubygems
    # ⋮
    gem: <name-1>
    on:
      branch: master
  - <<: *deploy
    gem: <name-2>
    on:
      branch: staging
```
{: data-file=".travis.yml"}

### Specifying the gemspec

You can specify the gemspec with the `gemspec` option:

```yaml
deploy:
  provider: rubygems
  # ⋮
  gemspec: <gemspec>
```
{: data-file=".travis.yml"}

{% include deploy/shared.md tags=true %}

