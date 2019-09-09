## Status

Support for deployments to Convox is in **development**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `host` | type: string, default: `console.convox.com` |
| `app` | **required**, type: string |
| `rack` | **required**, type: string |
| `password` | **required**, type: string |
| `install_url` | type: string, default: `https://convox.com/cli/linux/convox` |
| `update_cli` | type: boolean |
| `create` | type: boolean |
| `promote` | type: boolean, default: `true` |
| `env` | type: string or array of strings |
| `env_file` | type: string |
| `description` | type: string |
| `generation` | type: integer, default: `2` |

