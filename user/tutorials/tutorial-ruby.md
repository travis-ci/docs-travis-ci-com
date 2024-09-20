---
title: Use Ruby with Travis CI
layout: en
---

The following is a guide to getting started with Travis CI using Ruby.

## Prerequisite
To get started, create a `.travis.yml` file and add it to the root directory of your Ruby project.

## Specify the Language and Version
Define the Ruby version you want Travis CI to test against. The example below uses Ruby versions 2.7 and 3.0.

```yaml
language: ruby
rvm:
  - 2.7
  - 3.0
```
{: data-file=".travis.yml"}

## Install Build Dependencies
Install your dependencies via Bundler by using the `bundle install` command. 

```yaml
install:
  - bundle install
``` 
{: data-file=".travis.yml"}

## Define the Test Command
Specify a command to run your tests. The example below uses `RSpec`:

 ```yaml
script:
  - bundle exec rspec
 ```
{: data-file=".travis.yml"}

## Commit and Push 
Push the `.travis.yml` file to your repository, and Travis CI runs the tests for your Ruby project. The following is the complete example:

```yaml
language: ruby
rvm:
  - 2.7
  - 3.0
install:
  - bundle install
script:
  - bundle exec rspec
```
{: data-file=".travis.yml"}

## Further Reading
For more information on Ruby projects, see:
* [Building a Ruby Project](/user/languages/ruby/)
