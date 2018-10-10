---
title: The Windows Build Environment
layout: en
---

### What This Guide Covers

This guide explains what packages, tools and settings are available in the Travis Windows CI environment (often referred to as the “CI environment”).

> Take note that our Windows environment is in early stages and a minimal subset of what's available on Linux or OS X/macOS is currently supported.

## Support

Early adopters of our Windows environment can ask their questions/report issues in the [Windows category](https://travis-ci.community/__TO_BE_ADDED_CATEGORY_URL__) of our Community Forums.

## Using Windows

To use our Windows build infrastructure, add the following to your `.travis.yml`:

```yaml
os: windows
```
{: data-file=".travis.yml"}

## Windows Version

Only Windows Server 2016 is currently supported.

## Chocolatey

[Chocolatey](https://chocolatey.org/), the package manager for Windows, is installed and can be used to install Windows packages.

## File System

VMs running Windows use the default file system, NTFS.

## Supported languages
- Node.js (`language: node_js`)
- Rust (`language: rust`)
- Go (`language: go`)
- Bash variants (`language: shell`, `language: sh`)

## Pre-installed packages

## Services

## Runtimes

## Environment variables

