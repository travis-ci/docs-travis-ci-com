## Known options

Use the following options to further configure the deployment:

| `token` | Snap API token &mdash; **required**, **secret**, type: string |
| `snap` | Path to the snap to be pushed (can be a glob) &mdash; type: string, default: `**/*.snap` |
| `channel` | Channel into which the snap will be released &mdash; type: string, default: `edge` |

## Environment variables

All options can be given as environment variables if prefixed with `SNAP_`.

For example, `token` can be given as `SNAP_TOKEN=<token>`.

{% include deploy/secrets.md name="token" env_name="SNAP_TOKEN" %}