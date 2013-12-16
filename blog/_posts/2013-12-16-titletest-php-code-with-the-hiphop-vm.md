---
title: "Test PHP Code with the HipHop VM"
created_at: Mon 16 Dec 2013 17:06:20 CET
author: Mathias Meyer
twitter: roidrage
layout: post
permalink: blog/2013-12-16-test-php-code-with-the-hiphop-vm
---
<figure class="small right"> <img
src="http://images.rapgenius.com/03202371a58f6cef98b49058912e10b4.240x180x10.gif"/>
</figure>

Late last week, the [HipHop VM](http://hhvm.com) team [shipped version
2.3.0](http://www.hhvm.com/blog/2393/hhvm-2-3-0-and-travis-ci) of their
JIT-based virtual machine for PHP.

Not only does this release use 20% less CPU in Facebook's production environment
than the previous version, comes with support for FastCGI, it's now also
natively supported on [Travis CI](https://travis-ci.org)!

Testing your PHP code on the HipHop VM is easy, just add `hhvm` as your desired
PHP version:

    php:
      - hhvm

For inspiration, check out
[all](https://github.com/kriswallsmith/assetic/pull/548)
[the](https://github.com/yiisoft/yii/pull/3109)
[projects](https://github.com/codeguy/Slim/pull/698)
[currently](https://github.com/phpbb/phpbb/pull/1932) working
[on](https://github.com/joomla/joomla-cms/pull/2677)
[adding](https://github.com/doctrine/doctrine2/pull/873)
[support](https://github.com/EllisLab/CodeIgniter/pull/2766)
[for](https://github.com/j4mie/idiorm/pull/168)
[HipHop](https://github.com/sebastianbergmann/phpunit/pull/1072)
[VM](https://github.com/j4mie/paris/pull/81) [in]() their build matrix.

There are a few open issues left, but if you run into any problems, report them
either to [our issues
tracker](https://github.com/travis-ci/travis-ci/issues?labels=php&page=1&state=open)
or to the [HipHop team](https://github.com/facebook/hhvm/issues)!

To learn more about HipHop, be sure to check out this [post describing the
HipHop VM
architecture](https://www.facebook.com/notes/facebook-engineering/the-hiphop-virtual-machine/10150415177928920)
and the details the team [continuously publishes on their own
blog](http://www.hhvm.com/blog/2027/faster-and-cheaper-the-evolution-of-the-hhvm-jit).
