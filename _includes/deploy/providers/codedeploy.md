{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: codedeploy
  access_key_id: <encrypted access_key_id>
  secret_access_key: <encrypted secret_access_key>
  application: <application>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to AWS Code Deploy is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `access_key_id` | AWS access key &mdash; **required**, **secret**, type: string |
| `secret_access_key` | AWS secret access key &mdash; **required**, **secret**, type: string |
| `application` | CodeDeploy application name &mdash; **required**, type: string |
| `deployment_group` | CodeDeploy deployment group name &mdash; type: string |
| `revision_type` | CodeDeploy revision type &mdash; type: string, known values: `s3`, `github`, downcase: true |
| `commit_id` | Commit ID in case of GitHub &mdash; type: string |
| `repository` | Repository name in case of GitHub &mdash; type: string |
| `bucket` | S3 bucket in case of S3 &mdash; type: string |
| `region` | AWS availability zone &mdash; type: string, default: `us-east-1` |
| `file_exists_behavior` | How to handle files that already exist in a deployment target location &mdash; type: string, default: `disallow`, known values: `disallow`, `overwrite`, `retain` |
| `wait_until_deployed` | Wait until the deployment has finished &mdash; type: boolean |
| `bundle_type` | Bundle type of the revision &mdash; type: string |
| `key` | S3 bucket key of the revision &mdash; type: string |
| `description` | Description of the revision &mdash; type: string |
| `endpoint` | S3 endpoint url &mdash; type: string |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `AWS_` or `CODEDEPLOY_`.

For example, `access_key_id` can be given as 

* `AWS_ACCESS_KEY_ID=<access_key_id>` or 
* `CODEDEPLOY_ACCESS_KEY_ID=<access_key_id>`
{% include deploy/secrets.md name="access_key_id" env_name="AWS_ACCESS_KEY_ID" %}