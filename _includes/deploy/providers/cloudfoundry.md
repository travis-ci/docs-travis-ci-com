## Status

Support for deployments to Cloud Foundry is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `username` | Cloud Foundry username &mdash; **required**, type: string |
| `password` | Cloud Foundry password &mdash; **required**, **secret**, type: string |
| `organization` | Cloud Foundry organization &mdash; **required**, type: string |
| `space` | Cloud Foundry space &mdash; **required**, type: string |
| `api` | Cloud Foundry api URL &mdash; **required**, type: string |
| `app_name` | Application name &mdash; type: string |
| `buildpack` | Custom buildpack name or Git URL &mdash; type: string |
| `manifest` | Path to the manifest &mdash; type: string |
| `skip_ssl_validation` | Skip SSL validation &mdash; type: boolean |
| `v3` | Use the v3 API version to push the application &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `CLOUDFOUNDRY_`.

For example, `password` can be given as `CLOUDFOUNDRY_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="CLOUDFOUNDRY_PASSWORD" %}