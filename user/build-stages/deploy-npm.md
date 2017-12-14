---
title: "Build Stages: Deploying to npm"

layout: en
---

This example has 2 build stages:

* Four jobs that run tests against Node versions 4 to 7
* One job that deploys (releases) the package to npm

Here's what the `.travis.yml` config could look like:

```yaml
language: node_js
node_js:
  - "7"
  - "6"
  - "5"
  - "4"

script: echo "Running tests against $(node -v) ..."

jobs:
  include:
    - stage: npm release
      node_js: "7"
      script: echo "Deploying to npm ..."
      deploy:
        provider: npm
        api_key: $NPM_API_KEY
        on: deploy-npm-release
```
{: data-file=".travis.yml"}

This is how the build matrix might look:

![A screenshot of a build with two stages](https://cloud.githubusercontent.com/assets/43280/25871669/327bd7fe-34bd-11e7-8d17-6ba9672c9c29.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch master](https://github.com/travis-ci/build-stages-demo/tree/deploy-npm-release)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/deploy-npm-release/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/230512162)
