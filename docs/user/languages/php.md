---
title: Building a PHP project
layout: en
permalink: php/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to PHP projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Choosing PHP versions to test against

PHP VM images on travis-ci.org provide several PHP versions including XDebug as well as PHPUnit. Travis uses [phpenv](https://github.com/CHH/phpenv) to manage the different PHP vesions installed on the VM. A minimalistic .travis.yml file would look like this:

    language: php
    php:
      - 5.5
      - 5.4

This will make Travis run your tests using

    phpunit

by default against the latest 5.4.x and 5.5.x releases. 5.4 and 5.5 are aliases for "the most recent x.y.z release" of any given line. Note that "most recent" means "as provided by the Travis maintainers", not necessarily the very latest official php.net release. For a full listing of the supported versions see [About Travis CI Environment](/docs/user/ci-environment/).

Also note that specifying exact versions like 5.3.8 is discouraged as your .travis.yml file may become out of date and break your build when we update PHP versions on Travis.

For example, see [travis-ci-php-example .travis.yml](https://github.com/travis-ci/travis-ci-php-example/blob/master/.travis.yml).

## Default Test Script

### PHPUnit

By default Travis will run your tests using

    phpunit

for every PHP version you specify.

If your project uses something other than PHPUnit, [you can override our default test command to be anything](/docs/user/build-configuration/) you want.

### Working with atoum

Instead of PHPunit, you can also use [atoum](https://github.com/atoum/atoum) to test your projects. For example:

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
      - SYMFONY_VERSION="2.0.*" DB=mysql
      - SYMFONY_VERSION="dev-master" DB=mysql

and then use ENV variable values in any later script like your dependencies installation scripts, test cases or test script parameter values.

Here is an example using the above ENV variable to modify the dependencies when using the composer package manager to run the tests against the 2 different versions of Symfony as defined above.

    before_script:
       - composer require symfony/framework-bundle:${SYMFONY_VERSION}

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

You can also install [Composer](http://packagist.org/) packages into the Travis PHP environment. The composer
command comes pre-installed, so just use the following:

    composer install

To ensure that everything works, use http(s) URLs on [Packagist](http://packagist.org/) and not git URLs.

## PHP installation

You'll find the default configure options used to build the different PHP versions used on Travis [here](https://github.com/travis-ci/travis-cookbooks/blob/master/ci_environment/phpbuild/templates/default/default_configure_options.erb), it will give you an overview of Travis' PHP installation.

However please note the following differences between the different PHP versions available on Travis:

* For unmaintained PHP versions we provide (5.2.x, 5.3.3), OpenSSL extension is disabled because of [compilation problems with OpenSSL 1.0](http://about.travis-ci.org/blog/upcoming_ubuntu_11_10_migration/). Recent PHP 5.3.x and 5.4.x releases we provision do have OpenSSL extension support.
* Pyrus is obviously not available for PHP 5.2.x.
* Different SAPIs:

  * 5.2.x and 5.3.3 come with php-cgi only.
  * 5.3.x (last version in the 5.3 branch) comes with php-fpm only (see this [issue](https://bugs.php.net/bug.php?id=53271:)).
  * 5.4.x and 5.5.x come with php-cgi *and* php-fpm.

## Custom PHP configuration

The easiest way to customize PHP's configuration is to use `phpenv config-add` to add a custom config file with your configuration directives:

    before_script: phpenv config-add myconfig.ini

And myconfig.ini:

    extension = "mongo.so"
    date.timezone = "Europe/Paris"
    default_socket_timeout = 120
    # some other configuration directives...

You can also use this one line command:

    echo 'date.timezone = "Europe/Paris"' >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

## PHP extensions

### Core extensions

See the [default configure options](https://github.com/travis-ci/travis-cookbooks/blob/master/ci_environment/phpbuild/templates/default/default_configure_options.erb) to get an overview of the core extensions enabled.

### Preinstalled PHP extensions

There are some common PHP extensions preinstalled with PECL on Travis:

* [apc.so](http://php.net/apc)
* [memcache.so](http://php.net/memcache)
* [memcached.so](http://php.net/memcached)
* [mongo.so](http://php.net/mongo)
* [amqp.so](http://php.net/amqp)
* [zmq.so](http://php.zero.mq/)
* [xdebug.so](http://xdebug.org)

Please note that these extensions are not enabled by default, you will have to enable them by adding an `extension="<extension>.so"` line to a PHP configuration file (for the current PHP version). So the easiest way to do this is by using phpenv to add a custom config file which enables and eventually configure the extension:

    before_script: phpenv config-add myconfig.ini

And myconfig.ini:

    extension="mongo.so"
    # some other mongo specific configuration directives
    # or general custom PHP settings...

You can also use this one line command:

    echo "extension = <extension>.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

### Installing additional PHP extensions

It is possible to install custom PHP extensions into the Travis environment using [PECL](http://pecl.php.net/), but they have to be built against the PHP version being tested. Here is for example how the `memcache` extension can be installed:

    pecl install <extension>

PECL will automatically enable the extension at the end of the installation. If you want to configure your extension, use the `phpenv config-add` command to add a custom ini configuration file in your before_script.

It is also possible to do the installation "manually", but you'll have to manually enable the extension after the installation either with `phpenv config-add` and a custom ini file or with this one line command:

    echo "extension=<extension>.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

See also the [full script using midgard2](https://github.com/bergie/midgardmvc_core/blob/master/tests/travis_midgard2.sh).

If you need specific version of preinstalled extension, you need to force install specific version with the `-f` flag. For example:

    pecl install -f mongo-1.2.12


### Chef Cookbooks for PHP

If you want to learn all the details of how we build and provision multiple PHP installations, see our [php, phpenv and php-build Chef cookbooks](https://github.com/travis-ci/travis-cookbooks/tree/master/ci_environment).
