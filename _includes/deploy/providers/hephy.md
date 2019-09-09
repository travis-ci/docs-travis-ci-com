## Known options

Use the following options to further configure the deployment:

| `controller` | Hephy controller &mdash; **required**, type: string, e.g.: hephy.hephyapps.com |
| `username` | Hephy username &mdash; **required**, type: string |
| `password` | Hephy password &mdash; **required**, **secret**, type: string |
| `app` | Deis app &mdash; **required**, type: string |
| `cli_version` | Install a specific Hephy CLI version &mdash; type: string, default: `stable` |
| `verbose` | Verbose log output &mdash; type: boolean |

## Environment variables

All options can be given as environment variables if prefixed with `HEPHY_`.

For example, `password` can be given as `HEPHY_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="HEPHY_PASSWORD" %}