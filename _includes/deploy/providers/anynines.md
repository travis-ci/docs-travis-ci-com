## Known options

Use the following options to further configure the deployment:

| `username` | anynines username &mdash; **required**, type: string |
| `password` | anynines password &mdash; **required**, **secret**, type: string |
| `organization` | anynines organization &mdash; **required**, type: string |
| `space` | anynines space &mdash; **required**, type: string |
| `app_name` | Application name &mdash; type: string |
| `buildpack` | Custom buildpack name or Git URL &mdash; type: string |
| `manifest` | Path to the manifest &mdash; type: string |

## Environment variables

All options can be given as environment variables if prefixed with `ANYNINES_`.

For example, `password` can be given as `ANYNINES_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="ANYNINES_PASSWORD" %}