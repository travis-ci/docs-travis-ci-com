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

Only **Windows Server, version 1809** is currently supported.

> Note that this is a [Semi-Annual Channel](https://en.wikipedia.org/wiki/Windows_Server#Semi-Annual_Channel_(SAC)) release that does not contain GUI and multimedia components. Follow [this Community topic](https://travis-ci.community/t/1557) if you run into this limitation.

## Chocolatey

[Chocolatey](https://chocolatey.org/), the package manager for Windows, is installed and can be used to install Windows packages.

## Git BASH

Git BASH is the shell that's used to run your build. See [Git for Windows](https://gitforwindows.org/) for more details.

## Powershell

Powershell can be used by calling `powershell` in your .travis.yml file for now. We are looking into adding first class Powershell support very soon.

## File System

VMs running Windows use the default file system, NTFS.

## Supported languages
- Bash `language: bash` or `language: shell`
- C with `language: c`
- C++ with `language: cpp`
- Go with `language: go`
- Julia with `language: julia`
- Node.js with `language: node_js`
- Rust with `language: rust`

## Pre-installed Chocolatey packages

- 7zip.install v19.0
- chocolatey v0.10.15 
- chocolatey-core.extension v1.3.5.1
- chocolatey-dotnetfx.extension v1.0.1
- chocolatey-fastanswers.extension v0.0.2
- chocolatey-visualstudio.extension v1.8.1
- chocolatey-windowsupdate.extension v1.0.4
- cmake.install v3.16.2
- curl v7.68.0
- DotNet4.5.2 v4.5.2.20140902
- DotNet4.6 v4.6.00081.20150925
- DotNet4.6-TargetPack v4.6.00081.20150925
- DotNet4.6.1 v4.6.01055.20170308
- dotnetfx v4.8.0.20190930
- git.install v2.25.0
- hashdeep v4.4
- jq v1.6
- KB2919355 v1.0.20160915
- KB2919442 v1.0.20160915
- KB2999226 v1.0.20181019
- KB3033929 v1.0.5
- KB3035131 v1.0.3
- llvm v9.0.0
- microsoft-build-tools v15.0.26320.2
- mingw v8.1.0
- netfx-4.5.1-devpack v4.5.50932
- netfx-4.5.2-devpack v4.5.5165101.20180721
- netfx-4.6.1-devpack v4.6.01055.00
- rsync v5.5.0.20190204
- ruby v2.7.0.1
- vcredist140 v14.24.28127.4
- vcredist2017 v14.16.27033
- visualstudio-installer v2.0.1
- visualstudio2017-workload-netcorebuildtools v1.1.2
- visualstudio2017-workload-vctools v1.3.2
- visualstudio2017-workload-webbuildtools v1.3.2
- visualstudio2017buildtools v15.9.18.0
- Wget v1.20.3.20190531
- windows-sdk-10.1 v10.1.18362.1
- winscp v5.15.9
- winscp.install v5.15.9
- wsl v1.0.1

> A basic Python 2.7.9 interpreter is also included: `/C/ProgramData/chocolatey/bin/python.exe`

## How do I use MSYS2?

[MSYS2](https://www.msys2.org/) is a popular development environment for building GCC-based projects with Unix-style build systems. While it isn't included in the Windows image, it is fairly easy to install via [the Chocolatey package](https://chocolatey.org/packages/msys2) using the following additions to the sections of your `.travis.yml`:

```yaml
before_install:
- |-
    case $TRAVIS_OS_NAME in
      windows)
        [[ ! -f C:/tools/msys64/msys2_shell.cmd ]] && rm -rf C:/tools/msys64
        choco uninstall -y mingw
        choco upgrade --no-progress -y msys2
        export msys2='cmd //C RefreshEnv.cmd '
        export msys2+='& set MSYS=winsymlinks:nativestrict '
        export msys2+='& C:\\tools\\msys64\\msys2_shell.cmd -defterm -no-start'
        export mingw64="$msys2 -mingw64 -full-path -here -c "\"\$@"\" --"
        export msys2+=" -msys2 -c "\"\$@"\" --"
        $msys2 pacman --sync --noconfirm --needed mingw-w64-x86_64-toolchain
        ## Install more MSYS2 packages from https://packages.msys2.org/base here
        taskkill //IM gpg-agent.exe //F  # https://travis-ci.community/t/4967
        export PATH=/C/tools/msys64/mingw64/bin:$PATH
        export MAKE=mingw32-make  # so that Autotools can find it
        ;;
    esac

before_cache:
- |-
    case $TRAVIS_OS_NAME in
      windows)
        # https://unix.stackexchange.com/a/137322/107554
        $msys2 pacman --sync --clean --noconfirm
        ;;
    esac

cache:
    directories:
    - $HOME/AppData/Local/Temp/chocolatey
    - /C/tools/msys64
```
{: data-file=".travis.yml"}

This will download and install MSYS2 the first time, and store both the downloaded initial archive and the MSYS2 installation in your [build cache](/user/caching/#arbitrary-directories). Subsequent builds will avoid re-downloading the initial archive and will update the cached installation before use, and cache the updated installation upon success.

MSYS2 contains two noteworthy [subsystems](https://github.com/msys2/msys2/wiki/MSYS2-introduction#subsystems): "msys2" and "mingw64". The code above prepares the `$msys2` and `$mingw64` prefixes for entering the corresponding shells. As an example, the `$msys2` prefix is used to run `pacman` appropriately. Your build commands should use the `$mingw64` prefix to build native Windows programs, and the `$msys2` prefix to build POSIX-based programs requiring the MSYS2 DLL.

A point of caution: the pre-installed "mingw" Chocolatey package should **not** be used within any MSYS2 subsystem. (In fact, the above snippet uninstalls the "mingw" Chocolatey package to be safe.) Note that the [MSYS2 wiki](https://github.com/msys2/msys2/wiki/MSYS2-introduction#path) says:

> Be aware that mixing in programs from other MSYS2 installations, Cygwin installations, compiler toolchains or even various other programs is not supported and will probably break things in unexpected ways.
