---
title: GitHub Pages Deployment
layout: en
deploy: v2
provider: pages
---

Travis CI can deploy to [GitHub Pages](https://pages.github.com/) after a successful build.

{% capture content %}
  You can use a [personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
  with the `public_repo` or `repo` scope (`repo` is required for private repositories).
{% endcapture %}

{% include deploy/providers/pages_git.md content=content %}

## Setting the GitHub token

{% include deploy/shared.md %}
