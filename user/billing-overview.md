---
title: Billing Overview
layout: en
permalink: /user/billing-overview/

---

## Travis CI Plan types


Travis CI billing system consists of two types of subscriptions: Concurrency (fixed-price) based plans and Usage-based plans.
The variety of plans provides you with the flexibility to choose the plan that suits your needs.  


| Billing Period | Concurrency based (fixed-price) | Usage-based |
|:-------        |:-----------------:|:-----------:|
|Month           | Concurrent jobs limit<br />Unlimited build minutes on standard sized VMs Linux, Windows, and FreeBSD<br />Paid macOS builds (credits)<br />Paid premium VM size (credits). Contact sales for other options.<br /><br />Purchase in [Travis CI](https://app.travis-ci.com/account/plan). | Very high concurrency limit<br />Paid macOS, Linux, Windows, and FreeBSD build minutes (credits) on all VM types<br />Paid user licenses (only per unique users triggering the builds)<br /><br /> |
|Annual      | Available, same build rules as monthly. Purchase in [Travis CI](https://app.travis-ci.com/account/plan) or contact support.  | Very high concurrency limit<br />Paid macOS, Linux, Windows, and FreeBSD build minutes (credits)<br />Paid user licenses (only per unique users triggering the builds)<br /><br />Contact support for high volume annual usage-based plans. |


For most of users, a single concurrency-based plan should be sufficient. However, if you build a lot of minutes per month and concurrency becomes a bottleneck, please consider a Usage-based plan or contact Travis CI for more customized options.

### Free Trial Plan

A free 'Trial' Plan, which any new user can select upon sign up, is a usage-based plan with an unlimited amount of users, which comes with a pool of 10k trial credits (1k Linux build minutes) to start building right away. Once these credits run out, they are not replenished, and users must subscribe to a higher plan to continue building. Request [OSS Credits allowance](/user/billing-faq/#what-if-i-am-building-open-source), or please consider one of our available plans. Trial credits are valid only for 14 days.

Due to security reasons and an anti-abuse preventive measure, any new user will be asked to provide valid credit card details during the selection of the Free Trial Plan. Then, we will trigger an authorization transaction for $1.00 on the user’s card, which will be released back to the card owner after a few days. This action is meant only to validate legitimate users. Existing users are not affected by this procedure. 

> The Free Trial Plan is available only once and for new users only

## Definitions

*Build minute* - every build minute of a build job after the build job environment is started (queue time and spinning up the environment time are not deducting credits from the allowance).

*Unique user triggering the build* - every VCS (Version Control System) user, who's activity in VCS triggers a build in Travis CI via e.g. commit or pull request in the source repository. It does not have to be a user, who signed up to Travis CI - therefore it's important to review and adjust Travis CI Repository settings which VCS scenarios and users are allowed to trigger the build in Travis CI. Count of unique users triggering builds is tracked and reset every month, regardless if Usage-based plan is marked as monthly or annual. The same unique user triggering builds within a month is consuming user-license allowance only once in a given month.

*Build* - a build consists of at least 1 and up to *n* build jobs. Each build is triggered by an *unique user*.

*Build job* - a build job is where the build and test work happens. Build job is executed in an ephemeral environment (removed after single build job is finished) of a container or VM instance at Travis CI infrastructure. Build job duration is tracked and - if required - relevant cost covered from the credits pool.

## Concurrency based plans

Concurrency-based plans are similar to what Travis CI has been offering for a long time: the ability to run a build consisting of X concurrent jobs.

### Concurrency-based Plan - Summary

| Area                            | Details    |
| :---                            | ---        |
| **Payment**                     | The subscription is charged automatically in advance at the beginning of each billing period. <br /> The optional credits for macOS builds can be purchased anytime and only used when you need them. The charge is applied immediately upon transaction. The subscription price doesn't depend on the number of unique users running builds.|
| **Private/Public repositories** | You can build over both private and public repositories with a paid subscription. |
| **Build job limits**            | As per Plan |

### Concurrency Plan - How it works

In Travis CI, builds are executed singularly, without exceeding limitations. Therefore, if executing multiple builds simultaneously or executing a build with multiple build jobs, once the concurrency limit is reached, the reminder builds/jobs must wait until a queue capacity is available for processing.

> If a user on the 2 concurrent jobs plan executes a build with 5 build jobs, only the first 2 build jobs are processed while the remaining 3 of the build jobs wait in line to be processed.
>
> If a user/organization subscribes to the 5 concurrent jobs plan and executes 2 builds consisting of 5 jobs each, by default the second build will be sitting in the queue and its jobs waiting to be executed after at least 1 of the 5 build jobs of the first build are done.

Linux, Windows, and FreeBSD builds are included in the price of these plans. The macOS builds are paid separately on concurrency plans and can be run after purchasing the separate credits add-on.
Credits are used to pay for each build job minute on macOS. Purchase only the credits you need and use them until you run out. Please see more in the 'Usage based' section.

> If a user/organization on the 2 concurrent jobs Plan executes build with jobs for `os: linux` and `os: freebsd` it will execute as soon as the concurrency capacity is available for particular build jobs.
>
> If a user/organization on the same Plan tries to execute a job for `os: macOS` and has no credits available (see your [Plans](https://app.travis-ci.com/account/plan)), this build will not execute. In order to proceed, an add-on must be purchased, e.g., 25k credits. Now the build can be executed, and a pre-defined amount of [credits will be charged for each build minute of macOS build job](/user/billing-overview/#usage---credits).


### Concurrency Plan - How to obtain it?

1. Sign in to Travis CI with the [Version Control System of your choice](/user/tutorial/).
2. Navigate to the [Plan tab](https://app.travis-ci.com/account/plan) and select 'X concurrent jobs Plan'.
3. Enter your billing details. **Please note that all prices are provided netto, w/o any VAT or other applicable local taxes**. If you are EU based VAT paying company, do not forget to enter your VAT number.
4. Confirm the transaction.


## Usage-based plans

> **If you are running a large number of builds or users each month, please [contact Travis CI Customer Success](mailto:Customer.Success@travis-ci.com) if you’d like to discuss your plan.**

The Usage-based pricing system charges Travis CI users and Travis CI organizations depending on the number of minutes each builds jobs run on Travis CI infrastructure and unique users triggering builds.

### Usage-based Plan - Summary

| Area                            | Details    |
| :---                            | ---        |
| **Payment**                     | Credits are paid in advance:<BR />1. Upon purchasing a Plan, an immediate charge is applied depending on the credits allotment coming with a Plan.<BR />2. The additional credit addons, if available, can be purchased at any time, and credits are only used when you need them. The charge is applied immediately upon transaction.<BR /><BR />The user license cost exceeding pool included in the price is either covered using credits (Usage-based Plan with subscription) at the build request or charged automatically in arrears at the end of each billing period (Usage-based Plan w/o subscription). The number of unique users triggering a build is tracked and reset monthly.<br /><br />The Free Plan assigned upon sign-up grants you unlimited users for free. |
| **Private/Public repositories** | With Credits, you can build over both private and public repositories. <BR/> With OSS Credits, you can build only over public repositories. |
| **Build job limits**            | Very high. <BR/><BR/>The Free Plan assigned automatically upon sign-up has a limit of 20 concurrent jobs. The paid usage-based plans start from a 40 concurrent jobs limit. |

#### Credit costs associated with Usage-based Plans

1. User license cost: by default, credits per each unique user triggering a build or a specific rate charged in arrears at the end of month. See [Usage - user licenses](#usage---user-licenses) section for more details.
2. Build job duration costs: See [Usage - Credits](#usage---credits) for more details.
3. For Linux build job environments, additional resources are available as Premium VMs (extra CPU/RAM) on demand at a certain credit cost. See [VM Instance Sizes and Credit Cost](#vm-instance-sizes-and-credit-cost) for more details.
4. For a specific Linux build job environments, GPU builds are available on demand at a specific credit cost. See [GPU VM Instance Sizes and Credit Cost for GPU builds](#gpu-vm-instance-sizes-and-credit-cost-for-gpu-builds) for more details.

### Usage-based Plan - How to obtain?

1. Sign in to Travis CI with a [Version Control System of your choice](/user/tutorial/).
2. Navigate to the [Plans](https://app.travis-ci.com/account/plan) and have your billing and contact details filled in correctly.
3. Select an available Usage-based Plan or contact [Travis CI support](mailto:support@travis-ci.com) requesting a Usage-based Plan for larger options.


### Usage-based Plan - How it works

The Usage-based pricing is a model using credits. It may contain included user-license allowance and credit pool. Usage-based pricing features very high concurrent build jobs soft limits. In other words, users and organizations can run as many build jobs in Travis CI as they want simultaneously, meaning that all builds are executed as soon as possible. The final cost is flexible and closely related to the actual usage of the system, allowing you to downscale or upscale as per your needs.

All credit charges are deducted from a credit pool associated with an Usage-based plan assigned to Travis CI User or Organization, which is an 'owner' of a VCS repository enabled in Travis CI.

All unique user triggering build counting is tracked against an Usage-based plan assigned to Travis CI User or Organization, which is an 'owner' of a VCS repository enabled in Travis CI.

> The Usage-based pricing model bills based on minutes used (via credits) and the number of unique users trigerring those builds (via user licenses). Users subscribe to a plan that allocates a pool of credits to be used towards build minutes and pricing for a specific number of user licenses. The credits are deducted from the user's credit balance as they are used in the Travis CI service.
Unique users triggering builds within a billing period will constitute a number of actual user licenses used out of allowed pool. If the user-license pool is exceeded by new unique user triggering build, credits for this extra usage will be deducted from available credit pool.
In custom cases, instead of charge in credits, user licenses will be tracked within month and will be charged at the end of the billing period, according to the rates of their selected plan.

#### Plan Usage

Once the Usage-based plan is assigned to the Travis CI user or Travis CI Organization, which 'owns' repositories enabled at Travis CI, there will be a credits allowance present. Credits are immediately granted upon:

* the usage-based subscription´s payment (autobilling)
* manual purchase of a credits package
* auto-refilling credits (see [Auto-refill feature](/user/billing-autorefill/) feature description)

Usage-based plan may come with pre-purchased user-license allowance (expressed as number of users) and credits pool (expressed as number of credits). 

Every unique user triggering build within a month is consuming one user-license. Please see [Usage - user licenses](#usage---user-licenses) section for more details.

Every build job started on standard infrastructure is consuming credits. Exact cost rate depends on the type of build job and its duration. See See [Usage - Credits](#usage---credits), [VM Instance Sizes and Credit Cost](#vm-instance-sizes-and-credit-cost) and [GPU VM Instance Sizes and Credit Cost for GPU builds](#gpu-vm-instance-sizes-and-credit-cost-for-gpu-builds) for more details.

Triggering builds is only possible if a user has a positive credit balance. To get more credits, users can use the [Auto-refill feature](/user/billing-autorefill/) or change to a higher [credits plan](https://app.travis-ci.com/account/plan). If the user has credits after the plan´s renewal, these usually carry over to the new plan. For more information about your plan and validity dates, see the [Plan page](https://app.travis-ci.com/account/plan).


### Monthly Usage-based Plans

Monthly Usage-based plans are a subscription, granting specific credit pool each month and (optionally) user-license allowance included in the price. Once these allowances are depleted, the credits may be refilled via manual purchase of credits package or [auto-refilled](/user/billing-autorefill/) and spent on builds and additional user-licenes.

Consumed user-license count is reset each month.

If not stated or set otherwise, Monthly Usage-based plan is renewed automatically.

#### Selecting a Plan

Subscribe to one of our monthly plans to get your credits and continue building. Once you select a plan, your credits and your bill will be available at the start of the following month.

#### Canceling my Monthly Subscription

Users can cancel their current subscription anytime they like; simply use the Cancel Subscription button on the [Plan page](https://app.travis-ci.com/account/plan). Press the Cancel button to notify support of your desire to cancel your plan, and the Travis Support team will contact you soon with details regarding your cancellation.

Once users request cancellation, the remaining credits will be retained until the cancellation is confirmed. Your plan remains active until the end of the current billing cycle. Starting from the Cancellation Date, which can be found here: [Plan page](https://app.travis-ci.com/account/plan), users cannot purchase new credits unless rejoining a monthly or annual subscription. Users have one year after canceling the subscription to view or save build data; after one year of cancellation, build data is removed from Travis CI.

### Annual Usage-based Plans

Annual Usage-based plans are a subscription, granting specific credit pool each year and (optionally) user-license allowance per each month included in the price. Once these allowances are depleted, the credits may be refilled via manual purchase of credits package or [auto-refilled](/user/billing-autorefill/) and spent on builds and additional user-licenes.

Consumed user-license count is reset each month during the annual plan duration.

If not stated or set otherwise, Annual Usage-based plan is renewed automatically.


#### Selecting a Plan

Travis CI Users/Organizations who subscribe to an Annual Plan are granted the subscription´s amount of credits over 12 months. From the moment of subscription, users can use the credits however they see best, without monthly allotments or limits.

Users interested in Annual plans can select an annual plan on the [Plan page](https://app.travis-ci.com/account/plan).

> **All plans are available for Private and Open repositories in any VCS platform**
> **Please contact the [Travis sales team](mailto:sales@travis-ci.com) for larger plans.**

##### What if I ran out of credits before my annual contract elapses?

If users use up all their annual credits before the 12 months elapses, to get more credits, users either can keep auto-refilling their account or purchase additional credits allowance. If needed, please [contact Travis CI Customer Success](mailto:Customer.Success@travis-ci.com) to discuss details.


#### Canceling my Annual Subscription

Users on an Annual Plan must explicitly cancel their yearly subscription; otherwise, the plan renews automatically whenever the current cycle ends. Simply cancel your subscription using the Cancel Subscription button on the [Plan page](https://app.travis-ci.com/account/plan).

Upon cancellation, users have the remaining time of the contract plus one extra month to use the remaining credits; otherwise, any remaining credits expire. Users cannot purchase new credits unless rejoining a monthly or annual subscription. Users have one year after canceling the subscription to view or save build data; after one year of cancellation, build data is removed from Travis CI.


### Changing Plans

If you wish to switch from your monthly subscription to another plan with a different amount of credits, your new plan subscription will take effect at the start of the following month. And if you still run out of credits before the end of each month, try an annual plan, where you get a annual amount of credits for the price of 11 months.

### Usage - Credits

Credits are purchased at your discretion as an 'addon' (if available in your plan) or via the Auto-Refill option. The Plan you are on determines what selection addons are available for you. Credit addons are paid in advance.
Thus whenever you select or are assigned a Usage-based plan:

* Plan has the default allotment of credits associated (default Credits addon)
* Only advance charge is related to the allotment of credits available initially in the Plan, e.g. a plan coming with 25,000 credits will result in an immediate charge according to the enlisted price.
* If you have the Auto-Refill option enabled, whenever the overall balance of purchased credits drops down to a certain level, your account will be refilled with some portion of credits upon successful charge on your credit card; read more about it [here](/user/billing-autorefill/).

You can also purchase credits while on the Concurrency-based Plan. These are used only in scenarios that require credits to start a build job (e.g. building on macOS or using a non-standard VM instance size).

Credits are deducted from your balance each time a build job starts a VM instance or an LXD container and is running. Each started build job minute has a credit cost associated with the environment used, as shown in the table below. If your account runs out of credits, there's a slight margin of negative credits you are allowed to exceed in order to finish the job, but if that margin is passed - jobs will be canceled due to insufficient credits balance.

| OS                   | # Credits per<br />started build minute |
|:--------------------:|:-----------:|
| Partner Queue        | 0           |
| Linux                | 10          |
| Experimental FreeBSD | 10          |
| Windows              | 20          |
| macOS                | 50          |

Build job minutes are counted from the moment when [VM or LXD container](/user/reference/overview/#virtualization-environments) is spun up. Thus, queue waiting time or spinning-up time are not taken into account when calculating job duration time.

Your credits remain available until you use them or disband them. At the moment, unused paid credits expire after 12 months.
You may disband your credits. This happens when

* you switch from the Usage-based plan to a Free Plan (which cancels the paid Plan)

and is meant to prevent abusive usage of the system.

#### Partner Queue Solution

Partner Queue Solution is a solution for infrastructure sponsored by our Partners with OSS in mind, which can be used entirely for free. Currently, it includes:

- IBM CPU builds in IBM Cloud (sponsored by IBM)
- ARM64 CPU builds in Equinix Metal (former Packet) infrastructure (sponsored by ARM)

This is available only to Open Source Software repositories.

To run a job using Partner Queue Solution, use the following `.travis.yml` tags in your public repository:

```yaml
os: linux
arch:
  - arm64
  - ppc64le
  - s390x
```

Please see our [Build Environment overview](/user/reference/overview/) and [Building for Multiple CPU architectures](/user/multi-cpu-architectures/) pages for more details.

In order to start a build in the Usage-based Plan, a positive credits balance is required in the account (at least 1 credit). The build job under Partner Queue Solution costs 0 credits per started minute. At the moment of introducing Partner Queue Solution, active accounts on the Usage-based Plans, including the Free Plan, with a balance of zero or fewer credits, are updated to hold 1 credit. Thus everybody can use Partner Queues without requesting Travis CI support to grant additional credits. If you run into a negative account balance after that, you still need to file an additional request.

In the case of Concurrency-based Plans, you can use the above infrastructure for OSS builds without any credits in your account.

Partner Queues are available only for standard instance size.

#### Negative Credits

By design, the billing system usually allows the build job to finish even if the possible cost of the build job expressed in credits exceeds the available credits balance. Once the build finishes, you may notice your credit balance to be negative. **This is perfectly normal.** The negative balance will be deducted from the newly arriving credit pool whenever your credits get replenished, e.g. after purchasing an addon. What remains is your available credit balance for your builds.

Please note: Currently, if the system decides that the build could cause your negative balance to be too high, the job can be canceled mid-flight due to insufficient credits balance. This will be addressed in one of the incoming updates in order to allow fluent processing for your builds.


#### Credits vs. OSS Only Credits

Credits can be used to build both private and public repositories.

On occasion, an allotment of OSS Only credits may be granted by Travis CI. These credits may be used only for builds over public repositories and are meant for open-source support.
The OSS credits may be assigned as a one-time pool or renewable pool, subject to a case-by-case assessment of Travis CI staff.

The OSS credits are a separate pool of credits from regular credits, with separate credit balance tracking.


#### Free Plan Credits

Each new user who subscribes to the Free Trial Plan is automatically granted credits to use over a 14-day period. This one-time pool of credits is not renewable. This plan is meant to let you familiarize yourself with our usage-based plans as well as to try out other Travis CI features.



### Usage - User Licenses

User-licenses in Usage-based plans are consumed by [unique users triggering builds](#definitions) in a following order:

* any user-license allowance included in the price (if applicable)
* any discounted user-license allowance (if applicable)
* immediate charge in credits for user license or, in custom cases, adds to count of user licenses consumed within current month to be charged at the end of month

Count of unique users triggering a build is tracked and reset monthly. Unique users triggering a build are calculated as in following example:

> If person A triggers a build, and person B triggers a build, the billing system will recognize 2 unique users. Now, if person A or B again triggers a build, the amount of unique users triggering remains 2 (assuming builds are triggered within the same month). Only when user C triggers a build within the same month the number of unique users triggering a build will be increased to 3.
>
> By default, all users you've granted write rights to your repository are allowed to trigger a build. You may review Travis CI particular Repository page and manage which users are allowed to trigger the build in order to give you more control. 

#### Usage - User Licenses (Usage Plan with subscription)

Usage-based plan with subscription charges you immediately upon build start for the new unique user triggering build within a month.

Usage-based plans may have or may have not user-license allowance included in the price or available as a pool of user-licenses at a discounted credit cost.

##### Example 1: Credits, no user allowance included in price, user-license charge in credits, build with *n* build jobs

> If a build is triggered, the system will check if this is a new unique user triggering build. If yes, credit charge for user license will be immediately dedcuted from the available credit pool upon the build start.
> 
> The respective cost of build jobs execution in credits will be deducted from the available credit pool.

##### Example 2: Credits, user-license pool included in plan price, user-license charge in credits, build with *n* build jobs

> If a build is triggered, the system will check if this is a new unique user triggering build. If yes, system checks if consuming user-license exceeds user-license limit included:
> 
> no - no credit charge for user-license
> yes - credit charge for user license will be immediately deducted from the available credit pool upon the build start.
>
> The respective cost of build jobs execution in credits will be deducted from the available credit pool.

##### Example 3: Credits, pool of 3 discounted user-licenses included in the plan (e.g. *first 3 users for $XX*), user-license charge in credits, build with *n* build jobs

> Discounted user-license included in the plan means, in this example, that first three users cost e.g. 25K credits and after that each subsequent unique user triggering build costs $25k credits.
> 
> If a build is triggered, the system will check if this is a new unique user triggering build. If yes, system checks if consuming user-license exceeds pool of discounted user-license limit included in the plan:
> 
> no - if this is 1st user out of first 3 discounted, a charge of e.g. 25k credits is deducted upon build start. If this is 2nd or 3rd unique user within a month, no credits are deducted from credit pool.
> yes - full user-license credits charge is deducted from available credit pool upon build start.
> 
> The respective cost of build jobs execution in credits will be deducted from the available credit pool.




#### Usage - User Licenses (Usage Plan w/o subscription)

Usage-based plan w/o subscription charges you at the end of each month for the number of users who triggered the builds during this month.

With every build started, Travis CI keeps track of how many unique users triggered a build within a current billing period. At the end of the month, the total amount is used to calculate the user license charge.

##### Example 1: Credits, user-licenses counted within a month and charged at the end of period, build with *n* build jobs

> If a build is triggered, the system will check if this is a new unique user triggering build and if any potential included user-license allowance are exceeded:
> 
> no - count of consumed paid user-licenses is not increased
> yes - count of consumed paid user-licenses is increased
> 
> Depending on whether the plan is monthly or annual, respectively, there will be direct charge to credit card at the end of month or no more new unique users will be allowed to trigger builds this month.
> 
> The respective cost of build jobs execution in credits will be deducted from the available credit pool.


## VM Instance Sizes and Credit Cost

Usage and Concurrency based plans allow you to choose the instance size the build will run on (for the 'full vm' build job). Larger instance sizes deliver more resources (namely vCPU and RAM) for your build jobs. This can be done by setting a 'vm' property in the .travis.yml config. This property allows you to choose the Virtual machine instance for a build:
```yaml
vm:
  size: [large|x-large|2x-large]
```

Instance sizes do not apply to OSX build jobs. Our [CI Environment Overview page](/user/reference/overview/#vm-instance-size) describes the available VM sizes vs. operating system and CPU architecture.

To use instance sizes:

* you need to have credits under your account, regardless of the plan (Concurrency or Usage-based) you use.
* you need to add the tags mentioned above to your `.travis.yml`

VM size property impacts the cost of build minutes/credits usage in the following way:

| VM size              | Credits per<br />started build minute |
|:--------------------:|:-------------------------------------:|
| large                | 2 x usage credit cost of build minute |
| x-large              | 4 x usage credit cost of build minute |
| 2x-large             | 8 x usage credit cost of build minute |



> If you run a Linux build in usage model, it'll cost you 10 credits. If you run a Linux build under a concurrency plan, you do not need credits, as the subscription covers the cost. However, if you decide to run a Linux build using the `large` instance size, you will need, in both cases, 20 credits per every started build minutes (2 x 10 credits).


## GPU VM Instance Sizes and Credit Cost for GPU builds

Travis CI allows users to trigger GPU builds both in usage-based and concurrency-based plans.

GPU builds allow you to choose the instance size the build will run on (for the 'full vm' build job). X-large instance sizes deliver more resources (vCPU and RAM) for your build jobs. This can be done by setting a 'vm' property in the .travis.yml config. This property allows you to choose the Virtual machine instance for a build:

```yaml
vm:
 size: [gpu-medium | gpu-xlarge] #new values in the schema for existing key
```

Instance sizes do not apply to Windows, and OSX build jobs.  Visit our [CI Environment Overview page](/user/reference/overview/#gpu-vm-instance-size) for information on the available GPU VM sizes, operating system, and CPU architecture.

To use instance sizes:

* you need to have credits under your account, regardless of the plan (Concurrency or Usage-based) you use.
* you need to add the tags mentioned above to your `.travis.yml.`
* you need to select a Linux operating system in your `travis.yml.`

GPU VM size property impacts the cost of build minutes/credits usage in the following way:

| GPU VM size              | Credits per<br />started build minute |
|:--------------------:|:-------------------------------------:|
| T4 medium            | 230                                   |
| V100 x-large         | 890                                   |


> GPU Support is only available for:
> * arch: amd64
> * os: Linux
> * dist: [focal] # jammy to be added later, xenial EOL, bionic EOL.


## Getting Help

If you have any questions or issues with the new VCS, please see our [Billing FAQ](/user/billing-faq/) or email [support@travis-ci.com](mailto:support@travis-ci.com) for help.

We’d love to hear what you think of our new Pricing and if there’s something that you’d like to see included or improved! Let us know in the Travis CI Community Forum.
