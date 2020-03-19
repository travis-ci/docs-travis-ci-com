{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: lambda
  access_key_id: <encrypted access_key_id>
  secret_access_key: <encrypted secret_access_key>
  function_name: <function_name>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to AWS Lambda is *stable**.
## Known options

Use the following options to further configure the deployment.

| `access_key_id` | AWS access key id &mdash; **required**, **secret**, type: string |
| `secret_access_key` | AWS secret key &mdash; **required**, **secret**, type: string |
| `region` | AWS region the Lambda function is running in &mdash; type: string, default: `us-east-1` |
| `function_name` | Name of the Lambda being created or updated &mdash; **required**, type: string |
| `role` | ARN of the IAM role to assign to the Lambda function &mdash; type: string, note: required when creating a new function |
| `handler_name` | Function the Lambda calls to begin execution. &mdash; type: string, note: required when creating a new function |
| `module_name` | Name of the module that exports the handler &mdash; type: string, requires: `handler_name`, default: `index` |
| `description` | Description of the Lambda being created or updated &mdash; type: string |
| `timeout` | Function execution time (in seconds) at which Lambda should terminate the function &mdash; type: string, default: `3` |
| `memory_size` | Amount of memory in MB to allocate to this Lambda &mdash; type: string, default: `128` |
| `subnet_ids` | List of subnet IDs to be added to the function &mdash; type: string or array of strings, note: Needs the ec2:DescribeSubnets and ec2:DescribeVpcs permission for the user of the access/secret key to work |
| `security_group_ids` | List of security group IDs to be added to the function &mdash; type: string or array of strings, note: Needs the ec2:DescribeSecurityGroups and ec2:DescribeVpcs permission for the user of the access/secret key to work |
| `environment` | List of Environment Variables to add to the function &mdash; type: string or array of strings, alias: `environment_variables`, format: `/[\w\-]+=.+/`, note: Can be encrypted for added security |
| `runtime` | Lambda runtime to use &mdash; type: string, default: `nodejs10.x`, known values: `nodejs12.x`, `nodejs10.x`, `python3.8`, `python3.7`, `python3.6`, `python2.7`, `ruby2.7`, `ruby2.5`, `java11`, `java8`, `go1.x`, `dotnetcore2.1`, note: required when creating a new function |
| `dead_letter_arn` | ARN to an SNS or SQS resource used for the dead letter queue. &mdash; type: string |
| `kms_key_arn` | KMS key ARN to use to encrypt environment_variables. &mdash; type: string |
| `tracing_mode` | Tracing mode &mdash; type: string, default: `PassThrough`, known values: `Active`, `PassThrough`, note: Needs xray:PutTraceSegments xray:PutTelemetryRecords on the role |
| `layers` | Function layer arns &mdash; type: string or array of strings |
| `function_tags` | List of tags to add to the function &mdash; type: string or array of strings, format: `/[\w\-]+=.+/`, note: Can be encrypted for added security |
| `publish` | Create a new version of the code instead of replacing the existing one. &mdash; type: boolean |
| `zip` | Path to a packaged Lambda, a directory to package, or a single file to package &mdash; type: string, default: `.` |
| `dot_match` | Include hidden .* files to the zipped archive &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `AWS_` or `LAMBDA_`.

For example, `access_key_id` can be given as 

* `AWS_ACCESS_KEY_ID=<access_key_id>` or 
* `LAMBDA_ACCESS_KEY_ID=<access_key_id>`
## Interpolation variables

The following variables are available for interpolation on `description`:

* `dead_letter_arn`
* `function_name`
* `git_author_email`
* `git_author_name`
* `git_branch`
* `git_commit_author`
* `git_commit_msg`
* `git_sha`
* `git_tag`
* `handler_name`
* `kms_key_arn`
* `memory_size`
* `module_name`
* `region`
* `role`
* `runtime`
* `timeout`
* `tracing_mode`
* `zip`

Interpolation uses the syntax `%{variable-name}`. For example,
`"Current commit sha: %{git_sha}"` would result in a string with the
current Git sha embedded.

Furthermore, environment variables present in the current build
environment can be used through standard Bash variable interpolation.
For example: "Current build number: ${TRAVIS_BUILD_NUMBER}".
See [here](/user/environment-variables/#default-environment-variables)
for a list of default environment variables set.

{% include deploy/secrets.md name="access_key_id" env_name="AWS_ACCESS_KEY_ID" %}