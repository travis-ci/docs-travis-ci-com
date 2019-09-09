## Status

Support for deployments to AWS Code Deploy is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

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
| `bundle_type` | type: string |
| `endpoint` | type: string |
| `key` | type: string |
| `description` | type: string |

## Environment variables

All options can be given as environment variables if prefixed with `AWS_` or `CODEDEPLOY_`.

For example, `access_key_id` can be given as `AWS_ACCESS_KEY_ID=<access_key_id>` or `CODEDEPLOY_ACCESS_KEY_ID=<access_key_id>`.

{% include deploy/secrets.md name="access_key_id" env_name="AWS_ACCESS_KEY_ID" %}