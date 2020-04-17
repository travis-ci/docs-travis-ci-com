{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: nuget
  api_key: <encrypted api_key>
  registry: <registry>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to nuget is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `api_key` | NuGet registry API key &mdash; **required**, **secret**, type: string, note: can be retrieved from your NuGet registry provider, see: [https://docs.npmjs.com/creating-and-viewing-authentication-tokens](https://docs.npmjs.com/creating-and-viewing-authentication-tokens) |
| `registry` | NuGet registry url &mdash; **required**, type: string |
| `src` | The nupkg file(s) to publish &mdash; type: string, default: `*.nupkg` |
| `no_symbols` | Do not push symbols, even if present &mdash; type: boolean |
| `skip_duplicate` | Do not overwrite existing packages &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `NUGET_` or `DOTNET_`.

For example, `api_key` can be given as 

* `NUGET_API_KEY=<api_key>` or 
* `DOTNET_API_KEY=<api_key>`

{% include deploy/secrets.md name="api_key" env_name="NUGET_API_KEY" %}