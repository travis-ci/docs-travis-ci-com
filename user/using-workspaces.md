---
title: Using Workspaces (Beta)
layout: en
---

# Workspaces (Beta)

> Workspaces are currently in beta testing, and may change without a prior
> notice.
{: .beta}

Workspaces allow jobs _within_ a build to share files.
They are useful when you want to use build artifacts from a previous job;
for example, you create a cache that can be used in multiple jobs later.

So you can clearly see when a workspace is created and used, we recommend using workspaces with [build stages](/user/build-stages), as shown in the following [examples](#workspace-examples).

> Note that it is best to create a workspace in one stage and then use it in
subsequent stages.

## Configuration

A minimal workspace configuration looks like this:

```yaml
jobs:
  include:
    - stage: warm_cache
      script:
        - echo "foo" > foo.txt
      workspaces:
        create:
          name: ws1
          paths:
            - foo.txt
    - stage: use_cache
      workspaces:
        use: ws1
      script:
        - cat foo.txt || true
```
{: data-file=".travis.yml"}

Each workspace has a unique name within a build.
It is specified by the `name` key when it is created with
`workspaces.create`, and by the value when it is used with
`workspaces.use`.

In the example above, the workspace named `ws1` is created by the only
job in the `warm_cache` stage.
The workspace is subsequently consumed in the `use_cache` stage.

## Workspace examples

### Multiple workspaces example

You can use multiple workspaces in a build.


```yaml
script:
  - ./build $TRAVIS_OS_NAME
jobs:
  include:
    - stage: Build binaries
      os: linux
      workspaces:
        create:
          name: linux-binaries
    - os: osx
      workspaces:
        create:
          name: osx-binaries
    - stage: Deploy
      language: minimal
      workspaces:
        use:
          - linux-binaries
          - osx-binaries
      git:
        clone: false
      script:
        - ./create_archive.sh
      deploy:
        provider: script
        script: ./upload.sh
```
{: data-file=".travis.yml"}

In this example:
  1. we run two jobs in the "Build binaries" stage,
     each producing uploading binaries.
  1. in the subsequent "Deploy" stage, we fetch the workspaces
     produced by the jobs in the previous stage, and deploy it
     using a custom script.

## Workspaces and concurrency
Note that workspaces work best if there is no race condition set while
uploading them.
Since there is no guarantee in the execution order of jobs within a build
stage, it is a good idea to assign different workspace names to jobs within
a build stage.

## Workspace names must be pre-determined
Due to technical reasons, workspace names will be escaped for shell.
In other words, given:

```yaml
workspaces:
  create:
    name: $TRAVIS_OS_NAME
    paths: …
```
{: data-file=".travis.yml"}

it will have to be consumed by

```yaml
workspaces:
  use: $TRAVIS_OS_NAME
```
{: data-file=".travis.yml"}

and not by

```yaml
workspaces:
  use: linux
```
{: data-file=".travis.yml"}

even if the consumer is running on a Linux VM.

## How workspaces differ from caches

It is worth reiterating that the workspaces are meant for sharing files
within the same build.
For files you want to share across builds, use
[caches](/user/caching).

### Workspaces and caches are considered independently

It is possible to include a single file in the cache and workspaces.

> If you restart some builds within a job, and your workspace isn't working like you expect it to, try restarting the the entire build.
