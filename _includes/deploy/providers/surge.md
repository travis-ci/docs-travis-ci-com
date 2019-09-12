{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: surge
  login: <login>
  token: <encrypted token>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Surge is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `login` | Surge login (the email address you use with Surge) &mdash; **required**, type: string |
| `token` | Surge login token (can be retrieved with `surge token`) &mdash; **required**, **secret**, type: string |
| `domain` | Domain to publish to. Not required if the domain is set in the CNAME file in the project folder. &mdash; type: string |
| `project` | Path to project directory relative to repo root &mdash; type: string, default: `.` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `SURGE_`.

For example, `token` can be given as `SURGE_TOKEN=<token>`.
{% include deploy/secrets.md name="token" env_name="SURGE_TOKEN" %}