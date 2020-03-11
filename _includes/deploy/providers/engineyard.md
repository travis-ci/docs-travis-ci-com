{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: engineyard
  api_key: <encrypted api_key>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}

Alternatively, you can use `email` and `password`:

```yaml
deploy:
  provider: engineyard
  email: <email>
  password: <encrypted password>
```
{: data-file=".travis.yml"}


{{ include.content }}
{% endunless %}

## Status

Support for deployments to Engineyard is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment. Either `api_key` or `email` and `password` are required.

| `api_key` | Engine Yard API key &mdash; **secret**, type: string, note: can be obtained at https://cloud.engineyard.com/cli |
| `email` | Engine Yard account email &mdash; type: string |
| `password` | Engine Yard password &mdash; **secret**, type: string |
| `app` | Engine Yard application name &mdash; type: string, default: `repo name` |
| `env` | Engine Yard application environment &mdash; type: string, alias: `environment` |
| `migrate` | Engine Yard migration commands &mdash; type: string |
| `account` | Engine Yard account name &mdash; type: string |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `ENGINEYARD_` or `EY_`.

For example, `api_key` can be given as 

* `ENGINEYARD_API_KEY=<api_key>` or 
* `EY_API_KEY=<api_key>`

{% include deploy/secrets.md name="api_key" env_name="ENGINEYARD_API_KEY" %}