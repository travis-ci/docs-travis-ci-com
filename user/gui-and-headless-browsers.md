---
title: GUI and Headless Browser Testing
layout: en

---

## What This Guide Covers

This guide covers headless GUI & browser testing using tools provided by the Travis [CI environment](/user/reference/precise/). Most of the content is technology-neutral and does not cover all the details of specific testing tools (like Poltergeist or Capybara). We recommend you start with the [Getting Started](/user/getting-started/) and [Build Configuration](/user/customizing-the-build/) guides before reading this one.

## Using Sauce Labs

[Sauce Labs](https://saucelabs.com) provides a Selenium cloud with access to more than 170 different device/OS/browser combinations. If you have browser tests that use Selenium, using Sauce Labs to run the tests is very easy. First, you need to sign up for their service (it's free for open source projects).

Once you've signed up, set up a tunnel using Sauce Connect so Sauce Labs can connect to your web server. Our [Sauce Connect addon](/user/sauce-connect/) makes this easy, just add this to your .travis.yml:

```yaml
addons:
  sauce_connect:
    username: "Your Sauce Labs username"
    access_key: "Your Sauce Labs access key"
```
{: data-file=".travis.yml"}

You can [encrypt your access key](/user/encryption-keys/), if you want to.

Now Sauce Labs has a way of reaching your web server, but you still need to start it up. See [Starting a Web Server](#Starting-a-Web-Server) below for more information on how to do that.

Finally, you need to configure your Selenium tests to run on Sauce Labs instead of locally. This is done using a [Remote WebDriver](https://code.google.com/p/selenium/wiki/RemoteWebDriver). The exact code depends on what tool/platform you're using, but for Python it would look like this:

```bash
username = os.environ["SAUCE_USERNAME"]
access_key = os.environ["SAUCE_ACCESS_KEY"]
capabilities["tunnel-identifier"] = os.environ["TRAVIS_JOB_NUMBER"]
hub_url = "%s:%s@localhost:4445" % (username, access_key)
driver = webdriver.Remote(desired_capabilities=capabilities, command_executor="http://%s/wd/hub" % hub_url)
```

The Sauce Connect addon exports the `SAUCE_USERNAME` and `SAUCE_ACCESS_KEY` environment variables, and relays connections to the hub URL back to Sauce Labs.

This is all you need to get your Selenium tests running on Sauce Labs. However, you may want to only use Sauce Labs for Travis CI builds, and not for local builds. To do this, you can use the `CI` or `TRAVIS` environment variables to conditionally change what driver you're using (see [our list of available envionment variables](/user/reference/precise/#Environment-variables) for more ways to detect if you're running on Travis CI).

To make the test results on Sauce Labs a little more easy to navigate, you may wish to provide some more metadata to send with the build. You can do this by passing in more desired capabilities:

```bash
capabilities["build"] = os.environ["TRAVIS_BUILD_NUMBER"]
capabilities["tags"] = [os.environ["TRAVIS_PYTHON_VERSION"], "CI"]
```

For travis-web, our very own website, we use Sauce Labs to run browser tests on multiple browsers. We use environment variables in our [.travis.yml](https://github.com/travis-ci/travis-web/blob/15dc5ff92184db7044f0ce3aa451e57aea58ee19/.travis.yml#L14-15) to split up the build into multiple jobs, and then pass the desired browser into Sauce Labs using [desired capabilities](https://github.com/travis-ci/travis-web/blob/15dc5ff92184db7044f0ce3aa451e57aea58ee19/script/saucelabs.rb#L9-13). On the Travis CI side, it ends up looking like [this](https://travis-ci.org/travis-ci/travis-web/builds/12857641).

## Using xvfb to Run Tests That Require a GUI

To run tests requiring a graphical user interface on Travis CI, use `xvfb` (X
Virtual Framebuffer) to imitate a display. If you need a browser, you can use
Firefox (either with the pre-installed version, or the [addon](/user/firefox))
or Google Chrome (with the [addon](/user/chrome), on Linux Trusty or OS X).

### Using the xvfb-run wrapper

`xvfb-run` is a wrapper for invoking `xvfb` so that `xvfb` can be used with
less fuss:

```yaml
script: xvfb-run make test
```

To set the screen resolution:

```yaml
script: xvfb-run --server-args="-screen 0 1024x768x24" make test
```

### Using xvfb directly

To use `xvfb` itself, start it in the `before_script` section of your
`.travis.yml`:

```yaml
before_script:
  - "export DISPLAY=:99.0"
  - "sh -e /etc/init.d/xvfb start"
  - sleep 3 # give xvfb some time to start
```
{: data-file=".travis.yml"}

Note: Don't run `xvfb` directly, as it does not handle multiple concurrent
instances that way.

If you need to set the screen size and pixel depth, you need to start `xvfb`
with the `start-stop-daemon` utility and not with the init script in the
previous example.

For example, to set the screen resolution to `1280x1024x16`:

```yaml
before_install:
  - "/sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -ac -screen 0 1280x1024x16"
```
{: data-file=".travis.yml"}

See [xvfb manual page](http://www.xfree86.org/4.0.1/Xvfb.1.html) for more information.

### Starting a Web Server

If your project requires a web application running to be tested, you need to start one before running tests. It is common to use Ruby, Node.js and JVM-based web servers
that serve HTML pages used to run test suites. Because every travis-ci.org VM provides at least one version of Ruby, Node.js and OpenJDK, you can rely on one of those
three options.

Add a `before_script` to start a server, for example:

```yaml
before_script:
  - "export DISPLAY=:99.0"
  - "sh -e /etc/init.d/xvfb start"
  - sleep 3 # give xvfb some time to start
  - rackup  # start a Web server
  - sleep 3 # give Web server some time to bind to sockets, etc
```
{: data-file=".travis.yml"}

If you need web server to be listening on port 80, remember to use `sudo` (Linux will not allow non-privileged process to bind to port 80). For ports greater than 1024, using `sudo` is not necessary (and not recommended).

<div class="note-box">
Note that <code>sudo</code> is not available for builds that are running on the <a href="/user/workers/container-based-infrastructure">container-based workers</a>.
</div>


### Using the [Chrome addon](/user/chrome) in the headless mode

Starting with version 57 for Linux Trusty and version 59 on OS X, Google Chrome can be used in "headless"
mode, which is suitable for driving browser-based tests using Selenium and other tools.

> As of 2017-05-02, this means `stable` or `beta` on Linux builds, and `beta` on OS X builds.

For example, on Linux

```yaml
dist: trusty
addons:
  chrome: stable
before_install:
  - # start your web application and listen on `localhost`
  - google-chrome-stable --headless --disable-gpu --remote-debugging-port=9222 http://localhost &
  ⋮
```
{: data-file=".travis.yml"}

On OS X:

```yaml
language: objective-c
addons:
  chrome: beta
before_install:
  - # start your web application and listen on `localhost`
  - "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --headless --disable-gpu --remote-debugging-port=9222 http://localhost &"
  ⋮
```
{: data-file=".travis.yml"}

#### Documentation

* [Headless Chromium documentation](https://chromium.googlesource.com/chromium/src/+/lkgr/headless/README.md)
* [Getting Started with Headless Chrome](https://developers.google.com/web/updates/2017/04/headless-chrome)

### Using the [Firefox addon](/user/firefox) in headless mode

Starting with version 56, Firefox can be used in "headless" mode, which is
suitable for driving browser-based tests using Selenium and other tools.
Headless mode can be enabled using the `MOZ_HEADLESS`
[environment variable](/user/environment-variables):

```yaml
env:
  - MOZ_HEADLESS=1
addons:
  firefox: latest
```
{: data-file=".travis.yml"}

Alternatively, you can pass the `-headless` command line argument when
starting Firefox. For example, the following code demonstrates how you would
set this argument using the Python client for Selenium:

```python
from selenium.webdriver import Firefox
from selenium.webdriver.firefox.options import Options

options = Options()
options.add_argument('-headless')
firefox = Firefox(firefox_options=options)
```

#### Documentation

* [Using headless mode](https://developer.mozilla.org/en-US/Firefox/Headless_mode#Using_headless_mode)
* [Automated testing with headless mode](https://developer.mozilla.org/en-US/Firefox/Headless_mode#Automated_testing_with_headless_mode)

## Using PhantomJS

[PhantomJS](http://phantomjs.org/) is a headless WebKit with JavaScript API. It is an optimal solution for fast headless testing, site scraping, pages capture, SVG renderer, network monitoring and many other use cases.

[CI environment](/user/reference/precise/) provides PhantomJS pre-installed (available in PATH as `phantomjs`; don't rely on the exact location). Since it is completely headless, there is no need run `xvfb`.

A very simple example:

```yaml
script: phantomjs testrunner.js
```
{: data-file=".travis.yml"}

If you need a web server to serve the tests, see the previous section.

## Examples

### Real World Projects

- [Ember.js](https://github.com/emberjs/ember.js/blob/master/.travis.yml) (starts web server programmatically)
- [Sproutcore](https://github.com/sproutcore/sproutcore/blob/master/.travis.yml) (starts web server with *before_script*)

### Ruby

#### RSpec, Jasmine, Cucumber

Here's an example rake task that runs Rspec, Jasmine, and Cucumber tests:

```ruby
task :travis do
  ["rspec spec", "rake jasmine:ci", "rake cucumber"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end
```

In this example, both Jasmine and Cucumber need the display port, because they both use real browsers. Rspec would run without it, but it does no harm to set it.

## Troubleshooting

### Selenium and Firefox popups

If your test suite handles a modal dialog popup, for example, [a redirect to another location](https://support.mozilla.org/en-US/questions/792131), then you may need to add a custom profile so that the popup is suppressed.

This can be fixed by applying a custom Firefox profile with the option turned off: (example is in Ruby using Capybara)

```ruby
Capybara.register_driver :selenium do |app|

  custom_profile = Selenium::WebDriver::Firefox::Profile.new

  # Turn off the super annoying popup!
  custom_profile["network.http.prompt-temp-redirect"] = false

  Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => custom_profile)
end
```

### Karma and Firefox inactivity timeouts

When testing with Karma and Firefox, you may encounter build errors as a result of browser inactivity timeouts. When this occurs, Karma will output an error similar to:

```
WARN [Firefox 31.0.0 (Linux)]: Disconnected (1 times), because no message in 10000 ms.
```

In that case, you should increase the browser inactivity timeout to a higher value in `karma.conf.js`, e.g.:

```js
browserNoActivityTimeout: 30000,
```

For more infomation, refer to the Karma [Configuration File](https://karma-runner.github.io/1.0/config/configuration-file.html) documentation.
