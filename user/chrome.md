---
title: Google Chrome
layout: en

---

The Google Chrome addon allows Travis CI builds to install Google Chrome at runtime.

This addon supports both, Linux and [macOS](/user/reference/osx/) [build environments](https://docs.travis-ci.com/user/reference/overview/).

> For Linux, you must be running on [Ubuntu Xenial 16.04](https://docs.travis-ci.com/user/reference/xenial/) or later build environments.

## Selecting a Chrome version

You can install the `stable`  or the `beta` version of Chrome but you can't select a specific numeric version.

```yaml
addons:
  chrome: stable
```
{: data-file=".travis.yml"}

> Take note that the underlying Chrome version can change from one build to another when Google updates the `stable` or `beta` version.

## Headless mode

You can use Google Chrome in [headless mode](/user/gui-and-headless-browsers/#using-the-chrome-addon-in-the-headless-mode).

## Sandboxing

For security reasons, Google Chrome is unable to provide sandboxing when it is running in the
[container-based environment](/user/reference/overview/#virtualization-environments).

In that case, you may see an error message like this:

```
30 11 2017 13:35:42.245:ERROR [launcher]: Cannot start Chrome
  [4315:4315:1130/133541.781662:FATAL:setuid_sandbox_host.cc(157)] The SUID sandbox helper binary was found, but is not configured correctly. Rather than run without sandboxing I'm aborting now. You need to make sure that /opt/google/chrome/chrome-sandbox is owned by root and has mode 4755.
```

or like this:

```
Selenium::WebDriver::Error::UnknownError:
  unknown error: Chrome failed to start: crashed
    (Driver info: chromedriver=2.38.552522 (437e6fbedfa8762dec75e2c5b3ddb86763dc9dcb),platform=Linux 4.14.12-041412-generic x86_64)
```

To use Chrome in the container-based environment, pass the `--no-sandbox` flag to the `chrome` executable.

The method to accomplish this varies from one testing framework to another. Some examples are given below. Please consult your tool's documentation for further details on how to add the `--no-sandbox` flag.

### Karma Chrome Launcher

With [the customlauncher plugin for Karma](https://github.com/karma-runner/karma-chrome-launcher), you would add it to the `flags` array:

```javascript
module.exports = function(config) {
  config.set({
    browsers: ['Chrome', 'ChromeHeadless', 'ChromeHeadlessNoSandbox'],

    // you can define custom flags
    customLaunchers: {
      ChromeHeadlessNoSandbox: {
        base: 'ChromeHeadless',
        flags: ['--no-sandbox']
      }
    }
  })
}
```

### Capybara

When using [Capybara](https://github.com/teamcapybara/capybara) with Ruby, you would set up a custom driver with the appropriate flags:

```ruby
require 'capybara'
Capybara.register_driver :chrome do |app|
	options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu])

	Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :chrome
```

### Behat

When using [Behat](https://github.com/Behat/Behat) you should pass the options to the selenium2 chrome configuration:

```yml
default:
  extensions:
    Behat\MinkExtension:
      selenium2:
        # This will probably be the same always, if you follow the guide for browsers below.
        wd_host: http://localhost:8643/wd/hub
        capabilities:
          chrome:
            switches:
              - "--headless"
              - "--disable-gpu"
              - "--no-sandbox"
      javascript_session: selenium2
      browser_name: chrome
```
