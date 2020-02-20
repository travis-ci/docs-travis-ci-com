{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: snap
  token: <encrypted token>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Snap is *stable**.
## Known options

Use the following options to further configure the deployment.

| `token` | Snap API token &mdash; **required**, **secret**, type: string |
| `snap` | Path to the snap to be pushed (can be a glob) &mdash; type: string, default: `**/*.snap` |
| `channel` | Channel into which the snap will be released &mdash; type: string, default: `edge` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `SNAP_`.

For example, `token` can be given as `SNAP_TOKEN=<token>`.

{% include deploy/secrets.md name="token" env_name="SNAP_TOKEN" %}