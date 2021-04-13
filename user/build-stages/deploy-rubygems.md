---
title: "Build Stages: Deploying to Rubygems"

layout: en
---

This example has 2 build stages:

* Two jobs that run tests against Ruby 2.2 and 2.3 respectively
* One job that deploys (releases) the gem to rubygems.org

Here's what the `.travis.yml` config could look like:

```yaml
rvm:
  - 2.2
  - 2.3

script: echo "Running tests against $(ruby -v) ..."

jobs:
  include:
    - stage: gem release
      rvm: 2.2
      script: echo "Deploying to rubygems.org ..."
      deploy:
        provider: rubygems
        gem: travis-build-stages-demo
        api_key: $RUBYGEMS_API_KEY
        on: deploy-gem-release
```
{: data-file=".travis.yml"}

This is how the build matrix would look:

![image](https://cloud.githubusercontent.com/assets/2208/25852509/e2571b32-34c9-11e7-8253-b0982838296e.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch master](https://github.com/travis-ci/build-stages-demo/tree/deploy-gem-release)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/deploy-gem-release/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/230329221)
