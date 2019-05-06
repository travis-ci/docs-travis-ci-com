---
title: The Windows Build Environment
layout: en
---

### What This Guide Covers

This guide explains what packages, tools and settings are available in the Travis Windows CI environment (often referred to as the “CI environment”).

> Take note that our Windows environment is in early stages and a minimal subset of what's available on Linux or macOS is currently supported.

## Support

> Early adopters of our Windows environment can ask their questions/report issues in the [Windows category](https://travis-ci.community/c/windows) of our Community Forums.

## Using Windows

To use our Windows build infrastructure, add the following to your `.travis.yml`:

```yaml
os: windows
```
{: data-file=".travis.yml"}

## Windows Version

Only **Windows Server, version 1803** is currently supported.

## Chocolatey

[Chocolatey](https://chocolatey.org/), the package manager for Windows, is installed and can be used to install Windows packages.

## Git BASH

Git BASH is the shell that's used to run your build. See [Git for Windows](https://gitforwindows.org/) for more details.

## Powershell

Powershell can be used by calling `powershell` in your .travis.yml file for now. We are looking into adding first class Powershell support very soon.

## File System

VMs running Windows use the default file system, NTFS.

## Supported languages
- C with `language: c`
- C++ with `language: cpp`
- Node.js with `language: node_js`
- Rust with `language: rust`
- Go with `language: go`
- Bash `language: bash` or `language: shell`

## Pre-installed Chocolatey packages

- 7zip.install 18.5.0.20180730
- chocolatey 0.10.11
- chocolatey-core.extension 1.3.3
- chocolatey-fastanswers.extension 0.0.1
- chocolatey-visualstudio.extension 1.7.0
- chocolatey-windowsupdate.extension 1.0.3
- cmake.install 3.12.3
- curl 7.62.0
- dotnet4.6.2 4.6.01590.20170129
- git.install 2.19.1
- hashdeep 4.4
- jq 1.5
- KB2919355 1.0.20160915
- KB2919442 1.0.20160915
- KB2999226 1.0.20181019
- KB3033929 1.0.4
- KB3035131 1.0.2
- llvm 7.0.0
- microsoft-build-tools 15.0.26320.2
- mingw 8.1.0
- ruby 2.5.3.1
- vcredist140 14.15.26706
- vcredist2017 14.15.26706
- visualstudio2017buildtools 15.8.9.0
- visualstudio2017-installer 1.0.2
- visualstudio2017-workload-netcorebuildtools 1.1.0
- visualstudio2017-workload-vctools 1.3.0
- visualstudio2017-workload-webbuildtools 1.3.0
- wget 1.19.4
- winscp 5.13.4
- winscp.install 5.13.4
- wsl 1.0.1
