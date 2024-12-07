{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: pages:git
  token: <encrypted token>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}

Alternatively, you can use `deploy_key`:

```yaml
deploy:
  provider: pages:git
  deploy_key: <deploy_key>
```
{: data-file=".travis.yml"}


{{ include.content }}
{% endunless %}

## Status

Support for deployments to GitHub Pages is *stable**.
## Known options

Use the following options to further configure the deployment. Either `token` or `deploy_key` are required.

| `repo` | Repo slug &mdash; type: string, default: `repo slug` |
| `token` | GitHub token with repo permission &mdash; **secret**, type: string, alias: `github_token` |
| `deploy_key` | Path to a file containing a private deploy key with write access to the repository &mdash; type: string, see: [https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys](https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys) |
| `target_branch` | Branch to push force to &mdash; type: string, default: `gh-pages` |
| `keep_history` | Create incremental commit instead of doing push force &mdash; type: boolean, default: `true` |
| `commit_message` | type: string, default: `Deploy %{project_name} to %{url}:%{target_branch}` |
| `allow_empty_commit` | Allow an empty commit to be created &mdash; type: boolean, requires: `keep_history` |
| `verbose` | Be verbose about the deploy process &mdash; type: boolean |
| `local_dir` | Directory to push to GitHub Pages &mdash; type: string, default: `.` |
| `fqdn` | Write the given domain name to the CNAME file &mdash; type: string |
| `project_name` | Used in the commit message only (defaults to fqdn or the current repo slug) &mdash; type: string |
| `name` | Committer name &mdash; type: string, note: defaults to the current git commit author name |
| `email` | Committer email &mdash; type: string, note: defaults to the current git commit author email |
| `committer_from_gh` | Use the token's owner name and email for the commit &mdash; type: boolean, requires: `token` |
| `deployment_file` | Enable creation of a deployment-info file &mdash; type: boolean |
| `url` | type: string, alias: `github_url`, default: `github.com` |

### Shared options

| `strategy` | GitHub Pages deployment strategy &mdash; type: string, default: `git`, known values: `api`, `git` |
| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `GITHUB_` or `PAGES_`.

For example, `token` can be given as 

* `GITHUB_TOKEN=<token>` or 
* `PAGES_TOKEN=<token>`
## Interpolation variables

The following variables are available for interpolation on `commit_message`:

* `deploy_key`
* `email`
* `fqdn`
* `git_author_email`
* `git_author_name`
* `git_branch`
* `git_commit_author`
* `git_commit_msg`
* `git_sha`
* `git_tag`
* `local_dir`
* `name`
* `project_name`
* `repo`
* `target_branch`
* `url`

Interpolation uses the syntax `%{variable-name}`. For example,
`"Current commit sha: %{git_sha}"` would result in a string with the
current Git sha embedded.

Furthermore, environment variables present in the current build
environment can be used through standard Bash variable interpolation.
For example: "Current build number: ${TRAVIS_BUILD_NUMBER}".
See [here](/user/environment-variables/#default-environment-variables)
for a list of default environment variables set.

{% include deploy/secrets.md name="token" env_name="GITHUB_TOKEN" %}