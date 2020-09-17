---
title: Beta - Migrating repositories to travis-ci.com
layout: en
redirect_from: user/open-source-repository-migration/
---

On May 2nd, 2018 Travis CI announced that open source projects will be [joining private projects on travis-ci.com](/user/open-source-on-travis-ci-com)!

This document explains how to migrate your repositories, and answers some common questions about the migration.

> Hi there! If you'd like to become a beta tester, please sign in at [travis-ci.org] and in [your account page](https://travis-ci.org/account/repositories), sign up to migrate your Open Source repositories.


## What information will be transferred to travis-ci.com?

When a repository is migrated, the following information will be transferred to travis-ci.com:
* Environment variables (public and encrypted)
* Repository SSH keys (default or custom)
* Repository settings
* Cron jobs configured for the repository
* Last build status - the build badge in travis-ci.com will reflect this status until new builds are triggered
* Next build number
* Previous build history

### What information will not be transferred to travis-ci.com?

The following information will not be transferred to travis-ci.com when a repository is migrated:

* Caches - they will be re-created automatically on the first build on travis-ci.com

## Do I need to make any other changes?

You only need to make any changes yourself if you use any of the following features:

* **"Protected Branches" feature in GitHub** to require a passing Travis CI build before merging a Pull Request: make sure to edit your required status checks to now use `Travis CI - Pull Request` and/or `Travis CI - Branch`. See: [Required status checks at GitHub](https://help.github.com/articles/about-required-status-checks/).

* **[Travis CLI](https://github.com/travis-ci/travis.rb)**: after migration make sure to add the `--com` flag or [make it your default endpoint](https://github.com/travis-ci/travis.rb#endpoint) by running: `travis endpoint --com --set-default`.

* **[Travis CI API](https://developer.travis-ci.com/)**: edit your requests to use the new endpoint: `api.travis-ci.com` instead of `api.travis-ci.org`.

## What will happen to my travis-ci.org repository?

Your repository on travis-ci.org will be automatically deactivated (that is, it will no longer receive GitHub events) and will remain available in **read-only mode**.

With this read-only mode:

* The "Trigger build" functionality won't be available in travis-ci.org
* It won't be possible to restart a previous job that ran in travis-ci.org
* The Settings page for your repository will become inactive - the transferred repository settings will now be available in travis-ci.com instead.

In the future, we will provide redirections from all API/web requests going from travis-ci.org to travis-ci.com.

## How long does the migration process take?

The migration process for each repository should not take more than a couple of seconds.

## Can I migrate multiple repositories at once?

Yes, you can select as many repositories in the Migrate tab as you'd like to migrate and they'll be queued to be migrated.

## What happens if someone pushes a commit to my repository while it is being migrated?

We'll enqueue these build requests and the builds will be created in travis-ci.com as soon as the migration finishes.

## Does the migration require any changes in our `.travis.yml`?

No. Unless there was something very customised in your `.travis.yml`, no changes are required. 

> Please note: the experimental IBM Power CPU queue is not available on .com, one can use `arch: ppc64le` tag on travis-ci.com, which will run your [IBM build in LXD container](/user/multi-cpu-architectures/).

## Migrating a repository

### GitHub Apps initial setup

If you are already using GitHub Apps for your account in travis-ci.com, you need to access your installation settings and grant access to the repositories you'd like to migrate. Otherwise:

1. Log in to [https://travis-ci.com] and access your profile (or your organization's) at [https://travis-ci.com/profile](https://travis-ci.com/profile). For any doubts on the Travis CI GitHub Authorized OAuth App access rights message, please read more details [below](/user/migrate/open-source-repository-migration#travis-ci-github-oauth-app-access-rights).

2. If you aren't using the new GitHub Apps integration already, activate it for your account
  ![Activate GitHub Apps](/user/images/oss-migration/gapps-activate.png)

3. When activating the Travis CI GitHub App, grant access to the repositories (both public and private) that you want to build in travis-ci.com. Save the changes.

4. Once back in your Travis CI profile, the selected repositories will be listed there. Those projects that were already building in travis-ci.org will appear in the Migrate tab for your account.

#### Travis CI GitHub OAuth App access rights

{{ site.data.snippets.github_oauth_access_rights }}

### The migration steps

1. Once you have granted access via GitHub Apps to the repositories you'd like to build and transfer, on the ["Migrate" tab](https://travis-ci.com/account/migrate), there will be a list of the repositories available to migrate:
  ![Migration repository list](/user/images/oss-migration/repos-to-migrate.png)

2. Select the repositories you'd like to migrate and click "Migrate selected repositories",  You'll be asked for a final confirmation - please remember that you'll need to update protected branches (See: [Do I need to make any other changes?](#do-i-need-to-make-any-other-changes)).

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

The project page of a migrated repository in travis-ci.org will start showing that it has been migrated and then, the migrated repository will still appear in your repository list with a direct link to access the project in travis-ci.com:

![Migrated repository in travis-ci.org](/user/images/oss-migration/migrated-repo-org.png)

Since the repository in travis-ci.org is now in read-only mode, the settings page will also link to the corresponding settings page in travis-ci.com:

![Locked settings page in travis-ci.org](/user/images/oss-migration/locked-settings-org.png)

## Migrating within a "Grouped Account"

> Please note: Grouping accounts, very rarely done, was set only manually by Travis CI staff and was subject to assesment every time. This section concerns only a handful of accounts in Travis CI as only a couple of tens accounts were set that way in the past.

If your account happens to be grouped with other accounts in the so called 'grouped account' setup, migrating your repositories from travis-ci.org to travis-ci.com and preserving this unique configuration requires Travis CI staff support.


### How do I recognize I am part of a grouped account?

You are part of a grouped account if:
* At least 2 Version Control System (VCS) accounts utilize a common concurrency pool, e.g. two concurrent GitHub accounts utilize common concurrency pool.
* Your total available concurrency exceeds the limit number of concurrent jobs available for free builds for a single account.
* Optionally: if someone in your team confirms that you are part of a specific customised grouped account configuration in Travis CI.

All of above must be satisfied at the same time. If you only notice increased concurrency limit, that may be a subject to separate configuration and you are welcomed to contact with [our support team](/user/migrate/open-source-repository-migration#support-and-feedback) to clarify details before you migrate your repositories.

### How do I progress with the migration?

If your account is part of a grouped account and you will migrate just repositories on single account, then you will loose access to the combined concurrency pool. Therefore, all accounts must migrate their repositories to travis-ci.com and once done, Travis CI Staff can re-create the configuration for you in travis-ci.com. 

A whole migration can be done in seconds. Re-creating a grouped account configuration on travis-ci.com should complete within a couple of hours, depending on the Travis CI staff workload.

The following steps are meant to clarify the process:

#### Preparing

Organize & let us know ahead!

* Reach out to your collaborative group and establish, when to migrate the repositories to travis-ci.com; make sure all partaking account owners express their consent for the move and can inform contributors on the plan to migrate to travis-ci.com.
* Report to the Travis CI Support team to confirm that you are part of a `Grouped Account` on travis-ci.org, at best providing a list of other partakers with up-to-date contacts to decision makers (and a GitHub ticket, if you have opened one on your account for that action) - contact us via our Slack #embassy channel or to our [email address](/user/migrate/open-source-repository-migration#support-and-feedback), and we will internally create a ticket for that request.
* Travis CI Support will verify the configuration (which accounts belong to the group) and, reach out to the partaking account owners in order to confirm that the migration of repositories for every partaking account is executed or planned to be executed.


#### Migrating and re-creating configuration

* Every account partaking in a `Grouped Account` configuration must migrate their repositories to travis-ci.com following this [migration steps](/user/migrate/open-source-repository-migration#migrating-a-repository).
    * At least one repository migrated to travis-ci.com is required, however given you will need to use the travis-ci.com app, we recommend to move all repositories at once.
* Once all partaking accounts have migrated their repositories to travis-ci.com, **reach out to Travis CI Staff** confirming readiness to re-create the configuration on travis-ci.com (all partaking accounts migrated their repositories).
* Travis CI Staff re-creates your `Grouped Accounts` configuration and answers on the request.

The whole process takes a couple of hours.


## Support and feedback

If you have any further questions, comments or need help on our Beta migration process, please let us know at [support@travis-ci.com](mailto:support@travis-ci.com?subject=Migration%20Beta%20Testing%20Feedback). We have a dedicated team working on this project that will be glad to assist you.


[travis-ci.com]: https://www.travis-ci.com
[travis-ci.org]: https://www.travis-ci.org
