{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: git_push
  token: <encrypted token>
  branch: <branch>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}

Alternatively, you can use `deploy_key`:

```yaml
deploy:
  provider: git_push
  deploy_key: <deploy_key>
  branch: <branch>
```
{: data-file=".travis.yml"}


{{ include.content }}
{% endunless %}

## Status

Support for deployments to Git (push) is in **development**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment. Either `token` or `deploy_key` are required.

| `repo` | Repo slug &mdash; type: string, default: `repo slug` |
| `token` | GitHub token with repo permission &mdash; **secret**, type: string, alias: `github_token` |
| `deploy_key` | Path to a file containing a private deploy key with write access to the repository &mdash; type: string, see: [https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys](https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys) |
| `branch` | Target branch to push to &mdash; **required**, type: string |
| `base_branch` | Base branch to branch off initially, and (optionally) create a pull request for &mdash; type: string, default: `master` |
| `commit_message` | type: string, default: `Update %{base_branch}` |
| `allow_empty_commit` | Allow an empty commit to be created &mdash; type: boolean |
| `force` | Whether to push --force &mdash; type: boolean, default: `false` |
| `local_dir` | Local directory to push &mdash; type: string, default: `.` |
| `name` | Committer name &mdash; type: string, note: defaults to the current git commit author name |
| `email` | Committer email &mdash; type: string, note: defaults to the current git commit author email |
| `pull_request` | Whether to create a pull request for the given branch &mdash; type: boolean |
| `allow_same_branch` | Whether to allow pushing to the same branch as the current branch &mdash; type: boolean, default: `false`, note: setting this to true risks creating infinite build loops, use conditional builds or other mechanisms to prevent build from infinitely triggering more builds |
| `host` | type: string, default: `github.com` |
| `enterprise` | Whether to use a GitHub Enterprise API style URL &mdash; type: boolean |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `GITHUB_` or `GIT_`.

For example, `token` can be given as 

* `GITHUB_TOKEN=<token>` or 
* `GIT_TOKEN=<token>`
## Interpolation variables

The following variables are available for interpolation on `commit_message`:

* `base_branch`
* `branch`
* `deploy_key`
* `email`
* `git_author_email`
* `git_author_name`
* `git_branch`
* `git_commit_author`
* `git_commit_msg`
* `git_sha`
* `git_tag`
* `host`
* `local_dir`
* `name`
* `repo`

Interpolation uses the syntax `%{variable-name}`. For example,
`"Current commit sha: %{git_sha}"` would result in a string with the
current Git sha embedded.

Furthermore, environment variables present in the current build
environment can be used through standard Bash variable interpolation.
For example: "Current build number: ${TRAVIS_BUILD_NUMBER}".
See [here](/user/environment-variables/#default-environment-variables)
for a list of default environment variables set.

{% include deploy/secrets.md name="token" env_name="GITHUB_TOKEN" %}