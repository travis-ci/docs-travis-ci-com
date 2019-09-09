## Known options

Use the following options to further configure the deployment:

| `server` | OpenShift server &mdash; **required**, type: string |
| `token` | OpenShift token &mdash; **required**, **secret**, type: string |
| `project` | OpenShift project &mdash; **required**, type: string |
| `app` | OpenShift application &mdash; type: string, default: `repo name` |

## Environment variables

All options can be given as environment variables if prefixed with `OPENSHIFT_`.

For example, `token` can be given as `OPENSHIFT_TOKEN=<token>`.

{% include deploy/secrets.md name="token" env_name="OPENSHIFT_TOKEN" %}