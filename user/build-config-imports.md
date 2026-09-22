---
title: Import Shared Build Configuration

layout: en
---

The main source of configuration for your build is the `.travis.yml` file
stored in your repository. You can import shared configuration snippets into
your `.travis.yml` or [API build request payload](https://docs.travis-ci.com/user/triggering-builds/),
to update your build configuration in multiple repositories, making only one
change.

Imported configs can themselves include other configs, making this feature very
composable (cyclic imports will be skipped). You can import up to 25 build
configuration snippets in total.


> BETA The feature Build Config Imports is currently in beta. Please leave feedback on the [Community forum](https://travis-ci.community/c/early-releases).
{: .beta }

## The opt-in option

In order for this feature to be active, you have to enable the feature
[Build Config Validation](/user/build-config-validation/) which will be rolled
out to all users in the near future.

You can enable Build Config Validation in your repository's settings, or by
adding `version: ~> 1.0` to your `.travis.yml` file.

## Import Shared Build Configuration Example

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
> public and private repositories. See [private repositories](#importing-configs-from-private-repositories)
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

By default, the merge mode `deep_merge_append` is used to combine keys that are
present in the importing and an imported config, or in multiple imported configs.
You can customize this by specifying the merge mode used for each import.
See below for more information on [merge modes](#merge-modes).

## Import configs from the same repository

When importing configurations stored in the same repository as your
`travis.yml`, you can omit the `<account>/<repository>` part:

```yaml
# local imports fetch the same git commit ref
import:
- one.yml
- path/to/other.yml
```
{: data-file=".travis.yml"}

The path is relative to the repository's root.

## Import specific config versions

For configurations imported from a different repository, the latest version of
the default branch in the repository will be used by default.

For configurations imported from the same repository, the commit you are
currently building will be used by default. This is intended to help while you
are creating and testing the shared configurations.

You can specify the exact version of a config snippet by using any valid Git
reference:

```yaml
import:
- one.yml@production
- travis-ci/build-configs/other.yml@v1.0.0
```
{: data-file=".travis.yml"}

## Import private repository configs 

In order to share configurations **from** a private repository, this needs to
be allowed on that repository by enabling the *Allow importing config files from this repository*
setting in `More options > Settings > Config Import`.

> Only private repositories owned by the same organization or user account will
> be able to import configuration snippets from private repositories. Configs
> from private repositories cannot be imported to configs from public
> repositories.

## Share Encrypted Secrets

Encrypted secrets contained in imported config snippets can be shared and
decrypted with repositories owned by the same organization or user account.

Configs from public repositories can be imported to configs from other
public repositories owned by a different organization or user account, but
encrypted secrets contained in those imported configs won't be accessible.

## Conditional imports

Config imports can carry a condition that specifies under which circumstances
the imported config is supposed to be included.

For example, with this config the local file `.travis/master.yml` will be
imported for builds on the `master` branch, while `.travis/other.yml` will be
imported for all other builds.

```yaml
import:
- source: .travis/master.yml
  if: branch = master
- source: .travis/other.yml
  if: branch != master
```
{: data-file=".travis.yml"}

Please see [Conditions](/user/conditions-v1) for a full specification of the
conditions syntax.

## Merge modes

The merge mode controls how imported configs are being merged (combined) into
the importing config. A different merge mode can be specified for each imported
config source.

There are these merge modes:

* `deep_merge_append` (default)
* `deep_merge_prepend`
* `deep_merge`
* `merge`

The default merge mode is `deep_merge_append`.

### Deep merge: append and prepend

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
{: data-file=".travis.yml"}

### Deep merge

The merge mode `deep_merge` recursively merges sections (keys) that hold maps (hashes),
but overwrites sequences (arrays).

```yaml
import:
- source: one.yml
  mode: deep_merge # deep merge
```
{: data-file=".travis.yml"}

This mode first merges your `.travis.yml` contents into the `one.yml` file (i.e., items in the .travis.yml file “win”, if the merge mode deep_merge would be used and will overwrite keys on respective levels in `one.yml`).

Respectively:

```yaml
import:
  - source: one.yml
  mode: deep_merge # deep merge
  - source: two.yml
  mode: deep_merge # deep merge
```
{: data-file=".travis.yml"}

This mode first merges your `.travis.yml` contents into the `one.yml` file (overwriting,
if required, sections in `one.yml` with content from `.travis.yml`). The results are
merged into the `two.yml` file (again, items in the result of the previous merge win
over what’s in this one, as the `deep_merge` mode is specified here).

The reasoning behind this is that, in many cases, when you import something to your
`.travis.yml` file, you want to be able to overwrite or customize that imported
configuration with config in your `.travis.yml` file.

### Merge

The merge mode `merge` performs a shallow merge.

This means that root level sections (keys) defined in your `.travis.yml` will
overwrite root-level sections (keys) that are also present in the imported
file.

```yaml
import:
- source: one.yml
  mode: merge # shallow merge
```
{: data-file=".travis.yml"}

## Import precedence

When triggering a build through the Travis API or the web UI, the order of ascending precedence is:

- Config from the API build request payload, if given
- Imported configs from the API build request payload, if given, in the order listed (following a depth-first search pattern in case those imported configs import other configs)
- Config from `.travis.yml`
- Imported configs from `.travis.yml`, in the order listed (following a depth-first search pattern in case those imported configs import other configs).

## FAQ

### Can I import a shared build config at a specific job level?

No. The parsed YAML trees must be merged. Thus, the `import` keyword is accepted only at the root level. If it suits your scenario, you can specify your job template in, e.g., `job.yml` and import it into your `.travis.yml` with the `mode: deep_merge`, adding in the `.travis,yml` specifics to be overridden in the imported template.

### Can I create and use anchors via the shared configs mechanism?

Unfortunately, it’s not supported.
As much as we encourage [using YAML as a build configuration language](/user/build-config-yaml), anchors and aliases, referring to these anchors must be defined and used within a single `.yml` file and will be expanded before any *import* action (merging parse trees) occurs. For the same reason, attempts to assign an anchor within `.travis.yml` to an *imported* key will not work — both `.travis.yml` and `imported.yml` must be parsed before the merge action can occur.

See also  *native-api* concise [explanation in the Community Forum](https://travis-ci.community/t/imported-anchors-not-working/10035/2)


