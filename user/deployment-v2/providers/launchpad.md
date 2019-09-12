---
title: Launchpad Deployment
layout: en
deploy: v2
provider: launchpad
---

Travis CI can get [Launchpad](https://launchpad.net/) to automatically import your code from GitHub after a successful build, which is useful if you are building and hosting Debian packages.

To automatically trigger an import:

* [Register](https://launchpad.net/projects/+new) a project on Launchpad and then [import](https://code.launchpad.net/+code-imports/+new) your GitHub project there.
* [Generate](https://help.launchpad.net/API/SigningRequests) an API **access token** that we can use to trigger a new code import. Please make sure that the `oauth_consumer_key` is set to `Travis Deploy`.

{% capture content %}
  The `slug` contains user or team name, project name, and branch name, and is
  formatted like `~user-name/project-name/branch-name`. If your project's code is
  a git repository, the form is `~user-name/project-name/+git/repository-name`.
  You can find your project's slug in the header (and the url) of its
  `code.launchpad.net` page.
{% endcapture %}

{% include deploy/providers/launchpad.md content=content %}

{% include deploy/shared.md %}
