---
title: Private Dependencies Assembla
layout: en
permalink: /user/private-dependencies-assembla/

---

*Some of the features described here are currently **only available for private repositories on [travis-ci.com](https://travis-ci.com)**.*

When testing a private repository, you might need to pull in other private
repositories as dependencies via [git
submodules](http://git-scm.com/book/en/Git-Tools-Submodules), a custom script,
or a dependency management tool like [Bundler](http://bundler.io/) or
[Composer](https://getcomposer.org/).

Git submodules must be cloned early on in the build process, and so must use
either the [Deploy Key](#deploy-key) or [User Key](#user-key) method.

If the dependency is also on Assembla, there are several different ways of fetching
the repository from within a Travis CI VM. Each one has advantages and
disavantages, so read each method carefully and pick the one that applies best
to your situation.

| Authentication                | Protocol | Dependency URL format | Gives access to              | Notes                               |
|:------------------------------|:---------|:----------------------|:-----------------------------|:------------------------------------|
| **[Deploy Key](#deploy-key)** | SSH      | `git@assembla.com/…`    | single repository            | used by default for main repository |
| **[Repo Key](#repo-key)**     | SSH      | `git@assembla.com/…`    | all repos user has access to | **recommended** for dependencies    |
| **[Password](#password)**     | HTTPS    | `https://…`           | all repos user has access to | password can be encrypted           |
| **[API token](#api-token)**   | HTTPS    | `https://…`           | all repos user has access to | token can be encrypted              |

You can use a [dedicated CI user account](#dedicated-user-account) for all but
the deploy key approach. This allows you to limit access to a well defined list
of repositories, and make sure that access is read only.

## Deploy Key

Assembla allows you to set up SSH keys for a repository. These deploy keys have some great advantages:

- They are not bound to a user account, so they will not get invalidated by removing users from a repository.
- They do not give access to other, unrelated repositories.
- The same key can be used for dependencies not stored on Assembla.

However, using deploy keys is complicated by the fact that Assembla does not allow you to reuse keys.
So a single private key cannot access multiple Assembla repositories.

You could include a different private key for every dependency in the repository, possibly [encrypting them](/user/encrypting-files).
Maintaining complex dependency graphs this way can be complex and hard to maintain. For that reason, we recommend using a
[repo key](#repo-key) instead.

## Repo Key
Travis CI will add a new access key for your repository. It will allow us to read the travis.yml file content.


## Password

Assumptions:

- The repository you are running the builds for is called "myorg/main" and depends on "myorg/lib1" and "myorg/lib2".
- You know the credentials for a user account that has at least read access to all three repositories.

To pull in dependencies with a password, you will have to use the user name and password in the Git HTTPS URL: `https://ci-user:mypassword123@github.com/myorg/lib1.git`.

Alternatively, you can also write the credentials to the `~/.netrc` file:

```
machine assembla.com
  login ci-user
  password mypassword123
```


You can also encrypt the password and then write it to the netrc in a `before_install` step in your `.travis.yml`:

```bash
$ travis env set CI_USER_PASSWORD mypassword123 --private -r myorg/main
```

```bash
before_install:
- echo -e "machine assembla.com\n  login ci-user\n  password $CI_USER_PASSWORD" > ~/.netrc
```

It is also possible to inject the credentials into URLs, for instance, in a Gemfile, it would look like this:

```ruby
source 'https://rubygems.org'
gemspec

if ENV['CI']
  # use HTTPS with password on Travis CI
  git_source :assembla do |repo_name|
    repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
    "https://ci-user:#{ENV.fetch("CI_USER_PASSWORD")}@assembla.com/#{repo_name}.git"
  end
end

gem 'lib1', assembla: "myorg/lib1"
gem 'lib2', assembla: "myorg/lib2"
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
>   - echo -e "machine assembla.com\n  login ci-user\n  password $CI_USER_PASSWORD" >~/.netrc
>   - git submodule update --init --recursive
> ```
> {: data-file=".travis.yml"}

## API Token

Assumptions:

- The repository you are running the builds for is called "myorg/main" and depends on "myorg/lib1" and "myorg/lib2".
- You know the credentials for a user account that has at least read access to all three repositories.

This approach works just like the [password](#password) approach outlined above, except instead of the username/password pair,
you use a Assembla API token.

Under the Assembla account settings for the user you want to use, navigate to

and then generate a "Personal access tokens".

Make sure the token has the "repo" scope.

Your `~/.netrc` should look like this:

```
machine assembla.com
  login the-generated-token
```

You can also use it in URLs directly: `https://the-generated-token@assembla.com/myorg/lib1.git`.

Use the `encrypt` command to add the token to your `.travis.yml`.

```bash
$ travis env set CI_USER_TOKEN the-generated-token --private -r myorg/main
```

You can then have Travis CI write to the `~/.netrc` on every build.

```yaml
before_install:
- echo -e "machine assembla.com\n  login $CI_USER_TOKEN" > ~/.netrc
```
{: data-file=".travis.yml"}

It is also possible to inject the token into URLs, for instance, in a Gemfile, it would look like this:

```ruby
source 'https://rubygems.org'
gemspec

if ENV['CI']
  # use HTTPS with token on Travis CI
  git_source :assembla do |repo_name|
    repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
    "https://#{ENV.fetch("CI_USER_TOKEN")}@assembla.com/#{repo_name}.git"
  end
end

gem 'lib1', assembla: "myorg/lib1"
gem 'lib2', assembla: "myorg/lib2"
```

> In case of private git submodules, be aware that the `git submodule
> update --init --recursive` command runs before the `~/.netrc` credentials
> are updated. If you are writing credentials to `~/.netrc`, disable the automatic loading of
> submodules, update the credentials and add an explicit step to update the submodules:
>
> ```yaml
> git:
>   submodules: false
> before_install:
>   - echo -e "\n\nmachine assembla.com\n  $CI_TOKEN\n" >~/.netrc
>   - git submodule update --init --recursive
> ```
> {: data-file=".travis.yml"}

## Dedicated User Account

As mentioned a few times, it might make sense to create a dedicated CI user for the following reasons:

- The CI user will only have access to the repositories you want it to have access to.
- You can limit the access to read access.
- Less risk when it comes to leaking keys or credentials.
- The CI user will not leave the organization for non-technical reasons and accidentally break all your builds.

In order to do so, you need to register on Assembla as if you would be signing up for a normal user.
Registering users cannot be automated, since that would violate the Assembla Terms of Service.
