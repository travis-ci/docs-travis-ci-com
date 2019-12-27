{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: cloudformation
  access_key_id: <encrypted access_key_id>
  secret_access_key: <encrypted secret_access_key>
  template: <template>
  stack_name: <stack_name>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to AWS CloudFormation is in **development**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `access_key_id` | AWS Access Key ID &mdash; **required**, **secret**, type: string |
| `secret_access_key` | AWS Secret Key &mdash; **required**, **secret**, type: string |
| `region` | AWS Region to deploy to &mdash; type: string, default: `us-east-1` |
| `template` | CloudFormation template file &mdash; **required**, type: string, note: can be either a local path or an S3 URL |
| `stack_name` | CloudFormation Stack Name. &mdash; **required**, type: string |
| `stack_name_prefix` | CloudFormation Stack Name Prefix. &mdash; type: string |
| `promote` | Deploy changes &mdash; type: boolean, default: `true`, note: otherwise a change set is created |
| `role_arn` | AWS Role ARN &mdash; type: string |
| `sts_assume_role` | AWS Role ARN for cross account deployments (assumed by travis using given AWS credentials). &mdash; type: string |
| `capabilities` | CloudFormation allowed capabilities &mdash; type: string or array of strings, known values: `CAPABILITY_IAM`, `CAPABILITY_NAMED_IAM`, `CAPABILITY_AUTO_EXPAND`, see: [https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html](https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html) |
| `wait` | Wait for CloutFormation to finish the stack creation and update &mdash; type: boolean, default: `true` |
| `wait_timeout` | How many seconds to wait for stack creation and update. &mdash; type: integer, default: `3600` |
| `create_timeout` | How many seconds to wait before the stack status becomes CREATE_FAILED &mdash; type: integer, default: `3600`, note: valid only when creating a stack |
| `session_token` | AWS Session Access Token if using STS assume role &mdash; type: string, note: Not recommended on CI/CD |
| `parameters` | key=value pairs or ENV var names &mdash; type: string or array of strings |
| `output_file` | Path to output file to store CloudFormation outputs to &mdash; type: string |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `AWS_` or `CLOUDFORMATION_`.

For example, `access_key_id` can be given as 

* `AWS_ACCESS_KEY_ID=<access_key_id>` or 
* `CLOUDFORMATION_ACCESS_KEY_ID=<access_key_id>`
{% include deploy/secrets.md name="access_key_id" env_name="AWS_ACCESS_KEY_ID" %}