---
title: Triggering builds with API V3

layout: en
---

> Note that if you're still using [travis-ci.org](http://www.travis-ci.org) you need to use `--org` instead of `--com` in all of the commands shown on this page, and make requests to https://api.travis-ci.org.

Trigger Travis CI builds using the API V3 by sending a POST request to `/repo/{slug|id}/requests`:

1. Get an API token from your Travis CI [Profile page](https://travis-ci.com/profile). You'll need the token to authenticate most of these API requests.

   You can also use the Travis CI [command line client](https://github.com/travis-ci/travis.rb#readme)
   to get your API token:

   ```
   travis login --com
   travis token --com
   ```

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
      https://api.travis-ci.com/repo/travis-ci%2Ftravis-core/requests
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
    https://api.travis-ci.com/repo/travis-ci%2Ftravis-core/requests
   ```

4. Look at the response body, which contains information about the build, the
   repository, and the user:

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

{{ site.data.snippets.ghlimit }}

## Customizing the commit message

You can specify a commit message in the request body:

```bash
body='{
  "request": {
    "branch":"master",
    "message": "Override the commit message: this is an api request"
  }
}'
```

## Customizing the build configuration

You can also customize the build configuration.

Choose one of the following merge modes to determine how the original build configuration (in the `.travis.yml` file), and the configuration specified in your API request are combined:

* `replace` replaces the full, original build configuration with the configuration in the API request body
* `merge` (*default*) replaces sections in the original configuration with the configuration in the API request body
* `deep_merge` merges the configuration in the API request body into the build configuration

For example, given that the `.travis.yml` file contains the following configuration:

```yaml
language: ruby
env:
  FOO: foo_from_travis_yaml
```
{: data-file=".travis.yml"}

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

### Merge mode: replace

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

### Merge mode: merge (default)

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
 the API request. Other top level sections remain the same.

### Merge mode: deep_merge

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
