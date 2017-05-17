---
title: Travis CI for Beginners
layout: en
permalink: /user/for-beginners/
---

Welcome to Travis CI! If you are new here or new to Continuous Integration (CI) in general, this doc will provide context and terminology used throughout the platform and documentation. 

### What is Continuous Integration (CI)?

Continuous Integration is the concept and practice of merging in small code changes frequently - rather than waiting for a large integration process at the end of a development cycle. Companies and individuals may all do this process differently, but the goal is to build healthier software by developing and testing in smaller increments. This is where Travis CI can be helpful.

Travis CI, as a CI platform, supports your development process by automatically building and testing code changes, in order to provide immediate feedback on the success of the change. Travis CI also can automate some of your development process by managing deployments and notifications.  

### CI builds and automation: building, testing, deploying

Many things can happen when Travis CI runs. First, your project is brought into into our clean environment with `git clone`, then your code is compiled. Next, any tests you have are run, and their status is checked. If tests are successful, and you have set up a deployment provider, Travis CI will deploy your application. Depending on your settings, you may be notified via email, or over other platforms such as Slack. 

One of the advantages of CI builds, is they can execute arbitrary code if you configure the build to run a custom script. This means you can setup your own notifications, upload files output during your build (artifacts), and many other processes. Travis CI can function as a basis for general automation for your development processes. 

You can also customize your build into various stages, in which later stages are dependent on the result of prior stages. See our [Build Stages](../build-stages) document for details. 

### Jobs vs. builds

The words "job" and "build" can be somewhat ambiguous in the context of CI. In the Travis CI docs and materials, they refer to the following: 
 * *job* - a single automated process, where Travis CI starts an automated worker which clones your projects, compiles your code, runs tests, and executes any other steps, such as deployments. The status of the job depends on the success of the steps it executes. 
 * *build* - a group of automated processes, where multiple jobs might happen in parallel. For example, a build might have two jobs, which test a project with two different versions of a language. The status of a build depends on the status of the jobs it contains. 

### travis-ci.org vs travis-ci.com

Travis CI originally was developed for open-source projects before being expanded to support closed-source projects at a later date. As a result, open-source projects are hosted on our [travis-ci.org](https://travis-ci.org/) platform while closed source projects are hosted on [travis-ci.com](https://travis-ci.com/). Travis CI for closed-source projects is also know as [Travis Pro](../travis-pro/).


### Breaking the Build
--> TBD

### Infrastructure and environment notes

Travis CI supports a few different environment, so you have different options to use. Each job runs in exactly one of the following environments:
 * *Sudo-enabled* - this Linux (Ubuntu) environment allows for the use of `sudo`, `setuid`, and `setgid`. It uses a full virtual machine (vm). It starts a little slower, but it has more computational resources.
 * *Container-based* - this Linux (Ubuntu) environment does not allow for the use `sudo`, `setuid`, or `setgid`. It is run in a container. It starts faster than the sudo-enabled environment, but it's resources are a little more limited. It is the default environment for all projects that are enabled on Travis CI after 2015. 
 * OSX - this environment uses the OSX/macOS operating system. You can chose which version of OSX/macOS from several options. This environment is useful for building projects that require the OSX/macOS toolchain, such as projects in Swift. It is not a requirement to use the OSX environment if you develop on a macOS machine. 

More details are on our environments are available in our [CI Environment](../ci-environment) documentation. 

### Pre-getting started
To get a project started with CI, you will need the following:
 * [GitHub](https://github.com/) login 
 * Project hosted as a repository on GitHub. See GitHub's [documentation](https://help.github.com/categories/importing-your-projects-to-github/) for this. 
 * Working code in your project
 * At least one test for your code

Once you have those pieces, head over to our [Getting Started](../getting-started) guide for details on setting up your first build!
