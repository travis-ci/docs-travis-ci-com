## Known options

Use the following options to further configure the deployment:

| `app` | Gleis application to upload to &mdash; type: string, default: `repo name` |
| `username` | Gleis username &mdash; **required**, type: string |
| `password` | Gleis password &mdash; **required**, **secret**, type: string |
| `key_name` | Name of the SSH deploy key pushed to Gleis &mdash; type: string, default: `dpl_deploy_key` |
| `verbose` | type: boolean |

## Environment variables

All options can be given as environment variables if prefixed with `GLEIS_`.

For example, `password` can be given as `GLEIS_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="GLEIS_PASSWORD" %}