---
title: Announcing Haskell project support
layout: post
created_at: Mon Mar 12 10:00:00 CDT 2012
permalink: blog/announcing_support_for_haskell_on_travis_ci
author: Michael Klishin
twitter: michaelklishin
---

## Travis' Eleven

Today we are happy to announce support for an 11th language on Travis CI: Haskell. Known for its concision and very advanced type system, Haskell
has been attracting some of the brightest minds in the programming languages research community for a couple of decades.

Haskell can be found in [code analysis tools](http://vimeo.com/6699769), [DSLs for cryptographic algorithms](http://corp.galois.com/cryptol/),
[secure networking stack implementations](http://corp.galois.com/hans), [network applications](http://www.janrain.com/blogs/haskell-janrain), plenty of financial software
and even [system administration](http://k1024.org/~iusty/papers/icfp10-haskell-reagent.pdf). So Haskell sounds like the right candidate to complete
Travis' Eleven.


## Wait, What Is Travis CI Anyway?

[Travis CI](http://travis-ci.org) is a distributed continuous integration for the open source community. It is integrated with GitHub and offers first class support for multiple technologies. Our CI environment provides many tools, libraries, and services (MySQL, PostgreSQL, Redis, RabbitMQ, MongoDB and so on), and you don't have to bother setting up your own CI server.

You can watch build logs in near-real time in your browser, access logs later, and even link to log line numbers (for example, when reporting an issue).

Thanks to GitHub integration, Travis CI lets your contributors effortlessly add their development forks to test work-in-progress branches and makes your CI status very visible to the community thanks to our [CI badges](http://about.travis-ci.org/docs/user/status-images/).

Started in early 2011, Travis CI has since run half a million builds for over 7,000 open source projects, including Ruby, Ruby on Rails, RubyGems, Node.js, Leiningen, Symfony and many more.



## Getting Your Project on Travis CI

Travis CI currently provides [Haskell Platform](http://hackage.haskell.org/platform/contents.html) 2011.04 (with GHC 7, Cabal, Happy, Alex and so on). To get started, you need to add one file
(.travis.yml) and the GitHub hook as described in the [Getting Started guide](http://about.travis-ci.org/docs/user/getting-started/). If your
project uses Cabal, a minimal .travis.yml would look like this:

    language: haskell

Travis CI will run the dependency installation command:

    cabal install 

and then the testing commands:

    cabal configure --enable-tests && cabal build && cabal test

It is possible to override these commands and add new ones to the build lifecycle, please refer to [our documentation](http://about.travis-ci.org/), which now includes
a guide dedicated to [Haskell](http://about.travis-ci.org/docs/user/languages/haskell/).


### Build workflow

By default Travis' build workflow is

 * Clone your repository from GitHub
 * (If applicable) pick language/runtime version to use
 * Run `before_install` commands (can be more than one)
 * Install dependencies. Travis will use `cabal install` by default. You can override the command using the `install` key in your .travis.yml.
 * Run one or more `before_script` commands.
 * Run the `script` command, e.g. `cabal build && cabal test`. This too can be overridden in .travis.yml.
 * Report the build has finished running.


### Learn more

To learn what tools and services (MySQL, Postgres, Riak, etc.) are available in the CI environment, refer to the [CI environment](http://about.travis-ci.org/docs/user/ci-environment/) guide.

If you need help, feel free to join #travis on chat.freenode.net, ping us on Twitter ([@travisci](http://twitter.com/travisci)) and ask questions on [our mailing list](https://groups.google.com/group/travis-ci).



## Thank You Contributors

We would like to thank [Alessandro Vermeulen](http://alessandrovermeulen.me) for his help with making Haskell support on Travis CI a reality.
