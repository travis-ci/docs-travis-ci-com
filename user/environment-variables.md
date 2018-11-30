---
title: Environment Variables
layout: en

---

A common way to customize the build process is to define environment variables, which can be accessed from any stage in your build process.



The best way to define an environment variable depends on what type of information it will contain, and when you need to change it:

- if it does *not* contain sensitive information, might be different for different branches and should be available to forks -- [add it to your .travis.yml](#defining-encrypted-variables-in-travisyml)
- if it *does* contain sensitive information, and might be different for different branches -- [encrypt it and add it to your .travis.yml](#defining-encrypted-variables-in-travisyml)
- if it *does* contain sensitive information, but is the same for all branches -- [add it to your Repository Settings](#defining-variables-in-repository-settings)

## Defining public variables in .travis.yml

Public variables defined in `.travis.yml` are tied to a certain commit. Changing them requires a new commit, restarting an old build uses the old values. They are also available automatically on forks of the repository.

Define variables in `.travis.yml` that:

- are needed for the build to run and that don't contain sensitive data. For instance, a test suite for a Ruby application might require `$RACK_ENV` to be set to `test`.
- differ per branch.
- differ per job.

Define environment variables in your `.travis.yml` in the `env` key, quoting special characters such as asterisks (`*`).
One build will triggered for each line in the `env` array.

```yaml
env:
  - DB=postgres
  - SH=bash
  - PACKAGE_VERSION="1.0.*"
```
{: data-file=".travis.yml"}

> If you define a variable with the same name in `.travis.yml` and in the Repository Settings, the one in `.travis.yml` takes precedence. If you define a variable in `.travis.yml` as both encrypted and unencrypted, the one defined later in the file takes precedence.

### Defining Multiple Variables per Item

If you need to specify several environment variables for each build, put them all on the same line in the `env` array:

```yaml
rvm:
  - 1.9.3
  - rbx-3
env:
  - FOO=foo BAR=bar
  - FOO=bar BAR=foo
```
{: data-file=".travis.yml"}

this configuration triggers **4 individual builds**:

1. Ruby 1.9.3 with `FOO=foo` and `BAR=bar`
2. Ruby 1.9.3 with `FOO=bar` and `BAR=foo`
3. Rubinius latest version (rbx-3) with `FOO=foo` and `BAR=bar`
4. Rubinius latest version (rbx-3) with `FOO=bar` and `BAR=foo`

### Global Variables

Sometimes you may want to use environment variables that are global to the matrix, i.e. they're inserted into each matrix row. That may include keys, tokens, URIs or other data that is needed for every build. In such cases, instead of manually adding such keys to each `env` line in matrix, you can use `global` and `matrix` keys to differentiate between those two cases. For example:

```yaml
env:
  global:
    - CAMPFIRE_TOKEN=abc123
    - TIMEOUT=1000
  matrix:
    - USE_NETWORK=true
    - USE_NETWORK=false
```
{: data-file=".travis.yml"}

triggers builds with the following `env` rows:

```bash
USE_NETWORK=true CAMPFIRE_TOKEN=abc123 TIMEOUT=1000
USE_NETWORK=false CAMPFIRE_TOKEN=abc123 TIMEOUT=1000
```

## Defining encrypted variables in .travis.yml

{: #Encrypted-Variables}

Before adding sensitive data such as API credentials to your `.travis.yml` you need to encrypt it. Encrypted variables are not available to untrusted builds such as pull requests coming from another repository.

A `.travis.yml` file containing encrypted variables looks like this:

```yaml
env:
  global:
    - secure: mcUCykGm4bUZ3CaW6AxrIMFzuAYjA98VIz6YmYTmM0/8sp/B/54JtQS/j0ehCD6B5BwyW6diVcaQA2c7bovI23GyeTT+TgfkuKRkzDcoY51ZsMDdsflJ94zV7TEIS31eCeq42IBYdHZeVZp/L7EXOzFjVmvYhboJiwnsPybpCfpIH369fjYKuVmutccD890nP8Bzg8iegssVldgsqDagkuLy0wObAVH0FKnqiIPtFoMf3mDeVmK2AkF1Xri1edsPl4wDIu1Ko3RCRgfr6NxzuNSh6f4Z6zmJLB4ONkpb3fAa9Lt+VjJjdSjCBT1OGhJdP7NlO5vSnS5TCYvgFqNSXqqJx9BNzZ9/esszP7DJBe1yq1aNwAvJ7DlSzh5rvLyXR4VWHXRIR3hOWDTRwCsJQJctCLpbDAFJupuZDcvqvPNj8dY5MSCu6NroXMMFmxJHIt3Hdzr+hV9RNJkQRR4K5bR+ewbJ/6h9rjX6Ot6kIsjJkmEwx1jllxi4+gSRtNQ/O4NCi3fvHmpG2pCr7Jz0+eNL2d9wm4ZxX1s18ZSAZ5XcVJdx8zL4vjSnwAQoFXzmx0LcpK6knEgw/hsTFovSpe5p3oLcERfSd7GmPm84Qr8U4YFKXpeQlb9k5BK9MaQVqI4LyaM2h4Xx+wc0QlEQlUOfwD4B2XrAYXFIq1PAEic=
  matrix:
    - USE_NETWORK=true
    - USE_NETWORK=false
    - secure: <you can also put encrypted vars inside matrix>
```
{: data-file=".travis.yml"}

> Encrypted environment variables are not available to pull requests from forks due to the security risk of exposing such information to unknown code.
>
> If you define a variable with the same name in `.travis.yml` and in the Repository Settings, the one in `.travis.yml` takes precedence. If you define a variable in `.travis.yml` as both encrypted and unencrypted, the one defined later in the file takes precedence.

### Encrypting environment variables

Encrypt environment variables with the public key attached to your repository using the `travis` gem:

1. If you do not have the `travis` gem installed, run `gem install travis`.

2. In your repository directory, run:

   ```bash
   travis encrypt MY_SECRET_ENV=super_secret --add env.matrix
   ```

3. Commit the changes to your `.travis.yml`.

> Encryption and decryption keys are tied to the repository. If you fork a project and add it to Travis CI, it will *not* have access to the encrypted variables.

The encryption scheme is explained in more detail in [Encryption keys](/user/encryption-keys).

## Defining Variables in Repository Settings

{{ site.data.snippets.environment_variables }}

To define variables in Repository Settings, make sure you're logged in, navigate to the repository in question, choose "Settings" from the cog menu, and click on "Add new variable" in the "Environment Variables" section.

<figure>
  <img alt="Screenshot of environment variables in settings" src="{{ "/images/settings-env-vars.png" | prepend: site.baseurl }}">
  <figcaption>Environment Variables in the Repository Settings</figcaption>
</figure>

> These values are used directly in your build, so make sure to escape [special characters (for bash)](http://www.tldp.org/LDP/abs/html/special-chars.html) accordingly. In particular, if a value contains spaces, you should put quotes around that value. E.g. `my secret passphrase` should be written `"my secret passphrase"`.

By default, the value of these new environment variables is hidden from the `export` line in the logs. This corresponds to the behavior of [encrypted variables](#Encrypted-Variables) in your `.travis.yml`. The variables are stored encrypted in our systems, and get decrypted when the build script is generated.

Similarly, we do not provide these values to untrusted builds, triggered by pull requests from another repository.

As an alternative to the web interface, you can also use the CLI's [`env`](https://github.com/travis-ci/travis.rb#env) command.

> If you define a variable with the same name in `.travis.yml` and in the Repository Settings, the one in `.travis.yml` takes precedence.

## Convenience Variables

To make using encrypted environment variables easier, the following environment variables are available:

- `TRAVIS_SECURE_ENV_VARS` is set to `true` if you have defined any encrypted variables, including variables defined in the Repository Settings, and `false` if you have not.
- `TRAVIS_PULL_REQUEST` is set to the pull request number if the current job is a pull request build, or `false` if it's not.

## Default Environment Variables

The following default environment variables are available to all builds.

- `CI=true`
- `TRAVIS=true`
- `CONTINUOUS_INTEGRATION=true`
- `DEBIAN_FRONTEND=noninteractive`
- `HAS_JOSH_K_SEAL_OF_APPROVAL=true`
- `USER=travis`
- `HOME` is set to `/home/travis` on Linux, `/Users/travis` on MacOS, and
    `/c/Users/travis` on Windows.
- `LANG=en_US.UTF-8`
- `LC_ALL=en_US.UTF-8`
- `RAILS_ENV=test`
- `RACK_ENV=test`
- `MERB_ENV=test`
- `JRUBY_OPTS="--server -Dcext.enabled=false -Xcompile.invokedynamic=false"`
- `JAVA_HOME` is set to the appropriate value.

Additionally, Travis CI sets environment variables you can use in your build, e.g.
to tag the build, or to run post-build deployments.

- `TRAVIS_ALLOW_FAILURE`:
  + set to `true` if the job is allowed to fail.
  + set to `false` if the job is not allowed to fail.
- `TRAVIS_APP_HOST`: The name of the server compiling the build script. This server serves certain helper files
  (such as `gimme`, `nvm`, `sbt`) from `/files` to avoid external network calls; e.g., `curl -O $TRAVIS_APP_HOST/files/gimme`
- `TRAVIS_BRANCH`:
  + for push builds, or builds not triggered by a pull request, this is the name of the branch.
  + for builds triggered by a pull request this is the name of the branch targeted by the pull
  request.
  + for builds triggered by a tag, this is the same as the name of the tag (`TRAVIS_TAG`).

      > Note that for tags, git does not store the branch from which a commit was tagged.

- `TRAVIS_BUILD_DIR`: The absolute path to the directory where the repository
  being built has been copied on the worker.
- `TRAVIS_BUILD_ID`: The id of the current build that Travis CI uses internally.
- `TRAVIS_BUILD_NUMBER`: The number of the current build (for example, "4").
- `TRAVIS_BUILD_WEB_URL`: URL to the build log.
- `TRAVIS_COMMIT`: The commit that the current build is testing.
- `TRAVIS_COMMIT_MESSAGE`: The commit subject and body, unwrapped.
- `TRAVIS_COMMIT_RANGE`: The range of commits that were included in the push
  or pull request. (Note that this is empty for builds triggered by the initial commit of a new branch.)
- `TRAVIS_EVENT_TYPE`: Indicates how the build was triggered. One of `push`, `pull_request`, `api`, `cron`.
- `TRAVIS_JOB_ID`: The id of the current job that Travis CI uses internally.
- `TRAVIS_JOB_NAME`: The [job name](https://docs.travis-ci.com/user/build-stages/#naming-your-jobs-within-build-stages) if it was specified, or `""`.
- `TRAVIS_JOB_NUMBER`: The number of the current job (for example, "4.1").
- `TRAVIS_JOB_WEB_URL`: URL to the job log.
- `TRAVIS_OS_NAME`: On multi-OS builds, this value indicates the platform the job is running on.
  Values are `linux` and `osx` currently, to be extended in the future.
- `TRAVIS_OSX_IMAGE`: The `osx_image` value configured in `.travis.yml`. If this is not set in `.travis.yml`,
  it is empty.
- `TRAVIS_PULL_REQUEST`: The pull request number if the current job is a pull
  request, "false" if it's not a pull request.
- `TRAVIS_PULL_REQUEST_BRANCH`:
  + if the current job is a pull request, the name of the branch from which the PR originated.
  + if the current job is a push build, this variable is empty (`""`).
- `TRAVIS_PULL_REQUEST_SHA`:
  + if the current job is a pull request, the commit SHA of the HEAD commit of the PR.
  + if the current job is a push build, this variable is empty (`""`).
- `TRAVIS_PULL_REQUEST_SLUG`:
  + if the current job is a pull request, the slug (in the form `owner_name/repo_name`) of the repository from which the PR originated.
  + if the current job is a push build, this variable is empty (`""`).
- `TRAVIS_REPO_SLUG`: The slug (in form: `owner_name/repo_name`) of the repository currently being built.
- `TRAVIS_SECURE_ENV_VARS`:
  + set to `true` if there are any encrypted environment variables.
  + set to `false` if no encrypted environment variables are available.
- `TRAVIS_SUDO`: `true` or `false` based on whether `sudo` is enabled.
- `TRAVIS_TEST_RESULT`: **0** if all commands in the `script` section (up to the point this environment variable is referenced) have exited with zero; **1** otherwise.
- `TRAVIS_TAG`: If the current build is for a git tag, this variable is set to the tag's name.
- `TRAVIS_BUILD_STAGE_NAME`: The [build stage](/user/build-stages/) in capitalized form, e.g. `Test` or `Deploy`. If a build does not use build stages, this variable is empty (`""`).

Language-specific builds expose additional environment variables representing
the current version being used to run the build. Whether or not they're set
depends on the language you're using.

- `TRAVIS_DART_VERSION`
- `TRAVIS_GO_VERSION`
- `TRAVIS_HAXE_VERSION`
- `TRAVIS_JDK_VERSION`
- `TRAVIS_JULIA_VERSION`
- `TRAVIS_NODE_VERSION`
- `TRAVIS_OTP_RELEASE`
- `TRAVIS_PERL_VERSION`
- `TRAVIS_PHP_VERSION`
- `TRAVIS_PYTHON_VERSION`
- `TRAVIS_R_VERSION`
- `TRAVIS_RUBY_VERSION`
- `TRAVIS_RUST_VERSION`
- `TRAVIS_SCALA_VERSION`

Other software specific environment variables are set when the software or service is installed or started, and contain the version number:

- `TRAVIS_MARIADB_VERSION`

The following environment variables are available for Objective-C builds.

- `TRAVIS_XCODE_SDK`
- `TRAVIS_XCODE_SCHEME`
- `TRAVIS_XCODE_PROJECT`
- `TRAVIS_XCODE_WORKSPACE`
