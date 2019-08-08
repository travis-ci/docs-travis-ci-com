---
title: Coveralls
layout: en

---

[Coveralls](https://coveralls.io/) is a hosted analysis tool, providing statistics about your code coverage.

Configuring your Travis CI build to send results to Coveralls always follows the same pattern:

1. Add your repository to Coveralls.
2. Configure your build to install the Coveralls library for the programming language you're using.
3. Add Coveralls to your test suite.
4. If you're using Travis CI for private repos, add `service_name: travis-pro` to your `.coveralls.yml`.

We'll show you how to do this for Ruby in the following example.

## Using Coveralls with Ruby

Using Coveralls with Ruby on Travis CI is one of the configurations Coveralls support out of the box [have documentation for](https://coveralls.zendesk.com/hc/en-us/articles201769485-Ruby-Rails).

### 1. Add your repository to Coveralls

1. [Sign in to Coveralls](https://coveralls.io/authorize/github)  with your *GitHub* account.
2. Click *ADD REPOS* in the menu.
3. Click the ![Add your repository to Coveralls](/images/coveralls-button.png) button next to your repository.

### 2. Install the Coveralls Gem

Add the Coveralls Gem to your `Gemfile`:

```ruby
# ./Gemfile

gem 'coveralls', require: false
```

You might need to update your `Gemfile.lock` as well.

### 3. Add Coveralls to your test suite

Add Coveralls to the top your test suite, before you `require` any application code:

```ruby
# ./spec/spec_helper.rb
# ./test/test_helper.rb
# ..etc..

require 'coveralls'
Coveralls.wear!
```

After those three steps, the next time you push a commit, you'll be able to look up your [code coverage statistics](https://coveralls.io)!

## Coveralls and private repositories

If you're using Coveralls with Travis CI for private repositories, edit `.coveralls.yml`:

```yaml
service_name: travis-pro
```
{: data-file=".coveralls.yml"}

## Using Coveralls with other languages

Coveralls have documentation for many other programming languages:

- [C / C++](https://docs.coveralls.io/c)
- [D](https://docs.coveralls.io/d)
- [Elixir](https://docs.coveralls.io/elixir)
- [Erlang](https://docs.coveralls.io/erlang)
- [Fortran](https://docs.coveralls.io/fortran)
- [Go](https://docs.coveralls.io/go)
- [Haskell](https://docs.coveralls.io/haskell)
- [Java](https://docs.coveralls.io/java)
- [Javascript & Node](https://docs.coveralls.io/javascript)
- [Julia](https://docs.coveralls.io/julia)
- [Lua](https://docs.coveralls.io/lua)
- [OCaml](https://docs.coveralls.io/ocaml)
- [Objective C](https://docs.coveralls.io/objective-c)
- [PHP](https://docs.coveralls.io/php)
- [Python](https://docs.coveralls.io/python)
- [R](https://docs.coveralls.io/r)
- [Ruby / Rails](https://docs.coveralls.io/ruby-on-rails)
- [Swift](https://docs.coveralls.io/swift)

## Using Coveralls with Docker builds

If you're using Docker in builds, ensure that the necessary environment variables are exposed to the container:
```sh
docker exec -e TRAVIS_JOB_ID="$TRAVIS_JOB_ID" -e TRAVIS_BRANCH="$TRAVIS_BRANCH" ...
```
