---
title: Preinstalled PHP extensions
permalink: blog/2013-03-08-preinstalled-php-extensions
created_at: Wed Mar 06 18:56:00 CET 2013
author: Loïc Frering
twitter: loicfrering
layout: post
---

> PHP support on Travis is only made possible with the fantastic help from Loïc Frering, a PHP developer based in Lyon, France. 
>
>Loïc has been working on some amazing changes which will benefit the PHP community on Travis, and we are very glad to have him share these changes with you. 
>
>If you use PHP on Travis, and would like to show your appreciation, please send him an internet hug, get him over to a conference near you, or visit Lyon and give him a hug and High-5 in person!

When your project depends on some particular PHP extensions, maybe memcached or apc, installing these extensions during each build on Travis takes time and can slow down your CI feedback loop dramatically. In order to improve this, and to get your builds running as fast as possible, we're glad to announce that the Travis VMs now come pre-setup with some common PHP extensions!

We have taken six of the most popular extensions and preinstalled them in each PHP version (with a few exceptions) so you no longer need to manually build them!

Here is a list of the preinstalled extensions available right now:

* [apc.so](http://php.net/apc)
* [memcache.so](http://php.net/memcache)
* [memcached.so](http://php.net/memcached)
* [mongo.so](http://php.net/mongo)
* [amqp.so](http://php.net/amqp)
* [zmq.so](http://php.zero.mq/)

These extensions are *not enabled by default*, you'll have to explicitly enable them by adding an `extension="<extension>.so"` line to your PHP configuration.

Previously it was not particularly easy to customize Travis' PHP configuration since you had to locate the php.ini of the current PHP version you were running your tests against. I (Loïc) developed a little extension to [phpenv](https://github.com/CHH/phpenv), which Travis uses for PHP environment switching, that allows you to easily add a config file with all the configuration directives which make sense for your build with one super simple command! 

Just use __`phpenv config-add`__ and __`phpenv config-rm`__ to add or remove a configuration file. You can refer to the documentation for more details on how to [customize your PHP configuration](http://about.travis-ci.org/docs/user/languages/php/#Custom-PHP-configuration).

The easiest way to enable a preinstalled extension is to use `phpenv config-add` to add a custom config file which enables and configures the extension you need, for example:

    before_script: phpenv config-add myconfig.ini

And your myconfig.ini could look like this:

    extension = "mongo.so"
    # some other mongo specific configuration directives
    # or general custom PHP settings...

If adding a full configuration file is overkill for your needs, you can also use this one-line command in your before_script:

    echo "extension = <extension>.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

For more information, please refer to the [PHP extensions section](http://about.travis-ci.org/docs/user/languages/php/#PHP-extensions) of the documentation!

This feature is live on Travis CI for open source projects now and will be made available to [Travis Pro](http://beta.travis-ci.com) projects on the 18th of March.

Unfortunately, this update may cause build failures because of incompatibilities between the extension you are trying to install and the extension already preinstalled. We encourage you to update your Travis setup to take advantage of this new feature and to report any issues you encounter on [our GitHub issues tracker](https://github.com/travis-ci/travis-ci/issues). You can also pop into #travis on irc.freenode.org if you need any help.

If you feel that there is a really important extension that should be preinstalled on Travis, feel free to [tell us](https://github.com/travis-ci/travis-ci/issues).

We hope you enjoy this new feature and that it will make your test settings easier, speed up your builds, and bring a huge smile to your faces :)

Happy testing!

Your friendly Frenchman,

Loïc Frering
