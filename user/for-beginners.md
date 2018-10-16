---
title: Core Concepts for Beginners
layout: en

---



Welcome to Travis CI! This page provides some contexts and terminologies used
throughout the platform and documentation, which might be helpful if you are new
here or new to Continuous Integration (CI).

## What is Continuous Integration (CI)?

Continuous Integration is the practice of merging in small code changes
frequently - rather than merging in a large change at the end of a development
cycle. The goal is to build healthier software by developing and testing in smaller
increments. This is where Travis CI comes in.

As a continuous integration platform, Travis CI supports your development
process by automatically building and testing code changes, providing immediate
feedback on the success of the change. Travis CI can also automate other parts
of your development process by managing deployments and notifications.  

## CI builds and automation: building, testing, deploying

When you run a build, Travis CI clones your GitHub repository into a brand new
virtual environment, and carries out a series of tasks to build and test your
code. If one or more of those tasks fails, the build is considered
[*broken*](#Breaking-the-Build). If none of the tasks fail, the build is
considered [*passed*](#Breaking-the-Build), and Travis CI can deploy your code
to a web server, or application host.

CI builds can also automate other parts of your delivery workflow. This means
you can have jobs depend on each other with [Build Stages](/user/build-stages/),
setup [notifications](/user/notifications/), prepare
[deployments](/user/deployment/) after builds, and many other tasks.

## Builds, Jobs, Stages and Phases

In the Travis CI documentation, some common words have specific meanings:

* *job* - an automated process that clones your repository into a virtual
  environment and then carries out a series of *phases* such as compiling your
  code, running tests, etc. A job fails if the return code of the `script` *phase*
  is non zero.
* *phase* - the [sequential steps](/user/job-lifecycle/)
  of a job. For example, the `install` phase, comes before the `script` phase,
  which comes before the optional `deploy` phase.
* *build* - a group of *jobs*. For example, a build might have two *jobs*, each
  of which tests a project with a different version of a programming language.
  A *build* finishes when all of its jobs are finished.
* *stage* - a group of *jobs* that run in parallel as part of sequential build
  process composed of multiple [stages](/user/build-stages/).

## Breaking the Build

The build is considered *broken* when one or more of its jobs completes with a
state that is not *passed*:

 * *errored* - a command in the `before_install`, `install`, or `before_script`
   phase returned a non-zero exit code. The job stops immediately.
 * *failed* - a command in the `script` phase returned a non-zero exit code. The
   job continues to run until it completes.
 * *canceled* - a user cancels the job before it completes.

Our [Common Builds Problems](/user/common-build-problems/) page is a good place
to start troubleshooting why your build is broken.

## Infrastructure and environment notes

Travis CI offers a few different infrastructure environments, so you can select
the setup that suits your project best:

* *Container-based* - is the default for new projects. It is a Linux Ubuntu environment running in a container. It starts faster than the sudo-enabled environment, but has less resources and does not support the use of `sudo`, `setuid`, or `setgid`.
* *Sudo-enabled* - this Linux Ubuntu environment runs on full virtual machine. It starts a little slower, but it has more computational resources, and supports the use of `sudo`, `setuid`, and `setgid`.
* *OS X* - uses one of several versions of the OS X operating system. This environment is useful for building projects that require the OS X software, such as projects written in Swift. It is not a requirement to use the OS X environment if you develop on a macOS machine.

More details are on our environments are available in our [CI Environment](/user/ci-environment/) documentation.

Now that you've read the basics, head over to our [Tutorial](/user/tutorial/) for details on setting up your first
build!
