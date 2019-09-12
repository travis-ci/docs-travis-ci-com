## Cleaning up the Git Working Directory

By default your Git working directory will not be cleaned up before the deploy
step, so it might contain left over artifacts from previous steps.

For many providers and deployment targets this is not an issue or even intended.

If you do need to clean up the working directory from any changes made during
the build process, you can add the following to your `.travis.yml` file:

```yaml
deploy:
  provider: {{ page.provider | default: '[your provider]' }}
  cleanup: true
```
{: data-file=".travis.yml"}

> Please note that the previous version of dpl, our deployment integration
tooling, used to reset your working directory and delete all changes made
during the build using `git stash --all`. In order to keep changes one had to
opt out using `skip_cleanup: true`. This default turned out to be useful only
for very few providers and has been changed in dpl v2. You still might find
external tutorials or posts mentioning `skip_cleanup`.
