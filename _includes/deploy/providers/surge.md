## Known options

Use the following options to further configure the deployment:

| `login` | Surge login (the email address you use with Surge) &mdash; **required**, type: string |
| `token` | Surge login token (can be retrieved with `surge token`) &mdash; **required**, **secret**, type: string |
| `domain` | Domain to publish to. Not required if the domain is set in the CNAME file in the project folder. &mdash; type: string |
| `project` | Path to project directory relative to repo root &mdash; type: string, default: `.` |

## Environment variables

All options can be given as environment variables if prefixed with `SURGE_`.

For example, `token` can be given as `SURGE_TOKEN=<token>`.

{% include deploy/secrets.md name="token" env_name="SURGE_TOKEN" %}