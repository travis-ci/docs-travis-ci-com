---
title: Building a Ruby Project
layout: en

---

<div id="toc">
</div>

## What This Guide Covers

<aside markdown="block" class="ataglance">

| Ruby                                        | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#Dependency-Management) | `bundle install --jobs=3 --retry=3`       |
| [Default `script`](#Default-Build-Script)   | `rake`                                    |
| [Matrix keys](#Build-Matrix)                | `env`, `rvm`, `gemfile`, `jdk`            |
| Support                                     | [Travis CI](mailto:support@travis-ci.com) |

Minimal example:

```yaml
language: ruby
rvm:
  - 2.2
  - jruby
  - 2.0.0-p247
```
{: data-file=".travis.yml"}

</aside>

{{ site.data.snippets.trusty_note }}

The rest of this guide covers configuring Ruby projects on Travis CI. If you're
new to Travis CI please read our [Getting Started](/user/getting-started/) and
[build configuration](/user/customizing-the-build/) guides first.

## Specifying Ruby versions and implementations

The Ruby environment on Travis CI uses [RVM](https://rvm.io/) to provide many
Ruby implementations, versions and even patch levels.

To specify them, use the `rvm:` key in your `.travis.yml` file:

```yaml
language: ruby
rvm:
  - 2.2
  - jruby
  - 2.0.0-p247
```
{: data-file=".travis.yml"}

> Note that the `rvm:` key is only available in Ruby Build Environments, not in
> other images containing a ruby implementation.

As we upgrade both RVM and Rubies, aliases like `2.2` or `jruby` point to
different exact versions and patch levels.

### Using `.ruby-version`

If the ruby version is not specified by the `rvm` key, Travis CI uses the
version specified in the `.ruby-version` file in the root of the repository if
one is available.

### Rubinius

<!-- distro exception -->

If you're using OS X or Trusty environments, you can also use
[Rubinius](http://rubini.us). To test with Rubinius, add `rbx-X` or `rbx-X.Y.Z`
to your `.travis.yml`, where X.Y.Z specifies a Rubinius release listed on
[http://rubies.travis-ci.org/rubinius](http://rubies.travis-ci.org/rubinius) .

```yaml
language: ruby
dist: trusty
rvm:
  - rbx-3
```
{: data-file=".travis.yml"}

### JRuby: C extensions are not supported

Please note that **C extensions are not supported in JRuby** on Travis CI. The
reason for doing so is to bring it to developers attention that their project
may have dependencies that should not be used on JRuby in production. Using C
extensions on JRuby is technically possible but is not a good idea performance
and stability-wise and we believe continuous integration services like Travis
CI should highlight it.

So if you want to run CI against JRuby, please check that your Gemfile takes
JRuby into account. Most popular C extensions these days also have Java
implementations (json gem, nokogiri, eventmachine, bson gem) or Java
alternatives (like JDBC-based drivers for MySQL, PostgreSQL and so on).

## Default Build Script

On Ruby projects the default build script is `rake`. Add `rake` to the `:test`
group of your Gemfile.

## Dependency Management

### Bundler

Travis CI uses [Bundler](http://bundler.io/) to install your Ruby project's
dependencies if there is a Gemfile in the project's root directory, or if there
is a Gemfile specified in the build matrix:

```bash
bundle install --jobs=3 --retry=3
```

If a Gemfile.lock exists in your project's root directory, we add the
`--deployment` flag.

If you want to use a different means of handling your Ruby project's
dependencies, you can override the `install` command.

```yaml
install: gem install rails
```
{: data-file=".travis.yml"}

By default, gems are installed into vendor/bundle in your project's root
directory.

#### Caching Bundler

Bundler installation can take a while, slowing down your build. You can tell
[Travis CI to cache the installed bundle](/user/caching/).

On your first build, we warm the cache. On the second one, we'll pull in the
cache, making `bundle install` only take seconds to run.

#### Speeding up your build by excluding non-essential dependencies

Lots of project include libraries like `ruby-debug`, `unicorn` or `newrelic_rpm`
in their default set of gems.

This slows down the installation process quite a lot, and commonly, those
libraries aren't needed when running your tests. This also includes libraries
that compile native code, slowing down the installation and overall test times
even more.

On top of that, libraries that implicitly pull in `ruby_core_source` or
`linecache19`, are bound to fail when Travis CI upgrades Ruby versions and
patchlevels.

The same is true for gems that you only need in production, like Unicorn, the
New Relic library, and the like.

You can speed up your installation process by moving these libraries to a
separate section in your Gemfile, e.g. `production`:

```
group :production do
  gem 'unicorn'
  gem 'newrelic_rpm'
end
```

Adjust your Bundler arguments to explicitly exclude this group:

```yaml
bundler_args: --without production
```
{: data-file=".travis.yml"}

Enjoy a faster build, which is also less prone to compilation problems.

#### Custom Bundler arguments and Gemfile locations

The default Gemfile location is the `Gemfile` in the root of your project.

To specify a custom Gemfile name or location:

```yaml
gemfile: gemfiles/Gemfile.ci
```
{: data-file=".travis.yml"}

If you specify the location of your Gemfile in this way, the build will fail if the file is not found.

You can pass [extra arguments](http://bundler.io/v1.3/man/bundle-install.1.html)
 to `bundle install`:

```yaml
bundler_args: --binstubs
```
{: data-file=".travis.yml"}

### Testing against multiple versions of dependencies

Many projects need to be tested against multiple versions of Rack, EventMachine,
HAML, Sinatra, Ruby on Rails,etc.

To test against multiple versions of dependencies:

1. Create a directory in your project's repository root where you will keep
   gemfiles, such as `./gemfiles`.
2. Add one or more gemfiles to it.
3. Set the `gemfile` key in your `.travis.yml`.

Thoughtbot's Paperclip is [tested against multiple ActiveRecord
versions](https://github.com/thoughtbot/paperclip/blob/master/.travis.yml):

```yaml
gemfile:
  - gemfiles/rails2.gemfile
  - gemfiles/rails3.gemfile
  - gemfiles/rails3_1.gemfile
```
{: data-file=".travis.yml"}

An alternative to this is to use environment variables and make your test runner
use them. For example, [Sinatra is tested against multiple Tilt and Rack
versions](https://github.com/sinatra/sinatra/blob/master/.travis.yml):

```yaml
env:
  - "rack=1.3.4"
  - "rack=master"
  - "tilt=1.3.3"
  - "tilt=master"
```
{: data-file=".travis.yml"}

ChefSpec is [tested against multiple Chef
versions](https://github.com/chefspec/chefspec/blob/master/.travis.yml):

```yaml
env:
  - CHEF_VERSION=14.3.37
  - CHEF_VERSION=13.10.0
  - CHEF_VERSION=12.22.5
```
{: data-file=".travis.yml"}

The same technique is often applied to test against multiple databases, templating
engines, hosted service providers and so on.

### `$BUNDLE_GEMFILE` environment variable

When `gemfile` is defined *and* a Gemfile file exists in the repository,
we define the environment variable `$BUNDLE_GEMFILE`, which `bundle install`
uses to resolve dependencies.

If you need to work with multiple Gemfiles within a single job, override
`$BUNDLE_GEMFILE` by passing the `--gemfile=` flag:

```bash
bundle install --gemfile=my_gemfile
```

## JRuby: Testing against multiple JDKs

Test projects against multiple JDKs, by using the `jdk` key in your
`.travis.yml`:

```yaml
jdk:
  - oraclejdk7
  - openjdk7
  - oraclejdk8
```
{: data-file=".travis.yml"}

Each JDK you test against will create permutations with all other
configurations, so to avoid running tests for, say, CRuby 1.9.3 multiple times
you need to add some matrix excludes (described in our [Build Configuration guide](/user/customizing-the-build/)):

```yaml
language: ruby
rvm:
  - 1.9.2
  - jruby-18mode
  - jruby-19mode
  - jruby-head
jdk:
  - openjdk6
  - openjdk7
  - oraclejdk7
matrix:
  exclude:
    - rvm: 1.9.2
      jdk: openjdk6
    - rvm: 1.9.2
      jdk: openjdk7
    - rvm: 1.9.2
      jdk: oraclejdk7
```
{: data-file=".travis.yml"}

For example, see
[travis-support](https://github.com/travis-ci/travis-support/blob/master/.travis.yml).

### Using Java 10 and Up

For testing with OpenJDK and OracleJDK 10 and up, see
[Java documentation](/user/languages/java/#Using-Java-10-and-later).

## Upgrading RubyGems

The RubyGems version installed on Travis CI's Ruby environment depends on what's
installed by the newest Bundler/RubyGems combination, and is kept as up-to-date
as possible.

Should you require the latest version of RubyGems, you can add the following to
your `.travis.yml`:

```yaml
before_install:
  - gem update --system
  - gem --version
```
{: data-file=".travis.yml"}

To downgrade to a specific version of RubyGems:

```yaml
before_install:
  - gem update --system 2.1.11
  - gem --version
```
{: data-file=".travis.yml"}

Note that this will impact your overall test time, as additional network
downloads and installations are required.

## Build Matrix

For Ruby projects, `env`, `rvm`, `gemfile`, and `jdk` can be given as arrays to
construct a [build matrix](/user/customizing-the-build/#Build-Matrix).
