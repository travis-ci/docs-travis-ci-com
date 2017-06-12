---
title: Travis CI for Beginners
layout: en
permalink: /user/for-beginners/
---

Welcome to Travis CI! If you are new here or new to Continuous Integration (CI) in general, this doc will provide context and terminology used throughout the platform and documentation. 

## What is Continuous Integration (CI)?

Continuous Integration is the practice of merging in small code changes frequently - rather than waiting for a large integration process at the end of a development cycle. Companies and individuals may all do this process differently, but the goal is to build healthier software by developing and testing in smaller increments. This is where Travis CI can be helpful.

Travis CI, as a continuous integration platform, supports your development process by automatically building and testing code changes, in order to provide immediate feedback on the success of the change. Travis CI also can automate some of your development process by managing deployments and notifications.  

## CI builds and automation: building, testing, deploying

When you run a build, Travis CI clones your GitHub repository into a brand new build environment, and carries out a series of tasks to build and test your code. If one more more of the tasks fails, the build is considered *broken*. If none of the tasks fail, the build is considered *passed*, and Travis CI can deploy your code to a web server, or application host.  

CI builds can also automate other parts of your delivery workflow. This means you can have jobs depend on each other with [Build Stages](../build-stages), setup [notifications](../notifications.md), prepare [deployments](../deplyoment.md) after builds, and many other tasks. 

## Jobs vs. builds

In the Travis CI documentation, some common words have specific meanings. For example:
 * *build* - a group of automated processes, where multiple jobs might happen in parallel. For example, a build might have two jobs, which test a project with two different versions of a language. The status of a build depends on the status of the jobs it contains.  
 * *job* - a single automated process, where Travis CI starts an automated worker which clones your projects, compiles your code, runs tests, and executes any other steps, such as deployments. The status of the job depends on the success of the steps it executes. 
 * *stage* - a job or group of jobs that are a step in a sequential build process. These are used in [build stages](../build-stages.md)
 * *phase* - a part of a particular job. For example, the `install` phase runs all of the specified commands to install dependencies for a job. 

## travis-ci.org vs travis-ci.com

Travis CI originally was developed for open-source projects before being expanded to support closed-source projects at a later date. As a result, open-source projects are hosted on our [travis-ci.org](https://travis-ci.org/) platform while closed source projects are hosted on [travis-ci.com](https://travis-ci.com/). Travis CI for closed-source projects is also know as [Travis Pro](../travis-pro/).

## Breaking the Build

The build is considered "broken" when it completes with any state that is not *passed*. The options for these non-passing states are:
 * *errored* - a command returned a non-zero exit code in the `before_install`, `install`, or `before_script` section. The job is exited immediately. 
 * *failed* - a non-zero exit code is returned in the `script` section. The job continues to run until it completes. 
 * *canceled* -  a user cancels the job before it completes. 

See our [Common Builds Problems](../common-build-problems.md) doc for a good place to start when troubleshooting.

## Infrastructure and environment notes

Travis CI runs your build in one of the following environments, each with some advantages and disadvantages:
 * *Sudo-enabled* - this Linux (Ubuntu) environment allows for the use of `sudo`, `setuid`, and `setgid`. It uses a full virtual machine (vm). It starts a little slower, but it has more computational resources.
 * *Container-based* - this Linux (Ubuntu) environment does not allow for the use `sudo`, `setuid`, or `setgid`. It is run in a container. It starts faster than the sudo-enabled environment, but it's resources are a little more limited. It is the default environment for all projects that are enabled on Travis CI after 2015. 
 * OSX - this environment uses the OSX/macOS operating system. You can chose which version of OSX/macOS from several options. This environment is useful for building projects that require the OSX/macOS toolchain, such as projects in Swift. It is not a requirement to use the OSX environment if you develop on a macOS machine. 

More details are on our environments are available in our [CI Environment](../ci-environment) documentation. 

## Pre-getting started
To get a project started with CI, you will need the following:
 * [GitHub](https://github.com/) login 
 * Project hosted as a repository on GitHub. See GitHub's [documentation](https://help.github.com/categories/importing-your-projects-to-github/) for this. 
 * Working code in your project
 * At least one test for your code

Once you have those pieces, head over to our [Getting Started](../getting-started) guide for details on setting up your first build!
