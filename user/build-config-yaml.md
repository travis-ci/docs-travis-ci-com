---
title: Using YAML as a build configuration language

layout: en
---

Travis CI uses YAML as the primary language for build configuration stored in
the main `.travis.yml` build config file, as well as other config sources
imported using the [Build Config Imports](/build-config-imports) feature.

This page documents a few noteworthy pieces of information about how
Travis CI uses YAML.

## Usage of YAML anchors and aliases

In more advanced use cases, in order to reduce repetition in large build config
files a good practice is to use YAML's mechanism of defining and reusing shared
config portions as YAML anchors and aliases.

For example, instead of repeating a deployment configuration for two different
deployment targets like this:

```yaml
deploy:
- provider: heroku
  api_key: ...
  app: app-production
  on:
    branch: master
- provider: heroku
  api_key: ...
  app: app-staging
  on:
    branch: staging
```

It is possible to reuse a piece of YAML like this:

```yaml
deploy:
- &deploy
  provider: heroku
  api_key: ...
  app: app-production
  on:
    branch: master
- <<: *deploy
  app: app-staging
  on:
    branch: staging
```

## Private keys as YAML anchors and aliases and external tooling

In some cases it might be better to define a shared piece of YAML config in a
different place than where it is going to be used, e.g. in order to increase
readability.

For example, one might define several jobs by reusing a shared portion of
YAML like this:

```yaml
_shared_job: &shared_job
  script: echo "shared script config"
  # ...
jobs:
  include:
  - name: Job 1
    <<: *shared_job
  - name: Job 2
    <<: *shared_job
```

The extra key `_shared_job` is an unknown key according to Travis CI's
[Build Config Schema](https://config.travis-ci.com/). In other cases, some external
tools meant for use on Travis CI rely on storing configuration in Travis CI's
build config files, also adding unknown keys.

*It is recommended to prefix such keys with an underscore*, marking them as a
private config key, avoiding potential naming clashes with future additions to
the Build Config Schema.

## Version numbers

Travis CI used to use a plain Ruby YAML parser for parsing build configuration
given as YAML for a long time. This has caused version numbers given as YAML
numbers sometimes to be truncated in unintended ways. In turn, our
documentation, as well as a lot of external articles and posts have recommended
quoting version numbers so the YAML parser would interpret them as strings.

*This no longer applies* if the feature [Build Config Validation](/user/build-config-validation)
is active for the given repository.

For example, specifying a Node.js version as `node_js: 9.10` would have been
parsed into `9.0`, not matching the intended version. As a solution we would
have recommended specifying `node_js: "9.10"` instead.

With the introduction of a new YAML parser as part of the [Build Config Validation](/user/build-config-validation) 
feature, this is *no longer required* because this parser turns YAML
numbers into Ruby strings, which will be typecasted later only if required
by our [Build Config Schema](https://config.travis-ci.com/).
