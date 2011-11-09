---
title: Building a Node.js project
kind: content
---

Travis VMs used by Ruby workers provide Node 0.4.12 and NPM 1.0.x. Historically Node.js projects were built there but in November 2011 Node.js support was improved to
be "first class": testing against multiple Node.js versions on a separate set of VMs. We recommend that you use them to test your Node.js project.
Add the following line to .travis.yml:

    language: node_js
    node_js:
      - 0.4
      - 0.5
      - 0.6

For example, see [hook.io-amqp-listener .travis.yml](https://github.com/scottyapp/hook.io-amqp-listener/blob/master/.travis.yml).

You can tell npm how to run your test suite by adding a line in package.json. For example, to test using Vows:

    scripts: {
      test: "vows --spec"
    },

To setup the database and test using Expresso:

    scripts: {
      pretest: "NODE_ENV=test node setup_db",
      test: "expresso test/*"
    },

Keeping the test script configuration in package.json makes it easy for other people to collaborate on your project, all they need to remember are the npm install and npm test conventions.


### before_install, before_script and friends

See <a href="/docs/user/build-configuration/">Build configuration</a> to learn about *before_install*, *before_script*, branches configuration, email notification
configuration and so on.



### Provided Node.js Versions

 * 0.4.12
 * 0.5.8
 * 0.6.0

The NVM project we use is available in our [multi-version Node.js Chef cookbook](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/nodejs).
