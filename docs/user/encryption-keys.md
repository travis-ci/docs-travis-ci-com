---
title: Encryption keys
layout: en
permalink: encryption-keys/
---

Travis generates a pair of private and public RSA keys, which can be used
to encrypt information which you want to put into `.travis.yml` file and
still keep it private. Currently we allow to encrypt
[environment variables](/docs/user/build-configuration/#Secure-environment-variables)
and notification settings.

## Usage

The easiest way to encrypt something with the public key is to use Travis CLI.
This tool is written in ruby and published as a gem. First, you need to install
the gem:

```
gem install travis
```

Then, you can use `encrypt` command to encrypt data (this example assumes you are running the command in your project directory, if not, add `-r owner/project`):

```
travis encrypt "something to encrypt"
```

This will output string looking something like:

```
secure: ".... encrypted data ...."
```

Now you can place it in `.travis.yml` file. You can read more about
[secure environment variables](/docs/user/build-configuration/#Secure-environment-variables)
or [notifications](/docs/user/notifications)

## Fetching the public key for your repository

You can fetch the public key with Travis API, using `/repos/:owner/:name/key` or
`/repos/:id/key` endpoints, for example:

```
https://api.travis-ci.org/repos/travis-ci/travis-ci/key
```
