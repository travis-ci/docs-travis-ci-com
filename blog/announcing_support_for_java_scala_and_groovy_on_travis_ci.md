---
title: Announcing Java, Scala and Groovy project support on travis-ci.org
layout: en
created_at: Tue Feb 21 15:00:00 CDT 2012
permalink: announcing_support_for_java_scala_and_groovy_on_travis_ci/
---

Travis CI started in early 2011 as a service for the Ruby community with the simple vision to make CI easy for OSS libraries and services. It wasn't long until we added support for Erlang, Clojure, Node.js and PHP. And, in fact, it is easy to build many other projects by supplying your own commands.

Today we are excited to announce support for Java, Scala, and Groovy!

The JVM ecosystem is very vibrant with multiple exciting languages maturing and being adopted by companies far and wide. In fact, since November 2011 Travis started using the JVM (JRuby) for several of our applications. The JVM and JRuby gave us access to a very solid runtime, as well as a vast selection of stable libraries, helping us to keep up with the growth over the last year.

## Wait, What Is Travis CI Anyway?

[Travis CI](http://travis-ci.org) is a distributed continuous integration for the open source community. It is integrated with GitHub and offers first class support for multiple technologies. Our CI environment provides many tools, libraries, and services (MySQL, PostgreSQL, Redis, RabbitMQ, MongoDB and so on), and you don't have to bother setting up your own CI server.

You can watch build logs in near-real time in your browser, access logs later, and even link to log line numbers (for example, when reporting an issue).

Thanks to Github integration, Travis CI lets your contributors effortlessly add their development forks to test work-in-progress branches and makes your CI status very visible to the community thanks to our [CI badges](http://about.travis-ci.org/docs/user/status-images/).

Started in early 2011, Travis CI has since run half a million builds for over 6,000 open source projects, including Ruby, Ruby on Rails, RubyGems, Node.js, Leiningen, Symfony and many more.



## Getting Your Project on travis-ci.org

Travis CI currently provides OpenJDK 6, Maven 3, SBT 0.11.x and Gradle (currently 1.0 Milestone 8). To get started, you need to add one file
(.travis.yml) and the Github hook as described in the [Getting Started guide](http://about.travis-ci.org/docs/user/getting-started/). If your
project uses Maven or Gradle, a minimal .travis.yml would look like this:

    language: java

for Java, or

    language: groovy

for Groovy and so on. Then Travis will see if you have a `build.gradle` or `pom.xml` file in your repository root and will run the standard dependency installation and testing commands, like

    mvn test

or

    gradle check

It is possible to override these commands and add new ones to the build lifecycle, please refer to [our documentation](http://about.travis-ci.org/), which now includes guides dedicated to [Java](http://about.travis-ci.org/docs/user/languages/java/), [Scala](http://about.travis-ci.org/docs/user/languages/scala/) and [Groovy](http://about.travis-ci.org/docs/user/languages/groovy/).


### Build workflow

Travis' build workflow usually is

 * Clone your repository from GitHub
 * (If applicable) pick language/runtime version to use
 * Run `before_install` commands (can be more than one)
 * Install dependencies. Travis will try to detect whether project uses Gradle and SBT and run their respective commands, falling back to `mvn install`. You can override the command using the `install` key in your .travis.yml.
 * Run one or more `before_script` commands.
 * Run the `script` command, e.g. `gradle check` or `mvn test`, falling back to `ant test`. This too can be overriden in .travis.yml.
 * Report the build has finished running.


### Support for multiple JDKs in the Travis CI Environment

travis-ci.org currently provides only one JDK. This is not on par with our support for Ruby (a dozen of versions/implementations), Erlang (several OTP releases)
and so on. We will add support for testing against multiple JDKs near in the future.

Note that Clojure and Scala build tools allow testing against multiple versions and it is just as valid for Travis CI. This is documented in our guides:

 * [Clojure guide](http://about.travis-ci.org/docs/user/languages/scala/)
 * [Scala guide](http://about.travis-ci.org/docs/user/languages/scala/)


### Learn more

To learn what tools and services (mysql, postgres, riak, etc.) are available in the CI environment, refer to the [CI environment](http://about.travis-ci.org/docs/user/ci-environment/) guide.

If you need help, feel free to join #travis on irc.freenode.net, ping us on Twitter ([@travisci](http://twitter.com/travisci)) and ask questions on [our mailing list](https://groups.google.com/group/travis-ci).



## Thank You Contributors

We would like to thank Gilles Cornu for doing most of the work on the Scala builder and updating our SBT Chef cookbook to 0.11.x.


## Next steps

We don't want to stop here! There are so many other fantastic languages to add, and if all goes well we should have Perl and Python support around the corner. And if you want to help out, [donating to Travis CI](https://love.travis-ci.org) will make it happen sooner.


## Discuss on Hacker News

You can discuss Java, Scala and Groovy support on travis-ci.org [on Hacker News](http://news.ycombinator.com/item?id=3616923)
