---
title: Billing Overview
layout: en
permalink: /user/billing-overview/

---

> A new billing engine has been introduced on November 1st, 2020 to [https://travis-ci.com](https://travis-ci.com) 

## Travis CI Plan types


Travis CI billing system consists of two types of subscriptions: Concurrent based plans and Usage based plan.
The variety of plans provides you with flexibility to choose the plan that suits your needs.  


| Billing Period | Concurrency based | Usage based |
|:-------        |:-----------------:|:-----------:|
|Month           | Concurrent jobs limit<br />Unlimited build minutes on Linux, Windows, and FreeBSD<br />Paid macOS builds (credits)<br /><br />Available via [site](https://travis-ci.com/account/plan) | Very high or no concurrency limit<br />Paid macOS, Linux, Windows, and FreeBSD build minutes (credits)<br />Paid user licenses (only per users trigerring the builds)<br /><br />Contact Travis CI to obtain|

For majority of users one of concurrency based plans should be sufficient. However if you build a lot of minutes per month and concurrency becomes a bottleneck, please contact Travis CI asking for Usage based plan.

### Free Plan

A 'Free' Plan, assigned automatically to every new sign up, is a Usage based plan without limits on users and comes with a trial pool of credits to be used. Once these credits are used they are not replenished. Request [OSS Credits allowance](/user/billing-faq/#what-if-i-am-building-open-source) or please consider one of our available plans.


## Concurrency based plans

Concurrency based plans are much like what Travis CI has been offering already for a long time: an ability to run a build consisting of X concurrent jobs. 
In Travis CI builds are executed singularly, without exceeding limitations. Therefore, if executing multiple builds at the same time or executing a build with multiple build jobs, once the concurrency limit is reached, the reminder builds/jobs must wait until there is a queue capacity available for processing. 

> If a user on the 2 concurrent jobs plan executes a build with 5 build jobs, only the first 2 builds are processed while the remaining 3 of the builds wait in line to be processed.  
>
> If a user/organization subscribes to the 5 concurrent jobs plan and executes 2 builds consisting of 5 jobs each, the second build will be sitting in the queue and waiting to be executed after the 5 jobs of the first build are done.

Linux, Windows and FreeBSD builds are included in the price on these plans. The macOS builds are paid separately on concurrency plans, and can be run after purchasing the separate credits add-on. 
Credits are used to pay for each build job minute on macOS. Purchase only the credits you need and use them until you run out. Please see more in 'Usage based' section.

> If a user/organization on the 2 concurrent jobs Plan executes build with jobs for `os: linux` and `os: freebsd` it will execute as soon as the concurrency capacity is available for particular build jobs.
>
> If a user/organization on the same Plan tries to execute a job for `os: macOS` and has no credits available (see your [Plans](https://travis-ci.com/account/plan)), this build will not execute. In order to overcome that, an add-on must be purchased, e.g. 25k credits. Now the build can be executed and pre-defined amount of [credits will be charged for each build minute](/user/billing-overview/#usage---credits). 


### Concurrency based Plan - Summary

| Area                            | Details    |
| :---                            | ---        |
| **Payment**                     | The subscription is charged automatically in advance, at the beginning of each billing period. <br /> The optional credits for macOS builds can be purchased at any time and used only when you need them. Charge is applied immediately upon transaction. |
| **Private/Public repositories** | With paid subscription you can build over both private and public repositories. |
| **Build job limits**            | As per Plan |


### Concurrency Plan - How to obtain?

1. Sign in to Travis CI with [Version Control System of your choice](/user/tutorial/).
2. Navigate to the [Plans](https://travis-ci.com/account/plan) and select of of 'X concurrent jobs Plan'. 
3. Enter your billing details. **Please note, that all prices are provided netto, w/o any VAT or other applicable local taxes**. If you are EU based VAT paying company, do not forget to enter your VAT number.
4. Confirm transaction.



## Usage based plans

> **If you are running a large number of builds or users each month, please [contact Travis CI support](mailto:support@travis-ci.com) if you’d like to discuss your plan.** 

The usage based pricing system charges users and organizations depending on the amount of minutes each of the build jobs run on Travis CI infrastructure. 
The usage based pricing is a pre-paid model for credits and subscriptions for per-user-license. In other words, users and organizations can run as many build jobs as they want at the same time, meaning that all builds are executed as soon as possible without limitations.  
The final cost is flexible and closely related to the actual usage of the system, allowing you to downscale or upscale as per your needs.

> The usage based pricing model bills based on minutes used (via credits) and number of users executing those builds (via user licenses). Users subscribe to a plan that provides them an allocation of credits to be used towards build minutes and a pricing for specific number of user licenses. The credits are deducted from the users credit balance as they are used in the Travis CI service.
Unique users triggering builds within a billing period will constitute a number of actual user licenses used and will be charged at the end of the billing period, according to the rates of their selected plan. 


### Usage - Credits

Credits are purchased at your discretion as an 'addon'. The Plan you are on determines what selection addons is available for you. Credit addons are paid in advance.
Thus whenever you select or are assigned an Usage based plan:

* Plan has the default allotment of credits associated (default Credits addon)
* Only advance charge is related to the allotment of credits available initially in the Plan, e.g. Plan coming with 25,000 credits will result in immediate charge according to the enlisted price

Credits are deducted from your balance each time a build job ends either with some result or is cancelled manually by you. Each started build job minute has a credit cost associated with the environment as per table below.

| OS                   | # Credits per<br />started build minute |
|:--------------------:|:-----------:|
| Linux                | 10          |
| Experimental FreeBSD | 10          |
| Windows              | 20          |
| MacOS                | 50          |

Build job minutes are counted from the moment when [VM or LXD container](/user/reference/overview/#virtualization-environments) is spun up, thus queue waiting time or spinning-up time are not taken into the account when calculating job duration time.

Additional credits can be purchased at any time. Credits are replenished by purchasing credits addon.

> Automated credits purchasing is not available yet, please follow our blog and twitter for updates.

Your credits remain available until you use them or disband them. At the moment we do not discard unusued paid credits after 12 months, yet this may be a subject to change on short notice.

You may disband your credits. It will happen when

* you switch from usage based plan to a Free Plan (which cancels the paid Plan)

and is meant to prevent abusive usage of the system.

#### Negative Credits

By design, the billing system allows the build job to be finished even if the possible cost of build job expressed in credits exceeds available credits balance. After such build being finished you may notice your credit balance being negative. **This is perfectly normal.** Whenever your credits get replenished, e.g. after purchasing an addon, the negative balance will be deducted from newly arriving credit pool. What remains is your available credits balance for your builds.


#### Credits vs. OSS Only Credits

Credits can be used to build both over private and public repositories. 

On occassion, an allotment of OSS Only credits may be granted by Travis CI. These credits may be used only for builds over public repositories and are meant for open source support.
The OSS credits may be assigned as one time pool or renewable pool, subject to case by case assesment of Travis CI staff.

The OSS credits is a pool of credits completely separate from regular credits, with separate credits balance tracking.


#### Free Plan Credits

Each new user gets automatically assigned to the Free Plan upon signing up. The Free plan contains a one time pool of Credits, not renewable. This plan is meant to let you familiarize with our usage based plans as well as to try out other Travis CI features. 


### Usage - User Licenses

Usage based plan charges you at the end of each month for the number of users who triggered the builds during this month.

With every build started, Travis CI keeps track of how many unique users triggered a build within current billing period. At the end of the month the total amount is used to calculate the user license charge.

> If a person A triggers a build, and a person B triggers a build, the billing system will recognize 2 unique users. Now if person A or B again triggers a build, the amount of unique users trigerring remains 2 (assuming builds are trigerred within the same billing period). Only when user C triggers a build within the same billing period the amount of unique users triggering a build will be increased to 3.
>
> By default, all users you've granted write rights to your repository are allowed to trigger a build. We are preparing a separate page in your Travis CI account page, which will allow you to manage which users exactly are allowed to trigger the build in order to give you more control. Please watch out for updates.

### Usage based Plan - Summary

| Area                            | Details    |
| :---                            | ---        |
| **Payment**                     | Credits are paid in advance:<BR />1. Upon purchasing a Plan, an immediate charge is applied depending on credits allotment coming with a Plan.<BR />2. The additional credit addons can be purchased at any time and credits used only when you need them. Charge is applied immediately upon transaction.<BR /><BR />The user license cost is charged automatically in arrears, at the end of each billing period. The number of unique users trigerring a build is charged according to the license rates. |
| **Private/Public repositories** | With Credits you can build over both private and public repositories. <BR/> With OSS Credits you can build only over public repositories. |
| **Build job limits**            | None or very high. <BR/><BR/>The Free Plan assigned automatically upon sign-up has a limit of 20 concurrent jobs. |


### Usage based Plan - How to obtain?

1. Sign in to Travis CI with [Version Control System of your choice](/user/tutorial/).
2. Navigate to the [Plans](https://travis-ci.com/account/plan) and make sure you have your billing and contact details filled in correctly. 
3. Contact [Travis CI support](mailto:support@travis-ci.com) requesting Usage based Plan.


## Getting Help

If you have any questions or issues with the new VCS, please see our [Billing FAQ](/user/billing-faq) or email [support@travis-ci.com](mailto:support@travis-ci.com) for help.

We’d love to hear what you think of our new Pricing and if there’s something that you’d like to see included or improved! Let us know in the Travis CI Community Forum.
