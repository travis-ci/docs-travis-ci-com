---
title: RubyGems Deployment
layout: en

---

Travis CI can automatically release your Ruby gem to [RubyGems](https://rubygems.org/) after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```yaml
deploy:
  provider: rubygems
  api_key: "YOUR API KEY"
```
{: data-file=".travis.yml"}

Most likely you would only want to deploy to RubyGems when a new version of
your package is cut. To do this, you can tell Travis CI to only deploy on
tagged commits, like so:

```yaml
deploy:
  provider: rubygems
  api_key: "YOUR API KEY"
  on:
    tags: true
```
{: data-file=".travis.yml"}

If you tag a commit locally, remember to run `git push --tags` to ensure that your tags are uploaded to GitHub.

You can retrieve your api key by following [these instructions](http://guides.rubygems.org/rubygems-org-api). It is recommended to encrypt that key.
Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
travis encrypt --add deploy.api_key
```

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

```bash
travis setup rubygems
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

## Pre-releasing

Instead of releasing for each new version of your gem, you can have Travis CI create a [prerelease](http://guides.rubygems.org/patterns#prerelease-gems) for each build.

This gives your gem's users the option to download a newer, possibly more unstable version of your gem.

To enable this, add the following line to your gemspec, underneath your existing `version` line:

```
s.version = "#{s.version}-alpha-#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV['TRAVIS']
```

If your gem's current version is 1.0.0, then Travis CI will create a prerelease with the version 1.0.0-alpha-20, where `20` is the build number.

### Gem to release

By default, we will try to release a gem by the same name as the repository. For example, if you release a gem from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to release the gem named *travis-chat*.

You can explicitly set the name via the **gem** option:

```yaml
deploy:
  provider: rubygems
  api_key: ...
  gem: my-gem-123
```
{: data-file=".travis.yml"}

It is also possible to release different branches to different gems:

```yaml
deploy:
  provider: rubygems
  api_key: ...
  gem:
    master: my-gem
    old: my-gem-old
```
{: data-file=".travis.yml"}

If these gems belong to different RubyGems accounts, you will have to do the same for the API key:

```yaml
deploy:
  provider: rubygems
  api_key:
    master: ...
    old: ...
  gem:
    master: my-gem
    old: my-gem-old
```
{: data-file=".travis.yml"}

### Gemspec to use

If you like, you can specify can alternate option with the `gemspec` option:

```yaml
deploy:
    provider: rubygems
    api_key: ...
    gemspec: my-gemspec.gemspec
```
{: data-file=".travis.yml"}

### Branch to release from

If you have branch specific options, as [shown above](#gem-to-release), Travis CI will automatically figure out which branches to release from. Otherwise, it will only release from your **master** branch.

You can also explicitly specify the branch to release from with the **on** option:

```yaml
deploy:
  provider: rubygems
  api_key: ...
  on:
    branch: production
```
{: data-file=".travis.yml"}

Alternatively, you can also configure it to release from all branches:

```yaml
deploy:
  provider: rubygems
  api_key: ...
  on:
    all_branches: true
```
{: data-file=".travis.yml"}

Builds triggered from Pull Requests will never trigger a release.

### Releasing build artifacts

After your tests ran and before the release, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts that are supposed to be released, too. There is now an option to skip the clean up:

```yaml
deploy:
  provider: rubygems
  api_key: ...
  skip_cleanup: true
```
{: data-file=".travis.yml"}

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#conditional-releases-with-on).

### Gem must be registered beforehand

Note that the gem you upload must be registered beforehand.
If the gem does not exist on the host to which it is uploaded, deployment will fail.
See [this GitHub issue](https://github.com/travis-ci/dpl/issues/574) for details.

### Running commands before and after release

Sometimes you want to run commands before or after releasing a gem. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}
