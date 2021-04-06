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
   `/repo/travis-ci/travis-core/requests` to trigger a build of a specific 
   commit (omit `sha` for most recent) of the master branch of the `travis-ci/travis-core` repository:

   ```bash
   body='{
   "request": {
   "branch":"master"
   "sha":"bf944c952724dd2f00ff0c466a5e217d10f73bea"
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
    "merge_mode": "deep_merge",
    "config": {
      "env": {
        "jobs": [
          "TEST=unit"
        ]
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
         ...
       }
     },
     "resource_type": "request"
   }
   ```

5. Visit the [API V3 explorer](https://developer.travis-ci.com/) for more information
   about what endpoints are available and what you can do with them.

{{ site.data.snippets.ghlimit }}

## Customizing the commit message

You can specify a commit message in the request body:

```bash
body='{
  "request": {
    "branch":"master",
    "message": "Override the commit message: this is an api request"
    ...
  }
}'
```

## Merge modes

The merge mode controls how the build config in your `.travis.yml` is merged
(combined) into the build config sent with your POST request.

There are the following merge modes:

* `deep_merge_append`
* `deep_merge_prepend`
* `deep_merge`
* `merge`
* `replace`

The default merge mode is `deep_merge_append` with [Build Config Validation](/user/build-config-validation)
enabled. With Build Config Validation disabled the default is `deep_merge`,
which will be discontinued soon.

We recommend to specify the merge mode with your API requests explicitly.

Consider these examples:

```json
# build config sent via API
{
  "env": [
    "API=true"
  ],
  "cache": {
    "directories": [
      "./one"
    ]
  },
  "addons": {
    "snap": "snap"
  }
}
```

```yaml
# build config in your .travis.yml file
env:
- TRAVIS_YML=true
cache:
  apt: true
addons:
  apt:
    packages:
    - cmake
```

### Deep merge append/prepend

The merge modes `deep_merge_append` and `deep_merge_prepend` recursively merge
sections (keys) that hold maps (hashes), and concatenates sequences (arrays) by
either appending or prepending to the sequence in the importing config.

Given the merge mode `deep_merge_append`, with the example build configs above
the result will be:

```json
{
  "env": [
    "TRAVIS_YML=true",
    "API=true"
  ],
  "cache": {
    "apt": true,
    "directories": [
      "./one"
    ]
  },
  "addons": {
    "snap": "snap",
    "apt": {
      "packages": [
        "cmake"
      ]
    }
  }
}
```

Given the merge mode `deep_merge_prepend`, with the example build configs above
the result will be:

```json
{
  "env": [
    "API=true",
    "TRAVIS_YML=true"
  ],
  "cache": {
    "apt": true,
    "directories": [
      "./one"
    ]
  },
  "addons": {
    "snap": "snap",
    "apt": {
      "packages": [
        "cmake"
      ]
    }
  }
}
```

### Deep merge

The merge mode `deep_merge` recursively merges sections (keys) that hold maps (hashes),
but overwrites sequences (arrays).

Given the merge mode `deep_merge`, with the example build configs above
the result will be:

```json
{
  "env": [
    "API=true"
  ],
  "cache": {
    "apt": true,
    "directories": [
      "./one"
    ]
  },
  "addons": {
    "snap": "snap",
    "apt": {
      "packages": [
        "cmake"
      ]
    }
  }
}
```

### Merge

The merge mode `merge` performs a shallow merge.

This means that root level sections (keys) defined in your `.travis.yml` will
overwrite root level sections (keys) that are also present in the imported
file.

Given the merge mode `merge`, with the example build configs above the result
will be the following. The top level keys `cache` and `addons` replace the ones
in `.travis.yml`:

```json
{
  "env": [
    "API=true"
  ],
  "cache": {
    "apt": true
  },
  "addons": {
    "snap": "snap"
  }
}
```
### Replace

The merge mode `replace` instructs Travis CI to simply replace the build config
in your `.travis.yml` file with the config sent with your API request.

```json
{
  "env": [
    "API=true"
  ],
  "cache": {
    "directories": [
      "./one"
    ]
  },
  "addons": {
    "snap": "snap"
  }
}
```

