## Status

Support for deployments to Transifex is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `api_token` | Transifex API token &mdash; **secret**, type: string |
| `username` | Transifex username &mdash; type: string |
| `password` | Transifex password &mdash; **secret**, type: string |
| `hostname` | Transifex hostname &mdash; type: string, default: `www.transifex.com` |
| `cli_version` | CLI version to install &mdash; type: string, default: `>=0.11` |

## Environment variables

All options can be given as environment variables if prefixed with `TRANSIFEX_`.

For example, `api_token` can be given as `TRANSIFEX_API_TOKEN=<api_token>`.

{% include deploy/secrets.md name="api_token" env_name="TRANSIFEX_API_TOKEN" %}