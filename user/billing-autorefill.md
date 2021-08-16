---
title: Billing Autorefill
layout: en
permalink: /user/billing-autorefill/

---

## Auto-Refill

Currently, Travis CI sends an email notifying you when you are running low on credits to refill your credits. Now, you can choose to enable the Auto-Refill feature to ensure you don't run out of credits.

The Auto-Refill feature is available to all users who provide their credit card details and register to a usage-based plan or purchase credits add-on under a concurrency plan. This feature is not available for Free Plan users. Find the Auto-refill under: [Settings -> Plan tab](https://travis-ci.com/account/plan) -> Credits section -> Credits tab.

If you wish to set a different refill threshold and refill amount, please contact support at [support@travis-ci.com](mailto:support@travis-ci.com). 

### How it works

Activating the Auto-Refill option adds 25,000 credits to your balance each time your credit level drops below 5,000 credits. Users can switch off the Auto-Refill feature at any time.

For [usage-based plans](/user/billing-overview/#usage-based-plans), whenever your credit balance, drops below a certain *threshold*, a set *amount* of credits will be purchased and upon a successful transaction added to your account.

For [concurrency based plans](user/billing-overview/#concurrency-based-plans) the Auto-Refill applies only, if the account owner has purchased credits in order to use credit-based feature, like [higher instance size](/user/billing-overview/#vm-instance-sizes-and-credit-cost) or macOS builds. 

Once credits are added to the account and auto-refill is enabled, going below a certain *threshold* triggers the transaction to refill your account with a set *amount* of credits.

### Billing

After each refill, Travis CI sends an email notifying if the payment succeeded or if it failed. If payment fails, credits won’t replenish until payment succeeds. An invoice/receipt is issued for successful credit purchases that you can obtain via your [Settings -> Plans tab](https://travis-ci.com/account/plan).

