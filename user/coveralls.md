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
{: data-file=".travis.yml"}

## Using Coveralls with other languages

Coveralls have documentation for many other [programming languages](https://coveralls.zendesk.com/hc/en-us/sections/200330349-Languages):

- [C / C++](https://coveralls.zendesk.com/hc/en-us/articles/201342799-C-C-)
- [D](https://coveralls.zendesk.com/hc/en-us/articles/204189715)
- [Elixir](https://coveralls.zendesk.com/hc/en-us/articles/206207886)
- [Fortran](https://coveralls.zendesk.com/hc/en-us/articles/204446935)
- [Go](https://coveralls.zendesk.com/hc/en-us/articles/201342809-Go)
- [Haskell](https://coveralls.zendesk.com/hc/en-us/articles/201342819-Haskell)
- [Java](https://coveralls.zendesk.com/hc/en-us/articles/201342829-Java)
- [Javascript & Node](https://coveralls.zendesk.com/hc/en-us/articles/201769715-Javascript-Node)
- [Julia](https://coveralls.zendesk.com/hc/en-us/articles/203487969)
- [Lua](https://coveralls.zendesk.com/hc/en-us/articles/202044415-Lua)
- [OCaml](https://coveralls.zendesk.com/hc/en-us/articles/201769725-OCaml)
- [Objective C](https://coveralls.zendesk.com/hc/en-us/articles/204190275)
- [PHP](https://coveralls.zendesk.com/hc/en-us/articles/201769735-PHP)
- [Python](https://coveralls.zendesk.com/hc/en-us/articles/201342869-Python)
- [R](https://coveralls.zendesk.com/hc/en-us/articles/203487909)
- [Ruby / Rails](https://coveralls.zendesk.com/hc/en-us/articles/201769485-Ruby-Rails)
- [Swift](https://coveralls.zendesk.com/hc/en-us/articles/208113436)
