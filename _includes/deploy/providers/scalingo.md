## Known options

Use the following options to further configure the deployment:

| `app` | type: string, default: `repo name` |
| `api_token` | Scalingo API token &mdash; type: string, alias: `api_key` (deprecated, please use `api_token`) |
| `username` | Scalingo username &mdash; type: string |
| `password` | Scalingo password &mdash; **secret**, type: string |
| `region` | Scalingo region &mdash; type: string, default: `agora-fr1`, known values: `agora-fr1`, `osc-fr1` |
| `remote` | Git remote name &mdash; type: string, default: `scalingo-dpl` |
| `branch` | Git branch &mdash; type: string, default: `master` |
| `timeout` | Timeout for Scalingo CLI commands &mdash; type: integer, default: `60` |

## Environment variables

All options can be given as environment variables if prefixed with `SCALINGO_`.

For example, `password` can be given as `SCALINGO_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="SCALINGO_PASSWORD" %}