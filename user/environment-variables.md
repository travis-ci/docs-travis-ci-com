---
title: Environment Variables
layout: en
permalink: environment-variables/
---

A common way to customize the build process is to use environment variables. These can be accessed from any stage in your build process.

<div id="toc"></div>

## Where to define variables

Travis CI offers two different places for defining environment variables: In the [.travis.yml](#Variables-in-the-.travis.yml) or using the [repository settings](#Using-Settings). These differ slightly in their scope.

Variables in the **.travis.yml** are bound to a certain commit. Changing them requires a new commit, restarting an old build will use the old values. They will also be available automatically on forks of the repository.

On the other hand, variables defined in the **repository settings** are the same for all builds. When you restart an old build, it will use the latest values. These variables are not automatically available to forks.

Keep this in mind when choosing where to store which variable.

Examples for using the **.travis.yml**:

* Variables generally needed for the build to run, that don't contain sensitive data. For instance, a test suite for a Ruby application might require `$RACK_ENV` to be set to `test`.
* Variables that have to differ per branch.
* Variables that have to [differ per job](#Matrix-Variables).

Examples for using **repository settings**:

* Variables that have to differ per repository.
* Variables that contain sensitive data, such as third-party credentials.

If you define a variable with the same name in both places, the one from the .travis.yml will override the one from the repository settings.

## Variables in the `.travis.yml`

To specify an environment variable in your `.travis.yml`, add the following line:

    env: DB=postgres

Environment variables are useful for configuring build scripts. See the example in [Database setup](/user/database-setup/#multiple-database-systems).

### Matrix Variables

You can specify more than one environment variable per item in the `env` array:

    rvm:
      - 1.9.3
      - rbx
    env:
      - FOO=foo BAR=bar
      - FOO=bar BAR=foo

With this configuration, **4 individual builds** will be triggered:

1. Ruby 1.9.3 with `FOO=foo` and `BAR=bar`
2. Ruby 1.9.3 with `FOO=bar` and `BAR=foo`
3. Rubinius in 1.8 mode with `FOO=foo` and `BAR=bar`
4. Rubinius in 1.8 mode with `FOO=bar` and `BAR=foo`

Note that environment variable values may need quoting. For example, if they have asterisks (`*`) in them:

    env:
      - PACKAGE_VERSION="1.0.*"

### Global Variables

Sometimes you may want to use env variables that are global to the matrix, i.e. they're inserted into each matrix row. That may include keys, tokens, URIs or other data that is needed for every build. In such cases, instead of manually adding such keys to each env line in matrix, you can use `global` and `matrix` keys to differentiate between those two cases. For example:

    env:
      global:
        - CAMPFIRE_TOKEN=abc123
        - TIMEOUT=1000
      matrix:
        - USE_NETWORK=true
        - USE_NETWORK=false

Such configuration will generate matrix with 2 following env rows:

    USE_NETWORK=true CAMPFIRE_TOKEN=abc123 TIMEOUT=1000
    USE_NETWORK=false CAMPFIRE_TOKEN=abc123 TIMEOUT=1000

## Using Settings

Besides the **.travis.yml**, you can also use the **repository settings** to set an environment variable.

<figure>
  [ ![Environment Variables in the Repository Settings](/images/settings-env-vars.png) ](/images/settings-env-vars.png)
  <figcaption>Environment Variables in the Repository Settings]</figcaption>
</figure>


To do so, make sure you're logged in, navigate to the repository in question, choose "Settings" from the cog menu, and click on "Add new variable" in the "Environment Variables" section.

By default, the value of these new environment variables will be hidden from the `export` line in the logs. This corresponds to the behavior of [encrypted variables](#Secure-Variables) in your .travis.yml.

Similarly, we do not expose these values to untrusted builds, triggered by pull requests from another repository.

As an alternative to the web interface, you can also use the CLI's [`env`](https://github.com/travis-ci/travis.rb#env) command.

## Secure Variables

Additionally, variables can be marked "secure", which will encrypt the content and hide their value from the corresponding `export` line in the build. This can be used to expose sensitive data, like API credentials, to the Travis CI build.

Secure variables will not be added to untrusted builds (ie, builds for pull requests coming from another repository).

### In the .travis.yml

In the previous `.travis.yml` example, one of the environment variables had a token in it. Since putting private tokens in a file in cleartext isn't always the best idea, you might want to encrypt the environment variable. This allows you to keep parts of the configuration private. A configuration with secure environment variables might look something like this:

    env:
      global:
        - secure: <encrypted string here>
        - TIMEOUT=1000
      matrix:
        - USE_NETWORK=true
        - USE_NETWORK=false
        - secure: <you can also put encrypted vars inside matrix>

You can encrypt environment variables using public key attached to your repository. The simplest way to do that is to use travis gem:

    gem install travis
    cd my_project
    travis encrypt MY_SECRET_ENV=super_secret

Please note that secure env variables are not available for pull requests from forks. This is done due to the security risk of exposing such information in submitted code. Everyone can submit a pull request and if an unencrypted variable is available there, it could be easily displayed.

You can also automatically add it to your `.travis.yml`:

    travis encrypt MY_SECRET_ENV=super_secret --add env.matrix

To make the usage of secure environment variables easier, we expose info on their availability and info about the type of this build:

* `TRAVIS_SECURE_ENV_VARS` is set to "true" or "false" depending on the availability of environment variables
* `TRAVIS_PULL_REQUEST`: The pull request number if the current job is a pull request, "false" if it's not a pull request.

Please also note that keys used for encryption and decryption are tied to the repository. If you fork a project and add it to travis, it will have different pair of keys than the original.

The encryption scheme is explained in more detail in [Encryption keys](/user/encryption-keys).