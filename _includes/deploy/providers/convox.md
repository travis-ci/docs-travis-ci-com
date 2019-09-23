{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: convox
  app: <app>
  rack: <rack>
  password: <password>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Convox is in **development**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `host` | type: string, default: `console.convox.com` |
| `app` | **required**, type: string |
| `rack` | **required**, type: string |
| `password` | **required**, type: string |
| `install_url` | type: string, default: `https://convox.com/cli/linux/convox` |
| `update_cli` | type: boolean |
| `create` | type: boolean |
| `promote` | type: boolean, default: `true` |
| `env` | type: string or array of strings |
| `env_file` | type: string |
| `description` | type: string |
| `generation` | type: integer, default: `2` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

