{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: hackage
  username: <username>
  password: <encrypted password>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Hackage is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `username` | Hackage username &mdash; **required**, type: string |
| `password` | Hackage password &mdash; **required**, **secret**, type: string |
| `publish` | Whether or not to publish the package &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `HACKAGE_`.

For example, `password` can be given as `HACKAGE_PASSWORD=<password>`.
{% include deploy/secrets.md name="password" env_name="HACKAGE_PASSWORD" %}