---
title: Travis YAML reference
layout: en

---


<ul>
{% for key in site.data.travisyml %}
  <li>
    <a href="{{ key[1] }}"><code>{{key[0]}}</code></a>
  </li>
{% endfor %}
</ul>
