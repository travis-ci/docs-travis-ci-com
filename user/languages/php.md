---
title: Building a PHP project
layout: en

---

<div id="toc">
</div>

## What This Guide Covers

<aside markdown="block" class="ataglance">

| PHP                                         | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#Dependency-Management) | N/A                                       |
| [Default `script`](#Default-Build-Script)   | `phpunit`                                 |
| [Matrix keys](#Build-Matrix)                | `env`, `php`                              |
| Support                                     | [Travis CI](mailto:support@travis-ci.com) |

Minimal example:

```yaml
language: php
php:
  - '5.6'
  - '7.1'
  - hhvm # on Trusty only
  - nightly
```

</aside>

{{ site.data.snippets.trusty_note_no_osx }}

This guide covers build environment and configuration topics specific to PHP
projects. Please make sure to read our [Getting Started](/user/getting-started/)
and [build configuration](/user/customizing-the-build/) guides first.

PHP builds are not available on the OS X environment.

## Choosing PHP versions to test against

Travis CI provides several PHP versions, all of which include XDebug and
PHPUnit. Travis CI uses [phpenv](https://github.com/CHH/phpenv) to manage the
different PHP versions installed on the virtual machines.

An example `.travis.yml` file that tests various PHP versions:

```yaml
language: php
php:
  - '5.4'
  - '5.6'
  - '7.0'
  - hhvm # on Trusty only
  - nightly
```
{: data-file=".travis.yml"}

`X.Y` versions are aliases for recent `X.Y.Z` releases pre-installed on the build images.
For exact versions used in your build, consult "Build system information" in the build log.

These may not be the most recent releases. If you need to ensure the use of most recent releases, do provide the third number; e.g.,

```yaml
language: php
php:
  - 7.1.9
```
{: data-file=".travis.yml"}

### PHP 5.2(.x) and 5.3(.x) support is available on Precise only

We do not suppport these versions on Trusty.
If you need to test them, please use Precise.
See [this page](/user/reference/trusty#PHP-images) for more information.


### HHVM versions

Travis CI can test your PHP applications with HHVM on Ubuntu Trusty:

```yaml
php
  - hhvm-3.18
  - hhvm-nightly
```
{: data-file=".travis.yml"}


Please note that if you want to run PHPUnit on HHVM, you have to explicitly install version 5.7 in your `.travis.yml` due to a compatibility issue between HHVM and PHP7:

```yaml
before_script:
  - curl -sSfL -o ~/.phpenv/versions/hhvm/bin/phpunit https://phar.phpunit.de/phpunit-5.7.phar
```
{: data-file=".travis.yml"}

### Nightly builds

Travis CI can test your PHP applications with a nightly
[PHP](https://github.com/php/php-src/) build, which includes PHPUnit and
Composer:

```yaml
language: php

php:
  - nightly
```
{: data-file=".travis.yml"}

## Default Build Script

The default build script is PHPUnit. It comes packaged with PHP, but you can also
install a specific version in a custom location. If you do install it
separately, make sure you invoke the correct version by using the full path.

Travis CI looks for `phpunit` in the [same order as Composer
does](https://getcomposer.org/doc/articles/vendor-binaries.md#can-vendor-binaries-be-installed-somewhere-other-than-vendor-bin-)
and uses the first one found.

1. `$COMPOSER_BIN_DIR/phpunit`
1. `phpunit` found in the directory specified by `bin-dir` in `composer.json`
1. `vendor/bin/phpunit`
1. `phpunit`, which is found on `$PATH` (typically one that is pre-packaged with the PHP runtime)

If your project uses something other than PHPUnit, you can [override the default build script](/user/customizing-the-build/).

### Working with atoum

Instead of PHPunit, you can also use [atoum](https://github.com/atoum/atoum) to test your projects. For example:

```yaml
before_script: composer require atoum/atoum
script: vendor/bin/atoum
```
{: data-file=".travis.yml"}

## Dependency Management

Before Travis CI can run your test suite, it may be necessary to install your
project dependencies. It can be done using a PHP script, a shell script or
anything you need. Define one or more commands you want Travis CI to use with
the *install* option in your `.travis.yml`, for example:

```yaml
install: php vendor/vendors.php
```
{: data-file=".travis.yml"}

or, if you need to run multiple commands sequentially:

```yaml
install:
  - ./bin/ci/install_dependencies.sh
  - php vendor/vendors.php
```
{: data-file=".travis.yml"}

### Testing Against Multiple Versions of Dependencies

If you need to test against multiple versions of, say, Symfony, you can instruct
Travis CI to do multiple runs with different sets or values of environment
variables. Use *env* key in your `.travis.yml` file, for example:

```yaml
env:
  - SYMFONY_VERSION="2.0.*" DB=mysql
  - SYMFONY_VERSION="dev-master" DB=mysql
```
{: data-file=".travis.yml"}

and then use ENV variable values in any later script like your dependencies
installation scripts, test cases or test script parameter values.

Here is an example using the above ENV variable to modify the dependencies when
using the composer package manager to run the tests against the 2 different
versions of Symfony as defined above.

```yaml
install:
   - composer require symfony/framework-bundle:${SYMFONY_VERSION}
```
{: data-file=".travis.yml"}

Here we use DB variable value to pick phpunit configuration file:

```yaml
    script: phpunit --configuration $DB.phpunit.xml
```
{: data-file=".travis.yml"}

The same technique is often used to test projects against multiple databases and so on.

To see real world examples, see:

- [FOSRest](https://github.com/FriendsOfSymfony/FOSRest/blob/master/.travis.yml)
- [LiipHyphenatorBundle](https://github.com/liip/LiipHyphenatorBundle/blob/master/.travis.yml)
- [doctrine2](https://github.com/doctrine/doctrine2/blob/master/.travis.yml)

### Installing PEAR packages

If your dependencies include PEAR packages, the Travis CI PHP environment has the [Pyrus](http://pear2.php.net/) and [pear](http://pear.php.net/) commands available:

```bash
pyrus install http://phptal.org/latest.tar.gz
pear install pear/PHP_CodeSniffer
```

After install you should refresh your path

```bash
phpenv rehash
```

For example, if you want to use phpcs, you should execute:

```bash
pyrus install pear/PHP_CodeSniffer
phpenv rehash
```

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

```bash
composer install
```

To ensure that everything works, use http(s) URLs on [Packagist](http://packagist.org/) and not git URLs.

## PHP installation

You'll find the default configure options used to build the different PHP versions used on Travis CI [here](https://github.com/travis-ci/travis-cookbooks/blob/precise-stable/ci_environment/phpbuild/templates/default/default_configure_options.erb), it will give you an overview of Travis CI's PHP installation.

Please note the following differences among the different PHP versions available on Travis CI:

- The OpenSSL extension is switched off on php 5.3.3 because of [compilation problems with OpenSSL 1.0](http://blog.travis-ci.com/upcoming_ubuntu_11_10_migration/).
- Different SAPIs:

  - 5.3.3 comes with php-cgi only.
  - 5.3.x (5.3.29) comes with php-fpm only (see this [issue](https://bugs.php.net/bug.php?id=53271:)).
  - 5.4.x, 5.5.x, and 5.6.x come with php-cgi *and* php-fpm.

## Custom PHP configuration

The easiest way to customize your PHP configuration is to use `phpenv config-add` to add a custom config file with your configuration directives:

```yaml
before_script: phpenv config-add myconfig.ini
```
{: data-file=".travis.yml"}

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
{: data-file=".travis.yml"}

## Enabling preinstalled PHP extensions

You need to enable them by adding an `extension="<extension>.so"` line to a PHP configuration file (for the current PHP version).
The easiest way to do this is by using `phpenv` to add a custom config file which enables and eventually configure the extension:

```yaml
before_install: phpenv config-add myconfig.ini
```
{: data-file=".travis.yml"}

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
{: data-file=".travis.yml"}

## Disabling preinstalled PHP extensions

To disable xdebug, add this to your configuration:

```yaml
before_script:
  - phpenv config-rm xdebug.ini
```
{: data-file=".travis.yml"}

## Installing additional PHP extensions

It is possible to install custom PHP extensions into the Travis CI environment
using [PECL](http://pecl.php.net/), but they have to be built against the PHP
version being tested.

For example, to install `memcache`:

```
pecl install <extension>
```

PECL will automatically enable the extension at the end of the installation. If
you want to configure your extension, use the `phpenv config-add` command to add
a custom ini configuration file in your before_script.

It is also possible to do the installation "manually", but you'll have to
manually enable the extension after the installation either with `phpenv
config-add` and a custom ini file or with this one line command:

```
echo "extension=<extension>.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
```

See also the [full script using midgard2](https://github.com/bergie/midgardmvc_core/blob/master/tests/travis_midgard2.sh).

If you need specific version of preinstalled extension, you need to force
install specific version with the `-f` flag. For example:

```
pecl install -f mongo-1.2.12
```

### Note on `pecl install`

Note that `pecl install` can fail if the requested version of the package is already installed.



### Apache + PHP

Currently Travis CI does not support `mod_php` for apache, but you can configure
`php-fpm` for your integration tests:

```yaml
before_script:
  - sudo apt-get update
  - sudo apt-get install apache2 libapache2-mod-fastcgi
  # enable php-fpm
  - sudo cp ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf.default ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf
  - sudo cp ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.d/www.conf.default ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.d/www.conf
  - sudo a2enmod rewrite actions fastcgi alias
  - echo "cgi.fix_pathinfo = 1" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
  - sudo sed -i -e "s,www-data,travis,g" /etc/apache2/envvars
  - sudo chown -R travis:travis /var/lib/apache2/fastcgi
  - ~/.phpenv/versions/$(phpenv version-name)/sbin/php-fpm
  # configure apache virtual hosts
  - sudo cp -f build/travis-ci-apache /etc/apache2/sites-available/000-default.conf
  - sudo sed -e "s?%TRAVIS_BUILD_DIR%?$(pwd)?g" --in-place /etc/apache2/sites-available/000-default.conf
  - sudo service apache2 restart
```
{: data-file=".travis.yml"}

> Note that `sudo` is not available for builds that are running on [container-based](/user/workers/container-based-infrastructure).

You will need to have `build/travis-ci-apache` file that will configure your
virtual host as usual, the important part for php-fpm is this:

```apacheconf
<VirtualHost *:80>
  # [...]

  DocumentRoot %TRAVIS_BUILD_DIR%

  <Directory "%TRAVIS_BUILD_DIR%/">
    Options FollowSymLinks MultiViews ExecCGI
    AllowOverride All
    Require all granted
  </Directory>

  # Wire up Apache to use Travis CI's php-fpm.
  <IfModule mod_fastcgi.c>
    AddHandler php5-fcgi .php
    Action php5-fcgi /php5-fcgi
    Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
    FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -host 127.0.0.1:9000 -pass-header Authorization
    
    <Directory /usr/lib/cgi-bin>
        Require all granted
    </Directory>
  </IfModule>

  # [...]
</VirtualHost>
```

## Build Matrix

For PHP projects, `env` and `php` can be given as arrays
to construct a build matrix.

## Examples

- [Drupal](https://github.com/sonnym/travis-ci-drupal-module-example)
