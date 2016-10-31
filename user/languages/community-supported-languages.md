---
title: Community-Supported Languages
layout: en
permalink: /user/languages/community-supported-languages/
---

There are many programming languages out there, and Travis CI would like
to support as many as possible.

However, the Travis CI team often lacks the expertise to make this
a reality.
This is where the community-supported languages come in.

## What does 'community-support' mean?

The community-supported lanugages are those programming languages the support
of which is provided by self-identified experts in the langugages'
respective community.

Following the process described below, your favorite language could be
the next community-supported language on Travis CI!

## Process to add a new community-supported language

1. Gather a group of 3 or more volunteers versed in the desired language
   to provide support.
2. Create pull requests (details below).
3. Work with Travis CI team to get the PRs production-ready.
4. Provide ongoing support for the issues involving the language.

A group of 3 is a minimum to support a language.
This allows redundancy in providing support when a member of
the support team is unavailable.

## Technical Details

### Code

There are a few repositories (only [travis-build](https://github.com/travis-ci/travis-build) is required) that
realize support for builds in a new language.

1. [travis-build](https://github.com/travis-ci/travis-build)

   This is the only repository required to support the new language.

   Create a new class, inheriting from `Travis::Build::Script`, that implements
   reasonable defaults for your language's build stages.

   A basic build follows these stages:

   `configure` → `setup` → `announce` → `install` → `script`

   There are other phases that can be customized for a particular language;
   the Travis CI team will work with you to identify and implement the customization
   if you think it is appropriate to do so.

   NOTE: The `configure` phase runs before `sudo` is disabled in the container builds,
   so if you need to use `sudo` to set up your language environment
   (e.g., install Ubuntu packages), you should do that here.

   If you want to support build matrix expansion based on various language
   versions (e.g., Ruby 2.2, 2.1, etc.), and you wish to add a convenient way
   to restrict deployments based on the language version, add your language
   to [`Travis::Build::Addons::Deploy::Script::VERSIONED_RUNTIMES`](https://github.com/travis-ci/travis-build/blob/master/lib/travis/build/addons/deploy/script.rb).

2. [travis-core](https://github.com/travis-ci/travis-core)

   If you want to support build matrix expansion based on various language
   versions (e.g., Ruby 2.2, 2.1, etc.), `travis-core` needs to know about it.

   `Build::Config::ENV_KEYS` defines which keys are possible matrix dimensions,
   and `Build::Config::EXPANSION_KEYS_LANGUAGE` defines which keys among
   the possible ones are actually expanded based on the `language` value.

   [This PR](https://github.com/travis-ci/travis-core/pull/422) is a straightforward
   example.

3. [travis-web](https://github.com/travis-ci/travis-web)

   If the language provides build matrix expansion, it would be nice
   to have this information visible to the end user.

   To make this happen, you need to tell `travis-web` to pick up the value
   from the job's data and display it.  Clone the `travis-web` repository,
   add your language to the `app/utils/keys-map.coffee` file and submit a
   pull request for this change.

It is important to note that languages are configured at build time,
thus components are downloaded every time a job runs.

To save build time, you should limit your language resource usage to a minimum.

### Testing `travis-build` changes

Testing will be done in our staging environment, which, at the moment, is a shared
resource.
As such, testing the proposed changes could take some coordination between you and
the Travis CI team.

#### Testing your code locally

Optionally, you can use
[`travis-build` as an addon](https://github.com/travis-ci/travis-build/blob/master/README.md#use-as-addon-for-cli)
to [the CLI](https://github.com/travis-ci/travis.rb) utility.
This allows you to compile the `travis-build` code you are working on
into a Bash script, which you can then check for correct syntax (`bash -n`) and
execute (we recommend doing this on a virtual machine) to aid your development.

## List of community-supported languages

In alphabetical order, they are:

1. [C#](../csharp)
2. [Crystal](../crystal)
3. [D](../d)
4. [Dart](../dart)
5. [Haxe](../haxe)
6. [Julia](../julia)
7. [Nix](../nix)
8. [Perl 6](../perl6)
9. [R](../r)
10. [Smalltalk](../smalltalk)
