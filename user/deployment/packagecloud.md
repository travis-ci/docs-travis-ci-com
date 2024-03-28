---
title: packagecloud Deployment
layout: en
deploy: v1

---

Travis CI can automatically push your RPM, Deb, Deb source, or RubyGem package build
artifacts to [packagecloud.io](https://packagecloud.io/) after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```yaml
deploy:
  provider: packagecloud
  repository: "YOUR REPO"
  username: "YOUR USERNAME"
  token: "YOUR TOKEN"
  dist: "YOUR DIST" # like 'ubuntu/precise', or 'centos/5', if pushing deb or rpms
```
{: data-file=".travis.yml"}

Take note that your repository name should not have a forward slash in it. For example if your repository appears as `username / repo` on packagecloud.io, you should only put `repo` in the `repository:` option and put `username` in the `username:` option.

You can retrieve your api token by logging in and visiting the [API Token](https://packagecloud.io/api_token) page under Account Settings.

This is the list of [supported distributions](https://packagecloud.io/docs#os_distro_version) for the 'dist' option.

It is recommended to encrypt your auth token. Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
travis encrypt THE-API-TOKEN --add deploy.token
```

You can also have the `travis` tool set up everything for you:

```bash
travis setup packagecloud
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to release from

You can explicitly specify the branch to release from with the **on** option:

```yaml
deploy:
  provider: packagecloud
  on:
    branch: production
  # ⋮
```
{: data-file=".travis.yml"}

Alternatively, you can also configure Travis CI to release from all branches:

```yaml
deploy:
  provider: packagecloud
  on:
    all_branches: true
  # ⋮
```
{: data-file=".travis.yml"}

By default, Travis CI will only release from the **master** branch.

Builds triggered from Pull Requests will never trigger a release.

### Releasing build artifacts

After your tests ran and before the release, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts that are supposed to be released, too. There is now an option to skip the clean up:

```yaml
deploy:
  provider: packagecloud
  skip_cleanup: true
  # ⋮
```
{: data-file=".travis.yml"}

### Specify package folder

By default, the packagecloud provider will scan the current directory and push all supported packages.
You can specify which directory to scan from with the `local-dir` option. This example scans from `build` directory of your project.

```yaml
deploy:
  provider: packagecloud
  local-dir: build
  # ⋮
```
{: data-file=".travis.yml"}

Alternately, you may wish to specify the `package_glob` argument to restrict which files to scan. It defaults to `**/*` (recursively finding all package files) but this may pick up other artifacts you don't want to release. For example, if you only want to push gems in the top level directory:

```yaml
deploy:
  provider: packagecloud
  package_glob: "*.gem"
  # ⋮
```
{: data-file=".travis.yml"}

### A note about Debian source packages

If the packagecloud provider finds any `.dsc` files, it will scan it and try to locate it's contents within
the `local-dir` directory. Ensure the source package and it's contents are output to the same directory for it to work.

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#conditional-releases-with-on).

### Running commands before and after release

Sometimes you want to run commands before or after releasing a package. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  # ⋮
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}
