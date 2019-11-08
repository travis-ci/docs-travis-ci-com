---
title: Importing Shared Build Configuration

layout: en
---

The main source of configuration for your build is the `.travis.yml` file
stored in your repository. You can import shared configuration snippets into
your `.travis.yml` or [API build request payload](https://docs.travis-ci.com/user/triggering-builds/),
to update your build configuration in multiple repositories making only
one change.

Imported configs can themselves include other configs, making this feature very
composable (cyclic imports will be skipped). You can import up to 25 build
configuration snippets in total.


> BETA The Configuration Imports feature is currently in beta. You can leave your feedback on the [Community forum](https://travis-ci.community/c/early-releases).
{: .beta }

## Example

Instead of specifying which versions of Ruby to test against in multiple files
across many repositories, you can define them in a shared snippet:

```yaml
rvm:
  - 2.5
  - 2.6
```
{: data-file="rubies.yml"}

You can then `import` that snippet into your `.travis.yml`. The following
configuration imports the file `rubies.yml` from the `main` branch of the
`shared-configs` repository of the `travis-ci` account:

```yaml
import: travis-ci/shared-configs:rubies.yml@main
script: bundle exec rake
```
{: data-file=".travis.yml"}

Resulting in the following configuration:

```yaml
rvm:
  - 2.5
  - 2.6
script: bundle exec rake
```
{: data-file=".travis.yml"}

## Import sources

The format of the `import` source is `<account>/<repository>:<path>@<ref>` in
which `<ref>` can be any valid Git reference, such as a commit sha, branch name,
or tag name.

> Public repositories can import sources from public repositories, but not
> private repositories. Private repositories can import sources from both
> public and private repositories. See [private repositories](#private-repositories)
> for more information.

Import a single source:

```yaml
import: travis-ci/build-configs:rubies.yml@main

# or

import:
  source: travis-ci/build-configs:rubies.yml@main
```
{: data-file=".travis.yml"}

Import multiple sources:

```yaml
import:
  - travis-ci/build-configs:rubies.yml@adf1235
  - travis-ci/build-configs:other.yml@v1

# or

import:
  - source: travis-ci/build-configs:rubies.yml@adf1235
  - source: travis-ci/build-configs:other.yml@v1
```
{: data-file=".travis.yml"}

By default, if the same keys are present in multiple imported snippets, they
are overwritten with the last configuration imported. But you can also specify
[deep_merge](#merge-mode).

## Importing configs from the same repository

When importing configurations stored in the same repository as your
`travis.yml`, you can commit the `<account>/<repository>` part:

```yaml
# local imports fetch the same git commit ref
import:
- one.yml
- path/to/other.yml
```
{: data-file=".travis.yml"}

The path is relative to the repository's root.

## Importing specific versions of configs


Configurations imported from a different repository, fetch the fetch the latest
version of the default branch in the repository.

Configurations imported from the same repository, fetch the commit you are
currently building by default. This is intended to help while you are creating
and testing the shared configurations.

You can specify the exact version of a config snippet by using any valid Git
reference:

```yaml
import:
- one.yml@production
- travis-ci/build-configs/other.yml@v1.0.0
```
{: data-file=".travis.yml"}

## Merge modes

The merge mode controls how imported configs are being merged (combined) into
the importing config. A different merge mode can be specified for each imported
config source.

There are these merge modes:

* `merge`
* `deep_merge`
* `deep_merge_append` (default)
* `deep_merge_prepend`

The default merge mode is `deep_merge_append` when using the beta feature
[build config validation](/user/build-config-validation) that will be rolled
out to all users over the next couple of months, we encourage you to enable it.
With this feature not being enabled the default merge mode is `merge`.

### Merge

The merge mode `merge` performs a shallow merge.

This means that root level sections (keys) defined in your `.travis.yml` will
overwrite root level sections (keys) that are also present in the imported
file.

```yaml
import:
- source: one.yml
  mode: merge # shallow merge
```

### Deep merge

The merge mode `deep_merge` recursively merges sections (keys) that hold maps (hashes),
but overwrites sequences (arrays).

```yaml
import:
- source: one.yml
  mode: deep_merge # deep merge
```
{: data-file=".travis.yml"}

### Deep merge append/prepend

The merge modes `deep_merge_append` and `deep_merge_prepend` recursively merge
sections (keys) that hold maps (hashes), and concatenates sequences (arrays) by
either appending or prepending to the sequence in the importing config.

```yaml
import:
- source: one.yml
  mode: deep_merge_append
- source: other.yml
  mode: deep_merge_prepend
```

## Private repositories

Before sharing configurations **from** a private repository you need to toggle
the *Allow importing config files from this repository* setting in *More
options* > *Settings* > *Config Import*. Only repositories owned by the same
organisation will be able to access configuration snippets from private
repositories.

## Include precedence

When triggering a build through the Travis API or the web UI, the order of ascending precedence is:

- Config from the API build request payload, if given
- Config from `.travis.yml`
- Imported configs from the API build request payload, if given, in the order listed
- Imported configs from `.travis.yml`, in the order as listed
