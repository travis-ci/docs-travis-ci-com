---
title: Deployment (v2)
layout: en
---

>ALPHA This page documents deployments using the next major version dpl v2 which is in a preview release phase. Please see [the announcement blog post](https://blog.travis-ci.com/2019-08-27-deployment-tooling-dpl-v2-preview-release) on details about the release process. Documentation for dpl v1, the current default version, can be found [here](/user/deployment).
{: .alpha}

## Supported Providers

Continuous Deployment to the following providers is supported:

<ul class="list-language">
{% for provider in site.data.deploy_providers_v2 %}
  <li><a href="{{provider[1]}}">{{provider[0]}}</a></li>
{% endfor %}
</ul>

To deploy to a custom or unsupported provider, use the [after-success build
step](/user/deployment/custom/) or [script provider](/user/deployment/script).

{% include deploy/overview.md %}
