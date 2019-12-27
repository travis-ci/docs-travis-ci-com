{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: netlify
  site: <site>
  auth: <encrypted auth>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Netlify is in **beta**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `site` | A site ID to deploy to &mdash; **required**, type: string |
| `auth` | An auth token to log in with &mdash; **required**, **secret**, type: string |
| `dir` | Specify a folder to deploy &mdash; type: string |
| `functions` | Specify a functions folder to deploy &mdash; type: string |
| `message` | A message to include in the deploy log &mdash; type: string |
| `prod` | Deploy to production &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `NETLIFY_`.

For example, `auth` can be given as `NETLIFY_AUTH=<auth>`.
{% include deploy/secrets.md name="auth" env_name="NETLIFY_AUTH" %}