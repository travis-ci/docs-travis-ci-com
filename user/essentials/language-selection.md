---
title: Language selection
layout: en
permalink: /user/essentials/language-selection/
---

## Specifying Runtime Versions

One of the key features of Travis CI is the ease of running your test suite against multiple runtimes and versions. Specify what languages and runtimes to run your test suite against in the `.travis.yml` file:

{% include languages.html %}

## Installing a Second Programming language

If you need to install a second programming language in your current build environment, for example installing a more recent version of Ruby than the default version present in all build environments you can do so in the `before_install` stage of the build:

```yml
before_install:
- rvm install 2.1.5
```

You can also use other installation methods such as `apt-get`.
