---
title: Use C/C++ with Travis CI
layout: en
---

The following is a guide to getting started with Travis CI using C/C++. 

## Prerequisite
Before getting started, create a `.travis.yml` file and add it to the root directory of your C/C++ project.

## Specify the Language
Define C/C++ as the chosen language and specify which compiler to use.

Open your file and enter:

```yaml
language: c
compiler:
  - gcc
  - clang
```
{: data-file=".travis.yml"}

## Install Build Dependencies
Now is the time to install any necessary packages, like build tools or libraries, to the project. 
Use the `before_install` section to add the following command:

```yaml
before_install:
  - sudo apt-get update
  - sudo apt-get install -y build-essential
```
{: data-file=".travis.yml"}

## Configure your File
Define the build and specify any test command to compile and run tests. 
Use the `script` section to specify any commands. Below is an example using a `Makefile`:
 
```yaml
script:
  - make
```
{: data-file=".travis.yml"}

## Commit and Push
Once the file is set up, commit it to your repository, and Travis begins building and testing your C/C++ project. By the end, your file should look like this:

```yaml
language: c
compiler:
  - gcc
  - clang
before_install:
  - sudo apt-get update
  - sudo apt-get install -y build-essential
script:
  - make
```
{: data-file=".travis.yml"}

## Further Reading
For more information on C and C++ projects see:
* [Building a C Project](/user/languages/c/)
* [Building a C++ Project](/user/languages/cpp/)
* [Building a C# Project](/user/languages/csharp/)
* [Travis CI Cookbook: C++](https://www.youtube.com/watch?v=9rKfaT8Quzs)
