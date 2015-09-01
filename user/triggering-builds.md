---
title: Triggering builds through the API
permalink: /user/triggering-builds/
layout: en
---

This feature is currently in Beta.

Requesting a build through the Travis-CI API can be done by sending a POST request to a `/repo/{slug|id}/requests` path. This endpoint works on API v3 only.

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

This request triggers a build of the last commit on the master branch of the `travis-ci/travis-core` repo, using the `.travis.yml` file within the repo for the commit. 

It's possible to add to or override config in the `.travis.yml` file, or change the commit message.

The following script passes a `message` attribute, and adds to the build configuration by passing environment variables and a script command. Here the config from the `.travis.yml` file is merged with the config from the request body. 
Keys in the request's config override any keys existing in the `.travis.yml`.

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
