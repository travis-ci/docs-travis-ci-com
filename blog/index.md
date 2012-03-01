---
title: The Travis Blog
layout: en
---

{% for post in site.posts %}
### [{{ post.title }}](/{{ post.url }})

{{ post.content | strip_html | truncatewords: 75 }}

[Read More](/{{ post.url }})

---
{% endfor %}
