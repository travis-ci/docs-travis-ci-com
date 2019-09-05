---
title: Surge.sh Deployment
layout: en
deploy: v2
provider: surge
---

Travis CI can deploy your static files to [Surge.sh](https://surge.sh/) after a successful build. Builds triggered from Pull Requests will never trigger a deploy.

You will need to set 2 environment variables in your travis settings and set the deployment provider details in `.travis.yml`

### Environment variables

- **SURGE_LOGIN**: Set it to the email address you use with Surge
- **SURGE_TOKEN**: Set it to your login token (get it by doing a `surge token`)

### Configuration of `.travis.yml`:

- Add `surge` as deployment provider in `.travis.yml`

- If your project folder is not the repo root you can set the deploy option `project` to define a path relative to repo root to deploy.

- If you do not have a `CNAME` file with the name of the domain to publish to you can set the deploy option `domain` with the domain to deploy to.

Example:

```yaml
deploy:
  provider: surge
  project: ./static/
  domain: example.surge.sh
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
