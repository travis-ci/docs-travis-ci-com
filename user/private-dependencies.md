---
title: Private Dependencies
layout: en

---

*Some of the features described here are currently **only available for private repositories on [travis-ci.com](https://travis-ci.com)**.*

When testing a private repository, you might need to pull in other private
repositories as dependencies via [git
submodules](http://git-scm.com/book/en/Git-Tools-Submodules), a custom script,
or a dependency management tool like [Bundler](http://bundler.io/) or
[Composer](https://getcomposer.org/).

Git submodules must be cloned early on in the build process, and so must use
either the [Deploy Key](#deploy-key) or [User Key](#user-key) method.

If the dependency is also on GitHub, there are four different ways of fetching
the repository from within a Travis CI VM. Each one has advantages and
disavantages, so read each method carefully and pick the one that applies best
to your situation.

| Authentication                | Protocol | Dependency URL format | Gives access to              | Notes                               |
|:------------------------------|:---------|:----------------------|:-----------------------------|:------------------------------------|
| **[Deploy Key](#deploy-key)** | SSH      | `git@github.com/…`    | single repository            | used by default for main repository |
| **[User Key](#user-key)**     | SSH      | `git@github.com/…`    | all repos user has access to | **recommended** for dependencies    |
| **[Password](#password)**     | HTTPS    | `https://…`           | all repos user has access to | password can be encrypted           |
| **[API token](#api-token)**   | HTTPS    | `https://…`           | all repos user has access to | token can be encrypted              |

You can use a [dedicated CI user account](#dedicated-user-account) for all but
the deploy key approach. This allows you to limit access to a well defined list
of repositories, and make sure that access is read only.

## Deploy Key

GitHub allows you to set up SSH keys for a repository. These deploy keys have some great advantages:

- They are not bound to a user account, so they will not get invalidated by removing users from a repository.
- They do not give access to other, unrelated repositories.
- The same key can be used for dependencies not stored on GitHub.

However, using deploy keys is complicated by the fact that GitHub does not allow you to reuse keys. So a single private key cannot access multiple GitHub repositories.

You could include a different private key for every dependency in the repository, possibly [encrypting them](/user/encrypting-files). Maintaining complex dependency graphs this way can be complex and hard to maintain. For that reason, we recommend using a [user key](#user-key) instead.

## User Key

*Custom SSH keys are currently **only available for private repositories on [travis-ci.com](https://travis-ci.com)**.*

You can add SSH keys to user accounts on GitHub. Most users have probably already done this to be able to clone the repositories locally.

This way, a single key can access multiple repositories. To limit the list of repositories and type of access, it is recommended to create a [dedicated CI user account](#dedicated-user-account).

### Using an existing key

[ ![Adding an SSH key via the web interface.](/images/settings-ssh-key.png) ](/images/settings-ssh-key.png){:.small}{:.right}

Assumptions:

- The repository you are running the builds for is called "myorg/main" and depends on "myorg/lib1" and "myorg/lib2".
- You have a key already set up on your machine, for instance under `~/.ssh/id_rsa` (default on Unix systems).

You can add a new key using the repository settings. Paste the contents of `~/.ssh/id_rsa` into the "Private Key" text field and give it a nice description.

Alternatively, you can use the following [CLI](https://github.com/travis-ci/travis.rb) command to add the key to Travis CI:

```bash
$ travis sshkey --upload ~/.ssh/id_rsa -r myorg/main
Key description: Key to clone myorg/lib1 and myorg/lib2
updating ssh key for myorg/main with key from ~/.ssh/id_rsa
Current SSH key: Key to clone myorg/lib1 and myorg/lib2
```

You can omit the `-r myorg/main` if your current working directory is a clone of the "myorg/main" repository.

### Generating a new key

Assumptions:

- The repository you are running the builds for is called "myorg/main" and depends on "myorg/lib1" and "myorg/lib2".
- You know the credentials for a user account that has at least read access to all three repositories.

The `travis` command line tool can generate a new key for you and set it up on both Travis CI and GitHub. In order to do so, it will ask you for a GitHub user name and password This is very handy if you have just created a [dedicated user](#dedicated-user-account) or if you don't have a key set up on your machine that you want to use.

The credentials will only be used to access GitHub and will not be stored or shared with any other service.

```bash
$ travis sshkey --generate -r myorg/main
We need the GitHub login for the account you want to add the key to.
This information will not be sent to Travis CI, only to api.github.com.
The password will not be displayed.

Username: ci-user
Password for ci-user: **************

Generating RSA key.
Uploading public key to GitHub.
Uploading private key to Travis CI.

You can store the private key to reuse it for other repositories (travis sshkey --upload FILE).
Store private key? |no|

Current SSH key: key for fetching dependencies for myorg/main
```

You can omit the `-r myorg/main` if your current working directory is a clone of the "myorg/main" repository.

At the end of the process, it will ask you whether you want to store the generated key somewhere, usually it is safe to say "no" here. After all, you can just generate a new key as necessary. See [below](#reusing-a-generated-key) for instructions on storing and reusing a generated key.

### Reusing a generated key

Assumptions:

- The repository you are running the builds for is called "myorg/main" and depends on "myorg/lib1" and "myorg/lib2".
- You know the credentials for a user account that has at least read access to all three repositories.
- You only want to generate a single key, so you can revoke it easily or use it for accessing other sourced for dependencies or deploy targets.

This is absolutely optional, nothing keeps you from generating new keys for all the repositories you are testing.

You follow the [steps above](#generating-a-new-key), but choose to store the key. It will ask you for a path to store it under.

```bash
$ travis sshkey --generate -r myorg/main --description "CI dependencies"
We need the GitHub login for the account you want to add the key to.
This information will not be sent to Travis CI, only to api.github.com.
The password will not be displayed.

Username: ci-user
Password for ci-user: **************

Generating RSA key.
Uploading public key to GitHub.
Uploading private key to Travis CI.

You can store the private key to reuse it for other repositories (travis sshkey --upload FILE).
Store private key? |no| yes
Path: |id_travis_rsa| myorg_key

Current SSH key: CI dependencies
```

And as always, you can omit the `-r myorg/main` if your current working directory is a clone of the "myorg/main" repository.

You can then [upload](#using-an-existing-key) the key for myorg/main2:

```bash
$ travis sshkey --upload myorg_key -r myorg/main2 --description "CI dependencies"
updating ssh key for myorg/main with key from myorg_key
Current SSH key: CI dependencies
```

Starting with the 1.7.0 release of the `travis` command line tool, you are able to combine it with the `repos` command to set up the key not only for "main" and "main2", but all repositories under the "myorg" organization.

```bash
$ travis repos --active --owner myorg --com | xargs -I % travis sshkey --upload myorg_key -r % --description "CI dependencies"
updating ssh key for myorg/main with key from myorg_key
Current SSH key: CI dependencies
updating ssh key for myorg/main2 with key from myorg_key
Current SSH key: CI dependencies
updating ssh key for myorg/lib1 with key from myorg_key
Current SSH key: CI dependencies
updating ssh key for myorg/lib2 with key from myorg_key
Current SSH key: CI dependencies
```

> Note that if you're still using [travis-ci.org](http://www.travis-ci.org) you need to use `--org` instead of `--com`.

## Password

Assumptions:

- The repository you are running the builds for is called "myorg/main" and depends on "myorg/lib1" and "myorg/lib2".
- You know the credentials for a user account that has at least read access to all three repositories.

To pull in dependencies with a password, you will have to use the user name and password in the Git HTTPS URL: `https://ci-user:mypassword123@github.com/myorg/lib1.git`.

Alternatively, you can also write the credentials to the `~/.netrc` file:

```
machine github.com
  login ci-user
  password mypassword123
```


You can also encrypt the password and then write it to the netrc in a `before_install` step in your `.travis.yml`:

```bash
$ travis env set CI_USER_PASSWORD mypassword123 --private -r myorg/main
```

```bash
before_install:
- echo -e "machine github.com\n  login ci-user\n  password $CI_USER_PASSWORD" > ~/.netrc
```

It is also possible to inject the credentials into URLs, for instance, in a Gemfile, it would look like this:

```ruby
source 'https://rubygems.org'
gemspec

if ENV['CI']
  # use HTTPS with password on Travis CI
  git_source :github do |repo_name|
    repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
    "https://ci-user:#{ENV.fetch("CI_USER_PASSWORD")}@github.com/#{repo_name}.git"
  end
end

gem 'lib1', github: "myorg/lib1"
gem 'lib2', github: "myorg/lib2"
```

> In case of private git submodules, be aware that the `git submodule
> update --init recursive` command runs before the `~/.netrc` credentials
> are updated. If you are writing credentials to `~/.netrc`, disable the automatic loading of
> submodules, update the credentials and add an explicit step to update the submodules:
>
> ```yaml
> git:
>   submodules: false
> before_install:
>   - echo -e "machine github.com\n  login ci-user\n  password $CI_USER_PASSWORD" >~/.netrc
>   - git submodule update --init --recursive
> ```
> {: data-file=".travis.yml"}

## API Token

Assumptions:

- The repository you are running the builds for is called "myorg/main" and depends on "myorg/lib1" and "myorg/lib2".
- You know the credentials for a user account that has at least read access to all three repositories.

This approach works just like the [password](#password) approach outlined above, except instead of the username/password pair, you use a GitHub API token.

Under the GitHub account settings for the user you want to use, navigate to [Settings > Developer settings](https://github.com/settings/developers), and then generate a "Personal access tokens". Make sure the token has the "repo" scope.

Your `~/.netrc` should look like this:

```
machine github.com
  login the-generated-token
```

You can also use it in URLs directly: `https://the-generated-token@github.com/myorg/lib1.git`.

Use the `encrypt` command to add the token to your `.travis.yml`.

```bash
$ travis env set CI_USER_TOKEN the-generated-token --private -r myorg/main
```

You can then have Travis CI write to the `~/.netrc` on every build.

```yaml
before_install:
- echo -e "machine github.com\n  login $CI_USER_TOKEN" > ~/.netrc
```
{: data-file=".travis.yml"}

It is also possible to inject the token into URLs, for instance, in a Gemfile, it would look like this:

```ruby
source 'https://rubygems.org'
gemspec

if ENV['CI']
  # use HTTPS with token on Travis CI
  git_source :github do |repo_name|
    repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
    "https://#{ENV.fetch("CI_USER_TOKEN")}@github.com/#{repo_name}.git"
  end
end

gem 'lib1', github: "myorg/lib1"
gem 'lib2', github: "myorg/lib2"
```

> In case of private git submodules, be aware that the `git submodule
> update --init recursive` command runs before the `~/.netrc` credentials
> are updated. If you are writing credentials to `~/.netrc`, disable the automatic loading of
> submodules, update the credentials and add an explicit step to update the submodules:
>
> ```yaml
> git:
>   submodules: false
> before_install:
>   - echo -e "\n\nmachine github.com\n  $CI_TOKEN\n" >~/.netrc
>   - git submodule update --init --recursive
> ```
> {: data-file=".travis.yml"}

## Dedicated User Account

As mentioned a few times, it might make sense to create a dedicated CI user for the following reasons:

- The CI user will only have access to the repositories you want it to have access to.
- You can limit the access to read access.
- Less risk when it comes to leaking keys or credentials.
- The CI user will not leave the organization for non-technical reasons and accidentally break all your builds.

In order to do so, you need to register on GitHub as if you would be signing up for a normal user.  Registering users cannot be automated, since that would violate the GitHub Terms of Service.
