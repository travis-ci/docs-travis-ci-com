---
title: Announcing "first class" PHP project support!
kind: article
created_at: Sun Nov 13 12:08:00 EDT 2011
---

Today we are happy to announce first class PHP support with Travis CI. 

It includes all the same features Ruby, Erlang and Node.js projects enjoy today, including:

 * Easy to get started and integrates with GitHub.
 * Test against multiple databases and services, including Mysql, Postgres, Redis, RabbitMQ and many more.
 * Test your projects against multiple PHP versions.
 * Build results are publicly available online so you can link to them in your bug reports, including line numbers.
 * Notifications the way you want them! (email, IRC, and webhooks)

Over the last several weeks many nice folks from the PHP community have been working with the Travis team
and it would not be possible without all the help from [Loïc Frering](https://twitter.com/loicfrering) and [Pascal Borreli](https://github.com/pborreli). [Álvaro Videla](https://twitter.com/old_sound) and
[Lukas Kahwe Smith](https://github.com/lsmith77) helped us with testing by adding some of the [Friends of Symfony](https://github.com/friendsofsymfony) projects on Travis early on.
Pascal also got Symfony, Twig, Silex, Doctrine and Monolog test suites up and running on travis-ci.org (we hope his patches will be accepted
upstream). Having all those projects building fine for several days makes us confident that we are
ready to ship this feature.

Please see our [initial documentation for PHP projects](http://about.travis-ci.org/docs/user/languages/php) and [the rest of the guides](http://about.travis-ci.org/docs/). We tried to link to as many real world .travis.yml examples to demonstrate all the features in action.

In addition, we have a couple of machines lined up that we will be running PHP builds on. One of them is [Shopify](http://shopify.com): they donated us a worker we have been using for Node.js projects. Another one is [ServerGrove](http://servergrove.com), experts in PHP hosting and specifically frameworks like Symfony and Zend Framework: they donated us one more machine to run PHP builds
on.

If you have questions, find us in #travis on irc.freenode.net, we will be happy to answer them. To stay up to date with new announcements, CI environment software updates and more, [follow us on Twitter](https://twitter.com/travisci) and [join our mailing list](https://groups.google.com/forum/#!forum/travis-ci).

We hope you enjoy using Travis for your open source projects as much as we do. Go add your PHP projects to Travis CI and recommend your fellow PHP developers to do the same!

The Travis Team.
