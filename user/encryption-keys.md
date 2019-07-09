---
title: Encryption keys
layout: en

---

**We have separate documentation on [encrypting files](/user/encrypting-files/).**

A repository's `.travis.yml` file can have "encrypted values", such as [environment variables](/user/environment-variables/), notification settings, and deploy api keys. These encrypted values can be added by anyone, but are only readable by Travis CI. The repository owner does not keep any secret key material.

**Please note that encrypted environment variables are not available for [pull requests from forks](/user/pull-requests#pull-requests-and-security-restrictions).**

## Encryption scheme

Travis CI uses asymmetric cryptography. For each registered repository, Travis CI generates an RSA keypair. Travis CI keeps the private key private, but makes the repository's public key available to everyone. For example, the GitHub repository `foo/bar` has its public key available at `https://api.travis-ci.org/repos/foo/bar/key`. Anyone can run `travis encrypt` for any repository, which encrypts the arguments using the repository's public key. Therefore, `foo/bar`'s encrypted values can be decrypted by Travis CI, using `foo/bar`'s private key, but the values cannot be decrypted by anyone else (not even the encrypter, or "owner" of the `foo/bar` repository!).

## Usage

The easiest way to encrypt something with the public key is to use Travis CLI.
This tool is written in Ruby and published as a gem. First, you need to install
the gem:

```bash
gem install travis
```

If you are using [travis-ci.com](https://travis-ci.com) instead of [travis-ci.org](https://travis-ci.org), you need to login first:

```bash
travis login --pro
```

Then, you can use `encrypt` command to encrypt data (This example assumes you are running the command in your project directory. If not, add `-r owner/project`):

```bash
travis encrypt SOMEVAR="secretvalue"
```

Or, if you are using [travis-ci.com](https://travis-ci.com), you will need to add `--pro` to the CLI:

```bash
travis encrypt --pro SOMEVAR="secretvalue"
```

This will output a string looking something like:

```yaml
secure: ".... encrypted data ...."
```
{: data-file=".travis.yml"}

Now you can place it in the `.travis.yml` file.

You can also skip the above, and add it automatically by running:
```bash
travis encrypt SOMEVAR="secretvalue" --add
```

Please note that the name of the environment variable and its value are both encoded in the string produced by "travis encrypt." You must add the entry to your .travis.yml with key "secure" (underneath the "env" key). This makes the environment variable SOMEVAR with value "secretvalue" available to your program.

You may add multiple entries to your .travis.yml with key "secure." They will all be available to your program.

Encrypted values can be used in
[secure environment variables in the build matrix](/user/environment-variables#defining-encrypted-variables-in-travisyml)
and [notifications](/user/notifications).

### Note on escaping certain symbols

When you use `travis encrypt` to encrypt sensitive data, it is important to note that it will
be processed as a `bash` statement.
This means that secret you are encrypting should not cause errors when `bash` parses it.
Having incomplete data will cause `bash` to dump the error statement to the log, which
contains portions of your sensitive data.

Thus, you need to escape [special characters](http://www.tldp.org/LDP/abs/html/special-chars.html)
such as braces, parentheses, backslashes, and pipe symbols.

For example, you would type `ma&w!doc` as `ma\&w\!doc`.

And to assign the string `6&a(5!1Ab\` to `FOO`:

```bash
travis encrypt "FOO=6\\&a\\(5\\!1Ab\\\\"
```

`travis` encrypts the string `FOO=6\&a\(5\!1Ab\\`, which then `bash` uses to evaluate in the build environment.

Equivalently, you can do

```bash
travis encrypt 'FOO=6\&a\(5\!1AB\\'
```

### Notifications Example

We want to add campfire notifications to our .travis.yml file, but we don't want to publicly expose our API token.

The entry should be in this format:

```yaml
notifications:
  campfire:
    rooms: "[subdomain]:[api token]@[room id]"
```
{: data-file=".travis.yml"}

For us, that is somedomain:abcxyz@14.

We encrypt this string

```bash
travis encrypt somedomain:abcxyz@14
```

Which produces something like this

```
Please add the following to your .travis.yml file:

  secure: "ABC5OwLpwB7L6Ca...."
```

We add to our .travis.yml file

```yaml
notifications:
  campfire:
    rooms:
      secure: "ABC5OwLpwB7L6Ca...."
```
{: data-file=".travis.yml"}

And we're done.

### Detailed Discussion

The secure var system takes values of the form `{ 'secure' => 'encrypted string' }` in the (parsed YAML) configuration and replaces it with the decrypted string.

So

```yaml
notifications:
  campfire:
    rooms:
      secure: "encrypted string"
```
{: data-file=".travis.yml"}

becomes

```yaml
notifications:
  campfire:
    rooms: "decrypted string"
```
{: data-file=".travis.yml"}

while

```yaml
notifications:
  campfire:
    rooms:
      - secure: "encrypted string"
```
{: data-file=".travis.yml"}

becomes

```yaml
notifications:
  campfire:
    rooms:
      - "decrypted string"
```
{: data-file=".travis.yml"}

In the case of secure env vars

```yaml
env:
  - secure: "encrypted string"
```
{: data-file=".travis.yml"}

becomes

```yaml
env:
  - "decrypted string"
```
{: data-file=".travis.yml"}

## Fetching the public key for your repository

You can fetch the public key with Travis API, using `/repos/:owner/:name/key` or
`/repos/:id/key` endpoints, for example:

```
https://api.travis-ci.org/repos/travis-ci/travis-ci/key
```

You can also use the `travis` tool for retrieving said key:

```bash
travis pubkey
```

Or, if you're not in your project directory:

```bash
travis pubkey -r owner/project
```

Note, travis uses `travis.slug` in your project to determine the endpoints if it exists (check by using `git config --local travis.slug`), if you rename your repo or move your repo to another user/organization, you might need to change it.
