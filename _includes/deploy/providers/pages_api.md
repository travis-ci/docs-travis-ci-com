{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: pages:api
  token: <encrypted token>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to GitHub Pages (API) is in **development**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `repo` | GitHub repo slug &mdash; type: string, default: `repo slug` |
| `token` | GitHub oauth token with repo permission &mdash; **required**, **secret**, type: string, alias: `github_token` |

### Shared options

| `strategy` | GitHub Pages deployment strategy &mdash; type: string, default: `git`, known values: `api`, `git` |
| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `GITHUB_` or `PAGES_`.

For example, `token` can be given as 

* `GITHUB_TOKEN=<token>` or 
* `PAGES_TOKEN=<token>`

{% include deploy/secrets.md name="token" env_name="GITHUB_TOKEN" %}