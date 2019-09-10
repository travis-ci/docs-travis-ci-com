---
title: GitHub Pages Deployment
layout: en
deploy: v2
provider: pages
---

Travis CI can deploy to [GitHub Pages](https://pages.github.com/) after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: pages
  token: <encrypted token>
  on:
    branch: master
```
{: data-file=".travis.yml"}

{% include deploy/providers/pages_git.md %}

You can use a [personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
with the `public_repo` or `repo` scope (`repo` is required for private
repositories).

## Setting the GitHub token

{% include deploy/shared.md %}
