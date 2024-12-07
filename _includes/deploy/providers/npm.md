{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: npm
  api_token: <encrypted api_token>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to npm is *stable**.
## Known options

Use the following options to further configure the deployment.

| `email` | npm account email &mdash; type: string |
| `api_token` | npm api token &mdash; **required**, **secret**, type: string, alias: `api_key`, note: can be retrieved from your local ~/.npmrc file, see: [https://docs.npmjs.com/creating-and-viewing-authentication-tokens](https://docs.npmjs.com/creating-and-viewing-authentication-tokens) |
| `access` | Access level &mdash; type: string, known values: `public`, `private` |
| `registry` | npm registry url &mdash; type: string |
| `src` | directory or tarball to publish &mdash; type: string, default: `.` |
| `tag` | distribution tags to add &mdash; type: string |
| `run_script` | run the given script from package.json &mdash; type: string or array of strings, note: skips running npm publish |
| `dry_run` | performs test run without uploading to registry &mdash; type: boolean |
| `auth_method` | Authentication method &mdash; type: string, known values: `auth` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `NPM_`.

For example, `api_token` can be given as `NPM_API_TOKEN=<api_token>`.

{% include deploy/secrets.md name="api_token" env_name="NPM_API_TOKEN" %}