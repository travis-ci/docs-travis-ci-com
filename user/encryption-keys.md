---
title: Encryption keys
layout: en
permalink: /user/encryption-keys/
---

**We have separate documentation on [encrypting files](/user/encrypting-files/).**

Travis CI generates a pair of private and public RSA keys which can be used
to encrypt information which you will want to put into the `.travis.yml` file and
still keep it private. Currently we allow encryption of
[environment variables](/user/environment-variables/), notification settings, and deploy api keys.

**Please note that encrypted environment variables are not available for [pull requests from forks](/user/pull-requests#Security-Restrictions-when-testing-Pull-Requests).**

## Usage

The easiest way to encrypt something with the public key is to use Travis CLI.
This tool is written in Ruby and published as a gem. First, you need to install
the gem:

    gem install travis

Then, you can use `encrypt` command to encrypt data (This example assumes you are running the command in your project directory. If not, add `-r owner/project`):

    travis encrypt SOMEVAR=secretvalue

This will output a string looking something like:

    secure: ".... encrypted data ...."

Now you can place it in the `.travis.yml` file.

Please note that the name of the environment variable and its value are both encoded in the string produced by "travis encrypt." You must add the entry to your .travis.yml with key "secure" (underneath the "env" key). This makes the environment variable SOMEVAR with value "secretvalue" available to your program.

You may add multiple entries to your .travis.yml with key "secure." They will all be available to your program.

Encrypted values can be used in
[secure environment variables in the build matrix](/user/environment-variables#Defining-Variables-in-.travis.yml)
and [notifications](/user/notifications).

### Note on escaping certain symbols

When you use `travis encrypt` to encrypt sensitive data, it is important to note that it will
be processed as a `bash` statement.
This means that secret you are encrypting should not cause errors when `bash` parses it.
Having incomplete data will cause `bash` to dump the error statement to the log, which
contains portions of your sensitive data.

Thus, you need to escape symbols such as braces, parentheses, backslashes, and pipe symbols.
For example, when you want to assign the string `6&a(5!1Ab\` to `FOO`, you need to execute:

    travis encrypt "FOO=6\\&a\\(5\\!1Ab\\\\"

`travis` encrypts the string `FOO=6\&a\(5\!1Ab\\`, which then `bash` uses to evaluate in the build environment.

Equivalently, you can do

    travis encrypt 'FOO=6\&a\(5\!1AB\\'

### Notifications Example

We want to add campfire notifications to our .travis.yml file, but we don't want to publicly expose our API token.

The entry should be in this format:

    notifications:
      campfire: [subdomain]:[api token]@[room id]

For us, that is somedomain:abcxyz@14.

We encrypt this string

    travis encrypt somedomain:abcxyz@14

Which produces something like this

    Please add the following to your .travis.yml file:

      secure: "ABC5OwLpwB7L6Ca...."

We add to our .travis.yml file

    notifications:
      campfire:
        rooms:
          secure: "ABC5OwLpwB7L6Ca...."

And we're done.

### Detailed Discussion

The secure var system takes values of the form ```{ 'secure' => 'encrypted string' }``` in the (parsed YAML) configuration and replaces it with the decrypted string.

So

    notifications:
      campfire:
        rooms:
          secure: "encrypted string"

becomes

    notifications:
      campfire:
        rooms: "decrypted string"

while

    notifications:
      campfire:
        rooms:
          - secure: "encrypted string"

becomes

    notifications:
      campfire:
        rooms:
          - "decrypted string"

In the case of secure env vars

    env:
      - secure: "encrypted string"

becomes

    env:
      - "decrypted string"

## Fetching the public key for your repository

You can fetch the public key with Travis API, using `/repos/:owner/:name/key` or
`/repos/:id/key` endpoints, for example:

    https://api.travis-ci.org/repos/travis-ci/travis-ci/key

You can also use the `travis` tool for retrieving said key:

    travis pubkey

Or, if you're not in your project directory:

    travis pubkey -r owner/project
