{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: elasticbeanstalk
  access_key_id: <encrypted access_key_id>
  secret_access_key: <encrypted secret_access_key>
  env: <env>
  bucket: <bucket>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to AWS Elastic Beanstalk is *stable**.
## Known options

Use the following options to further configure the deployment.

| `access_key_id` | AWS Access Key ID &mdash; **required**, **secret**, type: string |
| `secret_access_key` | AWS Secret Key &mdash; **required**, **secret**, type: string |
| `region` | AWS Region the Elastic Beanstalk app is running in &mdash; type: string, default: `us-east-1` |
| `app` | Elastic Beanstalk application name &mdash; type: string, default: `repo name` |
| `env` | Elastic Beanstalk environment name which will be updated &mdash; **required**, type: string |
| `bucket` | Bucket name to upload app to &mdash; **required**, type: string, alias: `bucket_name` |
| `bucket_path` | Location within Bucket to upload app to &mdash; type: string |
| `description` | Description for the application version &mdash; type: string |
| `label` | Label for the application version &mdash; type: string |
| `zip_file` | The zip file that you want to deploy &mdash; type: string |
| `only_create_app_version` | Only create the app version, do not actually deploy it &mdash; type: boolean |
| `wait_until_deployed` | Wait until the deployment has finished &mdash; type: boolean |
| `wait_until_deployed_timeout` | How many seconds to wait for Elastic Beanstalk deployment update. &mdash; type: integer, default: `600` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `AWS_` or `ELASTIC_BEANSTALK_`.

For example, `access_key_id` can be given as 

* `AWS_ACCESS_KEY_ID=<access_key_id>` or 
* `ELASTIC_BEANSTALK_ACCESS_KEY_ID=<access_key_id>`

{% include deploy/secrets.md name="access_key_id" env_name="AWS_ACCESS_KEY_ID" %}