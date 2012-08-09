---
title: Travis Pro
layout: en
permalink: travis-pro/
---

## Travis Pro Frequently Asked Questions

Note: These issues are related to [Travis Pro](http://travis-ci.com), our hosted
continuous integration solution for private repositories.

### How can I configure Travis Pro to use private GitHub repositories as dependencies?

By default Travis focuses its build efforts around a single repository. We set
up a private deploy key for every repository that's enabled to build on Travis
Pro and assign that to the repository. That means we can't simply pull in
dependent repositories, e.g. from your Gemfile or for your Composer setup. The
key can only be assigned to the single repository and not be reused throughout
all of GitHub.

If you need to pull in git submodules or dependent repositories, that's still
easy to achieve, though. You can either specify the dependencies using GitHub's
https URL scheme, which can include username and password, e.g.
`https://user:password@github.com/organization/repo.git`. Ideally the user is a
separate user in your organization that only has read access to the required
repository.

As this doesn't work in all cases, e.g. with Composer, there's an alternative.
It still requires setting up a separate user with pull access to the relevant
repositories. But instead of specifying the username and passwords in for
instance your Gemfile, you add an SSH key specifically for this user and put
that key into your .travis.yml. Here are the steps to take:

* Create a user and add it to your organization, give it pull permission to the
  relevant repositories
* Create an SSH key for the user: `ssh-keygen -f id_mustache_power`
* Add the SSH key to the user on GitHub
* Add a Base64-encoded version of the private key to your .travis.yml. On the
  Mac, you can run `base64 id_mustache_power | pbcopy` to copy the encoded
  version of the key to the clipboard
* Add a new key to your main repositories .travis.yml file: `source_key: `. The
  value of the key should be the encoded version of the SSH key.

Travis will automatically prefer the key specified in your .travis.yml over the
deploy key for a repository, so all repositories you're pulling in for the build
to succeed automatically use this key.

__Note__: this only works on [Travis Pro](http://travis-ci.com), the open source
version of [Travis CI](http://travis-ci.org) doesn't support private
repositories.

##### Technicalities

These steps are necessary due to the way git and the underlying transport SSH
authenticate with a remote service. When you e.g. specify more than one key that
you want SSH to use, it will still use the first one that authenticates
successfully. After authentication, GitHub checks if this key is authorized to
access the repository requested. Given that you rely on SSH to use the second
key you have configured (e.g. by adding it to an ssh-agent), it will fail
because it will try the first one every time, successfully authenticate, but
fail to authorize access, failing the entire git clone operation.

### Can I use pull request testing on Travis Pro?

Yes, you can. It's enabled by default for all repositories set up. Currently,
the only thing you need to do for our trusty travisbot to be able to leave
comments on your pull requests is to add him as a read-only user to the
repositories tested on Travis. These steps aren't necessary for open source
projects, travisbot loves all of them without any manual intervention.
