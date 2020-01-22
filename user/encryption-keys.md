---
title: Encryption keys
layout: en

---

**We have separate documentation on [encrypting files](/user/encrypting-files/).**

A repository's `.travis.yml` file can have "encrypted values", such as [environment variables](/user/environment-variables/), notification settings, and deploy api keys. These encrypted values can be added by anyone, but are only readable by Travis CI. The repository owner does not keep any secret key material.

**Please note that encrypted environment variables are not available for [pull requests from forks](/user/pull-requests#pull-requests-and-security-restrictions).**

## Encryption scheme

Travis CI uses asymmetric cryptography. For each registered repository, Travis CI generates an RSA keypair.
Travis CI keeps the private key private, but makes the repository's public key available to those who have access to the repository.

Once the public key is available, anyone (including those without push access to
your repository) can encrypt data which can only be decrypted by Travis CI,
using the corresponding private key.

### Obtaining the public keys

The method to obtain the public key depends on where the target repository
exists, and the API version you are using.

Furthermore, the request may require authorization via the `Authorization: token`
header depending on the repository's location and visibility, as well as
the API version used.

<table>
  <caption><tt>Authorization</tt> header requirement</caption>
  <tr>
    <th rowspan="2">Repository visibility and location</th>
    <th rowspan="2">API server</th>
    <th>API v1</th>
    <th>API v3</th>
  </tr>
  <tr>
    <td><tt>/repos/OWNER/REPO/key</tt></td>
    <td><tt>/v3/repo/OWNER%2fREPO/key_pair/generated</tt></td>
  </tr>
  <tr>
    <td>.org</td>
    <td><a href="https://api.travis-ci.org">https://api.travis-ci.org</a></td>
    <td>no</td>
    <td>yes</td>
  </tr>
  <tr>
    <td>public on .com</td>
    <td><a href="https://api.travis-ci.com">https://api.travis-ci.com</a></td>
    <td>yes<br></td>
    <td>yes<br></td>
  </tr>
  <tr>
    <td>private on .com</td>
    <td><a href="https://api.travis-ci.com">https://api.travis-ci.com</a></td>
    <td>yes<br></td>
    <td>yes</td>
  </tr>
</table>

> Notice that API v3 endpoints above show the repository name with `%2f`.

If the `Authorization: token` header is required, you can obtain the token by
visiting the account page:
- [travis-ci.org](https://travis-ci.org/account/preferences)
- [travis-ci.com](https://travis-ci.com/account/preferences)

### Examples

Here are some examples of `curl` commands to obtain the public key.

1. A public repository on travis-ci.org using API v1

       curl https://api.travis-ci.org/repos/travis-ci/travis-build/key

1. A public repository on travis-ci.org using API v3

       curl -H "Authorization: token **TOKEN**" https://api.travis-ci.org/v3/repo/travis-ci%2ftravis-build/key_pair/generated

1. A private repository on travis-ci.com using API v3

       curl -H "Authorization: token **TOKEN**" https://api.travis-ci.com/v3/repo/OWNER%2fREPO/key_pair/generated

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
travis encrypt 'FOO=6\&a\(5\!1Ab\\'
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
