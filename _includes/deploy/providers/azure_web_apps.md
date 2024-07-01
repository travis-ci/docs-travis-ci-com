{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: azure_web_apps
  username: <username>
  password: <encrypted password>
  site: <site>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Azure Web Apps is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `username` | Web App Deployment Username &mdash; **required**, type: string |
| `password` | Web App Deployment Password &mdash; **required**, **secret**, type: string |
| `site` | Web App name (e.g. myapp in myapp.azurewebsites.net) &mdash; **required**, type: string |
| `slot` | Slot name (if your app uses staging deployment) &mdash; type: string |
| `verbose` | Print deployment output from Azure. Warning: If authentication fails, Git prints credentials in clear text. Correct credentials remain hidden. &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `AZURE_WA_`.

For example, `password` can be given as `AZURE_WA_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="AZURE_WA_PASSWORD" %}