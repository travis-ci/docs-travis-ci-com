---
title: Triggering builds with API V3
permalink: /user/triggering-builds/
layout: en
---

Trigger Travis CI builds using the API V3 by sending a POST request to `/repo/{slug|id}/requests`:

1. Get an API token using the Travis CI [command line client](https://github.com/travis-ci/travis.rb#readme):

   ```
   travis login --org
   travis token --org
   ```

   You'll need the token to make most API requests.

   > If you are using Travis CI with a private repository use `--pro` instead of
     `--org` in the previous commands, and use `https://api.travis-ci.com` in all API requests.

2. Send a request to the API. This example shell script sends a POST request to
   `/repo/travis-ci/travis-core/requests` to trigger a build of the most recent
   commit of the master branch of the `travis-ci/travis-core` repository:

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

   > The %2F in the request URL is required so that the owner and repository
     name in the repository slug are interpreted as a single URL segment.


   The build uses the `.travis.yml` file in the master branch, but you can add to
   or override configuration, or change the commit message. Overriding any section
   (like `script` or `env`) overrides the full section, the contents of the
   `.travis.yml` file is *not* merged with the values contained in the request.

3. Send a more complex request to the API. The following script triggers a build
   and also passes a `message` attribute for the commit, and adds to the build
   configuration by passing environment variables and a script command. Here the
   config from the `.travis.yml` file *is* merged with the config from the request body.

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
   }}'

   curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Travis-API-Version: 3" \
    -H "Authorization: token xxxxxx" \
    -d "$body" \
    https://api.travis-ci.org/repo/travis-ci%2Ftravis-core/requests
   ```

4. Look at the reponse body, which contains information about the build, the
   repository and the user:

   ```json
   {
     "@type": "pending",
     "remaining_requests": 1,
     "repository": {
       "@type": "repository",
       "@href": "/repo/39521",
       "@representation": "minimal",
       "id": 39521,
       "name": "test-2",
       "slug": "svenfuchs/test-2"
     },
     "request": {
       "repository": {
         "id": 44258138,
         "owner_name": "svenfuchs",
         "name": "test-2"
       },
       "user": {
         "id": 3664
       },
       "id": 205729,
       "message": null,
       "branch": "master",
       "config": {
       }
     },
     "resource_type": "request"
   }
   ```

5. Visit the [API V3 explorer](http://developer.travis-ci.com/) for more information
   about what endpoints are available and what you can do with them.

## Requests triggered with API and webhooks

Due to how we use tokens for webhook authentication, you need to explicitly
pass an API token as a parameter to the API for webhooks to work properly.

An example request with token passed as a parameter:

```json
"request": {
  "branch": "master",
  "token": "a-token"
}
```
