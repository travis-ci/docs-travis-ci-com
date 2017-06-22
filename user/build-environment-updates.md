---
title: Build Environment Update History
layout: en

---

> Please note that the releases listed below are not exhaustive, and that there
> are various means by which the behavior of a given build environment may
> change.  When in doubt, please request clarification via a [GitHub
> issue](https://github.com/travis-ci/travis-ci/issues).

<ul class="list--links">
{% for page in site.pages %}
  {% if page.category == 'build_env_updates' %}
    <li><a href="{{ page.url }}" title="{{ page.title }}">{{ page.url | remove:'/user/build-environment-updates/' | remove: '/' }}</a></li>
  {% endif %}
{% endfor %}
</ul>


### Atom feed

An <a href="/feed.build-env-updates.xml">atom feed</a> is also available.

### Mailing List

You can also sign up for the <a href="http://eepurl.com/9OCsP">announcement mailing list</a>.
