## Known options

Use the following options to further configure the deployment:

| `username` | Hackage username &mdash; **required**, type: string |
| `password` | Hackage password &mdash; **required**, **secret**, type: string |
| `publish` | Whether or not to publish the package &mdash; type: boolean |

## Environment variables

All options can be given as environment variables if prefixed with `HACKAGE_`.

For example, `password` can be given as `HACKAGE_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="HACKAGE_PASSWORD" %}