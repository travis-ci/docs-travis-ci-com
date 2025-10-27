## Running an edge version

If you contribute to or experiment with [dpl](https://github.com/travis-ci/dpl), our deployment tooling, make sure you use the edge version from GitHub:

```yaml
deploy:
  provider: <your-provider>
  edge:
    branch: master
    source: <GitHub handle>/dpl # only needed for forks of travis-ci/dpl
```
{: data-file=".travis.yml"}

You can find more information about contributing to dpl [here](https://github.com/travis-ci/dpl#contributing-to-dpl).
