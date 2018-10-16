---
title: Building a Clojure project
layout: en

---

## What This Guide Covers

<aside markdown="block" class="ataglance">

| Clojure                                     | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#Dependency-Management) | `project.clj`                             |
| [Default `script`](#Default-Build-Script)   | `lein test`                               |
| [Matrix keys](#Build-Matrix)                | `env`, `lein`, `jdk`                      |
| Support                                     | [Travis CI](mailto:support@travis-ci.com) |

Minimal example:

```yaml
language: clojure
```
{: data-file=".travis.yml"}

</aside>

{{ site.data.snippets.trusty_note_no_osx }}

This guide covers build environment and configuration topics specific to Clojure
projects. Please make sure to read our [Tutorial](/user/tutorial/)
and [general build configuration](/user/customizing-the-build/) guides first.

Clojure builds are not available on the OS X environment.

## CI Environment for Clojure Projects

Travis CI environment provides a large set of build tools for JVM languages with
[multiple JDKs, Ant, Gradle, Maven](/user/languages/java/#Overview) and both
[Leiningen](http://leiningen.org) 1.7.x and 2.4.x (default).

## Dependency Management

If you use Leiningen, it will automatically install any dependencies that are
listed in the `project.clj` file.

### Alternate Install Step

If you need to install other dependencies before your tests can run, you should
set up the proper `:hooks` in `project.clj`.

If for some reason you can't use hooks,you can override the install step in your
`.travis.yml`:

```yaml
install: lein protobuf install
```
{: data-file=".travis.yml"}

See the [build configuration guide](/user/customizing-the-build/) to learn more.

## Default Build Script

The default build script is:

```bash
lein test
```
{: data-file=".travis.yml"}

Projects that find this sufficient can use a very minimalistic .travis.yml file:

```yaml
language: clojure
```
{: data-file=".travis.yml"}

### Using Midje

If your project uses [Midje](https://github.com/marick/Midje), make sure
[lein-midje](https://github.com/marick/Midje/wiki/Lein-midje) is on your
`project.clj` development dependencies list and override `script:` in
`.travis.yml` to run the Midje task:

```yaml
script: lein midje
```
{: data-file=".travis.yml"}

For Leiningen 1 add `:dev-dependencies` to `project.clj`:

```
:dev-dependencies [[midje "1.4.0"]
                   [lein-midje "1.0.10"]])
```
{: data-file=".project.clj"}

Leiningen 2 replaces `:dev-dependencies` with profiles:

```
:profiles {:dev {:dependencies [[midje "1.6.3"]]
                 :plugins [[lein-midje "3.0.0"]]}}
```
{: data-file=".project.clj"}

Please note that for projects that only support Clojure 1.3.0 and later
versions, you may need to exclude transient `org.clojure/clojure` for Midje in
project.clj:

```
:dev-dependencies [[midje "1.4.0" :exclusions [org.clojure/clojure]]
                   [lein-midje "1.0.10"]])
```
{: data-file=".project.clj"}

For real world example, see [Knockbox](https://github.com/reiddraper/knockbox).

### Using Speclj on Travis CI

If your project uses [Speclj](https://github.com/slagyr/speclj), make sure it is
listed in your development dependencies in `project.clj`, and include this
`script:` line in `.travis.yml`:

```yaml
script: lein spec
```
{: data-file=".travis.yml"}

For Leiningen 1, Speclj should be listed under `:dev-dependencies` in `project.clj`:

```
:dev-dependencies [[speclj "3.3.1"]]
```
{: data-file=".project.clj"}

Leiningen 2 replaces `:dev-dependencies` with profiles:

```
:profiles {:dev {:dependencies [[speclj "3.3.1"]]}}
```
{: data-file=".project.clj"}

## Using Leiningen 1

Leiningen 1 is provided side by side with 2.4.x. To use it, specify `lein` key in `.travis.yml`:

```yaml
lein: lein1
```
{: data-file=".travis.yml"}

In case you need to use `lein` binary in `before_script`, `install:`, `script:` commands and so on, use `lein1`:

```yaml
before_install:
  - lein1 bootstrap
```
{: data-file=".travis.yml"}

Task chaining requires using the `do` task:

```yaml
script: lein1 do javac, test
```
{: data-file=".travis.yml"}

## Testing Against Multiple JDKs

As for any JVM language, it is also possible to [test against multiple JDKs](/user/languages/java/#Testing-Against-Multiple-JDKs).

### Examples

- [Monger](https://github.com/michaelklishin/monger/blob/master/.travis.yml)
- [Welle](https://github.com/michaelklishin/welle/blob/master/.travis.yml)
- [Langohr](https://github.com/michaelklishin/langohr/blob/master/.travis.yml)
- [Neocons](https://github.com/michaelklishin/neocons/blob/master/.travis.yml)

## Testing Against Multiple Versions of Clojure

### With Leiningen 1

Leiningen has an excellent plugin called [lein-multi](https://github.com/maravillas/lein-multi) that lets you effortlessly test against multiple versions of
Clojure (for example, 1.3, 1.4 and alphas/betas/snapshots of the most recent development version). Because leiningen can run tests against any version of Clojure (not necessary the same version as Leiningen itself uses),
there is no need for runtime switchers (like RVM) for Clojure.

To use lein-multi on Travis CI, add it to `:plugins` in project.clj (note, this feature is only available starting with Leiningen 1.7.0) and
override `script:` to run `lein multi test` instead of default `lein test`:

```yaml
language: clojure
script: lein1 multi test
```
{: data-file=".travis.yml"}

For a real world example, see [Monger](https://github.com/michaelklishin/monger).

### With Leiningen 2

Leiningen 2 has a core feature that replaces `lein-multi`: [Profiles](https://github.com/technomancy/leiningen/blob/master/doc/TUTORIAL.md). To run your tests against
multiple profiles (and thus, multiple dependency sets or Clojure versions), use `lein with-profile` command like so:

```yaml
lein: lein
script: lein with-profile dev:1.4 test
```
{: data-file=".travis.yml"}

where `dev:1.4` is a colon-separated list of profiles to run `test` task against. Use `lein profiles` to list your project's profiles
and `lein help with-profile` to learn more about the `with-profiles` task.

#### Using a more recent versions of Leiningen

If your Clojure project requires a more recent version of Leiningen, you can specify it with:

```yaml
language: clojure

lein: 2.6.1 # version 2 and up
```
{: data-file=".travis.yml"}

The job will install the specified version of Leiningen if it is not pre-installed,
and move on to install your project's dependencies.

### Example

For a real world example, see [Neocons](https://github.com/michaelklishin/neocons).

## Build Matrix

For Clojure projects, `env`, `lein`, and `jdk` can be given as arrays
to construct a build matrix.

## Examples

- [monger's .travis.yml](https://github.com/michaelklishin/monger/blob/master/.travis.yml)
- [welle's .travis.yml](https://github.com/michaelklishin/welle/blob/master/.travis.yml)
- [langohr's .travis.yml](https://github.com/michaelklishin/langohr/blob/master/.travis.yml)
- [neocons' .travis.yml](https://github.com/michaelklishin/neocons/blob/master/.travis.yml)
- [Knockbox's .travis.yml](https://github.com/reiddraper/knockbox/blob/master/.travis.yml)
- [Sumo's .travis.yml](https://github.com/reiddraper/sumo/blob/master/.travis.yml)
