---
title: Encryption keys
layout: en
permalink: encryption-keys/
---

Travis generates a pair of private and public RSA keys which can be used
to encrypt information which you will want to put into the `.travis.yml` file and
still keep it private. Currently we allow encryption of
[environment variables](/docs/user/build-configuration/#Secure-environment-variables), notification settings, and deploy api keys.

## Usage

The easiest way to encrypt something with the public key is to use Travis CLI.
This tool is written in Ruby and published as a gem. First, you need to install
the gem:

    gem install travis

Then, you can use `encrypt` command to encrypt data (This example assumes you are running the command in your project directory. If not, add `-r owner/project`):

    travis encrypt "something to encrypt"

This will output a string looking something like:

    secure: ".... encrypted data ...."

Now you can place it in the `.travis.yml` file. You can read more about
[secure environment variables](/docs/user/build-configuration/#Secure-environment-variables)
or [notifications](/docs/user/notifications).

## Fetching the public key for your repository

You can fetch the public key with Travis API, using `/repos/:owner/:name/key` or
`/repos/:id/key` endpoints, for example:

    https://api.travis-ci.org/repos/travis-ci/travis-ci/key

You can also use the `travis` tool for retrieving said key:

    travis pubkey

Or, if you're not in your project directory:

    travis pubkey -r owner/project
