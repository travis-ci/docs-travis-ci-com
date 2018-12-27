---
title: Best Practices in Securing Your Data
layout: en

---

## Steps Travis CI takes to secure your data
Travis CI obfuscates secure environment variables and tokens displayed in the UI. Our [documentation about encryption keys](/user/encryption-keys/) outlines the build configuration we require to ensure this, however, once a VM is booted and tests are running, we have less control over what information utilities or add-ons are able to print to the VM’s standard output.

To prevent leaks made by these components, we automatically filter secure environment variables and tokens that are longer than three characters at runtime, effectively removing them from the build log, displaying the string `[secure]` instead.

Please make sure your secret is never related to the repository or branch name, or any other guessable string. Ideally use a password generation tool such as `mkpasswd` instead of choosing a secret yourself.

## Recommendations on how to avoid leaking secrets to build logs
Despite our best efforts, there are however many ways in which secure information can accidentally be exposed. These vary according to what tools you are using and what settings you have enabled. Some things to look out for are:

* settings which duplicate commands to standard output, such as `set -x` or `set -v` in your bash scripts
* displaying environment variables, by running `env` or `printenv`
* printing secrets within the code, for example `echo "$SECRET_KEY"`
* using tools that print secrets on error output, such as `php -i`
* git commands like `git fetch` or `git push` may expose tokens or other secure environment variables
* mistakes in string escaping
* settings which increase command verbosity
* testing tools or plugins that may expose secrets while operating

Preventing commands from displaying any output is one way to avoid accidentally displaying any secure information. If there is a particular command that is using secure information you can redirect its output to `/dev/null` to make sure it does not accidentally publish anything, as shown in the following example:

```sh
git push url-with-secret >/dev/null 2>&1
```

## If you think that you might have exposed secure information

As an initial step, it’s possible to delete logs containing any secure information by clicking the *Remove log* button on the build log page of Travis CI.

![remove log button](/images/remove-log.png "remove log button")

If you discover a leak in one of your build logs it’s essential that you revoke the leaked token or environment variable, and update any build scripts or commands that caused the leak.

### Alternative methods of deleting logs

Instead of deleting build logs manually, you can do so using the [Travis CI CLI](https://github.com/travis-ci/travis.rb#logs) or the  [API](https://developer.travis-ci.com/resource/log#delete).

> Note that if you're still using [travis-ci.org](http://www.travis-ci.org) you need to use the [open source API](https://developer.travis-ci.org/resource/log#delete) instead.

## Rotate tokens and secrets periodically
Rotate your tokens and secrets regularly. GitHub OAuth tokens can be found in your [Developer Settings](https://github.com/settings/developers) on the GitHub site. Please regularly rotate credentials for other third-party services as well.

## More information
The suggestions in this document reflect general recommendations that the Travis CI team and community encourage everyone to follow. However, suggestions here are not exhaustive, and you should use your best judgement to determine security processes for your project. If you have any questions about security at Travis CI or suspect you may have found a vulnerability, please contact us at <security@travis-ci.com>.

All other questions about Travis CI should be directed to <support@travis-ci.com>.
