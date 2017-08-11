---
title: Atlas deployment
layout: en

---

Travis CI can automatically deploy your application to [Atlas](https://atlas.hashicorp.com/) after a successful build.

To deploy your application to Atlas:

1. Sign in to your Atlas account.
2. [Generate](https://atlas.hashicorp.com/settings/tokens) an Atlas API token for for Travis CI.
3. Add the following minimum configuration to your `.travis.yml`

   ```yaml
   deploy:
     provider: atlas
     token: "YOUR ATLAS API TOKEN"
     app: "YOUR ATLAS USERNAME/YOUR ATLAS APP NAME"
   ```

## Including or Excluding Files

You can include and exclude files by adding the `include` and `exclude` entries to `.travis.yml`. Both are glob patterns of files or directories to include or exclude, and may be specified multiple times. If there is a conflict, excludes have precedence over includes.

```yaml
deploy:
  provider: atlas
  exclude: "*.log"
  include:
   - "build/*"
   - "bin/*"
```

### Using your Version Control System

Get the lists of files to exclude and include from your version control system (Git, Mercurial or Subversion):

```yaml
deploy:
  provider: atlas
  vcs: true
```

## Other Deployment Options

### Specifying the Address of the Atlas Server:

```yaml
deploy:
   provider: atlas
   address: "URL OF THE ATLAS SERVER"
```

### Adding Custom Metadata

Add one or more items of metadata:

```yaml
deploy:
  provider: atlas
  metadata:
    - "custom_name=Jane"
    - "custom_surname=Doe"
```

{{ site.data.snippets.conditional_deploy }}

{{ site.data.snippets.before_and_after }}
