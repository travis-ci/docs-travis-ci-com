---
title: Preinstalled PHP extensions
permalink: blog/2013-03-08-preinstalled-php-extensions
created_at: Wed Mar 06 18:56:00 CET 2013
author: Loïc Frering
twitter: loicfrering
layout: post
---

When your project depends on some particular PHP extension, installing this
extension at each build on Travis takes some time and slows down your CI
feedback loop. In order to improve this situation and to get your builds
running as fast as possible, I'm glad to announce that there are now some
common PHP extensions directly preinstalled on Travis!

No need to manually build them anymore, here is a list of the preinstalled
extensions available right now:

* [apc.so](http://php.net/apc)
* [memcache.so](http://php.net/memcache)
* [memcached.so](http://php.net/memcached)
* [mongo.so](http://php.net/mongo)
* [amqp.so](http://php.net/amqp)
* [zmq.so](http://php.zero.mq/)

Watch out, these extensions are *not enabled by default*, so you'll have to
explicitly enable them by adding an `extension="<extension>.so"` line to your
PHP configuration.

But it was not particularly easy to customize Travis' PHP configuration until
now because you had to know where was located the php.ini file of the current
PHP version you were running your tests against. So I developed a little
extension to [phpenv](https://github.com/CHH/phpenv) that allows to easily add
a config file with all the configuration directives that make sense for your
build with a simple command! Just use `phpenv config-add` and `phpenv
config-rm` to add or remove a configuration file. You can refer to the
documentation for more details on how to [customize PHP
configuration](http://about.travis-ci.org/docs/user/languages/php/#Custom-PHP-configuration).

Thereby, the easiest way to enable a preinstalled extension is by using `phpenv
config-add` to add a custom config file that enables and configures if necessary
the extension you need:

    before_script: phpenv config-add myconfig.ini

And myconfig.ini:

    extension = "mongo.so"
    # some other mongo specific configuration directives
    # or general custom PHP settings...

For more information, please refer to the [PHP extensions
section](http://about.travis-ci.org/docs/user/languages/php/#PHP-extensions) of
the documentation!

We encourage you to update your Travis setup to take advantage of this new
feature. Also if you experience any issue or if you feel that there is a really
important extension that should be preinstalled on Travis, feel free to open an
[issue on GitHub](https://github.com/travis-ci/travis-ci/issues).

I hope that you will enjoy this new feature and that it will make your test
settings easier and speed up your builds!

Happy testing!
