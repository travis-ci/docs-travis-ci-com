---
title: Use Node.js with Travis CI
layout: en
—

The following is a guide to getting started with Travis CI using Node.js.

## Prerequisite
Before getting started, create a `.travis.yml` file and add it to the root directory of your Node.js project.

## Specify the Language
Specify Node.js as the language and version of Node.js the project will use to let Travis CI know you are building a Node.js project. Here is an example of the configuration:

 ```yaml
language: node_js
node_js:
  - "14"
  - "16"
  - "18"
```

## Install Build Dependencies
Travis CI runs the default `npm install` command to install your dependencies.

 ```yaml
 install:
  - npm install
```

## Define the Test Command
Travis CI runs any test defined in your `package.json` file by default. Explicitly run the command as follows: 

 ```yaml
install:
  - npm install
```

## Commit and Push 
Once your `.travis.yml` file is configured, push it to your repository, and Travis CI will start running tests for each Node version specified. 

Here is the complete example:
 ```yaml
language: node_js
node_js:
  - "14"
  - "16"
  - "18"
install:
  - npm install
script:
  - npm test
 ```

## Further Reading
For more information on Node.js projects, see:
* [Building a Node.js Project](/user/languages/javascript-with-nodejs/)
