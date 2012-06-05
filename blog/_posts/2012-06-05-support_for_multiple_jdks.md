---
title: Support for multiple JDKs
layout: post
created_at: Tue Jun 05 04:00:00 CDT 2012
permalink: blog/support_for_multiple_jdks
author: Michael Klishin
twitter: michaelklishin
---

Every new feature starts with a developer wanting to scratch an itch.

When Travis CI started in early 2011, one of the goals behind it was to make CI for everyone, including ourselves. Back then the Ruby community was in full swing moving to Ruby 1.9, and most popular projects supported 1.9 unknowingly, but it was common to run into issues with projects that either did not test against 1.9, or tested against 1.9 but not 1.8. So one of the features that was added very early on was ability to easily test against multiple versions and implementations of Ruby in the simplest way possible.

Fast forward to around August 2011. We were working on the Erlang support, the first additional language to be added to Travis, and had a question to face: should multi-runtime support be a Ruby-specific feature or should we try to do the same for more languages if we can? It was a no brainer: easy CI against multiple runtimes is too awesome a feature to pass by. So we launched Erlang support with multiple Erlang/OTP versions from the start.

Today you can test your projects in several languages against multiple releases or implementations. Sometimes we did not have to do any work to make this happen: Clojure and Scala build tools, ([Leiningen](http://leiningen.org) and SBT, respectively), for example, let you test against multiple versions without having to install several versions of Clojure or Scala.

However, up until now, we only provided a single JDK version: OpenJDK 6. Out of eleven languages with first class support on Travis CI, five run on the JVM: Clojure, Groovy, Java, Ruby, and Scala. But some of the projects already target JDK 7-specific features, for example, the Fork/Join framework.

### So without a further ado...

Today we are happy to announce support for multiple JDKs!!!

This will work for Clojure, Groovy, Java, Ruby and Scala. We hope this feature will make OpenJDK 7 migration even smoother and will make the lives of many developer communities a little bit more enjoyable. This includes the Travis CI core team, since a large chunk of Travis CI itself runs on the JVM :)


### How do I turn it on already?

To test against multiple JDKs, list them using the `:jdk` key in your `.travis.yml`:

    jdk:
      - openjdk7
      - openjdk6
      - oraclejdk7

It is that simple and that easy!

You can specify one, two or all jdk keys, and it works the same way for Java, Clojure and so on.

Here are some real examples:

 * [travis-ci/travis-support](https://github.com/travis-ci/travis-support/blob/master/.travis.yml)
 * [technomancy/leiningen](https://github.com/technomancy/leiningen/blob/master/.travis.yml)
 * [michaelklishin/monger](https://github.com/michaelklishin/monger/blob/master/.travis.yml)
 * [resthub/resthub](https://github.com/resthub/resthub-spring-stack/blob/master/.travis.yml)

Just in case, our documentation guides are updated to mention this feature.


### The Road to OpenJDK 7

But there is more. Today, if you don't specify what JDK version Travis CI should use you get OpenJDK 6. JDK 6 was released in 2006 and reaches
end-of-life in November 2012. 

OpenJDK 7 has been around for almost one year and ships with many long awaited features, including the crown jewel  [invokedynamic](http://download.oracle.com/javase/7/docs/technotes/guides/vm/multiple-language-support.html), a new JVM instruction that makes it possible for language implementers to take advantage of JVM optimizations that were previously (virtually) inaccessible to them. This feature is not just for dynamic languages like JRuby, Clojure and Groovy: there are projects that make use of invokedynamic for Scala, for example. Upcoming versions of Ubuntu and Fedora will use OpenJDK 7 by default as well. 

Take a look at [what JRuby developers have in mind for JDK 7 users](http://blog.headius.com/2011/08/jruby-and-java-7-what-to-expect.html).

So, on June 18th, 2012, OpenJDK 7 will be *the default JDK on Travis CI*. We think it's about time, but don't worry, OpenJDK 6 will still be around for those who need it.

To get OpenJDK 7 on Linux, use your package manager, it should be available in all recent releases. For Windows, use Oracle's [JDK 7 distribution](http://www.oracle.com/technetwork/java/javase/downloads/jdk-7u4-downloads-1591156.html).
For Mac OS X, you can either use [Oracle JDK 7 for OS X](http://www.oracle.com/technetwork/java/javase/downloads/jdk-7u4-downloads-1591156.html) or one of the [OpenJDK 7 for OS X](http://code.google.com/p/openjdk-osx-build/) packages by Henri Gomez.

To learn more about JDK 6 and JDK 7 differences, see

 * [JDK 7 compatibility guide](http://www.oracle.com/technetwork/java/javase/compatibility-417013.html)
 * [JDK 7 adoption guide](http://docs.oracle.com/javase/7/docs/webnotes/adoptionGuide/index.html) (an overview of why you


### Thank you, contributors

This feature was designed and implemented by [Loïc Frering](http://twitter.com/loicfrering) and [Michael Klishin](http://twitter.com/michaelklishin).

We would like to thank [Henri Gomez](http://twitter.com/hgomez) for his work on packaging [OpenJDK 7 and OpenJDK 8 for OS X](http://code.google.com/p/openjdk-osx-build/). Getting a recent
OpenJDK 7 build on OS X cannot possibly be easier than that.


### Discuss

Feel free to [upvote and discuss this feature on Hacker News](http://news.ycombinator.com/item?id=4068927).


Happy testing!


The Travis CI Team
