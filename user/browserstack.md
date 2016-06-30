---
title: Using BrowserStack with Travis CI
layout: en
permalink: /user/browserstack/
---
Travis CI integrates with [BrowserStack](https://www.browserstack.com), a cross browser and real device 
web-based testing platform. BrowserStack can be used for Live as well as automated testing through frameworks 
like Selenium, Karma and others.

This add-on automatically sets up Local Testing which allows you to test your private servers, alongside public 
URLs, using the BrowserStack cloud. To do this it uses the BrowserStackLocal binary for your build platform.

[local-testing]: https://www.browserstack.com/local-testing
[open-source-browserstack]: https://www.browserstack.com/pricing
[account-settings]: https://www.browserstack.com/accounts/settings
[encryption-keys]: http://docs.travis-ci.com/user/encryption-keys/
[browserstack-ruby-bindings]: https://www.browserstack.com/automate/ruby
[travis-matrix-builds]: https://docs.travis-ci.com/user/customizing-the-build/#Build-Matrix

## Setting up BrowserStack

[BrowserStack Local Testing][local-testing] establishes a secure connection between your Travis build container/VM 
and BrowserStack servers. Local Testing also has support for firewalls, proxies and Active Directory. 
Once the secure connection is setup, all URLs work out of the box, including your webserver, local folders, as well as 
URLs with HTTPS.

Before you move ahead please sign up for a BrowserStack account if you haven't already, it's 
[free][open-source-browserstack] for Open Source projects. Once you have signed up get your username and access key from 
the  [account settings][account-settings] page. Your username and access key will be required in configuring 
your projects .travis.yml file. 

Choose whether you want to store your access key as plain text or in secure/encrypted form. For open source projects we recommend 
storing the access key in secure form so that pull requests cannot use the keys stored in your .travis.yml. 
For more information see the [pull requests page](http://docs.travis-ci.com/user/pull-requests/#Security-Restrictions-when-testing-Pull-Requests).


### Plain Text Access Key


To keep your access key in plain text add the following configuration to your .travis.yml file,

    addons:
      browserstack:
        username: "Your BrowserStack username"
        access_key: "Your BrowserStack access key"
        

Note, this keeps your access key in plain text and other users that have access to your repository can read and use 
the same access key to test on BrowserStack. If you want to prevent this you can encrypt your access key as explained below.

### Encrypted Access Key

To encrypt your access key for use in .travis.yml you can encrypt it using `travis encrypt "your BrowserStack access key"`. 
You need to have the travis cli installed to be able to do this (see [Encryption Keys][encryption-keys] for more details).
Once your access key is encrypted you can add the secure string as,

    addons:
      browserstack: "Your BrowserStack username"
      access_key:
        secure: "The secure string output of `travis encrypt`"


### Local Identifier

A Local identifier is a unique identifier for each Local connection when multiple Local connections are connected.
The add-on will **ALWAYS** create a local identifier for each local connection that is created, 
this local identifier MUST be added to the Selenium capabilities if Selenium is the testing framework being used. 
The local identifier is exposed as an environment variable `BROWSERSTACK_LOCAL_IDENTIFIER`. You can use this to set 
Selenium capabilities as, using Ruby's [selenium-webdriver][browserstack-ruby-bindings]

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

Local identifiers are essential for [matrix builds][travis-matrix-builds]. Matrix builds in travis can be run on 
the same VM so to ensure that the correct local tunnel gets the correct requests we need to add the Local identifier 
when starting the connection.  

### Folder Testing

Local testing also allows you to test HTML in local folders. To enable folder testing you need to set the 
name of the local folders as,

    addons:
      browserstack: "Your BrowserStack username"
      access_key:
        secure: "The secure string output of `travis encrypt`"
      folder: "Absolute path of the folder containing HTML files"

You can then access the HTML files via the url 
`http://$BROWSERSTACK_USERNAME.browserstack.com/"Path to your HTML file with respect to the folder set."`


### Other Options

Other options that are supported by the add on are,
  * **force_local**: If this is set to true then all URLs will be resolved via the Travis container that your build is running in. 
  * **only**: restricts Local testing access to the specified local servers and/or folders.

Example,

    addons:
      browserstack: "Your BrowserStack username"
      access_key:
        secure: "The secure string output of `travis encrypt`"
      force_local: true
      only: dev.example.com,80,0,*.example.org,80,0

The format for the only flag is, `"Host pattern,Host Port,Flag for SSL True(1)/False(0)" and repeat.

### Proxy Options

Local testing also allows you to set the proxy host, port, username and password through which all 
urls will be resolved. You can set proxy settings as follows,

    addons:
      browserstack: "Your BrowserStack username"
      access_key:
        secure: "The secure string output of `travis encrypt`"
      proxy_host: "Proxy server host"
      proxy_port: "Proxy server port"
      proxy_user: "User to use when accessing proxy server"
      proxy_pass: "Password to use when accessing proxy server"

