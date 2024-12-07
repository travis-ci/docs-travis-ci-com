{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: opsworks
  access_key_id: <encrypted access_key_id>
  secret_access_key: <encrypted secret_access_key>
  app_id: <app_id>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to AWS OpsWorks is *stable**.
## Known options

Use the following options to further configure the deployment.

| `access_key_id` | AWS access key id &mdash; **required**, **secret**, type: string |
| `secret_access_key` | AWS secret key &mdash; **required**, **secret**, type: string |
| `app_id` | The app id &mdash; **required**, type: string |
| `region` | AWS region &mdash; type: string, default: `us-east-1` |
| `instance_ids` | An instance id &mdash; type: string or array of strings |
| `layer_ids` | A layer id &mdash; type: string or array of strings |
| `migrate` | Migrate the database. &mdash; type: boolean |
| `wait_until_deployed` | Wait until the app is deployed and return the deployment status. &mdash; type: boolean |
| `update_on_success` | When wait-until-deployed and updated-on-success are both not given, application source is updated to the current SHA. Ignored when wait-until-deployed is not given. &mdash; type: boolean, alias: `update_app_on_success` |
| `custom_json` | Custom json options override (overwrites default configuration) &mdash; type: string |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `AWS_` or `OPSWORKS_`.

For example, `access_key_id` can be given as 

* `AWS_ACCESS_KEY_ID=<access_key_id>` or 
* `OPSWORKS_ACCESS_KEY_ID=<access_key_id>`

{% include deploy/secrets.md name="access_key_id" env_name="AWS_ACCESS_KEY_ID" %}