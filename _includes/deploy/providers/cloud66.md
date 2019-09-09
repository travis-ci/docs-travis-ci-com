## Known options

Use the following options to further configure the deployment:

| `redeployment_hook` | The redeployment hook URL &mdash; **required**, **secret**, type: string |

## Environment variables

All options can be given as environment variables if prefixed with `CLOUD66_`.

For example, `redeployment_hook` can be given as `CLOUD66_REDEPLOYMENT_HOOK=<redeployment_hook>`.

{% include deploy/secrets.md name="redeployment_hook" env_name="CLOUD66_REDEPLOYMENT_HOOK" %}