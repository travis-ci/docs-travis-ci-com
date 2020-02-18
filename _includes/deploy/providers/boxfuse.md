{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: boxfuse
  user: <user>
  secret: <encrypted secret>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Boxfuse is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `user` | **required**, type: string |
| `secret` | **required**, **secret**, type: string |
| `payload` | type: string |
| `app` | type: string |
| `version` | type: string |
| `env` | type: string |
| `config_file` | type: string, alias: `configfile` (deprecated, please use `config_file`) |
| `extra_args` | type: string |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `BOXFUSE_`.

For example, `secret` can be given as `BOXFUSE_SECRET=<secret>`.
{% include deploy/secrets.md name="secret" env_name="BOXFUSE_SECRET" %}