---
title: Triggering builds through the API
permalink: /user/triggering-builds/
layout: en
---

Trigger Travis CI builds using the API (*v3 only*) by sending a POST request to `/repo/{slug|id}/requests`.

Before using the Travis CI API you need to use the [command line client](https://github.com/travis-ci/travis.rb#readme) to get an API token:

```bash
travis login --org
travis token --org
```

If you are using Travis CI with a private repository use `--pro` instead of `--org` and use `https://api.travis-ci.com` for all endpoints.

Here is a script for sending a minimal request to the master branch of the `travis-ci/travis-core` repository:

```bash
body='{
  "request": {
    "branch":"master"
  }
}'

curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Travis-API-Version: 3" \
  -H "Authorization: token xxxxxx" \
  -d "$body" \
  https://api.travis-ci.org/repo/travis-ci%2Ftravis-core/requests
```

> The %2F in the request URL is required so that the owner and repository name in the repository slug are interpreted as a single URL segment.

This request triggers a build of the most recent commit on the master branch of the `travis-ci/travis-core` repository, using the `.travis.yml` file in the master branch.

### Customizing the commit message

You can specify a commit message like so:

```bash
body='{
  "request": {
    "branch":"master",
    "message": "Override the commit message: this is an api request"
  }
}'
```

### Customizing the build configuration

You can also customize the build configuration.

For controlling how the original build configuration (in the `.travis.yml` file), and the configuration given in your API request are combined you can choose one out of 3 merge modes:

* `replace` replaces the full, original build configuration with the given configuration
* `merge` replaces sections in the original configuration with the given section (default)
* `deep_merge` deep merges the given configuration into the build configuration

For example, given that the `.travis.yml` file contains the following configuration:

```yaml
language: ruby
env:
  FOO: foo_from_travis_yaml
```

And given we send the following configuration as an API request:

```bash
body='{
  "request": {
    "config": {
      "merge_mode": [...],
      "env": {
        "BAZ": "baz_from_api_request"
      },
      "script": "echo FOO"
    }
  }
}'
```

#### Merge mode: replace

With the `merge_mode` set to `replace` the resulting build configuration will be the following.

```json
{
  "env": {
    "BAZ": "baz_from_api_request"
  },
  "script": "echo FOO"
}
```

I.e. the full configuration has been replaced by the configuration from the API request.

#### Merge mode: merge (default)

With the `merge_mode` set to `merge`, or not given a `merge_mode` (default), the resulting build configuration will be the following.

```json
{
  "language": "ruby"
  "env": {
    "BAZ": "baz_from_api_request"
  },
  "script": "echo FOO"
}
```

I.e. each of the top level sections have been replaced with the ones given in the API request, other top level sections will remain the same.

#### Merge mode: deep_merge

With the `merge_mode` set to `deep_merge`, the resulting build configuration will be the following.

```json
{
  "language": "ruby"
  "env": {
    "FOO": "foo_from_travis_yaml",
    "BAZ": "baz_from_api_request"
  },
  "script": "echo FOO"
}
```

I.e. the `env` section from the API request has been merged into the existing section.
