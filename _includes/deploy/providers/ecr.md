{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: ecr
  access_key_id: <encrypted access_key_id>
  secret_access_key: <encrypted secret_access_key>
  source: <source>
  target: <target>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to AWS ECR is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `access_key_id` | AWS access key &mdash; **required**, **secret**, type: string |
| `secret_access_key` | AWS secret access key &mdash; **required**, **secret**, type: string |
| `account_id` | AWS Account ID &mdash; type: string, note: Required if the repository is owned by a different account than the IAM user |
| `source` | Image to push &mdash; **required**, type: string, note: can be the id or the name and optional tag (e.g. mysql:5.6) |
| `target` | Comma separated list of partial repository names to push to &mdash; **required**, type: string |
| `region` | Comma separated list of regions to push to &mdash; type: string, default: `us-east-1` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `AWS_`.

For example, `access_key_id` can be given as `AWS_ACCESS_KEY_ID=<access_key_id>`.

{% include deploy/secrets.md name="access_key_id" env_name="AWS_ACCESS_KEY_ID" %}