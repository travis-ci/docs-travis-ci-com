{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: cloudfiles
  username: <username>
  api_key: <encrypted api_key>
  region: <region>
  container: <container>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Cloud Files is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `username` | Rackspace username &mdash; **required**, type: string |
| `api_key` | Rackspace API key &mdash; **required**, **secret**, type: string |
| `region` | Cloudfiles region &mdash; **required**, type: string, known values: `ord`, `dfw`, `syd`, `iad`, `hkg` |
| `container` | Name of the container that files will be uploaded to &mdash; **required**, type: string |
| `glob` | Paths to upload &mdash; type: string, default: `**/*` |
| `dot_match` | Upload hidden files starting a dot &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `CLOUDFILES_`.

For example, `api_key` can be given as `CLOUDFILES_API_KEY=<api_key>`.

{% include deploy/secrets.md name="api_key" env_name="CLOUDFILES_API_KEY" %}