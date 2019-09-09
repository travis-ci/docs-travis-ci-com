## Known options

Use the following options to further configure the deployment:

| `repo` | Repo slug &mdash; type: string, default: `repo slug` |
| `token` | GitHub oauth token with repo permission &mdash; **secret**, type: string, alias: `github_token` |
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
| `committer_from_gh` | Use the token's owner name and email for the commit &mdash; type: boolean, requires: `github_token` |
| `deployment_file` | Enable creation of a deployment-info file &mdash; type: boolean |
| `url` | type: string, alias: `github_url`, default: `github.com` |

## Environment variables

All options can be given as environment variables if prefixed with `GITHUB_` or `PAGES_`.

For example, `token` can be given as `GITHUB_TOKEN=<token>` or `PAGES_TOKEN=<token>`.

{% include deploy/secrets.md name="token" env_name="GITHUB_TOKEN" %}