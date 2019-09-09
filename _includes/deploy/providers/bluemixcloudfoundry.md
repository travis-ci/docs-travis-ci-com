## Known options

Use the following options to further configure the deployment:

| `username` | Bluemix username &mdash; **required**, type: string |
| `password` | Bluemix password &mdash; **required**, **secret**, type: string |
| `organization` | Bluemix organization &mdash; **required**, type: string |
| `space` | Bluemix space &mdash; **required**, type: string |
| `region` | Bluemix region &mdash; type: string, default: `ng`, known values: `ng`, `eu-gb`, `eu-de`, `au-syd` |
| `api` | Bluemix api URL &mdash; type: string |
| `app_name` | Application name &mdash; type: string |
| `buildpack` | Custom buildpack name or Git URL &mdash; type: string |
| `manifest` | Path to the manifest &mdash; type: string |
| `skip_ssl_validation` | Skip SSL validation &mdash; type: boolean |

## Environment variables

All options can be given as environment variables if prefixed with `CLOUDFOUNDRY_`.

For example, `password` can be given as `CLOUDFOUNDRY_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="CLOUDFOUNDRY_PASSWORD" %}