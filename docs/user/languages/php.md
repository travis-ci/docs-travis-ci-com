---
title: Building a PHP project
layout: en
permalink: php/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to PHP projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Choosing PHP versions to test against

PHP workers on travis-ci.org provide PHP 5.2, 5.3, 5.4 including XDebug as well as PHPUnit. A minimalistic .travis.yml file would look like this:

    language: php
    php:
      - 5.3
      - 5.4

This will make Travis run your tests using

    phpunit

by default against the latest 5.3.x and 5.4.x releases. 5.3 and 5.4 are aliases for "the most recent x.y.z release" of any given line. Note that "most recent" means "as provided by the Travis maintainers", not necessarily the very latest official php.net release. For a full listing of the supported versions see [About Travis CI Environment](/docs/user/ci-environment/).

Also note that specifying exact versions like 5.3.8 is discouraged as your .travis.yml file may become out of date and break your build when we update PHP versions on Travis.

For example, see [travis-ci-php-example .travis.yml](https://github.com/travis-ci/travis-ci-php-example/blob/master/.travis.yml).

### OpenSSL extension support

For unmaintained PHP versions we provide (5.2.x, 5.3.3), OpenSSL extension is disabled because of [compilation problems with OpenSSL 1.0](http://about.travis-ci.org/blog/upcoming_ubuntu_11_10_migration/). Recent PHP 5.3.x and 5.4.x releases we provision do have OpenSSL extension support.


## Default Test Script

By default Travis will run your tests using

    phpunit

for every PHP version you specify.

If your project uses something other than phpunit, [you can override our default test command to be anything](/docs/user/build-configuration/) you want.

### Working with atoum

Instead of PHPunit, you can also use [atoum](https://github.com/mageekguy/atoum) to test your projects. For example:

    before_script: wget http://downloads.atoum.org/nightly/mageekguy.atoum.phar
    script: php mageekguy.atoum.phar

## Dependency Management (a.k.a. vendoring)

Before Travis can run your test suite, it may be necessary to pull down your project dependencies. It can be done using a PHP script, a shell script or anything you need. Define one or more commands you want Travis CI to use with the *before_script* option in your .travis.yml, for example:

    before_script: php vendor/vendors.php

or, if you need to run multiple commands sequentially:

    before_script:
      - ./bin/ci/install_dependencies.sh
      - php vendor/vendors.php

Even though installed dependencies will be wiped out between builds (VMs we run tests in are snapshotted), please be reasonable about the amount of time and network bandwidth it takes to install them.

### Testing Against Multiple Versions of Dependencies (e.g. Symfony)

If you need to test against multiple versions of, say, Symfony, you can instruct Travis to do multiple runs with different sets or values of environment variables. Use *env* key in your .travis.yml file, for example:

    env:
      - SYMFONY_VERSION=2.0.*,DB=mysql
      - SYMFONY_VERSION=dev-master,DB=mysql

and then use ENV variable values in any later script like your dependencies installation scripts, test cases or test script parameter values.

Here is an example using the above ENV variable to modify the dependencies when using the composer package manager to run the tests against the 2 differnt versions of Symfony as defined above.

    before_script:
       - curl -s http://getcomposer.org/installer | php --
       - php composer.phar require symfony/framework-bundle:${SYMFONY_VERSION}

Here we use DB variable value to pick phpunit configuration file:

    script: phpunit --configuration $DB.phpunit.xml

The same technique is often used to test projects against multiple databases and so on.

To see real world examples, see:

* [FOSRest](https://github.com/FriendsOfSymfony/FOSRest/blob/master/.travis.yml)
* [LiipHyphenatorBundle](https://github.com/liip/LiipHyphenatorBundle/blob/master/.travis.yml)
* [doctrine2](https://github.com/doctrine/doctrine2/blob/master/.travis.yml)

### Installing PEAR packages

If your dependencies include PEAR packages, the Travis PHP environment has the [Pyrus](http://pear2.php.net/) and [pear](http://pear.php.net/) commands available:

    pyrus install http://phptal.org/latest.tar.gz
    pear install pear/PHP_CodeSniffer

After install you should refresh your path

    phpenv rehash

So, for example when you want to use phpcs, you should execute:

    pyrus install pear/PHP_CodeSniffer
    phpenv rehash

Then you can use phpcs as simply as phpunit command

### Installing Composer packages

You can also install [Composer](http://packagist.org/) packages into the Travis PHP environment. Use the following:

    curl -s http://getcomposer.org/installer | php
    php composer.phar install

### Installing PHP extensions

It is possible to install custom PHP extensions into the Travis environment using [PECL](http://pecl.php.net/), but they have to be built against the PHP version being tested. Here is for example how the `memcache` extension can be installed:

    pecl install memcache
    echo "extension=memcache.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`

It is also possible to do the installation "manually". This is how the `memcache` extension can be installed this way:

    wget http://pecl.php.net/get/memcache-2.2.6.tgz
    tar -xzf memcache-2.2.6.tgz
    sh -c "cd memcache-2.2.6 && phpize && ./configure --enable-memcache && make && sudo make install"
    echo "extension=memcache.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`

See also the [full before_script using midgard2](https://github.com/bergie/midgardmvc_core/blob/master/tests/travis_midgard.sh) or another one for [mongo php driver](https://gist.github.com/2351174).

### Chef Cookbooks for PHP

If you want to learn all the details of how we build and provision multiple PHP installations, see our [php, phpenv and php-build Chef cookbooks](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base).
