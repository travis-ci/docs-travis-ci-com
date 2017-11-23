---
title: Travis YAML reference
layout: en

---

<ul>
{% for key in site.data.travisyml %}
{% unless key[1] contains "TODO" %}
<li>
<a href="{{ key[1] }}"><code>{{ key[0] }}</code></a>
</li>
{% endunless %}
{% endfor %}
</ul>

We are adding documentation links for all keys you can use in `.travis.yml` as fast as we can. Help by [editing `travisyml.yml`]( https://github.com/travis-ci/docs-travis-ci-com/edit/master/_data/travisyml.yml).
