{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: flynn
  git: <git>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Flynn is in **development**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `git` | Flynn Git remote URL &mdash; **required**, type: string |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |


