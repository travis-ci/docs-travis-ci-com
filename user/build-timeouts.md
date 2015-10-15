---
title: My builds are timing out
layout: en
permalink: /user/build-timeouts/
---
<div id="toc"></div>

Builds can unfortunately time out, either during installation of dependencies, or during the build itself, for instance because of a command that's taking a longer amount of time to run while not producing any output.

Our builds have a global timeout and a timeout that's based on the output. If no output is received from a build for 10 minutes, it's assumed to have stalled for unknown reasons and is subsequently killed.

At other times, installation of dependencies can timeout. Bundler and RubyGems are a relevant example. Network connectivity between our servers can sometimes affect connectivity to APT, Maven or other repositories.

There are few ways to work around that.

## Timeouts installing dependencies

Bundler can time out downloading RubyGems or talking to the APIs at rubygems.org. In the same way, pip can be affected by network connectivity issues to the PyPi mirrors or CDN endpoints.

Bundler itself now has a [built-in feature to retry](http://bundler.io/v1.5/bundle_install.html#retry) gem downloads or API calls when a network error or timeout occurs.

You can add the `--retry` option with the number of retries you'd like to use. *Note: this may become a default in the future on Travis CI.*

Here's what you can add to your .travis.yml:

    bundler_args: --retry 3

Beyond Bundler, you can wrap commands using the function `travis_retry` which checks the return code of a command, retrying it three times if the return code is non-zero.

    install: travis_retry bundle install

Note that with Bundler, using one or the other should be sufficient to catch network timeouts affecting your build. Using the new `--retry` option has the benefit of giving you finer control about the total amount of retries.

We recommend using `travis_retry` when you have commands that only install one or two RubyGems, for instance, or when they're timing out for other reasons.

Most of our build-internal commands are wrapped with `travis_retry` to reduce the impact of temporary network hiccups.

## Build times out because no output was received

When a long running command or compile step regularly takes longer than 10 minutes without producing any output, you can adjust your build configuration to take that into consideration.

The shell environment in our build system provides a function that helps to work around that, at least for longer than 10 minutes.

If you have a command that doesn't produce output for more than 10 minutes, you can prefix it with `travis_wait`, a function that's exported by our build environment.

    install: travis_wait mvn install
    
`travis_wait` writes a short line to the build log every minutes for 20 minutes, extending the amount of time your command has to finish.

We recommend careful use of `travis_wait`, as overusing it can extend your build time when there could be a deeper underlying issue. When in doubt, [file a ticket](https://github.com/travis-ci/travis-ci/issues/new) or [email us](mailto:support@travis-ci.com) first to see if something could be improved about this particular command first.
