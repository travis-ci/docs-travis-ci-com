---
title: Coveralls
layout: en
permalink: /user/coveralls/
---

[Coveralls](https://coveralls.io/) is a hosted analysis tool, providing statistics about your code coverage.

Configuring your Travis CI build to send results to Coveralls always follows the same pattern:

1. Add your repository to Coveralls.
1. Configure your build to install the Coveralls library for the programming language you're using.
1. Add Coveralls to your test suite.
1. If you're using Travis CI for private repos, add `service_name: travis-pro` to your `.coveralls.yml `.

We'll show you how to do this for Ruby in the following example.

## Using Coveralls with Ruby

Using Coveralls with Ruby on Travis CI is one of the configurations Coveralls support out of the box [have documentation for](https://coveralls.zendesk.com/hc/en-us/articles/201769485-Ruby-Rails).

### 1. Add your repository to Coveralls

1. [Sign in to Coveralls](https://coveralls.io/authorize/github)  with your *GitHub* account.
1. Click *ADD REPOS* in the menu.
1. Click the ![Add your repository to Coveralls](/images/coveralls-button.png) button next to your repository.

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

## Using Coveralls with other languages

Coveralls have documentation for many other [programming languages](https://coveralls.zendesk.com/hc/en-us/sections/200330349-Languages):

[C / C++](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/201342798-C-C-)
[D](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/204189714-D)
[Elixir](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/206207885-Elixir)
[Fortran](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/204446934-Fortran)
[Go](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/201342808-Go)
[Haskell](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/201342818-Haskell)
[Java](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/201342828-Java)
[Javascript &amp; Node](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/201769714-Javascript-Node)
[Julia](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/203487968-Julia)
[Lua](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/202044414-Lua)
[OCaml](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/201769724-OCaml)
[Objective C](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/204190274-Objective-C)
[PHP](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/201769734-PHP)
[Python](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/201342868-Python)
[R](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/203487908-R)
[Ruby / Rails](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/201769484-Ruby-Rails)
[Scala](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/201342878-Scala)
[Swift](https://coveralls.zendesk.com/hc/en-us/articles/hc/en-us/articles/208113435-Swift)
