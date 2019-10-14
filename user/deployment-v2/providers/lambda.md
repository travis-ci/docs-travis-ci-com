---
title: Lambda Deployment
layout: en
deploy: v2
provider: lambda
---

Travis CI supports uploading to [AWS Lambda](https://aws.amazon.com/lambda/).

{% include deploy/providers/lambda.md %}

### AWS permissions

The AWS user that Travis deploys as must have the following IAM permissions in order to deploy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListExistingRolesAndPolicies",
      "Effect": "Allow",
      "Action": [
        "iam:ListRolePolicies",
        "iam:ListRoles"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CreateAndListFunctions",
      "Effect": "Allow",
      "Action": [
        "lambda:CreateFunction",
        "lambda:ListFunctions"
      ],
      "Resource": "*"
    },
    {
      "Sid": "DeployCode",
      "Effect": "Allow",
      "Action": [
        "lambda:GetFunction",
        "lambda:UpdateFunctionCode",
        "lambda:UpdateFunctionConfiguration"
      ],
      "Resource": [
        "arn:aws:lambda:<region>:<account-id>:function:<name-of-function>"
      ]
    },
    {
     "Sid": "SetRole",
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "arn:aws:iam::<account-id>:role/<name-of-role>"
    }
  ]
}
```

It does not appear to be possible to wildcard the `DeployCode` statement such
that Travis CI can deploy any function in a particular region by specifying the
resource as `arn:aws:lambda:<region>:<account-id>:function:*` but it is
possible to limit the deployment permissions on a per function basis by
specifying the complete ARN to one or more functions, i.e.
`arn:aws:lambda:<region>:<account-id>:function:<name>`.

{% include deploy/shared.md %}
