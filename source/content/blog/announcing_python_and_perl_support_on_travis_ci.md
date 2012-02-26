---
title: Announcing Python and Perl project support on Travis CI
kind: article
created_at: Mon Feb 27 15:00:00 CET 2012
---

Just shy of a week ago we announced support for Java, Scala, and Groovy. Well, we thought to ourselves 'we already support 8 languages, why not more?', and MOAR you shall have!

Today we are happy to announce first class support for Python and Perl projects!

Adding support for Perl and Python was a no brainer for us, not that it was easy, because it wasn't, but that both languages were sought after by their respective communities and complete the quest for the three P's (PHP, Perl, and Python). 

Perl, which has been around since 1987 (Genesis ["Land Of Confusion"](http://youtu.be/TlBIa8z_Mts))and has a toolset just as strong and mature as its community. For example, the Perl community has had a variation of Travis for the last 10 years called CPANTesters, with the difference being that CPANTesters tests releases while we test active development.

Python, around since the early 90's (think MC Hammer ["Too Legit to Quit"](http://youtu.be/_UJaLq4YOo0), 1991), and in fact it's OLDER than Java! It is used for pretty much EVERYTHING you can think of, from research at CERN, to build website (YouTube and DISQUS), scripting for Games (Battlefield 2), and scripting for Graphics programs (Autodesk Maya, GIMP, Panda3D and Blender to name a few). Pretty much, you have used Python and you didn't even know it!

## Wait, What Is Travis CI Anyway?

[Travis CI](http://travis-ci.org) is a distributed continuous integration for the open source community. It is integrated with GitHub and offers first class support for multiple technologies. Our CI environment provides many tools, libraries, and services (MySQL, PostgreSQL, Redis, RabbitMQ, MongoDB and so on), and you don't have to bother setting up your own CI server.

You can watch build logs in near-real time in your browser, access logs later, and even link to log line numbers (for example, when reporting an issue).

Thanks to Github integration, Travis CI lets your contributors effortlessly add their development forks to test work-in-progress branches and makes your CI status very visible to the community thanks to our [CI badges](http://about.travis-ci.org/docs/user/status-images/).

Started in early 2011, Travis CI has since run half a million builds for over 6,000 open source projects, including Ruby, Ruby on Rails, RubyGems, Node.js, Leiningen, Symfony and many more.


## Getting Your Python Project on Travis CI

Travis CI provides multiple Python and Perl versions to test against. To get started, you need to add one file
(.travis.yml) and the Github hook as described in the [Getting Started guide](http://about.travis-ci.org/docs/user/getting-started/). A minimal .travis.yml
would look like this:

    language: python
    python:
      - "2.6"
      - "2.7"
      - "3.2"
    # command to install dependencies
    install: pip install -r requirements.txt --use-mirrors
    # command to run tests
    script: nosetests

It is possible to add new commands to the build lifecycle, please refer to [our documentation](http://about.travis-ci.org/), which now includes a guide dedicated to [Python](http://about.travis-ci.org/docs/user/languages/python/).



## Getting Your Perl Project on Travis CI

Travis CI provides three Perl versions to test against. To get started, you need to add one file
(.travis.yml) and the Github hook as described in the [Getting Started guide](http://about.travis-ci.org/docs/user/getting-started/). A minimal .travis.yml
would look like this:

    language: perl
    perl:
      - "5.14"
      - "5.12"

Travis CI will will run widely used

    cpanm --installdeps --notest .

command to install your project's dependencies. For running tests, Travis CI will try to detect `Build.PL` or `Makefile.PL` file in your repository root
and will run either

    perl Build.PL && ./Build test

or

    perl Makefile.PL && make test

It is possible to override these commands and add new ones to the build lifecycle, please refer to [our documentation](http://about.travis-ci.org/), which now includes a guide dedicated to [Perl](http://about.travis-ci.org/docs/user/languages/perl/).




### Build workflow

Travis' build workflow usually is

 * Clone your repository from GitHub
 * Pick language/runtime version to use
 * Run `before_install` commands (can be more than one)
 * Install dependencies. This will use cpanm for Perl and pip for Python. You can override the command using the `install` key in your .travis.yml.
 * Run one or more `before_script` commands.
 * Run the `script` command, e.g. `perl Makefile.PL && make test`. This too can be overriden in .travis.yml. Python projects are required to provide `script:` command.
 * Report the build has finished running.



### Learn more

To learn what tools and services (mysql, postgres, riak, etc.) are available in the CI environment, refer to the [CI environment](http://about.travis-ci.org/docs/user/ci-environment/) guide.

If you need help, feel free to join #travis on irc.freenode.net, ping us on Twitter ([@travisci](http://twitter.com/travisci)) and ask questions on [our mailing list](https://groups.google.com/group/travis-ci).



## Thank You Contributors

We would like to thank [Donald Stufft](http://twitter.com/dstufft), [Kenneth Reitz](http://twitter.com/kennethreitz), [Jannis Leidel](http://twitter.com/jezdez) and [David Reid](http://twitter.com/dreid) for helping us making Python support happen and initial field testing.

Perl support wouldn't be possible without amazing work and advice by [Magnus Holm](http://twitter.com/judofyr), [Jonathan "Duke" Leto](http://twitter.com/dukeleto) (also a big YAY for adding Parrot to Travis CI!), and [Xavier Noria](http://twitter.com/fxn).

Also, if you have a spare minute, send a *HUGE* thanks to [Michael Klishin](http://twitter.com/michaelklishin) who works day and night (seriously, we can not figure out when he sleeps, or if he sleeps!) maintaining the VMs and making sure they are up to date. He was the driving force behind adding support for Clojure, Java, Scala, Groovy, and was instrumental in adding Python and Perl support. So please send him a tweet to say thanks, because without Michael we would still be at just Ruby support!


## Next steps

Python and Perl support brings the total number of languages supported by Travis CI to 10. We love adding support to even more languages, but we think for now we need to focus on features like pre-tested pull requests that will benefit all projects, regardless of the language.

If you want to help us make Travis CI even better, consider [making a donation](https://love.travis-ci.org).
