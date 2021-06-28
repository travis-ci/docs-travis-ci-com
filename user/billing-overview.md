---
title: Billing Overview
layout: en
permalink: /user/billing-overview/

---

> A new billing engine was introduced on November 1st, 2020 to [https://travis-ci.com](https://travis-ci.com) 

## Travis CI Plan types


Travis CI billing system consists of two types of subscriptions: Concurrent based plans and Usage based plans.
The variety of plans provides you with the flexibility to choose the plan that suits your needs.  


| Billing Period | Concurrency based | Usage based |
|:-------        |:-----------------:|:-----------:|
|Month           | Concurrent jobs limit<br />Unlimited build minutes on Linux, Windows, and FreeBSD<br />Paid macOS builds (credits)<br /><br />Available via [site](https://travis-ci.com/account/plan) | Very high concurrency limit<br />Paid macOS, Linux, Windows, and FreeBSD build minutes (credits)<br />Paid user licenses (only per users triggering the builds)<br /><br />Contact Travis CI to obtain|

For the majority of users, a single concurrency based plan should be sufficient. However, if you build a lot of minutes per month and concurrency becomes a bottleneck, please contact Travis CI asking for a Usage based plan.

### Free Plan

A 'Free' Plan, assigned automatically to every new sign up, is a Usage based plan with an unllimited amount of users which comes with a trial pool of credits to be used. Once these credits are used they are not replenished. Request [OSS Credits allowance](/user/billing-faq/#what-if-i-am-building-open-source) or please consider one of our available plans.


## Concurrency based plans

Concurrency based plans are much like what Travis CI has been offering already for a long time: an ability to run a build consisting of X concurrent jobs. 
In Travis CI builds are executed singularly, without exceeding limitations. Therefore, if executing multiple builds at the same time or executing a build with multiple build jobs, once the concurrency limit is reached, the reminder builds/jobs must wait until there is a queue capacity available for processing. 

> If a user on the 2 concurrent jobs plan executes a build with 5 build jobs, only the first 2 builds are processed while the remaining 3 of the builds wait in line to be processed.  
>
> If a user/organization subscribes to the 5 concurrent jobs plan and executes 2 builds consisting of 5 jobs each, the second build will be sitting in the queue and waiting to be executed after the 5 jobs of the first build are done.

Linux, Windows, and FreeBSD builds are included in the price of these plans. The macOS builds are paid separately on concurrency plans and can be run after purchasing the separate credits add-on. 
Credits are used to pay for each build job minute on macOS. Purchase only the credits you need and use them until you run out. Please see more in the 'Usage based' section.

> If a user/organization on the 2 concurrent jobs Plan executes build with jobs for `os: linux` and `os: freebsd` it will execute as soon as the concurrency capacity is available for particular build jobs.
>
> If a user/organization on the same Plan tries to execute a job for `os: macOS` and has no credits available (see your [Plans](https://travis-ci.com/account/plan)), this build will not execute. In order to proceed, an add-on must be purchased, e.g. 25k credits. Now the build can be executed and a pre-defined amount of [credits will be charged for each build minute](/user/billing-overview/#usage---credits). 


### Concurrency based Plan - Summary

| Area                            | Details    |
| :---                            | ---        |
| **Payment**                     | The subscription is charged automatically in advance, at the beginning of each billing period. <br /> The optional credits for macOS builds can be purchased at any time and used only when you need them. The charge is applied immediately upon transaction. The price of the subscription doesn't depend on the number of unique users running builds.|
| **Private/Public repositories** | With a paid subscription you can build over both private and public repositories. |
| **Build job limits**            | As per Plan |


### Concurrency Plan - How to obtain?

1. Sign in to Travis CI with [Version Control System of your choice](/user/tutorial/).
2. Navigate to the [Plans](https://travis-ci.com/account/plan) and select of of 'X concurrent jobs Plan'. 
3. Enter your billing details. **Please note, that all prices are provided netto, w/o any VAT or other applicable local taxes**. If you are EU based VAT paying company, do not forget to enter your VAT number.
4. Confirm transaction.


## Usage based plans

> **If you are running a large number of builds or users each month, please [contact Travis CI support](mailto:support@travis-ci.com) if you’d like to discuss your plan.** 

The Usage based pricing system charges users and organizations depending on the number of minutes each of the build jobs run on Travis CI infrastructure. 
The Usage based pricing is a pre-paid model for credits and subscriptions for per-user-license. In other words, users and organizations can run as many build jobs as they want at the same time, meaning that all builds are executed as soon as possible without limitations.  
The final cost is flexible and closely related to the actual usage of the system, allowing you to downscale or upscale as per your needs.

> The Usage based pricing model bills based on minutes used (via credits) and the number of users executing those builds (via user licenses). Users subscribe to a plan that provides them an allocation of credits to be used towards build minutes and a pricing for a specific number of user licenses. The credits are deducted from the user's credit balance as they are used in the Travis CI service.
Unique users triggering builds within a billing period will constitute a number of actual user licenses used and will be charged at the end of the billing period, according to the rates of their selected plan. 


### Usage - Credits

Credits are purchased at your discretion as an 'addon'. The Plan you are on determines what selection addons are available for you. Credit addons are paid in advance.
Thus whenever you select or are assigned a Usage based plan:

* Plan has the default allotment of credits associated (default Credits addon)
* Only advance charge is related to the allotment of credits available initially in the Plan, e.g. Plan coming with 25,000 credits will result in immediate charge according to the enlisted price

You can also purchase credits while on the Concurrency based Plan. These are used only in scenarios, which require credits in order to start a build job (e.g. building on macOS or using a non-standard VM instance size).

Credits are deducted from your balance each time a build job starts a VM instance or an LXD container and is running. Each started build job minute has a credit cost associated with the environment used as shown in the table below. If your account runs out of credits, there's a slight margin of negative credits you are allowed to exceed in order to finish the job, but if that margin is passed - jobs will be cancelled due to insufficient credits balance.

| OS                   | # Credits per<br />started build minute |
|:--------------------:|:-----------:|
| Partner Queue        | 0           |
| Linux                | 10          |
| Experimental FreeBSD | 10          |
| Windows              | 20          |
| MacOS                | 50          |

Build job minutes are counted from the moment when [VM or LXD container](/user/reference/overview/#virtualization-environments) is spun up, thus queue waiting time or spinning-up time are not taken into account when calculating job duration time.

Additional credits can be purchased at any time. Credits are replenished by purchasing credits addon.

> Automated credits purchasing is not available yet, please follow our blog and Twitter for updates.

Your credits remain available until you use them or disband them. At the moment we do not discard unused paid credits after 12 months, yet this may be subject to change on short notice.

You may disband your credits. This happens when

* you switch from the Usage based plan to a Free Plan (which cancels the paid Plan)

and is meant to prevent abusive usage of the system.

#### Partner Queue Solution

Partner Queue Solution is a solution for infrastructure sponsored by our Partners with OSS in mind which can be used completely for free. Currently, it includes:

- IBM CPU builds in IBM Cloud (sponsored by IBM)
- ARM64 CPU builds in Equinix Metal (former Packet) infrastructure (sponsored by ARM)

This is available only to Open Source Software repositories.

In order to run a job using Partner Queue Solution, use the following `.travis.yml` tags in your public repository:

```yaml
os: linux
arch:
  - arm64
  - ppc64le
  - s390x
```

Please see our [Build Environment overview](/user/reference/overview/) and [Building for Multiple CPU architectures](/user/multi-cpu-architectures/) pages for more details.

In order to start a build in the Usage based Plan, a positive credits balance is required in the account (at least 1 credit). The build job under Partner Queue Solution costs 0 credits per started minute. At the moment of introducing Partner Queue Solution active accounts on the Usage based Plans, including the Free Plan, with a balance of zero or fewer credits, balance is updated to hold 1 credit. Thus everybody can use Partner Queues without requesting Travis CI support to grant additional credits. If you run into a negative account balance after that, you still need to file an additional request.

In the case of Concurrency based Plans, you can use the above infrastructure for OSS builds without any credits in your account.

Partner Queues are available only for standard instance size.

#### Negative Credits

By design, the billing system usually allows the build job to finish even if the possible cost of the build job expressed in credits exceeds the available credits balance. Once the build finishes you may notice your credit balance to be negative. **This is perfectly normal.** Whenever your credits get replenished, e.g. after purchasing an addon, the negative balance will be deducted from the newly arriving credit pool. What remains is your available credit balance for your builds.

Please note: Currently, if the system decides that the build could cause your negative balance to be too high, the job can be canceled mid-flight due to insufficient credits balance. This will be addressed in one of the incoming updates in order to allow fluent processing for your builds.


#### Credits vs. OSS Only Credits

Credits can be used to build both over private and public repositories. 

On occasion, an allotment of OSS Only credits may be granted by Travis CI. These credits may be used only for builds over public repositories and are meant for open source support.
The OSS credits may be assigned as one time pool or renewable pool, subject to case by case assessment of Travis CI staff.

The OSS credits is a pool of credits completely separate from regular credits, with separate credits balance tracking.


#### Free Plan Credits

Each new user gets automatically assigned to the Free Plan upon signing up. The Free plan contains a one time pool of credits, not renewable. This plan is meant to let you familiarize with our usage based plans as well as to try out other Travis CI features. 



### Usage - User Licenses

Usage based plan charges you at the end of each month for the number of users who triggered the builds during this month.

With every build started, Travis CI keeps track of how many unique users triggered a build within a current billing period. At the end of the month, the total amount is used to calculate the user license charge.

> If person A triggers a build, and person B triggers a build, the billing system will recognize 2 unique users. Now if person A or B again triggers a build, the amount of unique users triggering remains 2 (assuming builds are triggered within the same billing period). Only when user C triggers a build within the same billing period the amount of unique users triggering a build will be increased to 3.
>
> By default, all users you've granted write rights to your repository are allowed to trigger a build. We are preparing a separate page in your Travis CI account page, which will allow you to manage which users exactly are allowed to trigger the build in order to give you more control. Please watch out for updates.

### Usage based Plan - Summary

| Area                            | Details    |
| :---                            | ---        |
| **Payment**                     | Credits are paid in advance:<BR />1. Upon purchasing a Plan, an immediate charge is applied depending on credits allotment coming with a Plan.<BR />2. The additional credit addons can be purchased at any time and credits used only when you need them. The charge is applied immediately upon transaction.<BR /><BR />The user license cost is charged automatically in arrears, at the end of each billing period. The number of unique users triggering a build is charged according to the license rates.<br /><br />The Free Plan assigned upon sign-up grants you unlimited users for free. |
| **Private/Public repositories** | With Credits you can build over both private and public repositories. <BR/> With OSS Credits you can build only over public repositories. |
| **Build job limits**            | Very high. <BR/><BR/>The Free Plan assigned automatically upon sign-up has a limit of 20 concurrent jobs. The paid usage based plans start from 40 concurrent jobs limit. |


### Usage based Plan - How to obtain?

1. Sign in to Travis CI with [Version Control System of your choice](/user/tutorial/).
2. Navigate to the [Plans](https://travis-ci.com/account/plan) and make sure you have your billing and contact details fill-in correctly. 
3. Contact [Travis CI support](mailto:support@travis-ci.com) requesting Usage based Plan.


## VM Instance Sizes and Credit Cost

Usage and Concurrency based plans allow you to choose the instance size, the build will run on (for the 'full vm' build job). Larger instance sizes deliver more resources (namely vCPU and RAM) for your build jobs. This can be done by setting a 'vm' property in the .travis.yml config. This property allows you to choose the Virtual machine instance for a build:
```yaml
vm:
  size: [large|x-large|2x-large]
```

Instance sizes are not applicable to OSX build jobs. Available VM sizes vs operating system and CPU architecture are described in our [CI Environment Overview page](/user/reference/overview#vm-instance-size). 

In order to use instance sizes:

* you need to have credits under your account, regardless of the plan (Concurrency or Usage based) you use. 
* you need to add the aforementioned tags to your `.travis.yml`

VM size property impacts the cost of build minutes/credits usage in the following way:

| VM size              | Credits per<br />started build minute |
|:--------------------:|:-------------------------------------:|
| large                | 2 x usage credit cost of build minute |
| x-large              | 4 x usage credit cost of build minute |
| 2x-large             | 8 x usage credit cost of build minute |



> If you run a Linux build in usage model, it'll cost you 10 credits. If you run a Linux build under concurrency plan, you do not need any credits, as the cost is already covered by a subscription. However, if you decide to run a Linux build using the `large` instance size, you will need in both cases 20 credits per every started build minutes (2 x 10 credits).


## Getting Help

If you have any questions or issues with the new VCS, please see our [Billing FAQ](/user/billing-faq) or email [support@travis-ci.com](mailto:support@travis-ci.com) for help.

We’d love to hear what you think of our new Pricing and if there’s something that you’d like to see included or improved! Let us know in the Travis CI Community Forum.
