## Running commands before and after the deploy step

Sometimes you want to run commands before or after deploying.

You can use the `before_deploy` and `after_deploy` steps for this. These will
only be triggered if Travis CI is actually deploying.

```yaml
before_deploy: "echo ready?"
deploy:
  # ⋮
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}
