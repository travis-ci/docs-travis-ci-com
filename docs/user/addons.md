---
title: Build Addons
layout: en
permalink: addons/
---

Travis CI allows you to set up some build tools using settings right in your
.travis.yml file.

<div id="toc"></div>

## Sauce Connect

[Sauce Connect][sauce-connect] securely proxies browser traffic between Sauce
Labs' cloud-based VMs and your local servers. Connect uses ports 443 and 80 for
communication with Sauce's cloud. If you're using Sauce Labs for your Selenium
tests, this makes connecting to your webserver a lot easier.

[sauce-connect]: https://saucelabs.com/docs/connect

First, [sign up][sauce-sign-up] with Sauce Labs if you haven't already (it's
[free][open-sauce] for Open Source projects), and get your access key from your
[account page][sauce-account]. Once you have that, add this to your .travis.yml
file:

    addons:
      sauce_connect:
        username: "Your Sauce Labs username"
        access_key: "Your Sauce Labs access key"

[sauce-sign-up]: https://saucelabs.com/signup/plan/free
[sauce-account]: https://saucelabs.com/account
[open-sauce]: https://saucelabs.com/signup/plan/OSS

If you don't want your access key publicly available in your repository, you
can encrypt it with `travis encrypt "your-access-key"` (see [Encryption Keys][encryption-keys]
for more information on encryption), and add the secure string as such:

    addons:
      sauce_connect:
        username: "Your Sauce Labs username"
        access_key:
          secure: "The secure string output by `travis encrypt`"

You can also add the `username` and `access_key` as environment variables if you
name them `SAUCE_USERNAME` and `SAUCE_ACCESS_KEY`, respectively. In that case,
all you need to add to your .travis.yml file is this:

    addons:
      sauce_connect: true

[encryption-keys]: http://about.travis-ci.org/docs/user/encryption-keys/

To allow multiple tunnels to be open simultaneously, Travis CI opens a
Sauce Connect [Identified Tunnel][identified-tunnels]. Make sure you are sending
the `TRAVIS_JOB_NUMBER` environment variable when you are opening the connection
to Sauce Labs' selenium grid, as the desired capability `tunnel-identifier`,
or it will not be able to connect to the server running on the VM.

[identified-tunnels]: https://saucelabs.com/docs/connect#tunnel-identifier

How this looks will depend on the client library you're using, in
Ruby's [selenium-webdriver][ruby-bindings] bindings:

    caps = Selenium::WebDriver::Remote::Capabilities.firefox({
      'tunnel-identifier' => ENV['TRAVIS_JOB_NUMBER']
    })
    driver = Selenium::WebDriver.for(:remote, {
      url: 'http://username:access_key@ondemand.saucelabs.com/wd/hub',
      desired_capabilities: caps
    })

[ruby-bindings]: https://code.google.com/p/selenium/wiki/RubyBindings

## Firefox

Our VMs come preinstalled with some recent version of Firefox, but sometimes you
need a specific version to be installed. The Firefox addon allows you to specify
any version of Firefox and the binary will be downloaded and installed before
running you build script (as a part of the before_install stage).

If you need version 17.0 of Firefox to be installed, add the following to your
.travis.yml file:

    addons:
      firefox: "17.0"

Please note that this downloads binaries that are only compatible with our
64-bit Linux VMs, so this won't work on our Mac VMs.

## Hosts

If your requires setting up custom hostnames, you can specify a single host or a
list of them in your .travis.yml. Travis CI will automatically setup the
hostnames in `/etc/hosts` for both IPv4 and IPv6.

    addons:
      hosts:
        - travis.dev
        - joshkalderimis.com
