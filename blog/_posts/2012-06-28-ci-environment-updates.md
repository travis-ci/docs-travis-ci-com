---
title: Some CI Environment Updates
layout: post
created_at: Thu Jun 28 18:00:00 CDT 2012
permalink: blog/june-2012-ci-environment-updates
author: Michael Klishin
twitter: michaelklishin
---

Open source projects move fast and so does Travis CI environment. Most of the changes make open source projects and Travis CI environment better
but some break backwards compatibility and may cause CI builds to fail.

Today we want to give you a heads-up on several recent (or upcoming) [CI environment](/docs/user/ci-environment/) changes that are not backwards compatible.
They are: moving to Leiningen 2.0 Preview 7, Node.js 0.8, switching to CRuby 1.9.3 as the new default Ruby version.


## Leiningen 2.0 Preview 7

Travis CI provides Leiningen 1.7 and a recent Leiningen 2.0 Preview versions side by side for projects to use. This gives projects
that use Leiningen (primarily in the Clojure community) time to migrate to Leiningen 2.0 and not lose the ability to use Travis for CI.

The most recent Leinigen 2.0 preview release introduces a breaking change that may affect a sizeable portion of projects on Travis CI:
task chaining now requires using the new `do` task.

For example, `lein clean, test, deploy` with Lein 2.0 Preview 6 becomes `lein do clean, test, deploy` in Lein 2.0 Preview 7. Use of the old style will
emit a warning explaining the change.

We will deploy Preview 7 on the **1st of July, 2012**.

For more information about this change, please see [preview 7 release announcement](http://librelist.com/browser//leiningen/2012/6/28/ann-leiningen-2-0-0-preview7/).
The [list of changes](https://github.com/technomancy/leiningen/blob/master/NEWS.md) available on Github.



## Ruby 1.9.3 as the new default.

When Travis CI was started in early 2011, using Ruby 1.8.7 as the default Ruby was a conservative but reasonable choice. Today, over one year later,
almost all maintained projects that can run on Ruby 1.9 are compatible with 1.9. In addition, there are projects that rely heavily on Ruby 1.9-specific
features and PaaS providers where Ruby 1.9 is the only choice.

So, on July 9th, 2012, we will make Ruby 1.9.3 the new default Ruby version. Please note that it does not mean that 1.8.7 won't be available, only that if
you don't specify the list of Rubies to test against, Travis CI will use 1.9.3 starting **July 9th**.



## Node.js 0.8

Recently released [Node.js 0.8](http://blog.nodejs.org/2012/06/25/node-v0-8-0/) is now available on Node.js workers. This release has multiple
[public API changes that are not backwards compatible](https://github.com/joyent/node/wiki/API-changes-between-v0.6-and-v0.8). One such change
that will affect CI experience for projects that test against multiple Node.js version is the migration from Waf to Gyp for the build system.

Projects that have native parts are "recommended to migrate to [node-gyp](https://github.com/TooTallNate/node-gyp) ASAP" (quoting Node.js wiki).

More information can be found in the [README of node-gyp](https://github.com/TooTallNate/node-gyp#readme)


## Getting Help

If you have questions, please ask them on our [mailing list](https://groups.google.com/forum/?fromgroups#!forum/travis-ci) or in
`#travis` on chat.freenode.net.


Happy testing!


The Travis CI Team
