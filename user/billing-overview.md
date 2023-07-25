---
title: Billing Overview
layout: en
permalink: /user/billing-overview/

---

> Effective March 2nd, 2022, concurrency pricing is returning to the Travis CI website for 1, 2, and 5 concurrency plans.


## Travis CI Plan types


Travis CI billing system consists of two types of subscriptions: Concurrent based plans and Usage-based plans.
The variety of plans provides you with the flexibility to choose the plan that suits your needs.  


| Billing Period | Concurrency based | Usage-based |
|:-------        |:-----------------:|:-----------:|
|Month           | Concurrent jobs limit<br />Unlimited build minutes on Linux, Windows, and FreeBSD<br />Paid macOS builds (credits)<br /><br /> | Very high concurrency limit<br />Paid macOS, Linux, Windows, and FreeBSD build minutes (credits)<br />Paid user licenses (only per users triggering the builds)<br /><br /> |
|Annual      | Only grandfathered | Very high concurrency limit<br />Paid macOS, Linux, Windows, and FreeBSD build minutes (credits)<br />Paid user licenses (only per users triggering the builds)<br /><br />Purchase in Travis CI or contact support [for plans over $3,300](https://app.travis-ci.com/account/plan) in Travis CI |


For most of users, a single concurrency-based plan should be sufficient. However, if you build a lot of minutes per month and concurrency becomes a bottleneck, please contact Travis CI asking for a Usage-based plan.

### Free Trial Plan

A free 'Trial' Plan, which any new user can select upon sign up, is a usage-based plan with an unlimited amount of users, which comes with a 10k trial pool of credits to start building right away. Once these credits run out, they are not replenished, and users must subscribe to a higher plan to continue building. Request [OSS Credits allowance](/user/billing-faq/#what-if-i-am-building-open-source), or please consider one of our available plans. Trial credits are valid only for 30 days.

Due to security reasons and an anti-abuse preventive measure, any new user will be asked to provide valid credit card details during the selection of the Free Trial Plan. Then, we will trigger an authorization transaction for $1.00 on the user’s card, which will be released back to the card owner after a few days. This action is meant only to validate legitimate users. Existing users are not affected by this procedure. 

> The  Free Plan is available only once and for new users only
 

## Concurrency based plans

Concurrency-based plans are much like what Travis CI has been offering already for a long time: an ability to run a build consisting of X concurrent jobs. 
In Travis CI, builds are executed singularly, without exceeding limitations. Therefore, if executing multiple builds simultaneously or executing a build with multiple build jobs, once the concurrency limit is reached, the reminder builds/jobs must wait until a queue capacity is available for processing. 

> If a user on the 2 concurrent jobs plan executes a build with 5 build jobs, only the first 2 builds are processed while the remaining 3 of the builds wait in line to be processed.  
>
> If a user/organization subscribes to the 5 concurrent jobs plan and executes 2 builds consisting of 5 jobs each, the second build will be sitting in the queue and waiting to be executed after the 5 jobs of the first build are done.

Linux, Windows, and FreeBSD builds are included in the price of these plans. The macOS builds are paid separately on concurrency plans and can be run after purchasing the separate credits add-on. 
Credits are used to pay for each build job minute on macOS. Purchase only the credits you need and use them until you run out. Please see more in the 'Usage based' section.

> If a user/organization on the 2 concurrent jobs Plan executes build with jobs for `os: linux` and `os: freebsd` it will execute as soon as the concurrency capacity is available for particular build jobs.
>
> If a user/organization on the same Plan tries to execute a job for `os: macOS` and has no credits available (see your [Plans](https://app.travis-ci.com/account/plan)), this build will not execute. In order to proceed, an add-on must be purchased, e.g. 25k credits. Now the build can be executed, and a pre-defined amount of [credits will be charged for each build minute of macOS build job](/user/billing-overview/#usage---credits).


### Concurrency based Plan - Summary

| Area                            | Details    |
| :---                            | ---        |
| **Payment**                     | The subscription is charged automatically in advance at the beginning of each billing period. <br /> The optional credits for macOS builds can be purchased at any time and only used when you need them. The charge is applied immediately upon transaction. The subscription price doesn't depend on the number of unique users running builds.|
| **Private/Public repositories** | You can build over both private and public repositories with a paid subscription. |
| **Build job limits**            | As per Plan |


### Concurrency Plan - How to obtain?

1. Sign in to Travis CI with the [Version Control System of your choice](/user/tutorial/).
2. Navigate to the [Plan tab](https://app.travis-ci.com/account/plan) and select 'X concurrent jobs Plan'.
3. Enter your billing details. **Please note that all prices are provided netto, w/o any VAT or other applicable local taxes**. If you are EU based VAT paying company, do not forget to enter your VAT number.
4. Confirm the transaction.


## Usage-based plans

> **If you are running a large number of builds or users each month, please [contact Travis CI support](mailto:support@travis-ci.com) if you’d like to discuss your plan.** 

The Usage-based pricing system charges users and organizations depending on the number of minutes each builds jobs run on Travis CI infrastructure. 
The Usage-based pricing is a pre-paid model for credits and subscriptions for per-user-license. In other words, users and organizations can run as many build job as they want simultaneously, meaning that all builds are executed as soon as possible without limitations.  
The final cost is flexible and closely related to the actual usage of the system, allowing you to downscale or upscale as per your needs.

> The Usage-based pricing model bills based on minutes used (via credits) and the number of users executing those builds (via user licenses). Users subscribe to a plan that allocates of credits to be used towards build minutes and pricing for a specific number of user licenses. The credits are deducted from the user's credit balance as they are used in the Travis CI service.
Unique users triggering builds within a billing period will constitute a number of actual user licenses used and will be charged at the end of the billing period, according to the rates of their selected plan. 

### Monthly Plans

Subscribe to one of our monthly plans to get more credits and continue building. 

#### Selecting a Plan

Subscribe to one of our monthly plans to get your credits and continue building. Once you select a plan, your credits and your bill will be available at the start of the following month.  

| Credits | Price |
|:---------  |:------- | 
|   50K    |  $30   |
|   100K  |  $60   |
|   200K  |  $120 |
|   300K  |  $180 |
|   400K  |  $240 |
|   500K  |  $300 |   

> **All plans are available for Private and Open repositories in any platform; Linux, Windows, macOS, and FreeBSD. Check the documentation to read about credits usage.**
> **Please contact the [Travis sales team](sales@travis-ci.com) for plans larger than Enterprise ($300).** 

#### Plan Usage

The new user is immediately granted the subscription´s credits to continue building at the moment of a plan’s subscription. 

The number of users is counted based on the number of builds triggered; each individual who triggers a build within a month counts as a user. For any monthly plan selected, the first three users cost 25K credits, and each additional user to trigger a build within that month costs an additional 25K credits. Triggering builds are only possible if a user has a positive credit balance. To get more credits, users can enable the [Auto-refill feature](/user/billing-autorefill/) or change to a higher [credits plan](https://app.travis-ci.com/account/plan). If the user has credits after the plan´s renewal, these carry over to the new subscription. For more information about your plan and validity dates, see the [Plan page](https://app.travis-ci.com/account/plan).

#### Canceling my Monthly Subscription

Users can choose to cancel their current subscription anytime they like; simply use the Cancel Subscription button located on the [Plan page](https://app.travis-ci.com/account/plan). Upon cancellation, Travis CI stops charging the monthly fee, and users have one extra month to use the remaining credits; otherwise, any remaining credits are lost. Users cannot purchase any new credits unless they rejoin a monthly or annual subscription. Users have one year after canceling the subscription to view or save build data; after one year of cancellation, build data is removed from Travis CI.

### Annual Plans

Subscribe to one of our annual plans to get more credits and continue building.

#### Selecting a Plan

Users who subscribe to an Annual Plan are granted the subscription´s amount of credits over 12 months. From the moment of subscription, users can use the credits however they see best, without monthly allotments or limits.   

Users interested in Annual plans can select an annual plan on the [Plan page](https://app.travis-ci.com/account/plan).

| Credits |   Price  |
|:---------  |:--------  | 
|  600K   |   $330  |
|  1200K |   $660  |
|  2400K | $1,320 |
|  3600K | $1,980 |
|  4800K | $2,640 |
|  6000K | $3,300 |   

> **All plans are available for Private and Open repositories in any platform; Linux, Windows, macOS, and FreeBSD. And all plans have a 10,000 user limit.** 

#### Plan Usage

The number of users is counted based on the number of builds triggered; each individual who triggers a build within a month counts as a user. Each month the unique user count is reset. The first three users cost 25K credits, and each additional user to start a build within that month costs an additional 25K credits. Triggering builds are only possible if a user has a positive credit balance. Users can enable the [Auto-refill option](/user/billing-autorefill/) or change to a higher [credits plan](https://app.travis-ci.com/account/plan) to get more credits. Otherwise, your Annual plan renews automatically when the 12 month elapses. If the user has credits after the plan renewal, these carry over to the new subscription. For more information about your plan and validity dates, see the [Plan page](https://app.travis-ci.com/account/plan).

##### What if I ran out of credits before my contract elapses?

If users use up all their yearly credits before the 12 months, to get more credits, users either:
Enable the Auto-Refill option, select the best option for you and keep on building until your next subscription begins. 
Then, increase their annual credit amount by subscribing to a higher credit plan.    

#### Canceling my Annual Subscription

Users on an Annual Plan must explicitly cancel their yearly subscription; otherwise, the plan renews automatically whenever the current cycle ends. To cancel your existing subscription, simply use the Cancel Subscription button located at the [Plan page](https://app.travis-ci.com/account/plan).

Upon cancellation, users have the remaining time of the contract plus one extra month to use the remaining credits; otherwise, any remaining credits expire. Users cannot purchase any new credits unless they rejoin a monthly or annual subscription. Users have one year after canceling the subscription to view or save build data; after one year of cancellation, build data is removed from Travis CI. 

### Changing Plans

If you wish to switch from your monthly subscription to another plan with a different amount of credits, your new plan subscription will take effect at the start of the following month. And if you still run out of credits before the end of each month, try an annual plan, where you get a yearly amount of credits for the price of 11 months.  

### Credits Calculator

Travis CI introduces this new tool to help you calculate credits correctly. The credit calculator estimates the number of credits you need to help you choose the best plan for you.

Simply input your Operating System information, your [VM size](https://docs.travis-ci.com/user/billing-overview/#vm-instance-sizes-and-credit-cost), and the number of users that will trigger builds. 

#### How to use the Credits Calculator
Use the credit calculator to estimate the credits you will need to build continuously. To find the best plan for you, use one of our pre-existing commonly used configurations or follow these easy steps:

1. First, input the number of users.
2. Next, select your Operating System (Linux, Windows, macOS).
3. Next, specify your [VM size and configurations](https://docs.travis-ci.com/user/billing-overview/#vm-instance-sizes-and-credit-cost) (Large, X-Large, 2X-Large).
4. Finally, input an amount of minutes for an estimated build time.  

Please note that the first three users cost 25K credits, and each additional user costs an additional 25K credits. 


### Usage - Credits

Credits are purchased at your discretion as an 'addon' (if available in your plan) or via the Auto-Refill option. The Plan you are on determines what selection addons are available for you. Credit addons are paid in advance.
Thus whenever you select or are assigned a Usage-based plan:

* Plan has the default allotment of credits associated (default Credits addon)
* Only advance charge is related to the allotment of credits available initially in the Plan, e.g. a plan coming with 25,000 credits will result in an immediate charge according to the enlisted price.
* If you have the Auto-Refill option enabled, whenever the overall balance of purchased credits drops down to a certain level, your account will be refilled with some portion of credits upon successful charge on your credit card; read more about it [here](user/billing-autorefill/).

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

Users can purchase additional credits at any time. Credits are replenished by purchasing credits addon (if available in your plan).

Your credits remain available until you use them or disband them. At the moment, we do not discard unused paid credits after 12 months, yet this may be subject to change on short notice.

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

On occasion, an allotment of OSS Only credits may be granted by Travis CI. These credits may be used only for builds over public repositories and are meant for open source support.
The OSS credits may be assigned as a one-time pool or renewable pool, subject to a case-by-case assessment of Travis CI staff.

The OSS credits are a separate pool of credits from regular credits, with separate credits balance tracking.


#### Free Plan Credits

Each new user that subscribes to the Free Trial Plan is automatically granted 10K credits to use over a 30 day period. This one-time pool of credits is not renewable. This plan is meant to let you familiarize yourself with our usage-based plans as well as to try out other Travis CI features. 



### Usage - User Licenses (Usage Plan w/o subscription)

Usage-based plan charges you at the end of each month for the number of users who triggered the builds during this month.

With every build started, Travis CI keeps track of how many unique users triggered a build within a current billing period. At the end of the month, the total amount is used to calculate the user license charge.

> If person A triggers a build, and person B triggers a build, the billing system will recognize 2 unique users. Now, if person A or B again triggers a build, the amount of unique users triggering remains 2 (assuming builds are triggered within the same billing period). Only when user C triggers a build within the same billing period will the number of unique users triggering a build increased to 3.
>
> By default, all users you've granted write rights to your repository are allowed to trigger a build. We are preparing a separate page in your Travis CI account page, allowing you to manage which users are allowed to trigger the build in order to give you more control. Please watch out for updates.

### Usage-based Plan - Summary

| Area                            | Details    |
| :---                            | ---        |
| **Payment**                     | Credits are paid in advance:<BR />1. Upon purchasing a Plan, an immediate charge is applied depending on the credits allotment coming with a Plan.<BR />2. The additional credit addons can be purchased at any time, and credits are only used when you need them. The charge is applied immediately upon transaction.<BR /><BR />The user license cost is charged automatically in arrears at the end of each billing period (Usage Plan w/o subscription). The number of unique users triggering a build is charged according to the license rates.<br /><br />The Free Plan assigned upon sign-up grants you unlimited users for free. |
| **Private/Public repositories** | With Credits, you can build over both private and public repositories. <BR/> With OSS Credits, you can build only over public repositories. |
| **Build job limits**            | Very high. <BR/><BR/>The Free Plan assigned automatically upon sign-up has a limit of 20 concurrent jobs. The paid usage-based plans start from a 40 concurrent jobs limit. |


### Usage-based Plan - How to obtain?

1. Sign in to Travis CI with a [Version Control System of your choice](/user/tutorial/).
2. Navigate to the [Plans](https://app.travis-ci.com/account/plan) and have your billing and contact details filled in correctly. 
3. Contact [Travis CI support](mailto:support@travis-ci.com) requesting a Usage-based Plan.


## VM Instance Sizes and Credit Cost

Usage and Concurrency based plans allow you to choose the instance size the build will run on (for the 'full vm' build job). Larger instance sizes deliver more resources (namely vCPU and RAM) for your build jobs. This can be done by setting a 'vm' property in the .travis.yml config. This property allows you to choose the Virtual machine instance for a build:
```yaml
vm:
  size: [large|x-large|2x-large]
```

Instance sizes do not apply to OSX build jobs. Our [CI Environment Overview page](/user/reference/overview#vm-instance-size) describes the available VM sizes vs. operating system and CPU architecture.  

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

Instance sizes do not apply to Windows, and OSX build jobs.  Visit our [CI Environment Overview page](/user/reference/overview#gpu-vm-instance-size) for information on the available GPU VM sizes, operating system, and CPU architecture.  

To use instance sizes:

* you need to have credits under your account, regardless of the plan (Concurrency or Usage-based) you use. 
* you need to add the tags mentioned above to your `.travis.yml.`
* you need to select a Linux operating system in your `travis.yml.`

GPU VM size property impacts the cost of build minutes/credits usage in the following way:

| GPU VM size              | Credits per<br />started build minute |
|:--------------------:|:-------------------------------------:|
| T4 medium       | 230 |
| V100 x-large      | 890 |


> GPU Support is only available for: 
> * arch: amd64 
> * os: Linux
> * dist: [focal] # jammy still under fixing, to be added later, xenial EOL, bionic will go EOL in April 2023.


## Getting Help

If you have any questions or issues with the new VCS, please see our [Billing FAQ](/user/billing-faq) or email [support@travis-ci.com](mailto:support@travis-ci.com) for help.

We’d love to hear what you think of our new Pricing and if there’s something that you’d like to see included or improved! Let us know in the Travis CI Community Forum.
