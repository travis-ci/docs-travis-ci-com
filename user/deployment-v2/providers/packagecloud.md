---
title: packagecloud Deployment
layout: en
deploy: v2
provider: packagecloud
---

Travis CI can automatically push your RPM, Deb, Deb source, or RubyGem package build
artifacts to [packagecloud.io](https://packagecloud.io/) after a successful build.

{% capture content %}
 >  Note that your repository name should not have a forward slash in it: For
  example if your repository appears as `username/repo` on packagecloud.io, the
  `repository` option is `repo` and the `username` option is `username`.

  You can retrieve your api token by logging in and visiting the [API Token](https://packagecloud.io/api_token)
  page under Account Settings.

  Additionally, for Debian, RPM, and Node.js packages the `dist` option is required:

  ```yaml
  deploy:
    provider: packagecloud
    # ⋮
    dist: <dist> # required for , e.g. 'centos/5'
  ```
  {: data-file=".travis.yml"}

  The list of supported distributions for the `dist` option can be found
  [here](https://packagecloud.io/docs#os_distro_version).
{% endcapture %}

{% include deploy/providers/packagecloud.md content=content %}

### Specifying a package folder

By default, the packagecloud provider will scan the current directory and push
all supported packages.

You can specify which directory to scan from with the `local_dir` option. This
example scans from `./build` directory.

```yaml
deploy:
  provider: packagecloud
  # ⋮
  local_dir: build
```
{: data-file=".travis.yml"}

Alternately, you can specify the `package_glob` argument to restrict
which files to scan. It defaults to `**/*` (recursively finding all package
files) but this may pick up other artifacts you don't want to release.

For example, if you only want to push gems in the top level directory:

```yaml
deploy:
  provider: packagecloud
  # ⋮
  package_glob: "*.gem"
```
{: data-file=".travis.yml"}

### A note about Debian source packages

If the packagecloud provider finds any `.dsc` files, it will scan it and try to
locate it's contents within the `local_dir` directory. Ensure the source
package and it's contents are output to the same directory for it to work.

{% include deploy/shared.md %}
