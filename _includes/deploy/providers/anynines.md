{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: anynines
  username: <username>
  password: <encrypted password>
  organization: <organization>
  space: <space>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Anynines is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `username` | anynines username &mdash; **required**, type: string |
| `password` | anynines password &mdash; **required**, **secret**, type: string |
| `organization` | anynines organization &mdash; **required**, type: string |
| `space` | anynines space &mdash; **required**, type: string |
| `app_name` | Application name &mdash; type: string |
| `buildpack` | Buildpack name or Git URL &mdash; type: string |
| `manifest` | Path to the manifest &mdash; type: string |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `ANYNINES_`.

For example, `password` can be given as `ANYNINES_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="ANYNINES_PASSWORD" %}