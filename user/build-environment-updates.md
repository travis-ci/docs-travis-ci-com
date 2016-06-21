---
title: Build Environment Update History
layout: en
permalink: /user/build-environment-updates/
---
### December 2014 and later

Roughly, environments will be updated during the first week of the 'even' month
(February, April, June, August, October, December).
Language-specific updates may be released as needed.

<ul class="list--links">
{% for page in site.pages %}
{% if page.category == "build_env_updates" %}
	<li><a href="{{ page.permalink }}" title="{{ page.title }}">{{ page.permalink | remove:'/user/build-environment-updates/' | remove: '/' }}</a></li>
{% endif %}
{% endfor %}
</ul>

### Atom feed
<a href="/feed.build-env-updates.xml">Atom feed</a> is also available.

### Mailing List
You can also sign up to the <a href="http://eepurl.com/9OCsP">announcement mailing list</a>.
