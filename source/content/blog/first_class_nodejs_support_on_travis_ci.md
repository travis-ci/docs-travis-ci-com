---
title: Announcing "first class" Node.js project support!
kind: article
created_at: Wed Nov 9 13:00:00 EDT 2011
---

One of the things people keep asking us is when language X will be a first class citizen on Travis-CI.
While it has been possible to build Node.js and C++ projects on Ruby workers for a while, it is not very convenient or intuitive, and such projects will not get the killer feature of travis-ci.org: testing against multiple versions/implementations. So we have good news for the Node.js community: Node.js is gaining first class support on Travis-CI, joining Ruby and Erlang.

Thanks to the hard work by [Harry Brundage](https://twitter.com/harrybrundage) and the Travis core team, it is now possible to test your Node.js projects against multiple Node versions (currently 0.4.12, 0.5.8 and 0.6.0). We use [NVM ("RVM for Node.js") project](https://github.com/travis-ci/travis-cookbooks/blob/master/vagrant_base/nodejs/files/default/nvm.sh) and [Chef cookbooks](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/nodejs) to enable to easy switching of Node.js versions.

In addition, Shopify now sponsors a machine that we will be running five Node.js workers on. Please thank them by sending a loving tweet or two to [@Shopify](https://twitter.com/shopify) :)

### How do I test my project against multiple Node.js versions?

To test your Node.js project against multiple Node versions, add a '.travis.yml' file to your GitHub repository and add the following to it:

    language: "node_js"
    node_js:
      - 0.4
      - 0.5
      - 0.6

When you define "node_js" as the language it tells Travis to switch the Node.js version (nvm use 0.4), install the dependencies of the project (npm install), and run the tests (npm test). If you define multiple Node.js versions to test against, like the above example, Travis will create a matrix of test configurations, in this case three builds will be queued. Or you can leave out the node_js versions to test against and Travis will use 0.4 by default. If your project is not yet Node 0.5 or 0.6 compatible,
you can exclude those versions. The same goes for project that want to only support 0.6, for example.

See Shopify's [Batman](https://github.com/shopify/batman/blob/master/.travis.yml) as well as [Martin Wawrusch](https://twitter.com/#!/martin_sunset)'s [hook.io-blueprint-in-coffescript](https://github.com/scottyapp/hook.io-blueprint-coffeescript/blob/master/.travis.yml) and [hook.io-amqp-listener](https://github.com/scottyapp/hook.io-amqp-listener/blob/master/.travis.yml) projects as examples.


## The Workflow

Travis' Node.js builder will do the following as part of the build process:

 * Clone your repository from GitHub
 * Pick Node.js version to use
 * Run `before_install` commands (can be more than one)
 * Install dependencies using `npm install [npm_args]` or whatever you provide in the `install` key in your .travis.yml file
 * Run `before_script` (can be more than one script)
 * Run `install` command if you provided it in your .travis.yml. By default it is `npm test` if it finds package.json in the repository root or  `make test` otherwise.
 * Run `after_script` (can be more than one command)
 * Report the build has finished running

Most of steps in the workflow can be overriden by projects that need it. We recommend you to use defaults when possible, though.

For more information on what is [available in terms of services](http://about.travis-ci.org/docs/user/ci-environment/) (mysql, postgres, riak, etc.), or how to configure your builds or matrix, visit the [docs site](http://about.travis-ci.org/docs/).


### Next steps

We have support for more languages in the works, one of which we hope to ship really soon, so stay tuned!


### In conclusion (a.k.a lots of <3 <3 <3)

Once again we would like to thank Harry for doing most of the work on first class Node.js support and Shopify for sponsoring a machine that we will host the workers on. 

Now go add your Node.js projects to travis-ci.org and tell your friends and colleagues about it!

<3 <3 <3, the [Travis CI core team](https://twitter.com/travisci).


### Discuss on Hacker News

You can discuss Node.js support on travis-ci.org [on Hacker News](http://news.ycombinator.com/item?id=3216403).
