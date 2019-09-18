{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: gcs
  key_file: <key_file>
  bucket: <bucket>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}

Alternatively, you can use `access_key_id` and `secret_access_key`:

```yaml
deploy:
  provider: gcs
  access_key_id: <encrypted access_key_id>
  secret_access_key: <encrypted secret_access_key>
  bucket: <bucket>
```
{: data-file=".travis.yml"}


{{ include.content }}
{% endunless %}

## Status

Support for deployments to Google Cloud Store is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment. Either `key_file` or `access_key_id` and `secret_access_key` are required.

| `key_file` | Path to a GCS service account key JSON file &mdash; type: string |
| `access_key_id` | GCS Interoperable Access Key ID &mdash; **secret**, type: string |
| `secret_access_key` | GCS Interoperable Access Secret &mdash; **secret**, type: string |
| `bucket` | GCS Bucket &mdash; **required**, type: string |
| `local_dir` | Local directory to upload from &mdash; type: string, default: `.` |
| `upload_dir` | GCS directory to upload to &mdash; type: string |
| `dot_match` | Upload hidden files starting with a dot &mdash; type: boolean |
| `acl` | Access control to set for uploaded objects &mdash; type: string, default: `private`, known values: `private`, `public-read`, `public-read-write`, `authenticated-read`, `bucket-owner-read`, `bucket-owner-full-control`, see: [https://cloud.google.com/storage/docs/reference-headers#xgoogacl](https://cloud.google.com/storage/docs/reference-headers#xgoogacl) |
| `detect_encoding` | HTTP header Content-Encoding to set for files compressed with gzip and compress utilities. &mdash; type: boolean |
| `cache_control` | HTTP header Cache-Control to suggest that the browser cache the file. &mdash; type: string, see: [https://cloud.google.com/storage/docs/xml-api/reference-headers#cachecontrol](https://cloud.google.com/storage/docs/xml-api/reference-headers#cachecontrol) |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `GCS_`.

For example, `access_key_id` can be given as `GCS_ACCESS_KEY_ID=<access_key_id>`.
{% include deploy/secrets.md name="access_key_id" env_name="GCS_ACCESS_KEY_ID" %}