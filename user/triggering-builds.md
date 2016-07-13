---
title: Triggering builds through the API
permalink: /user/triggering-builds/
layout: en
---

> This feature is currently in Beta.

Trigger Travis CI builds using the API (*v3 only*) by sending a POST request to `/repo/{slug|id}/requests`.

Before using the Travis CI API you need to use the [command line client](https://github.com/travis-ci/travis.rb#readme) to get an API token:

```bash
travis login --org
travis token --org
```

If you are using Travis CI with a private repository use `--pro` instead of `--org`

Here is a script for sending a minimal request to the master branch of the `travis-ci/travis-core` repository:

```bash
body='{
"request": {
  "branch":"master"
}}'

curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Travis-API-Version: 3" \
  -H "Authorization: token xxxxxx" \
  -d "$body" \
  https://api.travis-ci.org/repo/travis-ci%2Ftravis-core/requests
```

This request triggers a build of the most recent commit on the master branch of the `travis-ci/travis-core` repository, using the `.travis.yml` file in the master branch.

You can also add to or override configuration in the `.travis.yml` file, or change the commit message.
Please note that overriding any of the sections (like `script` or `env`) overrides the full section, the
contents of the .travis.yml file will not be merged with the values contained in
the request.

The following script passes a `message` attribute, and adds to the build configuration by passing environment variables and a script command. Here the config from the `.travis.yml` file is merged with the config from the request body.

> Keys in the request's config override any keys existing in the `.travis.yml`.

```bash
body='{
"request": {
  "message": "Override the commit message: this is an api request",
  "branch":"master",
  "config": {
    "env": {
      "matrix": ["TEST=unit"]
    },
    "script": "echo FOO"
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

### Requests triggered with API and webhooks

Due to a way we use tokens for webhooks authentication, a token needs to be
passed manually as a param for webhooks to work properly. An example request
with token passed as a param would look like:

```json
"request": {
  "branch": "master",
  "token": "a-token"
}
```
