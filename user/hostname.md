---
title: Setting Custom Hostname
layout: en

---

This addon, available in build environment with `sudo` enabled,
allows you to set the `hostname`.

{% highlight yaml %}
addons:
  hostname: short-hostname
{% endhighlight %}

This is useful when your processes require a short hostname.
For example, [OpenJDK 6 and OpenJDK 7 processes will encounter
buffer overflows when the host name is too long](https://github.com/travis-ci/travis-ci/issues/5227).
