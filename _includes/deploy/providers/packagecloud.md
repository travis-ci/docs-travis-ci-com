## Known options

Use the following options to further configure the deployment:

| `username` | The packagecloud.io username. &mdash; **required**, type: string |
| `token` | The packagecloud.io api token. &mdash; **required**, **secret**, type: string |
| `repository` | The repository to push to. &mdash; **required**, type: string |
| `local_dir` | The sub-directory of the built assets for deployment. &mdash; type: string, default: `.` |
| `dist` | Required for debian, rpm, and node.js packages (use "node" for node.js packages). The complete list of supported strings can be found on the packagecloud.io docs. &mdash; type: string |
| `force` | Whether package has to be (re)uploaded / deleted before upload &mdash; type: boolean |
| `connect_timeout` | type: integer, default: `60` |
| `read_timeout` | type: integer, default: `60` |
| `write_timeout` | type: integer, default: `180` |
| `package_glob` | type: string or array of strings, default: `["**/*"]` |

## Environment variables

All options can be given as environment variables if prefixed with `PACKAGECLOUD_`.

For example, `token` can be given as `PACKAGECLOUD_TOKEN=<token>`.

{% include deploy/secrets.md name="token" env_name="PACKAGECLOUD_TOKEN" %}