---
title: Travis CI for Beginners
layout: en
permalink: /user/for-beginners/
---

Welcome to Travis CI! This page provides some context and terminology used
throughout the platform and documentation, which might be helpful if you are new
here or new to Continuous Integration (CI).

## What is Continuous Integration (CI)?

Continuous Integration is the practice of merging in small code changes
frequently - rather than merging in a large change at the end of a development
cycle. Companies and individuals all have slightly different processes, but the
goal is to build healthier software by developing and testing in smaller
increments. This is where Travis CI is comes in.

Travis CI, as a continuous integration platform, supports your development
process by automatically building and testing code changes, providing immediate
feedback on the success of the change. Travis CI can also automate other parts
of your development process by managing deployments and notifications.  

## CI builds and automation: building, testing, deploying

When you run a build, Travis CI clones your GitHub repository into a brand new
build environment, and carries out a series of tasks to build and test your
code. If one or more of those tasks fails, the build is considered *broken*. If
none of the tasks fail, the build is considered *passed*, and Travis CI can
deploy your code to a web server, or application host.  

CI builds can also automate other parts of your delivery workflow. This means
you can have jobs depend on each other with [Build Stages](/user/build-stages/),
setup [notifications](/user/notifications/), prepare
[deployments](/user/deployment/) after builds, and many other tasks.

## Jobs vs. builds

In the Travis CI documentation, some common words have specific meanings. For example:

 * *build* - a group of automated processes, where multiple jobs might happen in parallel. For example, a build might have two jobs, which test a project with two different versions of a language. The status of a build depends on the status of the jobs it contains.  
 * *job* - a single automated process, where Travis CI starts an automated worker which clones your projects, compiles your code, runs tests, and executes any other steps, such as deployments. The status of the job depends on the success of the steps it executes.
 * *stage* - a job or group of jobs that are a step in a sequential build process. These are used in [build stages](/user/build-stages/)
 * *phase* - a part of a particular job. For example, the `install` phase runs all of the specified commands to install dependencies for a job.

## travis-ci.org vs travis-ci.com

Travis CI was originally developed for open-source projects before being
expanded to support closed-source projects at a later date. As a result:

* open-source projects are hosted on [travis-ci.org](https://travis-ci.org/).
* closed-source projects are hosted on [travis-ci.com](https://travis-ci.com/), also known as [Travis Pro](/user/travis-pro/).

## Breaking the Build

The build is considered *broken* when it completes with any state that is not *passed*:

 * *errored* - a command returned a non-zero exit code in the `before_install`, `install`, or `before_script` section. The job stops immediately.
 * *failed* - a non-zero exit code is returned in the `script` section. The job continues to run until it completes.
 * *canceled* -  a user cancels the job before it completes.

Our [Common Builds Problems](/user/common-build-problems/) page  is a good place
to start troubleshooting when you need to find out why your build is broken.

## Infrastructure and environment notes

Travis CI runs your build in one of the following environments, each with some
advantages and disadvantages:

* *Container-based* - is the default for new projects. It is a Linux Ubuntu environment running in a container. It starts faster than the sudo-enabled environment, but has less resources and does not support the use of `sudo`, `setuid`, or `setgid`.
* *Sudo-enabled* - this Linux Ubuntu environment runs on full virtual machine. It starts a little slower, but it has more computational resources, and supprts the use of `sudo`, `setuid`, and `setgid`.
* *OS X* - uses one of serveral versions of the OS X operating system. This environment is useful for building projects that require the OS X software, such as projects written in Swift. It is not a requirement to use the OS X environment if you develop on a macOS machine.

More details are on our environments are available in our [CI Environment](/user/ci-environment) documentation.

## Pre-getting started

To get a project started with Travis CI, you will need the following:

 * [GitHub](https://github.com/) login
 * Project hosted as a repository on GitHub. See GitHub's [documentation](https://help.github.com/categories/importing-your-projects-to-github/) for this.
 * Working code in your project
 * At least one test for your code

Once you have those pieces, head over to our [Getting
Started](/user/getting-started) guide for details on setting up your first
build!
