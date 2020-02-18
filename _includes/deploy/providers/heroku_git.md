{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: heroku:git
  api_key: <encrypted api_key>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}

Alternatively, you can use `username` and `password`:

```yaml
deploy:
  provider: heroku:git
  username: <username>
  password: <encrypted password>
```
{: data-file=".travis.yml"}


{{ include.content }}
{% endunless %}

## Status

Support for deployments to Heroku Git is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment. Either `api_key` or `username` and `password` are required.

| `api_key` | Heroku API key &mdash; **secret**, type: string |
| `username` | Heroku username &mdash; type: string, alias: `user` |
| `password` | Heroku password &mdash; **secret**, type: string |
| `git` | Heroku Git remote URL &mdash; type: string |

### Shared options

| `strategy` | Heroku deployment strategy &mdash; type: string, default: `api`, known values: `api`, `git` |
| `app` | Heroku app name &mdash; type: string, default: `repo name` |
| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `HEROKU_`.

For example, `api_key` can be given as `HEROKU_API_KEY=<api_key>`.
{% include deploy/secrets.md name="api_key" env_name="HEROKU_API_KEY" %}