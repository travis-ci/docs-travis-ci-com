---
title: Travis Artifacts
layout: post
created_at: Tue 18 Dec 16:00:00 CET
author: Piotr Sarnacki
twitter: drogus
permalink: blog/2012-12-18-travis-artifacts
---

TL;DR Travis prepares a solution to easily upload files produced while
running tests to any external storage service. If you want to test it,
you can go straight to [install instructions](#how-to-use).

Travis is already very good at running your tests, but we feel that we can
do much better job with things that happen **after** the tests have
finished running. First step in this direction is what we call build artifacts.
Artifacts are files, which are produced while running the tests. It may be
compiled version of a library, screenshots done while running your tests in the browser
or logs that can help with debugging test failures.

### How to use?

We chose to start with something very simple, so [travis-artifacts](https://github.com/travis-ci/travis-artifacts)
is just a simple gem that is not built into travis architecture in any way.

In order to use artifacts you need to do a couple steps:

1. At this point we support only s3, so you need s3 account and credentials. After grabbing the
   information from your account, you need to add it to `.travis.yml` using 4 env variables:

   - `ARTIFACTS_S3_BUCKET`
   - `ARTIFACTS_AWS_REGION` - the default is `us-east-1`
   - `ARTIFACTS_AWS_ACCESS_KEY_ID`
   - `ARTIFACTS_AWS_SECRET_ACCESS_KEY`

   Last 2 vars should be kept secret, so you should encrypt them using `travis` gem, just like this:

       travis encrypt owner/repo_name ARTIFACTS_AWS_ACCESS_KEY_ID=abc123

   In the end your .travis.yml should look something like:

       env:
        global:
          - "ARTIFACTS_AWS_REGION=us-east-1"
          - "ARTIFACTS_S3_BUCKET=drogus-artifacts"
          - secure: ".......long encrypted string............."
          - secure: ".......another long encrypted string....."

2. Next thing is to install `travis-artifacts` gem in `before_script` stage,
   simply add this to your `.travis.yml`:

        before_script:
          - "gem install travis-artifacts"

3. And finally we can add lines that will upload your files:

       after_script:
         - "travis-artifacts upload --path logs --path a/long/nested/path:short_alias"
       after_failure: # this will of course run only on failure
         - "travis-artifacts upload --path debug/debug.log"
       aftrer_success: # and this only on success
         - "travis-artifacts upload --path build/build.tar.gz"

   The default path to save files is "artifacts/{{build_number}}/{{job_number}}",
   but you can customize it with `--target-path` option, for example:

       after_test:
         - "travis-artifacts upload --target_path artifacts/$TRAVIS_BUILD_ID/$TRAVIS_JOB_ID"

4. Profit!

In short future we would like to extend it with more providers and features, as well
as listen to your ideas, feedback and specific use cases. Please let us know what are
your thoughts on this topic.

### Why don't we use .travis.yml?

You may be wondering why we chose to create artifacts as a simple script rather than
addition to `.travis.yml`. At first this was my idea, but frankly speaking `.travis.yml`
is getting more and more complex, so we want to test new ideas without touching `.travis.yml`
format and then decide how to handle it in config, when we have more information on usage.

### A bit longer story

When you run tests on travis, you can run any code in a various stages of test
execution, so obviously you could use your own scripts to upload build artifacts
to s3, but unless you have really specific needs, you're probably reinventing the wheel.

When I started working on this task, at first my nature of "let's build something
epic" took part and I prepared a proposal for a thin uploader script, which would
upload files to some kind of full blown proxy service, which would then process them
and upload to some kind of storage. I think it's a quite good and
flexible idea, but when you're short on manpower it becomes a bad one. If you add
the fact that currently we need to put a bit more work into architecture
improvements and that deploying code to workers is far from ideal, it becomes
even worse. So in order to allow test things and iterate quickly, the best way
is to come up with something that can be developed without any coupling
with the rest of the platform.

The other argument for going in such direction is that we're not yet sure what will
we end up with. Maybe it will not evolve too much, but maybe based on use cases and
feedback we will change a lot in a way it works.

During the development of artifacts I wanted a way to run script regardless the tests result.
There was no such hook, so I wanted to change `after_script` to behave that way.
I also exposed the `TRAVIS_TEST_RESULT` environment variable so you can check if tests failed
or passed at this point. This is a general purpose change in a way travis works and it will
be probably used in a lot of other use cases. That's why it's easy to justify such change
into one of the travis apps.

This is also a good way to deal with things in open source in general. Sometimes you would
like to make an addition to a library, which can't be accepted. It may be something that
is a specific use case, which will not be used by a majority. It may be something that
is not yet well formed as an idea and needs testing or maybe maintainers are just not
interested in going that way. In such situation you can either fork the project, which
is not a good solution in the long run, because you need to maintain the fork, or you can extend
the library to allow you to plug in your extensions. I really like the latter approach, because
not only does it make the library more flexible, but it also makes your life easier.

Does this way of building thing have its drawbacks? Of course. For example, it will be hard
to save the list of uploaded files to the database and fetch it with the API. But maybe we won't
need this feature at all? It's better to check it as quickly as we can, than make assumptions
that can turn to be wrong.
