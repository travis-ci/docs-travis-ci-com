## Status

Support for deployments to GitHub Releases is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `token` | GitHub oauth token (needs public_repo or repo permission) &mdash; **secret**, type: string, alias: `api_key` |
| `username` | GitHub login name &mdash; type: string, alias: `user` |
| `password` | GitHub password &mdash; **secret**, type: string |
| `repo` | GitHub repo slug &mdash; type: string, default: `repo slug` |
| `file` | File or glob to release to GitHub &mdash; type: string or array of strings, default: `*` |
| `file_glob` | Interpret files as globs &mdash; type: boolean, default: `true` |
| `overwrite` | Overwrite files with the same name &mdash; type: boolean |
| `prerelease` | Identify the release as a prerelease &mdash; type: boolean |
| `release_number` | Release number (overide automatic release detection) &mdash; type: string |
| `release_notes` | Content for the release notes &mdash; type: string, alias: `body` |
| `release_notes_file` | Path to a file containing the release notes &mdash; type: string, note: will be ignored if --release_notes is given |
| `draft` | Identify the release as a draft &mdash; type: boolean |
| `tag_name` | Git tag from which to create the release &mdash; type: string |
| `target_commitish` | Commitish value that determines where the Git tag is created from &mdash; type: string |
| `name` | Name for the release &mdash; type: string |

## Environment variables

All options can be given as environment variables if prefixed with `GITHUB_` or `RELEASES_`.

For example, `token` can be given as `GITHUB_TOKEN=<token>` or `RELEASES_TOKEN=<token>`.

{% include deploy/secrets.md name="token" env_name="GITHUB_TOKEN" %}