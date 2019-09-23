{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: cargo
  token: <encrypted token>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Cargo is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `token` | Cargo registry API token &mdash; **required**, **secret**, type: string |
| `allow_dirty` | Allow publishing from a dirty git working directory &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `CARGO_`.

For example, `token` can be given as `CARGO_TOKEN=<token>`.
{% include deploy/secrets.md name="token" env_name="CARGO_TOKEN" %}