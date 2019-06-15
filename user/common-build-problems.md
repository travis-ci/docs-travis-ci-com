---
title: Common Build Problems
layout: en

redirect_from:
  - /user/build-timeouts/
---




## My tests broke but were working yesterday

A very common cause when a test is suddenly breaking without any major code
changes involved is a change in upstream dependencies.

This can be a Ubuntu package or any of your project's language dependencies,
like RubyGems, NPM packages, Pip, Composer, etc.

To find out if this is the case, restart a build that used to be green, the last
known working one, for instance. If that build suddenly fails too, there's a
good chance, that a dependency was updated and is causing the breakage.

Make sure to check the list of dependencies in the build log, usually output
including versions, and see if there's anything that's changed.

Sometimes, this can also be caused by an indirect dependency that was updated.

After figuring out which dependency was updated, lock it to the last known
version.

Additionally, we update our build environment regularly, which brings in newer
versions of languages and the running services.

## My build script is killed without any error

Sometimes, you'll see a build script being causing an error, and the message in
the log will be something like `Killed`.

This is usually caused by the script or one of the programs it runs exhausting
the memory available in the build sandbox, which is currently 3GB. Plus, there
are two cores available, bursted.

Depending on the tool in use, this can be cause by a few things:

- Ruby test suite consuming too much memory
- Tests running in parallel using too many processes or threads (e.g. using the
  `parallel_test` gem)
- g++ needing too much memory to compile files, for instance with a lot of
  templates included.

For parallel processes running at the same time, try to reduce the number. More
than two to four processes should be fine, beyond that, resources are likely to
be exhausted.

With Ruby processes, check the memory consumption on your local machine, it's
likely to show similar causes. It can be caused by memory leaks or by custom
settings for the garbage collector, for instance to delay a sweep for as long as
possible. Dialing these numbers down should help.

## My build fails unexpectedly

One possible cause for builds failing unexpectedly can be calling `set -e` (also known as `set errexit`), either *directly in* your `.travis.yml`, or `source`ing a script which does. This causes any error causing a non-zero return status in your script to stop and fail the build immediately.

Note that using `set -e` in external scripts does not cause this problem, as the `errexit` is effective only in the external script.

See also [Complex Build Steps](/user/customizing-the-build/#implementing-complex-build-steps).

## Segmentation faults from the language interpreter (Ruby, Python, PHP, Node.js, etc.)

If your build is failing due to unexpected segmentation faults in the language interpreter, this may be caused by corrupt or invalid caches of your extension codes (gems, modules, etc). This can happen with any interpreted language, such as Ruby, Python, PHP, Node.js, etc.

Fix the problem by clearing the cache or removing the cache key from your .travis.yml (you can add it back in a subsequent commit).

## Ruby: RSpec returns 0 even though the build failed

In some scenarios, when running `rake rspec` or even rspec directly, the command
returns 0 even though the build failed. This is commonly due to some RubyGem
overwriting the `at_exit` handler of another RubyGem, in this case RSpec's.

The workaround is to install this `at_exit` handler in your code, as pointed out
in [this article](http://www.davekonopka.com/2013/rspec-exit-code.html).

```ruby
if defined?(RUBY_ENGINE) && RUBY_ENGINE == "ruby" && RUBY_VERSION >= "1.9"
  module Kernel
    alias :__at_exit :at_exit
    def at_exit(&block)
      __at_exit do
        exit_status = $!.status if $!.is_a?(SystemExit)
        block.call
        exit exit_status if exit_status
      end
    end
  end
end
```

If your project is using the [Code Climate integration](/user/code-climate/) or
Simplecov, this issue can also come up with the 0.8 branch of Simplecov. The fix
is downgrade to the last 0.7 release until the issue is fixed.

## Capybara: I'm getting errors about elements not being found

In scenarios that involve JavaScript, you can occasionally see errors that
indicate that an element is missing, a button, a link, or some other resource
that is updated or created by asynchronous JavaScript.

This can indicate that the timeouts used for Selenium or one of its drivers are
set too low.

Capybara has a timeout setting which you can increase to a minimum of 15
seconds:

```js
Capybara.default_max_wait_time = 15
```

Poltergeist has its own setting for timeouts:

```js
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 15)
end
```

If you're still seeing timeouts after increasing it initially, set it to
something much higher for one test run. Should the error still persist, there's
possibly a deeper issue on the page, for instance compiling the assets.

## Ruby: Installing the debugger_ruby-core-source library fails

This Ruby library unfortunately has a history of breaking with even patchlevel
releases of Ruby. It's commonly a dependency of libraries like linecache or
other Ruby debugging libraries.

We recommend moving these libraries to a separate group in your Gemfile and then
to install RubyGems on Travis CI without this group. As these libraries are only
useful for local development, you'll even gain a speedup during the installation
process of your build.

```ruby
# Gemfile
group :debug do
  gem 'debugger'
  gem 'debugger-linecache'
  gem 'rblineprof'
end

# .travis.yml
bundler_args: --without development debug
```

## Ruby: tests frozen and cancelled after 10 minute log silence

In some cases, the use of the `timecop` gem can result in seemingly sporadic
"freezing" due to issues with ordering calls of `Timecop.return`,
`Timecop.freeze`, and `Timecop.travel`.  For example, if using RSpec, be sure to
have a `Timecop.return` configured to run *after* all examples:

```ruby
# in, e.g. spec/spec_helper.rb
RSpec.configure do |c|
  c.after :all do
    Timecop.return
  end
end
```

## Mac: macOS Mavericks (10.9) Code Signing Errors

With Mavericks, quite a lot has changed in terms of code signing and the keychain application.

Signs of issues can be errors messages stating that an identity can't be found and that "User
interaction is not allowed."

The keychain must be marked as the default keychain, must be unlocked explicitly and the build needs to make sure that the keychain isn't locked before the critical point in the build is reached. The following set of commands takes care
of this:

```
KEY_CHAIN=ios-build.keychain
security create-keychain -p travis $KEY_CHAIN
# Make the keychain the default so identities are found
security default-keychain -s $KEY_CHAIN
# Unlock the keychain
security unlock-keychain -p travis $KEY_CHAIN
# Set keychain locking timeout to 3600 seconds
security set-keychain-settings -t 3600 -u $KEY_CHAIN
```

## Mac: macOS Sierra (10.12) Code Signing Errors

With the introduction of macOS Sierra (10.12) on our infrastructure, we've seen build jobs that were hanging at the codesigning step of the build process. Here's some information on how to recognize this issue and fix it.

Your build is running on macOS Sierra (10.12) if the `osx_image` in your .travis.yml file is `xcode8.3` or higher. See [the macOS Build Environment documentation](https://docs.travis-ci.com/user/reference/osx/) to know which macOS version is associated with each image.

The following lines in your build log possibly indicate an occurrence of this issue:

**Example: Signing**

```
▸ Signing /Users/travis/Library/Developer/Xcode/DerivedData/PresenterKit-ggzwtlifkopsnbffbqrmtydtmafv/Build/Intermediates/CodeCoverage/Products/Debug-iphonesimulator/project.xctest

No output has been received in the last 10m0s, this potentially indicates a stalled build or something wrong with the build itself.
Check the details on how to adjust your build configuration on: https://docs.travis-ci.com/user/common-build-problems/#build-times-out-because-no-output-was-received

The build has been terminated
```

**Example: Embed Pods Frameworks**

```
▸ Running script '[CP] Embed Pods Frameworks'

No output has been received in the last 10m0s, this potentially indicates a stalled build or something wrong with the build itself.
Check the details on how to adjust your build configuration on: https://docs.travis-ci.com/user/common-build-problems/#build-times-out-because-no-output-was-received

The build has been terminated
```

To fix this issue, you will need to add the following command **after** you have imported your certificate:

```
security set-key-partition-list -S apple-tool:,apple: -s -k keychainPass keychainName
```

Where:

- `keychainPass` is the password of your keychain
- `keychainName` is the name of your keychain

Here's an example of where to put the command in context:

```bash
# Create the keychain with a password
security create-keychain -p travis ios-build.keychain

# Make the custom keychain default, so xcodebuild will use it for signing
security default-keychain -s ios-build.keychain

# Unlock the keychain
security unlock-keychain -p travis ios-build.keychain

# Add certificates to keychain and allow codesign to access them
security import ./Provisioning/certs/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./Provisioning/certs/distribution.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./Provisioning/certs/distribution.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -T /usr/bin/codesign

security set-key-partition-list -S apple-tool:,apple: -s -k travis ios-build.keychain
```

> IMPORTANT: It's mandatory to create a keychain with a password for the command `security set-key-partition-list` to work.

### Fastlane

If you are using [Fastlane](https://fastlane.tools/) to sign your app (e.g. with [Fastlane Match](https://github.com/fastlane/fastlane/tree/master/match)), you will need to do something similar to the following in your `Fastfile`:

```
    create_keychain(
      name: ENV["MATCH_KEYCHAIN_NAME"],
      password: ENV["MATCH_PASSWORD"],
      default_keychain: true,
      unlock: true,
      timeout: 3600,
      add_to_search_list: true
    )

    match(
      type: "adhoc",
      keychain_name: ENV["MATCH_KEYCHAIN_NAME"],
      keychain_password: ENV["MATCH_PASSWORD"],
      readonly: true
    )
```

If you are using `import_certificate` directly to import your certificates, it's mandatory to pass your keychain's password as a parameter e.g.

```
keychain_name = "ios-build.keychain"
keychain_password = SecureRandom.base64

create_keychain(
    name: keychain_name,
    password: keychain_password,
    default_keychain: true,
    unlock: true,
    timeout: 3600,
    add_to_search_list: true
)

import_certificate(
    certificate_path: "fastlane/Certificates/dist.p12",
    certificate_password: ENV["KEY_PASSWORD"],
    keychain_name: keychain_name
    keychain_password: keychain_password
)
```

You can also have more details in [this GitHub issue](https://github.com/travis-ci/travis-ci/issues/6791) starting at [this comment](https://github.com/travis-ci/travis-ci/issues/6791#issuecomment-261071904).


## Mac: Errors running CocoaPods

CocoaPods usage can fail for a few reasons currently.

### Newer version of CocoaPods required

Most Pods now require CocoaPods 0.32.1, but we still have 0.21 preinstalled. If
you're seeing this error, add this to your `.travis.yml`:

```yaml
before_install:
  - gem install cocoapods -v '0.32.1'
```
{: data-file=".travis.yml"}

### CocoaPods can't be found

CocoaPods isn't currently installed on all available Rubies, which unfortunately
means it will fail when using the default Ruby, which is 2.0.0.

To work around this issue, you can either install CocoaPods manually as shown
above, or you can switch to Ruby 1.9.3 in your `.travis.yml`, which should work
without any issues:

```yaml
rvm: 1.9.3
```
{: data-file=".travis.yml"}

### CocoaPods fails with a segmentation fault

On Ruby 2.0.0, CocoaPods has been seen crashing with a segmentation fault.

You can work around the issue by using Ruby 1.9.3, which hasn't shown these
issues. Add this to your `.travis.yml`:

```yaml
rvm: 1.9.3
```
{: data-file=".travis.yml"}

## System: Required language pack isn't installed

The Travis CI build environments currently have only the en_US language pack
installed. If you get an error similar to : "Error: unsupported locale
setting", then you may need to install another language pack during your test
run.

This can be done with the follow addition to your `.travis.yml`:

```yaml
before_install:
  - sudo apt-get update && sudo apt-get --reinstall install -qq language-pack-en language-pack-de
```
{: data-file=".travis.yml"}

The above addition will reinstall the en_US language pack, as well as the de_DE
language pack.

If you are running on the container-base infrastructure and don't have access
to the `sudo` command, install locales [using the APT addon](/user/installing-dependencies/#installing-packages-with-the-apt-addon):

```yaml
addons:
  apt:
    packages:
      - language-pack-en
      - language-pack-de
```
{: data-file=".travis.yml"}

## Linux: apt fails to install package with 404 error

This is often caused by old package database and can be fixed by adding the following to `.travis.yml`:

```yaml
before_install:
  - sudo apt-get update
```
{: data-file=".travis.yml"}

## Travis CI does not Preserve State Between Builds

Travis CI uses virtual machine snapshotting to make sure no state is preserved between
builds. If you modify CI environment by writing something to a data store, creating
files or installing a package via apt, it does not affect subsequent builds.

## SSH is not working as expected

Travis CI runs all commands over SSH in isolated virtual machines. Commands that
modify SSH session state are "sticky" and persist throughout the build. For example,
if you `cd` into a directory, all subsequent commands are run from that directory.

## Git Submodules are not updated correctly

Travis CI automatically initializes and updates submodules when there's a `.gitmodules` file in the root of the repository.

To turn this off, set:

```yaml
git:
  submodules: false
```
{: data-file=".travis.yml"}

If your project requires specific options for your Git submodules which Travis CI
does not support out of the box, turn off the automatic integration and use the
`before_install` hook to initializes and update them.

For example, to update nested submodules:

```yaml
before_install:
  - git submodule update --init --recursive
```
{: data-file=".travis.yml"}

## Git cannot clone my Submodules

If your project uses Git submodules, make sure you use public Git URLs. For example, on GitHub, instead of

```
git@github.com:someuser/somelibrary.git
```

use

```
https://github.com/someuser/somelibrary.git
```

Otherwise, Travis CI builders won't be able to clone your project because they don't have your private SSH key.

## My builds are timing out

Builds can unfortunately time out, either during installation of dependencies, or during the build itself, for instance because of a command that's taking a longer amount of time to run while not producing any output.

Our builds have a global timeout and a timeout that's based on the output. If no output is received from a build for 10 minutes, it's assumed to have stalled for unknown reasons and is subsequently killed.

At other times, installation of dependencies can timeout. Bundler and RubyGems are a relevant example. Network connectivity between our servers can sometimes affect connectivity to APT, Maven or other repositories.

There are few ways to work around that.

### Timeouts installing dependencies

If you are getting network timeouts when trying to download dependencies, either
use the built in retry feature of your dependency manager or wrap your install
commands in the `travis_retry` function.

#### Bundler

Bundler retries three times by default, but if you need to increase that number,
use the following syntax in your `.travis.yml`

```bash
bundler_args: --retry 5
```

#### travis_retry

For commands which do not have a built in retry feature, use the `travis_retry`
function to retry it up three times if the return code is non-zero:

```bash
install: travis_retry pip install myawesomepackage
```

Most of our internal build commands are wrapped with `travis_retry` to reduce the
impact of network timeouts.

Note that `travis_retry` does not work in the `deploy` step of the build, although it
does work in the [other steps](/user/job-lifecycle/).


### Build times out because no output was received

When a long running command or compile step regularly takes longer than 10 minutes without producing any output, you can adjust your build configuration to take that into consideration.

The shell environment in our build system provides a function that helps to work around that, at least for longer than 10 minutes.

If you have a command that doesn't produce output for more than 10 minutes, you can prefix it with `travis_wait`, a function that's exported by our build environment. For example:

```yaml
    install: travis_wait mvn install
```
{: data-file=".travis.yml"}

spawns a process running `mvn install`.
`travis_wait` then writes a short line to the build log every minute for 20 minutes, extending the amount of time your command has to finish.

If you expect the command to take more than 20 minutes, prefix the command with `travis_wait n` where `n` is the number of minutes extend the waiting time by.

Continuing the example above, to extend the wait time to 30 minutes:

```yaml
    install: travis_wait 30 mvn install
```
{: data-file=".travis.yml"}

We recommend careful use of `travis_wait`, as overusing it can extend your build time when there could be a deeper underlying issue. When in doubt, [file a ticket](https://github.com/travis-ci/travis-ci/issues/new) or [email us](mailto:support@travis-ci.com) first to see if something could be improved about this particular command first.

#### Limitations of `travis_wait`

`travis_wait` works by starting a process, sending it to the background, and watching the background
process.
If the command you pass to `travis_wait` does not persist, then `travis_wait` does not extend the timeout.

## Running builds in debug mode

In private repositories and those public repositories for which the feature is enabled,
it is possible to run builds and jobs in the debug mode.
Using this feature, you can interact with the live VM where your builds run.

For more information, please consult [the debug VM documentation](/user/running-build-in-debug-mode/).

## Log Length exceeded

The log for each build is limited to approximately 4 Megabytes. When it reaches that length the build is terminated and you'll see the following message at the end of your build log:

```
The log length has exceeded the limit of 4 Megabytes (this usually means that test suite is raising the same exception over and over).

The build has been terminated.
```

## FTP/SMTP/other protocol does not work

Some protocols such as FTP and SMTP are not directly supported due to the
infrastructure requirements in place for security and fair usage.  Using
alternate <q>stateless</q> protocols such as HTTPS is best, but tunneling is
also known to work, such as by using SFTP in the specific case of FTP, or a VPN
connection for a wide variety of protocols, e.g.:

``` yaml
addons:
  apt:
    packages:
    - openvpn

before_install:
- sudo openvpn path/to/conf.ovpn &>>openvpn-client.log &
```
{: data-file=".travis.yml"}


## I pushed a commit and can't find its corresponding build

The build request events that Travis CI receives are listed in your repository's Requests page. You can find it under the **More Options** dropdown menu, choosing **Requests**.

![More Options dropdown menu, choosing Requests](/images/common-build-problems/repository-requests-page.png)

Whenever your build has been processed you'll see the message: **"Build created successfully"**.

If a build hasn't been triggered for your commit, these are the possible build request messages:

- **"Could not authorize build request"**, usually means that the account's subscription expired or that it ran out of trial builds.
- **"Build skipped via commit message"**, this commit contains [the skip command](/user/customizing-the-build/#skipping-a-build).
- **"GitHub payload is missing a merge commit"**, please confirm your pull request is open and mergeable.
- **"Branch excluded per configuration"** or **"Branch not included per configuration"**, please make sure your branch is not [explicitly excluded](/user/customizing-the-build/#safelisting-or-blocklisting-branches) or [not included](/user/customizing-the-build/#safelisting-or-blocklisting-branches) in your `.travis.yml` file.
- **Build type disabled via repository settings**, please make sure your Push and Pull Request builds are still active.

> Please note that Travis CI does not receive a Webhook event when more than three commits are tagged. So if you do `git push --tags`, and more than three tags that are present locally, are not known on GitHub, Travis will not be told about any of those events, and the tagged commits will not be built.

## I'm running out of disk space in my build

Approximate available disk space is listed in the [build environment overview](/user/reference/overview/#virtualisation-environment-vs-operating-system).

The best way to find out what is available on your specific image is to run `df -h` as part of your build script.
If you need a bit more space in your Ubuntu builds, we recommend using `language: minimal`, which will route you to a base image with less tools and languages preinstalled. This image has approximately ~24GB of free space.

## Uploading Artifacts to Sonatype

When publishing via the `nexus-staging-maven-plugin` to Sonatype OSS Repository, IP addresses used by TravisCI change due to our [NAT layer](https://blog.travis-ci.com/2018-07-23-the-tale-of-ftp-at-travis-ci). To get around this, please use a `stagingProfileId` as [explained in this document](https://travis-ci.community/t/sonatype-deployment-problems/1353/2?u=mzk). 

## Travis CLI does not recognize my valid Github Token

When using the [Travis CLI tool](https://github.com/travis-ci/travis.rb#readme) to interact with the Travis CI platform, if you receive an `insufficient_oauth_permissions` error or similar, please ensure the Github Token supplied via `--github-token` has **repo** scope as [explained in this document](https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/).

## Duplicate/Unknown Job shows up in my build

When specifying stages, users often unknowingly add an implicit Job to the list of Jobs in a Stage using YAML that is otherwise syntactically correct.

``` yaml
language: c
...
jobs:
  include:
  - stage: Breakfast
  - name: Peanut Butter and Bread
    script: ./brew_hot_coffee.sh
```
{: data-file=".travis.yml"}

The above definition, creates a stage called **Breakfast** and 2 jobs. The first job is an _implicit_ job that inherits all the default values for the programming language specified. In the example above, the [default values for `C`](user/languages/c/#what-this-guide-covers) will be used while the second job is the _Peanut Butter and Bread_, which you have explicitly defined.

To remove this _implicit_ job, you would edit the above to look like:

``` yaml
language: c
...
jobs:
  include:
  - stage: Breakfast
    name: Peanut Butter and Bread
    script: ./brew_hot_coffee.sh

``` 
{: data-file=".travis.yml"}


This creates only one job,  _Peanut Butter and Bread_ under the stage named _Breakfast_ as you have defined. It is important to note that in YAML, the `-` symbol is used to create a list of items and the earlier example creates a list of 2 items, while you actually wanted 1. You can read more on [How to define Build Stages](/user/build-stages/#how-to-define-build-stages) and YAML lists syntax in the official [documentation](https://yaml.org/spec/1.2/spec.html#id2759963).
