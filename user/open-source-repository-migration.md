---
title: Beta - Migrating your open source repositories to travis-ci.com
layout: en
---

> Hi there! If you'd like to be part of this beta testing process, send us an email to support@travis-ci.com with the subject "Open Source Beta Testing Migration" - we'll be glad to send you further details!

## Details and questions

### Which information will be transferred to travis-ci.com?

When a repository is migrated, the following information will be transferred to travis-ci.com:
* Environment variables (public and encrypted)
* Repository SSH keys (default or custom)
* Repository settings
* Last build status - the build badge in travis-ci.com will reflect this status until new builds are triggered
* Next build number

At this early stage of the beta testing process, it isn't yet possible to migrate [cron jobs](https://docs.travis-ci.com/user/cron-jobs/). We are working to make this available as soon as possible.

#### Which information will not be transferred to travis-ci.com?

The following information will not be transferred to travis-ci.com when a repository is migrated.

* Cron jobs configured for the repository
* Build history - it will be migrated at a later time
* Caches - they will be re-created automatically on the first build on travis-ci.com

### Are there any manual changes required?

* If you're including **build badges** in your repository, you will need to update the URL to reflect the new repository setup in travis-ci.com.

* If you're using the **"Protected Branches" feature in GitHub** to require your Travis CI to pass before merging a Pull Request, you will need to update these settings to require the new GitHub Checks events instead of the old Commit Statuses that travis-ci.org was sending to your project. See: [Required status checks at GitHub](https://help.github.com/articles/about-required-status-checks/).

* If you use the **Travis CLI or the Travis CI API**, you will need to make sure your requests are addressed to the correct endpoint (`api.travis-ci.com` instead of `api.travis-ci.org`).

### What will happen to my travis-ci.org repository?

Your repository in travis-ci.org will be automatically deactivated (this is, it will no longer receive GitHub events) and will remain available in **read-only mode**.

With this read-only mode:
* All the previous build history will be accessible at travis-ci.org
* The "Trigger build" functionality won't be available in travis-ci.org
* It won't be possible to restart a previous job that ran in travis-ci.org
* The Settings page for your repository will become inactive - the transferred repository settings will now be available in travis-ci.com instead.

In the future, when all the previous build history is migrated, we will provide redirections from all API/web requests going to travis-ci.org to travis-ci.com.

### How long does the migration process take?

The migration process should not take more than a couple seconds.

### Can I migrate multiple repositories at once?

At the moment, it's only possible to trigger migrations on repositories one by one. We'll add this bulk-migration feature in future stages.

## What happens if someone pushes a commit to my repository while it is being migrated?

We'll enqueue these build requests and the builds will be created in travis-ci.com as soon as the migration finishes.

## Migrating a repository

### GitHub Apps initial setup

If you are already using GitHub Apps for your account in travis-ci.com, you need to access your installation settings and grant access to the repositories you'd like to migrate. Otherwise:

1. Log in to https://travis-ci.com and access your profile (or your organization's) at https://travis-ci.com/profile
2. If you aren't using the new GitHub Apps integration already, activate it for your account

  ![Activate GitHub Apps](/user/images/oss-migration/gapps-activate.png)

3. When activating the Travis CI GitHub App, grant access to the repositories (both public and private) that you want to build in travis-ci.com. Save the changes.
4. Once back in your Travis CI profile, the selected repositories will be listed there. Those projects that were already building in travis-ci.com, or any new public or private projects will now be active in travis-ci.com.

### The migration steps
1. Once you have granted access via GitHub Apps to the repositories you'd like to build and transfer, a new "Migrate" button will appear in your repository list:

  ![Migration repository list](/user/images/oss-migration/repos-to-migrate.png)

2. Click "Migrate" for the repository you'd like to migrate. You'll be asked for a final confirmation - please remember that your build history will not be migrated at this time (See: [Which information will not be transferred to travis-ci.com?](#which-information-will-not-be-transferred-to-travis-cicom)).
3. Confirm the migration. The icons next to your repository name will show the migration status ("processing", or "migrated"):

  ![Migration statuses](/user/images/oss-migration/migration-statuses.png)

4. That's it! Your open source repository has been migrated to travis-ci.com!

## Interacting with a migrated repository

Travis CI will now start receiving the GitHub events for migrated open source repository in travis-ci.com. Any new builds and requests will start appearing in the travis-ci.com site.

The project page of a migrated repository in travis-ci.com will start showing the following message:

  ![Note for migrated repository](/user/images/oss-migration/migrated-warning.png)

Then, when going back to travis-ci.org, the migrated repository will still appear in your repository list with a direct link to access the project in travis-ci.com:

  ![Migrated repository in travis-ci.org](/user/images/oss-migration/migrated-repo-org.png)

Since the repository in travis-ci.org is now in read-only mode, the settings page will also link to the corresponding settings page in travis-ci.com:

  ![Locked settings page in travis-ci.org](/user/images/oss-migration/locked-settings-org.png)

## Support and feedback

If you have any further questions or comments on our Beta migration process or need help, please let us know at support@travis-ci.com. We have a dedicated team working on this project that will be glad to assist you.
