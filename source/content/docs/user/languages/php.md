---
title: Building a PHP project
kind: content
---

PHP workers on travis-ci.org provide PHP 5.3, 5.4.0RC1 and phpunit. A minimalistic .travis.yml file would looks like this:

    language: php
    php:
      - 5.3
      - 5.4
    script: phpunit

This will make Travis run your tests against the latest (as provided by Travis maintainers, not necessary the absolutely the latest) 5.3.x branch release. 5.4 is an alias
for "the most recent 5.4.x release" and so on. Please note that using exact versions (for example, 5.3.8) is highly discouraged because as versions change, your
.travis.yml will get outdated and things will break.

For example, see [FOSTwitterBundle .travis.yml](https://github.com/FriendsOfSymfony/FOSTwitterBundle/blob/master/.travis.yml).


### Dependency Management (a.k.a. vendoring)

TBD


#### Multiple Versions of Dependencies (e.g. Symfony)

TBD

For example, see [FOSUserBundle](https://github.com/FriendsOfSymfony/FOSUserBundle/blob/master/.travis.yml), [FOSRest .travis.yml](https://github.com/FriendsOfSymfony/FOSRest/blob/master/.travis.yml)
and [doctrine2 .travis.yml](https://github.com/pborreli/doctrine2/blob/master/.travis.yml).



### Overriding script, before_install, before_script and friends

See <a href="/docs/user/build-configuration/">Build configuration</a> to learn about *script*, *before_install*, *before_script*, branches configuration, email notification
configuration and so on.



### Provided PHP Versions

 * 5.3.x (currently 5.3.8)
 * 5.4.x (currently 5.4.0RC1)

Please see our [php, phpenv and phpfarm Chef cookbooks](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base) if you want to learn more.
