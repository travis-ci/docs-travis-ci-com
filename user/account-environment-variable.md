---
title: Account Environment Variables
layout: en

---

## Define Account Environment Variables

Travis CI allows you to create Account Environment variables, which can be used in every build under the account's enabled repositories. 

Account-level variables work similarly to repository-level settings; they can be used to customize your builds and set a list of environment variables and values to be reused across projects. Account environment variables can be used across different repositories. Any account environment variables created are accessible in all available repositories unless explicitly overridden. 

When an account-level variable is created with the same name as an existing repository-level variable, the build log displays the repository-level value instead of the account-level value. This is because the repository-level variable overrides the account-level variable.

Global environment variables are available to all repositories under the account but cannot be shared with forked repositories. Therefore, global environment variables are unavailable when attempting a Pull Request from a forked repository to the base repository.

### Using Account Variables in Forked Repositories
When a PR is created from a forked repository to the base repository, global environment variables defined in the base repository are not available in the PR's build environment.
The global environment variables are unavailable in the PR build because, for security reasons, they are not shared with the forked repository. 

Therefore, the base repository should clone the global environment variables to the repository level so that the PR build from a forked repository succeeds. This is because repository-level environment variables defined in the base repository are available in the PR's build environment. 

## Add Account Variables

Add new account environment variables by following these easy steps: 
1. Log in to your [Travis CI account](https://app.travis-ci.com/signin), and under your profile icon, select Settings. 
2. Navigate to the Settings tab and scroll to the Account Environment Variables section. 
3. Add new variables by filling out the required fields. 
  - **Name**: Select a name for the account environment variable.
  - **Value**: Enter the value for the account environment variable.
4. If desired, enable the **Display Value in Build Log** switch. If enabled, the value is visible in the logs. If disabled, it is marked as *“[secure]”*.
5. Once all fields are filled, click on the **Add New Variable** button. 

[img1]

After adding a variable, the secret is masked and added to the list of existing variables.

> Note: Using account-level variables can pose a security risk. Read our documentation for secure tips on [generating private keys](/user/best-practices-security#recommendations-on-how-to-avoid-leaking-secrets-to-build-logs). 

## Delete an Account Variable

An account variable can be deleted with the Delete option to the right of each key. 

Builds no longer have access to deleted variables. 

[img2]
