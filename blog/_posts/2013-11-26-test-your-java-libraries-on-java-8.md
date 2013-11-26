---
title: Test Your Java Libraries on Java 8
created_at: Tue 26 Nov 2013 17:00:00 CET
author: Mathias Meyer
twitter: roidrage
permalink: blog/2013-11-26-test-your-java-libraries-on-java-8
layout: post
---
<figure class="right smaller">
  <img src="http://www.eclipse.org/xtend/images/java8_logo.png"/>
</figure>

[Java 8](https://jdk8.java.net) is close to general availability and being
officially shipped as a stable release. It's coming [packed with lots of
goodies](http://www.techempower.com/blog/2013/03/26/everything-about-java-8/),
including Lambdas!

I don't know about you, but I'm rather excited about what's in stock for it.
Heck, almost the entire Travis CI stack runs on the JVM by way of
[JRuby](http://jruby.org).

Today we're thrilled to announce that Oracle JDK 8 Early Access is now available
for testing on Travis CI!

The fine folks at Oracle (and us, of course!) would love for you to try it out
and make sure all bugs and issues are ironed out before the general release.

To start building your projects on JDK 8, update your `.travis.yml` to include
`oraclejdk8`:

    language: java
    jvm:
      - oracle8

This is a great opportunity to not only make sure your code runs properly on the
upcoming release, but also to report any bugs that come up trying it out. The
folks from Oracle would [love to hear your
feedback](http://bugreport.sun.com/bugreport/), be it bugs, issues, or success
stories. For deeper discussion, make sure to follow the [JDK
8](http://mail.openjdk.java.net/mailman/listinfo/jdk8-dev) mailing list

JRuby is already testing on JDK 8, now it's your turn!

To find out about all the goodness included in Java 8, [TechEmpower has a great
blog post with lots of
detail](http://www.techempower.com/blog/2012/03/26/everything-about-java-8/) and
here's a [great list of resources on lambdas and
streams](http://javarevisited.blogspot.ca/2013/11/java-8-tutorials-resources-and-examples-lambda-expression-stream-api-functional-interfaces.html#more).

Java 8 Early Access SDKs are available on [travis-ci.org](https://travis-ci.org)
today, and we'll have it available on [travis-ci.com](https://travis-ci.com)
later this week!
