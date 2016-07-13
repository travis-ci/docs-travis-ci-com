---
title: Using Sauce Labs with Travis CI
layout: en
permalink: /user/sauce-connect/
---
Travis CI integrates with [Sauce Labs](https://saucelabs.com), a browser and
mobile testing platform. It integrates well with Selenium, for instance.

The integration automatically sets up a tunnel required to get started testing
with it. For that purpose, it uses Sauce Connect.

Note that due to security restrictions, the Sauce Labs addon is not available on pull request builds. See the [pull requests page](http://docs.travis-ci.com/user/pull-requests/#Security-Restrictions-when-testing-Pull-Requests) for full details on why it is disabled.

## Setting up Sauce Connect

[Sauce Connect][sauce-connect] securely proxies browser traffic between Sauce
Labs' cloud-based VMs and your local servers. Connect uses ports 443 and 80 for
communication with Sauce's cloud. If you're using Sauce Labs for your Selenium
tests, this makes connecting to your webserver a lot easier.

[sauce-connect]: https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy

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

[encryption-keys]: http://docs.travis-ci.com/user/encryption-keys/

To allow multiple tunnels to be open simultaneously, Travis CI opens a
Sauce Connect [Identified Tunnel][identified-tunnels]. Make sure you are sending
the `TRAVIS_JOB_NUMBER` environment variable when you are opening the connection
to Sauce Labs' selenium grid, as the desired capability `tunnel-identifier`,
or it will not be able to connect to the server running on the VM.

[identified-tunnels]: https://wiki.saucelabs.com/display/DOCS/Using+Multiple+Sauce+Connect+Tunnels#UsingMultipleSauceConnectTunnels-UsingTunnelIdentifierswithMultipleTunnels

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

## Additional options

Sometimes you may need to pass additional options to Sauce Connect. Currently
supported parameters are

  * `direct_domains`
  * `no_ssl_bump_domains`
  * `tunnel_domains`

As an example, you may need `--direct-domains` option in case [some HTTPS domains
fail to work with Sauce Connect](https://support.saucelabs.com/customer/portal/articles/2005359-some-https-sites-don-t-work-correctly-under-sauce-connect):

    addons:
      sauce_connect:
        username: "Your Sauce Labs username"
        access_key:
          secure: "The secure string output by `travis encrypt`"
        direct_domains: example.org,*.foobar.com
