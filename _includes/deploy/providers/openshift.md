{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: openshift
  server: <server>
  token: <encrypted token>
  project: <project>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to OpenShift is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `server` | OpenShift server &mdash; **required**, type: string |
| `token` | OpenShift token &mdash; **required**, **secret**, type: string |
| `project` | OpenShift project &mdash; **required**, type: string |
| `app` | OpenShift application &mdash; type: string, default: `repo name` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `OPENSHIFT_`.

For example, `token` can be given as `OPENSHIFT_TOKEN=<token>`.
{% include deploy/secrets.md name="token" env_name="OPENSHIFT_TOKEN" %}