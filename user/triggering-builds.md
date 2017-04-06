---
title: Triggering builds with the API
permalink: /user/triggering-builds/
layout: en
---

Trigger Travis CI builds using V3 of the Travis CI API by sending a POST request to `/repo/{slug|id}/requests`.

Before using the Travis CI API, get an authorization token from the  [command line client](https://github.com/travis-ci/travis.rb#readme):

```bash
travis login --org
travis token --org
```

If you are using Travis CI with a private repository use `--pro` instead of `--org` and use `https://api.travis-ci.com` for all endpoints. See the [API V3 Getting Started Guide](https://developer.travis-ci.org/gettingstarted) for more information.

Here is a script for sending a minimal request to the master branch of the `travis-ci/travis-core` repository.

> If you want to run any of the examples scripts yourself, change the `xxxxxx` in the example to the authentication token you generated and change the repository slug to your own repository.

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

You can specify a commit message in the request body:

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

Choose one of the following merge modes to determine how the original build configuration (in the `.travis.yml` file), and the configuration specified in your API request are combined :

* `replace` replaces the full, original build configuration with the configuration in the API request body
* `merge` (*default*) replaces sections in the original configuration with the configuration in the API request body
* `deep_merge` merges the configuration in the API request body into the build configuration

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

With the `merge_mode` set to `replace` the resulting combined build configuration is:

```json
{
  "env": {
    "BAZ": "baz_from_api_request"
  },
  "script": "echo FOO"
}
```

The full configuration has been replaced by the configuration from the API request.

#### Merge mode: merge (default)

With the `merge_mode` set to `merge`, or not given a `merge_mode` (default), the resulting build configuration is:

```json
{
  "language": "ruby"
  "env": {
    "BAZ": "baz_from_api_request"
  },
  "script": "echo FOO"
}
```

Each of the top level sections have been replaced with the ones from
 the API request, other top level sections remain the same.

#### Merge mode: deep_merge

With the `merge_mode` set to `deep_merge`, the resulting build configuration is:

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

The `env` section from the API request has been merged into the existing `env` section.
