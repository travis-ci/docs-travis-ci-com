---
title: Billing FAQ
layout: en
permalink: /user/billing-faq/

---

> Please see our **[Billing overview](/user/billing-overview/)** first.

## How can I get on an annual plan? 

You can select one of available annual plans via [Your Account->Settings->Plan](https://app.travis-ci.com/account/plan) page. The customised annual based plans are available by contacting the Travis CI support team. 

## How can I get on the usage based plan?

The usage based plan is available by contacting theTravis CI support team. 

## How are the credits deducted?

The credits will be deducted from the credits pool after each build job is executed depending on the operation system used.

## How  can I check how much I will pay for user licenses at the end of the month?

The unique users triggering builds within a billing period will constitute a number of actual user licenses used and will be charged at the end of the billing period, according to the rates in a selected plan.

By default Travis CI system provides the possibility to trigger a build to all members of your team on GitHub, Bitbucket, GitLab and Assembla who have writing rights on repositories.
If the team member has not triggered the build during the billing period Travis CI will not charge you for that user.


To check how much active users you got during the last billing cycle you may generate a report for selected time period on your [Plan Usage](https://app.travis-ci.com/account/plan/usage) page or contact the support.
Travis CI also offers the user management functionality where you are able:

* To see how many users has rights to trigger the build
* To see how many was active/trigger the build during the last month
* Select the users who are able to trigger the build 

This is available under each repository settings (in the https://app.travis-ci.com/{vcs provider identifier}/{your account name}/{repository name}/settings ) as a'User Management' button.

## What if I am building open source?

Each of the Travis CI Plans contains an amount of special OSS credits per month assigned to run builds only on public repositories. To find out more about it please [contact the Travis CI support team](mailto:support@travis-ci.com). In the email please include:

* Your account name and your VCS provider (like travis-ci.com/github/[your account name] )
* How many credits (build minutes) you’d like to request (should your run out of credits again you can repeat the process to request more or to discuss a renewable amount)


## How do I use credits?

You can use your credits to run builds on your public and private repositories.
You may have been assigned an amount of OSS credits to run builds on public repositories. When you run out of OSS credits but want to keep building on public repositories you can go to the Plan page and turn the Credits consumption for OSS switcher to `On`. In this case,  once the ‘OSS credits’ pool is depleted, the system starts deducting from the ‘paid credits’ pool. Builds for OSS repositories will be allowed to start, and deducted from the paid credits. 

## How do I recharge my credits balance?

You can buy additional build credits anytime you need them by clicking on your profile icon in the right upper corner of the screen =>Settings, navigate to the Plan page and  press the ‘Buy add-ons’ button. You may also enable the [auto-refill](user/billing-autorefill/) feature.
Please be advised that it is not possible to buy additional credits on free Plan. 


## Do credits expire?

Credits which you purchase or obtain as a part of the free Plan do have an expiry date. Please check your [Plan Usage](https://app.travis-ci.com/account/plan/usage) page.

## Can you send me an invoice?

The invoice is sent automatically by the Travis CI system after the Plan purchase or subsequent user license charge is made. 

## How do I cancel my paid plan?

If you want to cancel your paid plan, please contact our support. The self-service functionality is temporarily unavailable and will be restored soon.
Travis CI free Trial plan will provide you with 10,000 build credits to try it out for public and private repositories builds and unlimited number of users with no charge. Once you use up all credits or they expire, simply do not select any other plan.
If you want your account to be deleted, please contact the Travis CI support.  


## Do these prices include tax?

No, all prices do not include tax. 

## Can I sign up for automatic renewals for usage based plan?

The per-seats licence invoice will be charged and sent automatically after each month you use the Travis CI service, based on the maximum number of unique users who triggered the build during the given month. 
You may manually buy credits each time you are about to run out of them or enable the [auto-refill](user/billing-autorefill/) functionality in your Plan page, which will refill your credits every time it drops below certain threshold. We intend to make it more convenient in the near future. Concurrency-based plans are not subject to auto-refill.
To help you track the build credit consumption Travis CI system will send the notification emails each time your credit balance is used up by 50, 75 and 100%.
We are working on making the system more convenient.

## Are add-ons limited to a certain number of users?

You can buy additional add-ons any time you feel it is needed. You and your organization’s members can use the bought add-ons with no limitations.

## Why my credits balance is negative?

Most probably your last build costed more than you had available in your credit balance. You won't be able to run any builds until your balance gets positive. Replenish your credits (the negative balance will be deducted upon arrival of new credits creating new balance - see our [billing overview](/user/billing-overview/#negative-credits).

## Why am I asked for credit card details upon selection of free Trial Plan? 

Due to continued abuse of our free service and in order to make environment more secure and with fair access to shared infrastructure, Travis CI decided to introduce credit card validation step for every new user. There will be a small fee placed on your card in order to authorize the account and it will be returned after several days.
