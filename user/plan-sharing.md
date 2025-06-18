---
title: Plan Sharing Guide
layout: en

---

Assembla’s billing model allows customers to pay once for an entire portfolio of projects and allocate the allowance across the projects. Travis CI modified the billing model to map Assembla’s spaces to Travis CI Organizations and fulfill customer needs.  

Travis CI introduces a flexible new feature that allows users to share paid plans across Assembla’s spaces. This innovation introduces two new roles to Travis CI plans: the Donor and the Receiver, providing users with more control over their resources. 

## Donor and Receiver 
Travis CI users with paid plans can enable the Plan Sharing feature and decide to share with the available Spaces.

A user who enables the Sharing Plan option is referenced as the *** Donor *** account. 

A ***Donor*** account consists of a Travis CI user or Organization willingly sharing a Travis CI Plan allowance with other Travis CI users or Organizations. 

A user who benefits from the Sharing Plan feature is referenced as the ***Receiver*** account. 

A ***Receiver*** account is a Travis CI user or Organization that benefits from accessing a Travis CI Shared Plan by a Donor account. 
 
## How does a Shared Plan work?
Only Travis CI paid plans are available for sharing with another Travis CI Organization linked with an Assembla Space.

All recipients may trigger builds within the allowances of the original plan. It means that the system tracks all metrics under the original plan, but there are now multiple sources for these metrics.

### Concurrency-based Plans
Concurrency-based plans are available to all Travis CI accounts that use the Shared Plan, including Donor and Receiver accounts. When sharing a concurrency-based plan, the number of jobs is shared between all accounts. For example, if user account ***A*** decides to share a plan with 20 concurrent jobs with user accounts ***B*** and ***C***. This means that all three accounts have a total of 20 concurrent jobs. 

Here is an example:
User account ***A*** runs a build with 10 concurrent jobs. This consumes 10 of the 20 available slots. Then, Account ***B*** runs a build with 7 concurrent jobs, which consumes 17 out of the 20 available slots. Finally, if account ***C*** runs a build with 5 or more concurrent jobs, only 3 jobs are available to start, while the remaining jobs must wait in the queue for free slots.  


### User limits
If the donor’s plan has user license limits, only one pool of user licenses is consumed for both Donors and Receivers within the month. 

A unique user triggering builds is checked against all accounts, not just one. 

The user with the Donor account can see the number of unique users and which accounts consumed user licenses in a given month. The allowance gets deducted from the Donor’s allowance, and only the Donor account controls the user license allowance. 

### License charges
Users from ***Donor*** and ***Receiver*** accounts must consume a user license and incur the respective charges if applicable. 

There is no double charge for the license for the same user, given that this user triggers a build and is a member of both the ***Donor*** and ***Receiver*** accounts simultaneously. 

In other words, the user license consumption, which is a unique user triggering a build within a billing cycle, is tracked in the context of the Plan. Regardless of whether the source build is triggered from the ***Donor*** or ***Receiver*** accounts.

### Credits
The ***Donor*** account is responsible for the plan’s credits. 
When the donor plan has credits, both the donor and the Receiver can use the credits from the account. Once the credits run out, the user with the donor account is responsible for refilling the credits. 

The user with the Donor account can see the credit consumption information for the shared plan. This way, the donor user can identify which accounts consumed the credits. 

### Trial Plans
Trial Plans are not available for sharing. 

A Travis CI Organization account (linked to an Assembla Space), which has been a RECEIVER of a shared Plan at least once, if such user selects a Travis CI Plan on its own, the user must not be able to see or enable a trial period or select a trial plan (unless there’s a higher than one trial period limit configured for a selected plan).

## Sharing a Plan
The plan sharing feature is only available to Travis CI users or Organizations linked to Assembla Spaces with a paid plan. 
Users with a paid plan can navigate to the Settings screen and select the Share Plan tab. 

> Note: The Share Plan tab is only available to active Travis CI paid plan users. 

As a plan ***Donor***, the Share Plan screen displays a list of available spaces with which the donor can select to share the Travis CI plan. To share the plan, click the ***Share Plan*** button for each desired space. Any selected spaces for sharing the plan will immediately display the start date for sharing the plan. 

As a ***Receiver***, navigate to the Account screen, select the **Plan** tab, and check the available Spaces on the left-hand side. In the list, you will find the Space where a plan is being shared with your account. 

The Receiver account can see the shared Plan much like it would see a 'regular' plan, with the following annotations:

![Example of Plan Sharing](/user/images/plan-sharing-sample.png)

The ***Receiver*** may still select and purchase their own Travis CI plan by clicking the ***“Buy New Plan”*** button available to each TravisCI Organization (Linked with Assemble Space), which can purchase its own Travis CI plan. 

### Stop Plan Sharing

A Travis CI Plan Sharing can be ceased at any moment. The Donor account may stop sharing with a specific Receiver account or all Receivers in bulk. 

The Travis CI user with the Donor account can navigate to the Sharing Plan tab and click the ***Stop Sharing*** button for any Space on the list. 

Additionally, if the Donor account plan expires, the Receiver account will no longer be able to utilize the allowance. Whenever the Donor’s sharing plan stops, the Receiver does not have an active plan unless a new plan is assigned to the Receiver's account.
