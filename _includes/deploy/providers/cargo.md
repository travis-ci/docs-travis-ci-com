## Known options

Use the following options to further configure the deployment:

| `token` | Cargo registry API token &mdash; **required**, **secret**, type: string |

## Environment variables

All options can be given as environment variables if prefixed with `CARGO_`.

For example, `token` can be given as `CARGO_TOKEN=<token>`.

{% include deploy/secrets.md name="token" env_name="CARGO_TOKEN" %}