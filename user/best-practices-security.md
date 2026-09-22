---
title: Best Practices in Securing Your Data
layout: en

---

## Travis CI steps to secure your data
Travis CI obfuscates secure environment variables and tokens displayed in the UI. Our [documentation about encryption keys](/user/encryption-keys/) outlines the build configuration we require to ensure this, however, once a VM is booted and tests are running, we have less control over what information utilities or add-ons are able to print to the VM’s standard output.

To prevent leaks made by these components, we automatically filter secure environment variables and tokens that are longer than three characters at runtime, effectively removing them from the build log, displaying the string `[secure]` instead.

Please make sure your secret is never related to the repository or branch name, or any other guessable string. Ideally, you should use a password generation tool such as `mkpasswd` instead of choosing a secret yourself.

> The beta Windows support does not obfuscate secure environment variables leaked into the build log. Please keep reading the next section, [on how to avoid leaking secrets to build logs](https://docs.travis-ci.com/user/best-practices-security/#recommendations-on-how-to-avoid-leaking-secrets-to-build-logs)

### Log Scans

Travis CI has also enabled a mandatory post-job log scan in an attempt to find any other potential leakage of secrets. These scans are carried out on the raw job log files shortly after the build job is completed. Scans are executed using [Trivy](https://github.com/aquasecurity/trivy) and [detect-secrets](https://github.com/Yelp/detect-secrets), Open Source scanners made available by their maintainers via means of a permissive OSS license. If the scanning process finds an unmasked secret-like entry in the job log, Travis CI, as a precautionary action, will mask the full line in the job log with asterisks (`*`) and produce a log scan report, available to the repository administrators for 7 days.

The job log scan report contains details on found potential secrets, referring to the line numbers in the **raw** job log file, and is meant to help review and find the source of the possible leak and if this proves to be an actual exposition of the secret, the scan fixes that.

When the additional post-job scanning process finds a potential leak in the build-job log, a graphical status in the Travis CI Web UI will present the log scan results. The *log scan: failing* is displayed over the repository page and in the dashboard for the next 7 days or until at least one of the repository administrators visits the job log scan report page, whichever condition is satisfied first.

Since the job log scan is executed by the tools looking for secret-like entries, the notifications must be treated as a warning about the **potential** issue and verified by the repository administrator. Therefore, we recommend the following verification steps:

 * Reviewing the exact build instructions in the repository `.travis.yml` file (particularly if any unencrypted secrets are used) and build scripts called from within the `.travis.yml` recipe.
 * Re-running suspicious jobs and reviewing the build job log on the go. Particularly around the preemptively censored area (please mind it will re-trigger the job log scan and any potential notifications in the process).

> Please note: The scan results may produce false positives and/or miss some items due to the nature of the scanners (searching for secret-like patterns). This is continuous work, and we expect it to improve over time based on findings and feedback. Also, we closely monitor the number of warnings raised by the job log scan process and decide later on to enable respective email notifications on top of existing visual indicators.


## Leaking secrets to build logs
Despite our best efforts, there are, however, many ways in which secure information can accidentally be exposed. These vary according to what tools you are using and what settings you have enabled. Some things to look out for are:

* settings which duplicate commands to standard output, such as `set -x` or `set -v` in your bash scripts.
* displaying environment variables, by running `env` or `printenv`.
* printing secrets within the code, for example `echo "$SECRET_KEY"`.
* using tools that print secrets on error output, such as `php -i`.
* git commands like `git fetch` or `git push` may expose tokens or other secure environment variables.
* mistakes in string escaping.
* settings which increase command verbosity.
* testing tools or plugins that may expose secrets while operating.

Preventing commands from displaying any output is one way to avoid accidentally displaying any secure information. If there is a particular command that is using secure information, you can redirect its output to `/dev/null` to make sure it does not accidentally publish anything, as shown in the following example:

```sh
git push url-with-secret >/dev/null 2>&1
```

While using Travis CI, you may want to consider the additional means to decrease the risk of exposing secrets in the build job logs:

### Use encrypted secrets

Travis CI offers the ability to either [encrypt your secret](/user/encryption-keys/) with the Travis-CLI (command line interface tool) or define the secret in the [Travis CI Repository Settings](/user/environment-variables/#defining-variables-in-repository-settings).

Shall the secret be stored in an encrypted file within your source code repository, you may instead [encrypt a file with a secret](/user/encrypting-files/) and use it during the build job. Decrypt your file for the shortest time needed and remove any temporary environment variables from the build job environment as soon as these are not necessary.

Please mind that at some point, the secret, in order to be used, must be decrypted for the build job environment. Thus debug outputs to the standard outputs may still result in secret exposure. The additional post-job log scanning process is meant to find as many of these as possible.

### Use the Hashicorp Vault KMS integration
If you manage your secrets using the Hashicorp Vault KMS (Key Management System), then you may use the existing [Travis CI - Hashicorp integration](/user/hashicorp-vault-integration) to obtain secrets directly to the build job.

Again, please be wary of any possible debug outputs to the standard outputs in the build job environment. The additional post-job log scanning process is meant to find as many of these as possible. The advantage of pulling the secret from a KMS managed by you is the ability to rotate it from a single secret repository in case of any incident. We strongly recommend using Hashicorp Vault credentials limited to a specific set of CI/CD-related secrets to limit the threat scope for the KMS.

### Limit job log access
Review who and why should have access to the build job logs and set the appropriate options in the [Travis CI Repository Settings](/user/disable-job-logs/).

### Settings review for fork repository builds
Review the [Travis CI Repository Settings](/user/pull-requests/#pull-requests-and-security-restrictions) and adjust what should be shared with forks. This is meant for a collaboration pattern when a forked repository can file a Pull Request to the base repository, thus triggering a CI/CD build job with automated build and tests as a part of the Pull Request validation and approval process. Assess the risks and adjust settings to your scenario.

### Run builds requiring secrets in private repositories
If this is a viable option, consider running builds requiring the usage of secrets as a CI/CD for private repositories with a carefully reviewed collaborator list. Combined with the above options, it should decrease the risk of secret exposition in the build job log.


## Take control of exposing secure information  

As an initial step, it’s possible to delete logs containing any secure information by clicking the *Remove log* button on the build log page of Travis CI.

![remove log button](/images/remove-log.png "remove log button")

If you discover a leak in one of your build logs, it’s essential that you revoke the leaked token or environment variable and update any build scripts or commands that caused the leak.

### Alternative log-deleting methods 

Instead of deleting build logs manually, you can do so using the [Travis CI CLI](https://github.com/travis-ci/travis.rb#logs) or the  [API](https://developer.travis-ci.com/resource/log#delete).

## Rotate tokens and secrets periodically
Rotate your tokens and secrets regularly. GitHub OAuth tokens can be found in your [Developer Settings](https://github.com/settings/developers) on the GitHub site. Please regularly rotate credentials for other third-party services as well.

## Disclaimer
The suggestions in this document reflect general recommendations that the Travis CI team and community encourage everyone to follow. However, suggestions here are not exhaustive, and you should use your best judgment to determine security processes for your project. If you have any questions about security at Travis CI or suspect you may have found a vulnerability, don't hesitate to contact us at <security@travis-ci.com>.

All other questions about Travis CI should be directed to <support@travis-ci.com>.
