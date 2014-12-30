---
title: Build Environment Update History
layout: en
permalink: /user/build-environment-updates/
---
### December 2014 and later

<ul>
{% for page in site.pages %}
{% if page.category == "build_env_updates" %}
	<li><a href="{{ page.permalink }}">{{ page.permalink }}</a></li>
{% endif %}
{% endfor %}
</ul>

### Atom feed
<a href="/feed.build-env-updates.xml">Atom feed</a> is also availabe.

### Mailing List
You can also sign up to the <a href="http://eepurl.com/9OCsP">announcement mailing list</a>.
