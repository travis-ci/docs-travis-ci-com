{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: puppetforge
  username: <username>
  password: <encrypted password>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Puppet Forge is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `username` | Puppet Forge user name &mdash; **required**, type: string, alias: `user` |
| `password` | Puppet Forge password &mdash; **required**, **secret**, type: string |
| `url` | Puppet Forge URL to deploy to &mdash; type: string, default: `https://forgeapi.puppetlabs.com/` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `PUPPETFORGE_`.

For example, `password` can be given as `PUPPETFORGE_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="PUPPETFORGE_PASSWORD" %}