---
title: Community-Supported Languages
layout: en

swiftypetags: 'Community Supported'
---



There are many programming languages out there, and Travis CI would like
to support as many as possible.

However, the Travis CI team often lacks the expertise to make this
a reality, which is where community support come in.

## What does 'community-support' mean?

Support for Community-supported languages are programming languages where
support is provided by self-identified experts in the languages'
respective community.

## How do I add a new community-supported language?

1. Gather a group of 3 or more volunteers who will support the new language.
2. Create pull requests in [travis-build](#Adding-a-new-language) and if
   necessary [travis-web](#Adding-Matrix-support).
3. [Test your changes](#Testing-travis-build-changes).
4. Work with Travis CI team to get the PRs production-ready.
5. Provide ongoing support for the issues involving the language.

A group of 3 is a minimum to support a language.
This allows redundancy in providing support when a member of
the support team is unavailable.

## Technical Details

It is important to note that languages are configured at build time,
so components are downloaded every time a job runs. To save build time, limit
 your language resource usage to a minimum.

### Adding a new language

To add support for a new language, edit [travis-build](https://github.com/travis-ci/travis-build)
and create a new class, inheriting from `Travis::Build::Script`, that implements
reasonable defaults for your language's build stages.

As a minimum, implement the following stages:

`configure` → `setup` → `announce` → `install` → `script`

There are other phases that can be customized for a particular language;
the Travis CI team will work with you to identify and implement the customization
if you think it is appropriate to do so.

> The `configure` phase runs before `sudo` is disabled in the container builds,
> so if you need to use `sudo` to set up your language environment
> (e.g., install Ubuntu packages), you should do that in the `configure` phase.

If you want to support build matrix expansion based on various language
versions (e.g., Ruby 2.2, 2.1, etc.), and you wish to add a convenient way
to restrict deployments based on the language version, add your language
to [`Travis::Build::Addons::Deploy::Script::VERSIONED_RUNTIMES`](https://github.com/travis-ci/travis-build/blob/master/lib/travis/build/addons/deploy/script.rb).

### Adding Matrix support

If the language provides build matrix expansion, make this information visible
to the end user by editing [travis-web](https://github.com/travis-ci/travis-web).

To make this happen, you need to tell `travis-web` to pick up the value
from the job's data and display it.  Clone the `travis-web` repository,
add your language to the `app/utils/keys-map.coffee` file and submit a
pull request for this change.

> If you want to support build matrix expansion for various language versions
> (e.g., Ruby 2.2, 2.1, etc.), please coordinate with the Travis CI team to
> find out exactly what is required.

### Testing `travis-build` changes

Testing happens in our staging environment, which is a shared resource.Testing
the proposed changes could take some coordination between you and the Travis CI team.

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
