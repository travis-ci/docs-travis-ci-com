## Deploying tags

Most likely, you would only want to deploy when a new version of your
package is cut.

To do this, you can include a `tags` condition like so:

```yaml
deploy:
  provider: {{ page.provider }}
  # ⋮
  on:
    tags: true
```
{: data-file=".travis.yml"}

If you tag a commit locally, remember to run `git push --tags` to ensure that
your tags are uploaded to GitHub.
