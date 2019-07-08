---
title: Beta - Migrating repositories to travis-ci.com
layout: en
redirect_from: user/open-source-repository-migration/
---

On May 2nd, 2018 Travis CI announced that open source projects will be [joining private projects on travis-ci.com](/user/open-source-on-travis-ci-com)!

This document explains how to migrate your repositories, and answers some common questions about the migration.

> Hi there! If you'd like to become a beta tester, send us an email to [support@travis-ci.com with the subject "Open Source Migration Beta Testing"](mailto:support@travis-ci.com?subject=Open%20Source%20Migration%20Beta%20Testing) - we'll be there to send you further details!

## What information will be transferred to travis-ci.com?

When a repository is migrated, the following information will be transferred to travis-ci.com:
* Environment variables (public and encrypted)
* Repository SSH keys (default or custom)
* Repository settings
* Cron jobs configured for the repository
* Last build status - the build badge in travis-ci.com will reflect this status until new builds are triggered
* Next build number

### What information will not be transferred to travis-ci.com?

The following information will not be transferred to travis-ci.com when a repository is migrated.

* Previous build history - your builds from before the migration to travis-ci.com will remain on travis-ci.org until the  complete build- history migration (sometime in Q2 2019)
* Caches - they will be re-created automatically on the first build on travis-ci.com

## Do I need to make any other changes?

You only need to make any changes yourself if you use any of the following features:

* **build badges**:  make sure to update the URL to reflect the new repository setup in travis-ci.com. In the future, we will automatically redirect travis-ci.org badge URLs to the corresponding travis-ci.com ones.

* **"Protected Branches" feature in GitHub** to require a passing Travis CI build before merging a Pull Request: make sure to edit your required status checks to now use `Travis CI - Pull Request` and/or `Travis CI - Branch`. See: [Required status checks at GitHub](https://help.github.com/articles/about-required-status-checks/).

* **[Travis CLI](https://github.com/travis-ci/travis.rb)**: after migration make sure to add the `--com` flag or [make it your default endpoint](https://github.com/travis-ci/travis.rb#endpoint) by running: `travis endpoint --com --set-default`.

* **[Travis CI API](https://developer.travis-ci.com/)**: edit your requests to use the new endpoint: `api.travis-ci.com` instead of `api.travis-ci.org`.

## What will happen to my travis-ci.org repository?

Your repository on travis-ci.org will be automatically deactivated (that is, it will no longer receive GitHub events) and will remain available in **read-only mode**.

With this read-only mode:

* All the previous build history will be accessible at travis-ci.org
* The "Trigger build" functionality won't be available in travis-ci.org
* It won't be possible to restart a previous job that ran in travis-ci.org
* The Settings page for your repository will become inactive - the transferred repository settings will now be available in travis-ci.com instead.

In the future, when all the previous build history is migrated, we will provide redirections from all API/web requests going to travis-ci.org to travis-ci.com.

## How long does the migration process take?

The migration process for a repository should not take more than a couple of seconds.

## Can I migrate multiple repositories at once?

Yes, you can select as many repositories in the Migrate tab as you'd like to migrate and they'll be queued to be migrated.

## What happens if someone pushes a commit to my repository while it is being migrated?

We'll enqueue these build requests and the builds will be created in travis-ci.com as soon as the migration finishes.

## Migrating a repository

### GitHub Apps initial setup

If you are already using GitHub Apps for your account in travis-ci.com, you need to access your installation settings and grant access to the repositories you'd like to migrate. Otherwise:

1. Log in to [https://travis-ci.com](https://travis-ci.com) and access your profile (or your organization's) at [https://travis-ci.com/profile](https://travis-ci.com/profile)

2. If you aren't using the new GitHub Apps integration already, activate it for your account
  ![Activate GitHub Apps](/user/images/oss-migration/gapps-activate.png)

3. When activating the Travis CI GitHub App, grant access to the repositories (both public and private) that you want to build in travis-ci.com. Save the changes.

4. Once back in your Travis CI profile, the selected repositories will be listed there. Those projects that were already building in travis-ci.com, or any new public or private projects will now be active in travis-ci.com.

### The migration steps

1. Once you have granted access via GitHub Apps to the repositories you'd like to build and transfer, a new ["Migrate" tab](https://travis-ci.com/account/migrate) will appear in your account page with a list of the repositories to migrate:
  ![Migration repository list](/user/images/oss-migration/repos-to-migrate.png)

2. Select the repositories you'd like to migrate and click "Migrate selected repositories",  You'll be asked for a final confirmation - please remember that your build history will not be migrated at this time (See: [What information will not be transferred to travis-ci.com?](#what-information-will-not-be-transferred-to-travis-cicom)).

3. Confirm the migration. The icons next to your repository name will show the migration status ("processing", or "migrated"):
  ![Migration statuses](/user/images/oss-migration/migration-statuses.png)

4. That's it! Your open source repository is now ready to build at travis-ci.com!

### Migrating repositories via API

If you'd like to automate your migration process, it's also possible to migrate a repository by directly making a request to the `/repo/:id/migrate` or `/repo/:slug/migrate` endpoints of the Travis CI API:

* Using the repository slug:

```bash
 curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token {API_TOKEN}" \
   --data '' \
   https://api.travis-ci.com/repo/{REPO_OWNER}%2F{REPO_NAME}/migrate
```

* Using the repository ID:

```bash
 curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token {API_TOKEN}" \
   --data '' \
   https://api.travis-ci.com/repo/{REPO_ID}/migrate
```

## Interacting with a migrated repository

Travis CI will now start receiving the GitHub events for migrated open source repository in travis-ci.com. Any new builds and requests will start appearing in the travis-ci.com site.

The project page of a migrated repository in travis-ci.com will start showing the following message:

  ![Note for migrated repository](/user/images/oss-migration/migrated-warning.png)

Then, when going back to travis-ci.org, the migrated repository will still appear in your repository list with a direct link to access the project in travis-ci.com:

![Migrated repository in travis-ci.org](/user/images/oss-migration/migrated-repo-org.png)

Since the repository in travis-ci.org is now in read-only mode, the settings page will also link to the corresponding settings page in travis-ci.com:

![Locked settings page in travis-ci.org](/user/images/oss-migration/locked-settings-org.png)

## Support and feedback

If you have any further questions or comments on our Beta migration process or need help, please let us know at [support@travis-ci.com](mailto:support@travis-ci.com?subject=Migration%20Beta%20Testing%20Feedback). We have a dedicated team working on this project that will be glad to assist you.
