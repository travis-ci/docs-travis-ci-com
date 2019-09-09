## Known options

Use the following options to further configure the deployment:

| `email` | npm account email &mdash; type: string |
| `api_token` | npm api token &mdash; **required**, **secret**, type: string, alias: `api_key`, note: can be retrieved from your local ~/.npmrc file, see: [https://docs.npmjs.com/creating-and-viewing-authentication-tokens](https://docs.npmjs.com/creating-and-viewing-authentication-tokens) |
| `access` | Access level &mdash; type: string, known values: `public`, `private` |
| `registry` | npm registry url &mdash; type: string |
| `src` | directory or tarball to publish &mdash; type: string, default: `.` |
| `tag` | distribution tags to add &mdash; type: string |
| `auth_method` | Authentication method &mdash; type: boolean, known values: `auth` |

## Environment variables

All options can be given as environment variables if prefixed with `NPM_`.

For example, `api_token` can be given as `NPM_API_TOKEN=<api_token>`.

{% include deploy/secrets.md name="api_token" env_name="NPM_API_TOKEN" %}