## Status

Support for deployments to Cloud66 is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `redeployment_hook` | The redeployment hook URL &mdash; **required**, **secret**, type: string |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `CLOUD66_`.

For example, `redeployment_hook` can be given as `CLOUD66_REDEPLOYMENT_HOOK=<redeployment_hook>`.

{% include deploy/secrets.md name="redeployment_hook" env_name="CLOUD66_REDEPLOYMENT_HOOK" %}