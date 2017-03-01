---
title: Using BrowserStack with Travis CI
layout: en
permalink: /user/browserstack/
---

Travis CI integrates with [BrowserStack](https://www.browserstack.com), a cross browser and real device
web-based testing platform. BrowserStack can be used for interactive as well as automated testing through frameworks
like Selenium, Karma and others.

This add-on automatically sets up [BrowserStack Local][local-testing] which allows you to test your private servers alongside public URLs, using the BrowserStack cloud. To do this it uses the [BrowserStackLocal binary][local-binary] for your build platform.

[BrowserStack Local][local-testing] establishes a secure connection between your Travis build container/VM
and BrowserStack servers. Local Testing also has support for firewalls, proxies and Active Directory.
Once the secure connection is setup, all URLs work out of the box, including your webserver, local folders, as well as
URLs with HTTPS.

[local-testing]: https://www.browserstack.com/local-testing

[local-binary]: https://www.browserstack.com/local-testing#command-line

[open-source-browserstack]: https://www.browserstack.com/pricing

[account-settings]: https://www.browserstack.com/accounts/settings

[encryption-keys]: http://docs.travis-ci.com/user/encryption-keys/

[browserstack-ruby-bindings]: https://www.browserstack.com/automate/ruby

[travis-matrix-builds]: https://docs.travis-ci.com/user/customizing-the-build/#Build-Matrix

## Setting up BrowserStack

Please sign up for a BrowserStack account if you haven't already; it's
[free][open-source-browserstack] for Open Source projects. Once you have signed up get your username and access key from
the  [account settings][account-settings] page. Your username and access key are required to configure the `.travis.yml`
file of your project.

Choose whether you want to store your access key as plain text or in a secure/encrypted form. For open source projects we recommend
storing the access key in a secure form so that pull requests cannot use the keys stored in your `.travis.yml`.
For more information see the [pull requests page](http://docs.travis-ci.com/user/pull-requests/#Security-Restrictions-when-testing-Pull-Requests).

### Encrypted Access Key

To encrypt your access key for use in `.travis.yml` you can use `travis encrypt "your BrowserStack access key"`.
You need to have the travis cli installed to be able to do this (see [Encryption Keys][encryption-keys] for more details).
Once your access key is encrypted you can add the secure string:

```yaml
addons:
  browserstack:
    username: "Your BrowserStack username"
    access_key:
      secure: "The secure string output of `travis encrypt`"
```

### Plain Text Access Key

To store your access key in plain text format, add the following configuration to your `.travis.yml` file:

```yaml
addons:
  browserstack:
    username: "Your BrowserStack username"
    access_key: "Your BrowserStack access key"
```

We **strongly** recommend storing your BrowserStack access keys in encrypted format, since other users that have access to your repository
can read and use your plain text access keys to test on BrowserStack.

### Local Identifier

A Local Identifier is a unique identifier for each Local connection when multiple Local connections are connected.
The add-on will **ALWAYS** create a Local Identifier for each local connection that is created. If you are using the Selenium
testing framework, the Local Identifier must be added to the Selenium capabilities.

The Local Identifier is exposed as an environment variable `BROWSERSTACK_LOCAL_IDENTIFIER`. You can use it to set
the Selenium capability. See the following example which uses Ruby's [selenium-webdriver][browserstack-ruby-bindings]:

```ruby
require 'rubygems'
require 'selenium-webdriver'

# Input capabilities
caps = Selenium::WebDriver::Remote::Capabilities.new
caps['browserstack.local'] = 'true'
caps['browserstack.localIdentifier'] = ENV['BROWSERSTACK_LOCAL_IDENTIFIER']
# Add other capabilities like browser name, version and os name, version
...

driver = Selenium::WebDriver.for(:remote,
  :url => "http://USERNAME:ACCESS_KEY@hub-cloud.browserstack.com/wd/hub",
  :desired_capabilities => caps)
```

Local identifiers are essential for [matrix builds][travis-matrix-builds]. Since matrix builds in travis can be run on
the same VM, we need to add the Local Identifier when starting the connection to ensure that the correct local tunnel
gets the right requests.  

## Additional Options

### Proxy

Local testing also allows you to set the proxy host, port, username and password
through which all urls will be resolved:

```yaml
addons:
  browserstack:
    username: "Your BrowserStack username"
    access_key:
      secure: "The secure string output of `travis encrypt`"
    proxyHost: "Proxy server host"
    proxyPort: "Proxy server port"
    proxyUser: "User to use when accessing proxy server"
    proxyPass: "Password to use when accessing proxy server"
```

### More Options

Some other options that are supported by the add on are,

- **forcelocal**: If this is set to true then all network traffic will be resolved via the Travis CI container/VM.
- **only**: restricts Local testing access to the specified local servers and/or folders.

Sample usage,

```yaml
addons:
  browserstack:
    username: "Your BrowserStack username"
    access_key:
      secure: "The secure string output of `travis encrypt`"
    forcelocal: true
    only: dev.example.com,80,0,*.example.org,80,0
```

The format for the **only** flag is, "Host pattern,Host Port,Flag for SSL True(1)/False(0)" and repeat.
