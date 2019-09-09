## Known options

Use the following options to further configure the deployment:

| `user` | **required**, type: string |
| `secret` | **required**, **secret**, type: string |
| `payload` | type: string |
| `app` | type: string |
| `version` | type: string |
| `env` | type: string |
| `config_file` | type: string, alias: `configfile` (deprecated, please use `config_file`) |
| `extra_args` | type: string |

## Environment variables

All options can be given as environment variables if prefixed with `BOXFUSE_`.

For example, `secret` can be given as `BOXFUSE_SECRET=<secret>`.

{% include deploy/secrets.md name="secret" env_name="BOXFUSE_SECRET" %}