{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: transifex
  api_token: <encrypted api_token>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}

Alternatively, you can use `username` and `password`:

```yaml
deploy:
  provider: transifex
  username: <username>
  password: <encrypted password>
```
{: data-file=".travis.yml"}


{{ include.content }}
{% endunless %}

## Status

Support for deployments to Transifex is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment. Either `api_token` or `username` and `password` are required.

| `api_token` | Transifex API token &mdash; **secret**, type: string |
| `username` | Transifex username &mdash; type: string |
| `password` | Transifex password &mdash; **secret**, type: string |
| `hostname` | Transifex hostname &mdash; type: string, default: `www.transifex.com` |
| `cli_version` | CLI version to install &mdash; type: string, default: `>=0.11` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `TRANSIFEX_`.

For example, `api_token` can be given as `TRANSIFEX_API_TOKEN=<api_token>`.

{% include deploy/secrets.md name="api_token" env_name="TRANSIFEX_API_TOKEN" %}