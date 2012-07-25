---
title: Support for C, C++ and Go projects
layout: post
created_at: Wed Jul 25 13:00:00 CDT 2012
permalink: blog/support_for_go_c_and_cpp
author: Michael Klishin
twitter: michaelklishin
---

Travis CI was designed to be an awesome testing service for anyone and everyone. With over 16,000 projects
on Travis to date, it is not uncommon to see people pushing the boundaries and building projects Travis CI does not have native support for.

Over time we notice that some languages gain enough traction on Travis that it makes sense to provide some sugar so that configuration and setup becomes as simple as counting to three. From fairly early on
we've seen C and C++ projects being built and tested on Travis, as well as a surge of Go projects as of late. 

Today we are happy to announce first class support for C, C++ and Go projects.



### C and C++ support

To tell Travis CI to use the C builder for your project, specify the following:

    language: c

and for C++ it is "cpp":

    language: cpp

By default Travis CI will run

    ./configure && make && make test

to compile your project and run the tests. It is possible to override this behavior by specifying [your own `install:` and `script:` commands](http://about.travis-ci.org/docs/user/build-configuration/).

Historically, Travis CI environment only had GCC (currently 4.6) preinstalled but with the first class support for C and C++ project, we've added Clang (3.1) and introduced a way to switch compilers using the `compiler` key in `.travis.yml`. 

For example, to build with Clang you just need to add the following to your .travis.yml:

    compiler: clang

or both GCC and Clang:

    compiler:
      - clang
      - gcc

Testing against two compilers will create two rows in your build matrix, or possibly more depending on your other configuration settings.  If you are familiar with how testing against multiple Ruby versions or JDKs works on Travis this should sound familiar. 

During each test the Travis CI C builder will export the `CXX` env variable to point to either g++ or clang++ and `CC` to either gcc or clang.

See [C support](http://about.travis-ci.org/docs/user/languages/c/) and [C++ support](http://about.travis-ci.org/docs/user/languages/cpp/) guides for more information.

Some real world examples that already use C++ support and test against both GCC and Clang:

 * [Rubinius](https://github.com/rubinius/rubinius/blob/master/.travis.yml)



### Go Support

Although the Go community is young and practices around continuous integration for Go libraries and applications are still [being discussed](https://groups.google.com/forum/?fromgroups#!topic/golang-nuts/t01qsI40ms4), we have had many people shout out for first class support in Travis.

Travis VMs are 32 bit and currently provide

 * go 1.0
 * core GNU build toolchain (autotools, make), cmake, scons

Go projects on Travis assume you use Make or the Go build tool by default. If there is a Makefile in your repository root Travis will just run `make`, otherwise it will run

    go get -d -v && go build -v

to build your project's dependencies and

    go test -v

to run tests.

To tell Travis CI to pick the Go builder for your project, specify the following:

    language: go

Here are some projects using it today:

 * [peterbourgon/diskv](https://github.com/peterbourgon/diskv/blob/master/.travis.yml)
 * [Go RabbitMQ client](https://github.com/streadway/amqp/blob/master/.travis.yml)

Our documentation guides [cover Go support on Travis CI](http://about.travis-ci.org/docs/user/languages/go/). There is no support for multiple versions of Go because at the moment as the only released version of Go is 1.0.



### Thank you, contributors

Go support was designed and implemented by [Peter Bourgon](https://github.com/peterbourgon) and [Michael Klishin](http://twitter.com/michaelklishin).

C and C++ support was designed and implemented by [Michael Klishin](http://twitter.com/michaelklishin) with help from [Dirkjan Bussink](https://github.com/dbussink).

Happy testing!


The Travis CI Team
