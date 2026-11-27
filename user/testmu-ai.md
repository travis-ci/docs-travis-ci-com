---
title: Use TestMu AI with Travis CI
layout: en

---

Travis CI works with [TestMu AI](https://www.testmuai.com/) (formerly LambdaTest), a cloud
testing platform for running Selenium, Playwright, Cypress and Appium tests on real browsers
and real devices. You can browse the other tools it connects to on the
[TestMu AI integrations page][integrations].

There is no Travis CI add-on for TestMu AI. You start its tunnel yourself in `before_script`,
which takes three lines.

[integrations]: https://www.testmuai.com/integrations/
[open-source]: https://www.testmuai.com/open-source/
[tunnel-docs]: https://www.testmuai.com/support/docs/testing-locally-hosted-pages/
[tunnel-flags]: https://www.testmuai.com/support/docs/lambda-tunnel-modifiers/
[testmu-travis]: https://www.testmuai.com/support/docs/travis-ci-with-testmu/

## Set up your credentials

Sign up for a TestMu AI account if you haven't already (open source projects can apply for a
[free plan][open-source]). Your username and access key are on the Automation dashboard,
under the key icon.

Add them in your repository's settings on Travis CI as two
[environment variables](/user/environment-variables/#defining-variables-in-repository-settings),
`LT_USERNAME` and `LT_ACCESS_KEY`, and leave **Display value in build log** off. Don't put
the access key in `.travis.yml` in plain text: anyone who can read your repository could use it.

Travis CI doesn't pass secure environment variables to pull request builds from forks.
For more information see the [pull requests page](/user/pull-requests/#pull-requests-and-security-restrictions).

## Run your tests on TestMu AI

If your tests only open public URLs, point your Selenium Remote WebDriver at the TestMu AI
grid. In Python:

```python
import os
from selenium import webdriver

lt_options = {
    "username": os.environ["LT_USERNAME"],
    "accessKey": os.environ["LT_ACCESS_KEY"],
    "platformName": "Windows 11",
    "build": "Travis CI build " + os.environ.get("TRAVIS_BUILD_NUMBER", "local"),
    "name": os.environ.get("TRAVIS_JOB_NAME", "test"),
}

options = webdriver.ChromeOptions()
options.set_capability("LT:Options", lt_options)

driver = webdriver.Remote(
    command_executor="https://hub.lambdatest.com/wd/hub",
    options=options,
)
```
{: data-file="example.py"}

The `build` and `name` values group each Travis CI job's sessions on the TestMu AI dashboard.

## Test a server running inside the build

To test a web server started inside your Travis CI build, open a TestMu AI tunnel before the
tests run. The tunnel securely connects TestMu AI's browsers to your build VM, so URLs such as
`http://localhost:8080` work.

```yaml
before_script:
  - curl -fsSLo LT https://downloads.lambdatest.com/tunnel/v3/linux/amd64/LT && chmod +x LT
  - ./LT --user "$LT_USERNAME" --key "$LT_ACCESS_KEY" --tunnelName "$TRAVIS_JOB_NUMBER" > tunnel.log 2>&1 &
  - sleep 20
```
{: data-file=".travis.yml"}

Then ask for that tunnel in your capabilities:

```python
lt_options["tunnel"] = True
lt_options["tunnelName"] = os.environ["TRAVIS_JOB_NUMBER"]
```
{: data-file="example.py"}

Naming the tunnel after `TRAVIS_JOB_NUMBER` keeps the jobs of a
[build matrix](/user/customizing-the-build/#build-matrix) apart, so each job's tests go through
its own tunnel.

If the tests can't reach your server, print the tunnel's log in `after_failure`:

```yaml
after_failure:
  - cat tunnel.log
```
{: data-file=".travis.yml"}

For proxies, restricting which hosts go through the tunnel and other options, see the
[tunnel flags][tunnel-flags]. For a full Node.js and Nightwatch example, see
[TestMu AI's Travis CI guide][testmu-travis].
