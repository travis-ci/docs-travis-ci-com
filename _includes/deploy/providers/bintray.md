{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: bintray
  user: <user>
  key: <encrypted key>
  file: <file>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Bintray is *stable**.
## Known options

Use the following options to further configure the deployment.

| `user` | Bintray user &mdash; **required**, type: string |
| `key` | Bintray API key &mdash; **required**, **secret**, type: string |
| `file` | Path to a descriptor file for the Bintray upload &mdash; **required**, type: string |
| `passphrase` | Passphrase as configured on Bintray (if GPG signing is used) &mdash; type: string |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `BINTRAY_`.

For example, `key` can be given as `BINTRAY_KEY=<key>`.

{% include deploy/secrets.md name="key" env_name="BINTRAY_KEY" %}