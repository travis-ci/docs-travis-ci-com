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
        export mingw64="$msys2 -mingw64 -full-path -here -c \$\* --"
        export msys2+=" -msys2 -c \$\* --"
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

>Beware that mixing in programs from other MSYS2 installations, Cygwin installations, compiler toolchains or even various other programs is not supported and will probably break things in unexpected ways.