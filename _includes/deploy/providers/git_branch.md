{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: git_branch
  token: <encrypted token>
  branch: <branch>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}

Alternatively, you can use `deploy_key`:

```yaml
deploy:
  provider: git_branch
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
| `remote` | Git remote &mdash; type: string |
| `pull_request` | Whether to create a pull request for the given branch &mdash; type: boolean |
| `url` | type: string, alias: `github_url`, default: `github.com` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `GITHUB_` or `GIT_`.

For example, `token` can be given as 

* `GITHUB_TOKEN=<token>` or 
* `GIT_TOKEN=<token>`
{% include deploy/secrets.md name="token" env_name="GITHUB_TOKEN" %}