## Status

Support for deployments to Azure Web Apps is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `username` | Web App Deployment Username &mdash; **required**, type: string |
| `password` | Web App Deployment Password &mdash; **required**, **secret**, type: string |
| `site` | Web App name (e.g. myapp in myapp.azurewebsites.net) &mdash; **required**, type: string |
| `slot` | Slot name (if your app uses staging deployment) &mdash; type: string |
| `verbose` | Print deployment output from Azure. Warning: If authentication fails, Git prints credentials in clear text. Correct credentials remain hidden. &mdash; type: boolean |

## Environment variables

All options can be given as environment variables if prefixed with `AZURE_WA_`.

For example, `password` can be given as `AZURE_WA_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="AZURE_WA_PASSWORD" %}