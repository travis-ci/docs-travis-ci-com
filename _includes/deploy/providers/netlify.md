## Known options

Use the following options to further configure the deployment:

| `site` | A site ID to deploy to &mdash; **required**, type: string |
| `auth` | An auth token to log in with &mdash; **required**, **secret**, type: string |
| `dir` | Specify a folder to deploy &mdash; type: string |
| `functions` | Specify a functions folder to deploy &mdash; type: string |
| `message` | A message to include in the deploy log &mdash; type: string |
| `prod` | Deploy to production &mdash; type: boolean |

## Environment variables

All options can be given as environment variables if prefixed with `NETLIFY_`.

For example, `auth` can be given as `NETLIFY_AUTH=<auth>`.

{% include deploy/secrets.md name="auth" env_name="NETLIFY_AUTH" %}