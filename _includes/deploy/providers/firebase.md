{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: firebase
  token: <encrypted token>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Firebase is *stable**.
## Known options

Use the following options to further configure the deployment.

| `token` | Firebase CI access token (generate with firebase login:ci) &mdash; **required**, **secret**, type: string |
| `project` | Firebase project to deploy to (defaults to the one specified in your firebase.json) &mdash; type: string |
| `message` | Message describing this deployment. &mdash; type: string |
| `only` | Firebase services to deploy &mdash; type: string, note: can be a comma-separated list |
| `force` | Whether or not to delete Cloud Functions missing from the current working directory &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `FIREBASE_`.

For example, `token` can be given as `FIREBASE_TOKEN=<token>`.

{% include deploy/secrets.md name="token" env_name="FIREBASE_TOKEN" %}