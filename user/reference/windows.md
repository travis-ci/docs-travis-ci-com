---
title: The Windows Build Environment
layout: en
---

### What This Guide Covers

This guide explains what packages, tools and settings are available in the Travis Windows CI environment (often referred to as the “CI environment”).

> Take note that our Windows environment is in early stages and a minimal subset of what's available on Linux or OS X/macOS is currently supported.

## Support

> Early adopters of our Windows environment can ask their questions/report issues in the [Windows category](https://travis-ci.community/c/windows) of our Community Forums.

## Using Windows

To use our Windows build infrastructure, add the following to your `.travis.yml`:

```yaml
os: windows
```
{: data-file=".travis.yml"}

## Windows Version

Only **Windows Server 2016** is currently supported.

## Chocolatey

[Chocolatey](https://chocolatey.org/), the package manager for Windows, is installed and can be used to install Windows packages.

## Git BASH

Git BASH is the shell that's used to run your build. See [Git for Windows](https://gitforwindows.org/) for more details.

## Powershell

Powershell can be used by calling `powershell` in your .travis.yml file for now. We are looking into adding first class Powershell support very soon.

## File System

VMs running Windows use the default file system, NTFS.

## Supported languages
- Node.js (`language: node_js`)
- Rust (`language: rust`)
- Go (`language: go`)
- Bash variants (`language: shell`, `language: sh`)

## Pre-installed packages

- 7zip.install
- ant
- chromedriver
- cmake
- curl
- firefox
- git.install
- gradle
- jdk10
- jdk8
- jq
- lein
- maven
- mysql
- phantomjs
- postgresql
- python
- python2
- ruby
- sbt
- visualstudio2017buildtools
- wget
- yarn

Latest list of pre-installed packages can be found [here](https://github.com/travis-ci/packer-templates/blob/master/packer-assets/windows-server-2016-ci-onion-packages.txt).
