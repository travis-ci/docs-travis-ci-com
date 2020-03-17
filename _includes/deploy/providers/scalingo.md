{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: scalingo
  api_token: <api_token>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}

Alternatively, you can use `username` and `password`:

```yaml
deploy:
  provider: scalingo
  username: <username>
  password: <encrypted password>
```
{: data-file=".travis.yml"}


{{ include.content }}
{% endunless %}

## Status

Support for deployments to Scalingo is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment. Either `api_token` or `username` and `password` are required.

| `app` | type: string, default: `repo name` |
| `api_token` | Scalingo API token &mdash; type: string, alias: `api_key` (deprecated, please use `api_token`) |
| `username` | Scalingo username &mdash; type: string |
| `password` | Scalingo password &mdash; **secret**, type: string |
| `region` | Scalingo region &mdash; type: string, default: `agora-fr1`, known values: `agora-fr1`, `osc-fr1` |
| `remote` | Git remote name &mdash; type: string, default: `scalingo-dpl` |
| `branch` | Git branch &mdash; type: string, default: `master` |
| `timeout` | Timeout for Scalingo CLI commands &mdash; type: integer, default: `60` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `SCALINGO_`.

For example, `password` can be given as `SCALINGO_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="SCALINGO_PASSWORD" %}