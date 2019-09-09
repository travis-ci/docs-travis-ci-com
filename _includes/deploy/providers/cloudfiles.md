## Known options

Use the following options to further configure the deployment:

| `username` | Rackspace username &mdash; **required**, type: string |
| `api_key` | Rackspace API key &mdash; **required**, **secret**, type: string |
| `region` | Cloudfiles region &mdash; **required**, type: string, known values: `ord`, `dfw`, `syd`, `iad`, `hkg` |
| `container` | Name of the container that files will be uploaded to &mdash; **required**, type: string |
| `glob` | Paths to upload &mdash; type: string, default: `**/*` |
| `dot_match` | Upload hidden files starting a dot &mdash; type: boolean |

## Environment variables

All options can be given as environment variables if prefixed with `CLOUDFILES_`.

For example, `api_key` can be given as `CLOUDFILES_API_KEY=<api_key>`.

{% include deploy/secrets.md name="api_key" env_name="CLOUDFILES_API_KEY" %}