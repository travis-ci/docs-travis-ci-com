---
title: Building a PHP project
kind: content
---

PHP workers on travis-ci.org provide PHP 5.3, 5.4.0RC1 and phpunit. A minimalistic .travis.yml file would looks like this:

    language: php
    php:
      - 5.3
      - 5.4

This will make Travis run your tests using

    phpunit

by default against the latest 5.3.x and 5.4.x releases. 5.3 and 5.4 are aliases for "the most recent x.y.z release" of any given line. Note that "most recent" means
"as provided by the Travis maintainers, not necessarily the very latest official php.net release.

Also note that specifying exact versions like 5.3.8 is discouraged as your .travis.yml file may become out of date and break your build when we update
PHP versions on Travis.

For example, see [FOSTwitterBundle .travis.yml](https://github.com/FriendsOfSymfony/FOSTwitterBundle/blob/master/.travis.yml).


If your project uses something other than phpunit, you can override our default test command to be anything you want. See the
"Overriding script, before_install, before_script and friends" section below.


### Dependency Management (a.k.a. vendoring)

Before Travis can run your test suite, it may be necessary to pull down your project dependencies. It can be done using a PHP
script, a shell script or anything you need. Define one or more commands you want Travis CI to use with the *before_script* option
in your .travis.yml, for example:

    before_script: php vendor/vendors.php

or, if you need to run multiple commands sequentially:

    before_script:
      - ./bin/ci/install_dependencies.sh
      - php vendor/vendors.php

Even though installed dependencies will be wiped out between builds (VMs we run tests in are snapshotted), please be reasonable about the amount of time and network bandwidth it takes to install them.

#### Installing Ubuntu packages

If your dependencies need native libraries to be available, you can use passwordless sudo to install them with

    sudo apt-get install [packages list]

#### Installing PEAR packages

If your dependencies include PEAR packages, the Travis PHP environment has the [Pyrus command](http://pear2.php.net/) available:

    pyrus install http://phptal.org/latest.tar.gz

After install you should refresh your path

    phpenv rehash

So, for example when you want to use phpcs, you should execute:

    pyrus install pear/PHP_CodeSniffer
    phpenv rehash

Then you can use phpcs as simply as phpunit command

#### Installing Composer packages

You can also install [Composer](http://packagist.org/) packages into the Travis PHP environment. Use the following:

    wget http://getcomposer.org/composer.phar 
    php composer.phar install

#### Installing PHP extensions

It is possible to install custom PHP extensions into the Travis environment, but they have to be built against the PHP version being tested. Here is for example how the `memcache` extension can be installed:

    wget http://pecl.php.net/get/memcache-2.2.6.tgz
    tar -xzf memcache-2.2.6.tgz
    sh -c "cd memcache-2.2.6 && phpize && ./configure --enable-memcache && make && sudo make install"
    echo "extension=memcache.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`

See also the [full before_script using midgard2](https://github.com/bergie/midgardmvc_core/blob/master/tests/travis_midgard.sh).

#### Multiple Versions of Dependencies (e.g. Symfony)

If you need to test against multiple versions of, say, Symfony, you can instruct Travis to do multiple runs with different sets or values of
environment variables. Use *env* key in your .travis.yml file, for example:

    env:
      - SYMFONY_VERSION=v2.0.5
      - SYMFONY_VERSION=origin/master

and then use ENV variable values in your dependencies installation scripts, test cases or test script parameter values. Here we use
DB variable value to pick phpunit configuration file:

    script: phpunit --configuration $DB.phpunit.xml

The same technique is often used to test projects against multiple databases and so on.

To see real world examples, see [FOSUserBundle](https://github.com/FriendsOfSymfony/FOSUserBundle/blob/master/.travis.yml), [FOSRest .travis.yml](https://github.com/FriendsOfSymfony/FOSRest/blob/master/.travis.yml)
and [doctrine2 .travis.yml](https://github.com/pborreli/doctrine2/blob/master/.travis.yml).

#### Working with atoum

Instead of PHPunit, you can also use [atoum](https://github.com/mageekguy/atoum)

    before_script: wget http://downloads.atoum.org/nightly/mageekguy.atoum.phar

    script: php mageekguy.atoum.phar


### Overriding script, before_install, before_script and friends

See <a href="/docs/user/build-configuration/">Build configuration</a> to learn about *script*, *before_install*, *before_script*, branches configuration, email notification
configuration and so on.



### Provided PHP Versions

 * 5.3.x (currently 5.3.8)
 * 5.4.x (currently 5.4.0RC1)

Please see our [php, phpenv and phpfarm Chef cookbooks](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base) if you want to learn more.
