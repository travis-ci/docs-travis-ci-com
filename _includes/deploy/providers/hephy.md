{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: hephy
  controller: <controller>
  username: <username>
  password: <encrypted password>
  app: <app>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Hephy is in **beta**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `controller` | Hephy controller &mdash; **required**, type: string, e.g.: hephy.hephyapps.com |
| `username` | Hephy username &mdash; **required**, type: string |
| `password` | Hephy password &mdash; **required**, **secret**, type: string |
| `app` | Deis app &mdash; **required**, type: string |
| `cli_version` | Install a specific Hephy CLI version &mdash; type: string, default: `stable` |
| `verbose` | Verbose log output &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `HEPHY_`.

For example, `password` can be given as `HEPHY_PASSWORD=<password>`.
{% include deploy/secrets.md name="password" env_name="HEPHY_PASSWORD" %}