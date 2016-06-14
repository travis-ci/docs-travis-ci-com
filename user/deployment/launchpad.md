---
title: Launchpad deployment
layout: en
permalink: /user/deployment/launchpad/
---

Travis CI can get [Launchpad](https://launchpad.net/) to automatically import your code from GitHub after a successful build, which is useful if you are building and hosting Debian packages.

To automatically trigger an import:

1. [Register](https://launchpad.net/projects/+new) a project on Launchpad and then [import](https://code.launchpad.net/+code-imports/+new) your GitHub project there.
2. [Generate](https://help.launchpad.net/API/SigningRequests) an API **access token** that we can use to trigger a new code import. Please make sure that the `oauth_consumer_key` is set to `Travis Deploy`.
3. Add the following to your `.travis.yml`

```yaml
deploy:
  provider: launchpad
  slug: "LAUNCHPAD PROJECT SLUG"
  oauth_token: "YOUR OAUTH_TOKEN"
  oauth_token_secret: "YOUR OAUTH_TOKEN_SECRET"
```

It is recommended to [encrypt both your `oauth_token` and your `oauth_token_secret`](/user/deployment/launchpad/#Encrypting-your-OAUTH-tokens).

The `slug` contains user or team name, project name, and branch name, and is formatted like `~user-name/project-name/branch-name`. You can find your project's slug in the header (and the url) of its `code.launchpad.net` page.

<figure>
  <img alt="Launchpad slug" src="/images/launchpad-slug.png"/>
</figure>

### Encrypting your OAUTH tokens

It is recommended that you encrypt both OAUTH tokens using the Travis CI command line client by removing them from your `travis.yml` above and running the following commands:

```bash
$ travis encrypt TOKEN="YOUR OAUTH_TOKEN" --add deploy.oauth_token
$ travis encrypt TOKEN_SECRET="YOUR OAUTH_TOKEN_SECRET" --add deploy.oauth_token_secret
```

The resulting `.travis.yml` looks like this:

```yaml
deploy:
  provider: launchpad
  slug: "LAUNCHPAD PROJECT SLUG"
  oauth_token:
    secure: KmMdcwTWGubXVRu93/lY1NtyHxrjHK4TzCfemgwjsYzPcZuPmEA+pz+umQBN\n1ZhzUHZwDNsDd2VnBgYq27ZdcS2cRvtyI/IFuM/xJoRi0jpdTn/KsXR47zeE\nr2bFxRqrdY0fERVHSMkBiBrN/KV5T70js4Y6FydsWaQgXCg+WEU=
  oauth_token_secret:
    secure: jAglFtDjncy4E3upL/RF0ZOcmJ2UMrqHFCLQwU8PBdurhTMBeTw+IO6cXx5z\nU5zqvPYo/ghZ8mMuUhvHiGDM6m6OlMP7+l10VTxH1CoVew2NcQvRdfK3P+4S\nZJ43Hyh/ZLCjft+JK0tBwoa3VbH2+ZTzkRZQjdg54bE16C7Mf1A=
```
