{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: heroku:api
  api_key: <encrypted api_key>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Heroku API is *stable**.
## Known options

Use the following options to further configure the deployment.

| `api_key` | Heroku API key &mdash; **required**, **secret**, type: string |

### Shared options

| `strategy` | Heroku deployment strategy &mdash; type: string, default: `api`, known values: `api`, `git` |
| `app` | Heroku app name &mdash; type: string, default: `repo name` |
| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `HEROKU_`.

For example, `api_key` can be given as `HEROKU_API_KEY=<api_key>`.

{% include deploy/secrets.md name="api_key" env_name="HEROKU_API_KEY" %}