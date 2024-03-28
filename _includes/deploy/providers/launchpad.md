{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: launchpad

  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Launchpad is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `oauth_token` | Launchpad OAuth token &mdash; **secret**, type: string |
| `oauth_token_secret` | Launchpad OAuth token secret &mdash; **secret**, type: string |
| `slug` | Launchpad project slug &mdash; type: string, format: `/^~[^\/]+\/[^\/]+\/[^\/]+$/`, e.g.: ~user-name/project-name/branch-name |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `LAUNCHPAD_`.

For example, `oauth_token` can be given as `LAUNCHPAD_OAUTH_TOKEN=<oauth_token>`.

{% include deploy/secrets.md name="oauth_token" env_name="LAUNCHPAD_OAUTH_TOKEN" %}