---
title: Best Practices in Securing Your Data
layout: en
permalink: /user/best-practices-security/
---

## Steps Travis CI takes to secure your data
Travis CI takes a number of steps to ensure secure environment variables and tokens are obfuscated when displayed in the UI. Our [documentation about encryption keys](https://docs.travis-ci.com/user/encryption-keys/) outlines the build configuration we require to ensure this, however, once a VM is booted and tests are running, we have less control over what information utilities or add-ons are able to print to the VM’s standard output. 

In order to prevent leaks made by these components, we automatically filter secure environment variables and tokens at runtime, effectively removing them from the build log. The string `[secure]` will replace potentially leaked secure environment variables and tokens that are longer than three characters. 


## Recommendations on how to avoid leaking secrets to build logs
Despite our best efforts, there are however many ways in which secure information can accidentally be exposed. These vary according to what tools you are using and what settings you have enabled. Some things to look out for are:

* settings which duplicate commands to standard out, such as `set -x` or `set -v` in your bash scripts
* displaying environment variables, by running `env` or `printenv`
* printing secrets within the code, for example `echo $SECRET_KEY`
* using tools that prints out secrets on error, such as `php -i`
* git commands like git fetch or git push may expose GitHub tokens if the command fails
* mistakes in string escaping 
* settings which increase command verbosity
* testing tools or plugins that may expose secrets while operating


Preventing commands from displaying any output is one way to avoid accidentally displaying any secure information. If there is a particular command that is using secure information you can redirect its output to `/dev/null` to make sure it does not accidentally publish anything.

`git push url-with-secret >/dev/null 2>&1`

## If you think that you might have exposed secure information

As an initial step, it’s possible to delete logs containing any secure information by clicking the “Remove log” button in our UI:

![remove log button](/images/remove-log.png "remove log button")

If you discover a leak in one of your build logs it’s essential that you revoke the leaked token or environment variable, and update any build scripts or commands that caused the leak.

## Alternative methods to delete logs that may have exposed secure information

### Using the Travis CI API

Using the log endpoint of the Travis CI API you can delete build logs too:

[For public repositories](https://developer.travis-ci.org/resource/log#delete)

[For private repositories](https://developer.travis-ci.com/resource/log#delete)

You can use our API to find the the Job ID or displayed in the build log after expanding "Build system information". 

For this you would need to have the job IDs belonging to your organization. Those you would get from the [`build` end point](https://developer.travis-ci.com/resource/build#standard-representation).

### Using the Travis Command Line Tool

For instructions on how to delete build logs using the CLI please check https://github.com/travis-ci/travis.rb#logs 
 
## Rotate tokens and secrets periodically
As a general measure, tokens and secrets should be rotated regularly. GitHub OAuth tokens can be found in your [Developer Settings](https://github.com/settings/developers) on the GitHub site. Please regularly rotate credentials for other third-party services as well. 

## More information
The suggestions in this document reflect general recommendations that the Travis CI team and community encourage everyone to follow. However, this list may not be exhaustive, and you should use your best judgement to determine security processes for your project. If you have any questions about security at Travis CI or suspect you may have found a vulnerability, please contact us at <security@travis-ci.com>. 

All other questions about Travis CI  should be directed to <support@travis-ci.com>. 
