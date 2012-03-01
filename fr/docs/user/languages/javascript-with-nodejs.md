---
title: Building a Node.js project
kind: content
---

Travis VMs includes Node 0.4.12/0.5.8 and NPM 1.0.x. You can use these to build and test your Node.js project. Add the following line to .travis.yml:

    before_script: "npm install --dev"
    script: "npm test"


The first command installs the project's runtime and development dependencies (listed as devDependencies in the project's package.json file). The second command runs the test script specified in package.json.

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

