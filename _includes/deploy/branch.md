### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

```yaml
deploy:
  provider: {{ page.provider }}
  on: production
```
{: data-file=".travis.yml"}

Alternatively, you can also configure it to deploy from all branches:

```yaml
deploy:
  provider: {{ page.provider }}
  on:
    all_branches: true
```
{: data-file=".travis.yml"}

Builds triggered from Pull Requests will never trigger a deploy.

### Branches

By default, Travis CI will only deploy from your `master` branch. You can specify what branch to deploy from with the deploy option `on`:

```yaml
deploy:
  ...
  on: myProductionBranch
```
{: data-file=".travis.yml"}

To deploy from all branches set the deploy->on option `all_branches` to `true`

```yaml
deploy:
  ...
  on:
    all_branches: true
```
{: data-file=".travis.yml"}
