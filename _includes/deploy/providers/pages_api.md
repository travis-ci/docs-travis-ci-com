## Status

Support for deployments to GitHub Pages (API) is in **development**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `repo` | GitHub repo slug &mdash; type: string, default: `repo slug` |
| `token` | GitHub oauth token with repo permission &mdash; **required**, **secret**, type: string, alias: `github_token` |

## Environment variables

All options can be given as environment variables if prefixed with `GITHUB_` or `PAGES_`.

For example, `token` can be given as `GITHUB_TOKEN=<token>` or `PAGES_TOKEN=<token>`.

{% include deploy/secrets.md name="token" env_name="GITHUB_TOKEN" %}