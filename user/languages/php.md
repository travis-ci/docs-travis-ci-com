---
title: Building a PHP project
layout: en
permalink: /user/languages/php/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to PHP projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

PHP builds are not available on the OSX environment.

<div id="toc"></div>

## Choosing PHP versions to test against

PHP VM images on travis-ci.org provide several PHP versions including XDebug as well as PHPUnit. Travis CI uses [phpenv](https://github.com/CHH/phpenv) to manage the different PHP versions installed on the VM.

A minimalistic `.travis.yml` file would look like this:

```yaml
language: php
php:
  - '5.4'
  - '5.5'
  - '5.6'
  - '7.0'
  - hhvm
  - nightly
```
The previous example uses `phpunit`, the default build script, to build against the following list of PHP versions:

* 5.4.x
* 5.5.x
* 5.6.x
* 7.0.x
* hhvm
* nightly

which are specified using aliases for the "most recent x.y.z release" provided on Travis CI of any given line. For a full listing of the supported versions see [About Travis CI Environment](/user/ci-environment/).

You can see an [example of version number aliaes ](https://github.com/travis-ci/travis-ci-php-example/blob/master/.travis.yml) on github. For precise versions used in your build, consult "Build system information" in the build log.

> Specifying exact versions like 5.3.8 is discouraged as it may break your build when we update PHP versions on Travis CI. PHP version *5.5.9* is supported, however, because it's the version of PHP that is shipped with Ubuntu 14.04 LTS.

### HHVM versions

Travis CI can test your PHP applications with HHVM.

Without specifying further, the latest version of HHVM available for the Ubuntu release
your job is running on is used.

In addition, depending on the Ubuntu release, you can test with more HHVM versions.

#### HHVM versions on Precise

```yaml
language: php
php:
  - hhvm-3.3
```

#### HHVM versions on Trusty

Note: Currently, PHP is [not officially supported on Trusty](https://docs.travis-ci.com/user/trusty-ci-environment#PHP).
However, you can use the "edge" image to test it.

```yaml
language: php
sudo: required
dist: trusty
group: edge
php:
  - hhvm-3.3
  - hhvm-3.6
  - hhvm-3.9
  - hhvm-3.12
  - hhvm-nightly
```

## Default Test Script

The default test script is `phpunit`.

If your project uses something other than PHPUnit, [you can override our default test command to be anything](/user/customizing-the-build/) you want.

### Working with atoum

Instead of PHPunit, you can also use [atoum](https://github.com/atoum/atoum) to test your projects. For example:

```yaml
before_script: wget http://downloads.atoum.org/nightly/mageekguy.atoum.phar
script: php mageekguy.atoum.phar
```

## Dependency Management (a.k.a. vendoring)

Before Travis CI can run your test suite, it may be necessary to pull down your project dependencies. It can be done using a PHP script, a shell script or anything you need. Define one or more commands you want Travis CI to use with the *install* option in your .travis.yml, for example:

```yaml
install: php vendor/vendors.php
```

or, if you need to run multiple commands sequentially:

```yaml
install:
  - ./bin/ci/install_dependencies.sh
  - php vendor/vendors.php
```

Even though installed dependencies will be wiped out between builds (VMs we run tests in are snapshotted), please be reasonable about the amount of time and network bandwidth it takes to install them.

### Testing Against Multiple Versions of Dependencies (e.g. Symfony)

If you need to test against multiple versions of, say, Symfony, you can instruct Travis CI to do multiple runs with different sets or values of environment variables. Use *env* key in your `.travis.yml` file, for example:

```yaml
env:
  - SYMFONY_VERSION="2.0.*" DB=mysql
  - SYMFONY_VERSION="dev-master" DB=mysql
```

and then use ENV variable values in any later script like your dependencies installation scripts, test cases or test script parameter values.

Here is an example using the above ENV variable to modify the dependencies when using the composer package manager to run the tests against the 2 different versions of Symfony as defined above.

```yaml
install:
   - composer require symfony/framework-bundle:${SYMFONY_VERSION}
```

Here we use DB variable value to pick phpunit configuration file:

```yaml
    script: phpunit --configuration $DB.phpunit.xml
```

The same technique is often used to test projects against multiple databases and so on.

To see real world examples, see:

* [FOSRest](https://github.com/FriendsOfSymfony/FOSRest/blob/master/.travis.yml)
* [LiipHyphenatorBundle](https://github.com/liip/LiipHyphenatorBundle/blob/master/.travis.yml)
* [doctrine2](https://github.com/doctrine/doctrine2/blob/master/.travis.yml)

### Installing PEAR packages

If your dependencies include PEAR packages, the Travis CI PHP environment has the [Pyrus](http://pear2.php.net/) and [pear](http://pear.php.net/) commands available:

    pyrus install http://phptal.org/latest.tar.gz
    pear install pear/PHP_CodeSniffer

After install you should refresh your path

    phpenv rehash

For example, if you want to use phpcs, you should execute:

    pyrus install pear/PHP_CodeSniffer
    phpenv rehash

Then you can use phpcs like the phpunit command

### Installing Composer packages

<div class="note-box">
<p>
Note that we update composer every time we update the PHP build environment, which is every 30-60 days.  Because
composer has a time-based update warning, you may see messages such as this, which may be safely ignored:
</p>
<pre>Warning: This development build of composer is over 30 days old. It is recommended to update it by running "/home/travis/.phpenv/versions/5.6/bin/composer self-update" to get the latest version.</pre>
</div>

You can also install [Composer](http://packagist.org/) packages into the Travis CI PHP environment. The composer
command comes pre-installed, use the following:

    composer install

To ensure that everything works, use http(s) URLs on [Packagist](http://packagist.org/) and not git URLs.

## PHP installation

You'll find the default configure options used to build the different PHP versions used on Travis CI [here](https://github.com/travis-ci/travis-cookbooks/blob/precise-stable/ci_environment/phpbuild/templates/default/default_configure_options.erb), it will give you an overview of Travis CI's PHP installation.

Please note the following differences among the different PHP versions available on Travis CI:

* Note that the OpenSSL extension is disabled on php 5.3.3 because of [compilation problems with OpenSSL 1.0](http://blog.travis-ci.com/upcoming_ubuntu_11_10_migration/).
* Different SAPIs:

  * 5.3.3 comes with php-cgi only.
  * 5.3.x (5.3.29) comes with php-fpm only (see this [issue](https://bugs.php.net/bug.php?id=53271:)).
  * 5.4.x, 5.5.x, and 5.6.x come with php-cgi *and* php-fpm.

## Custom PHP configuration

The easiest way to customize your PHP configuration is to use `phpenv config-add` to add a custom config file with your configuration directives:

```yaml
before_script: phpenv config-add myconfig.ini
```

> Make sure that your config file does not start with a dot (`.`) or a hyphen (`-`) as this will prevent PHP loading your custom settings.

And `myconfig.ini`:

```ini
extension = "mongo.so"
date.timezone = "Europe/Paris"
default_socket_timeout = 120
# some other configuration directives...
```

You can also use this one line command in your `.travis.yml`:

```yaml
before_script: echo 'date.timezone = "Europe/Paris"' >> ~/.phpenv/versions/$(phpenv version-name)/etc/conf.d/travis.ini
```

## PHP extensions

### Core extensions

See the [default configure options](https://github.com/travis-ci/travis-cookbooks/blob/precise-stable/ci_environment/phpbuild/templates/default/default_configure_options.erb) to get an overview of the core extensions enabled.

### Preinstalled PHP extensions

#### PHP 7.0

The following extensions are preinstalled for PHP 7.0 and nightly builds:

* [apc.so](http://php.net/apc)
* [memcached.so](http://php.net/memcached)
* [mongodb.so](https://php.net/mongodb)
* [amqp.so](http://php.net/amqp)
* [zmq.so](http://zeromq.org/bindings:php)
* [xdebug.so](http://xdebug.org)
* [redis.so](http://pecl.php.net/package/redis)

Please note that these extensions are not enabled by default with the exception of xdebug.


#### PHP 5.6 and below

For PHP versions up to 5.6, the following extensions are available:

* [apc.so](http://php.net/apc) (not available for 5.5 or 5.6)
* [memcache.so](http://php.net/memcache) or [memcached.so](http://php.net/memcached)
* [mongo.so](http://php.net/mongo)
* [amqp.so](http://php.net/amqp)
* [zmq.so](http://zeromq.org/bindings:php)
* [xdebug.so](http://xdebug.org)
* [redis.so](http://pecl.php.net/package/redis)

Please note that these extensions are not enabled by default with the exception of xdebug.

### Enabling preinstalled PHP extensions

You need to enable them by adding an `extension="<extension>.so"` line to a PHP configuration file (for the current PHP version).
The easiest way to do this is by using `phpenv` to add a custom config file which enables and eventually configure the extension:

```yaml
before_install: phpenv config-add myconfig.ini
```

> Make sure that your config file does not start with a dot (`.`) or a hyphen (`-`) as this will prevent PHP loading your custom settings.

And `myconfig.ini`:

```ini
extension="mongo.so"
# some other mongo specific configuration directives
# or general custom PHP settings...
```

You can also use this one line command:

```yaml
before_install: echo "extension = <extension>.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
```

### Disabling preinstalled PHP extensions

To disable xdebug, add this to your configuration:

```yaml
before_script:
  - phpenv config-rm xdebug.ini
```

### Installing additional PHP extensions

It is possible to install custom PHP extensions into the Travis CI environment using [PECL](http://pecl.php.net/), but they have to be built against the PHP version being tested. Here is for example how the `memcache` extension can be installed:

    pecl install <extension>

PECL will automatically enable the extension at the end of the installation. If you want to configure your extension, use the `phpenv config-add` command to add a custom ini configuration file in your before_script.

It is also possible to do the installation "manually", but you'll have to manually enable the extension after the installation either with `phpenv config-add` and a custom ini file or with this one line command:

    echo "extension=<extension>.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

See also the [full script using midgard2](https://github.com/bergie/midgardmvc_core/blob/master/tests/travis_midgard2.sh).

If you need specific version of preinstalled extension, you need to force install specific version with the `-f` flag. For example:

    pecl install -f mongo-1.2.12

#### Note on `pecl install`

Note that `pecl install` can fail if the requested version of the package is already installed.

### Chef Cookbooks for PHP

If you want to learn all the details of how we build and provision multiple PHP installations, see our [php, phpenv and php-build Chef cookbooks](https://github.com/travis-ci/travis-cookbooks/tree/precise-stable/ci_environment).

### Apache + PHP

Currently Travis CI does not support mod_php for apache, but you can configure php-fpm for your integration tests.

In your .travis.yml:

```yaml
before_script:
  - sudo apt-get update
  - sudo apt-get install apache2 libapache2-mod-fastcgi
  # enable php-fpm
  - sudo cp ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf.default ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf
  - sudo a2enmod rewrite actions fastcgi alias
  - echo "cgi.fix_pathinfo = 1" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
  - ~/.phpenv/versions/$(phpenv version-name)/sbin/php-fpm
  # configure apache virtual hosts
  - sudo cp -f build/travis-ci-apache /etc/apache2/sites-available/default
  - sudo sed -e "s?%TRAVIS_BUILD_DIR%?$(pwd)?g" --in-place /etc/apache2/sites-available/default
  - sudo service apache2 restart
```

> Note that `sudo` is not available for builds that are running on [container-based](/user/workers/container-based-infrastructure) workers.

You will need to have ``build/travis-ci-apache`` file that will configure your virtual host as usual, the important part for php-fpm is this:

```apacheconf
<VirtualHost *:80>
  # [...]

  DocumentRoot %TRAVIS_BUILD_DIR%

  <Directory "%TRAVIS_BUILD_DIR%">
    Options FollowSymLinks MultiViews ExecCGI
    AllowOverride All
    Order deny,allow
    Allow from all
  </Directory>

  # Wire up Apache to use Travis CI's php-fpm.
  <IfModule mod_fastcgi.c>
    AddHandler php5-fcgi .php
    Action php5-fcgi /php5-fcgi
    Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
    FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -host 127.0.0.1:9000 -pass-header Authorization
  </IfModule>

  # [...]
</VirtualHost>
```

## PHP nightly builds

Travis CI offers ability to test your PHP applications with a recent build of
[PHP](https://github.com/php/php-src/).

You can specify this with:

```yaml
language: php

php:
  - nightly
```

This installation includes PHPUnit and Composer, and also has
[some extensions](#PHP-7.0){: data-proofer-ignore=""}.

## Build Matrix

For PHP projects, `env` and `php` can be given as arrays
to construct a build matrix.

## Examples

  * [Drupal](https://github.com/sonnym/travis-ci-drupal-module-example)
