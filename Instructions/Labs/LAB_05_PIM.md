---
lab:
    title: '05 - Azure AD Privileged Identity Management'
    module: 'Module 01 - Manage Identity and Access'
---

# Lab 05 - Azure AD Privileged Identity Management

# Student lab manual

## Lab scenario

You have been asked to create a proof of concept with Azure Privileged Identity Management (PIM) to enable just-in-time administration and control the number of users who can perform privileged operations. The specific requirements are:

- User aaduser2 should have a permanent assignment to the Security Administrator role. 
- User aaduser2 should be eligible for the Billing Administrator and Global Reader roles.
- The Global Reader role must require approval from aaduser3 to activate the role.
- Configure an Access Review for the Global Reader role and review auditing capabilities.

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is region to use for you class. 

> Before proceeding ensure you have completed Lab 04: MFA, Conditional Acccess and AAD Identity Protection . You will need both the tenant, AdatumLab500-04, and the aaduser1, aaduser2, and aaduser3 user accounts.

## Lab objectives

In this lab, you will complete:

- Exercise 1: Configure PIM users and roles.
- Exercise 2: Activate PIM roles with and without approval.
- Exercise 3: Create an Access Review and review PIM auditing features.

## Exercise 1 - Configure PIM users and roles

### Estimated timing: 15 minutes

In this exercise, you will complete:

- Task 1: Make a user eligible for a role.
- Task 2: Configure a role to require approval to activate and add an eligible member.
- Task 3: Give a user permanent assignment to a role. 

#### Task 1:  Make a user eligible for a role

In this task, you will make  a user eligible for an Azure AD directory role.

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

	> Ensure that you are signed-in to the **AdatumLab500-04** Azure AD tenant. You can use the **Directory + subscription** filter to switch between Azure AD tenants. Ensure you are signed in as the tenant owner.

1. From the Portal menu, click **All services**

1. Search for and select **Azure AD Privileged Identity Management**.

1. Under **Manage**, select **Azure AD roles**.

	> Most of the actions in this lab are from this page. Make a note of how to get to it. 

1. Under **Manage**, select **Roles**.

1. Click **Roles** and then **Add assignments**.

1. In the **Select a role** drop-down, select **Billing Administrator**.

1. Under **Select member(s)**, select **No member selected**, choose **aaduser2**, then **Select**.

1. Click **Next**. 

1. Ensure the **Assignment type** is **Eligible**. 

1. Ensure the **Permanently eligible** option is not selected. Notice the eligible duration settings.

1. Click **Assign**.
 
1. Under **Manage** Select **Assignments**.

1. Use **Member filter** to select **aaduser2**. 

1. Notice the tabs for **Eligible roles**, **Active roles**, and **Expired roles**.

1. Verify on the **Eligible roles** tab that **aaduser2** is shown as a **Billing administrator**. 

	> When aaduser2 signs in they will be Eligible to use the Billing administrator role. 

#### Task 2:  Configure a role to require approval to activate and add an eligible member

1. In the Azure Portal, continue in the PIM **Azure AD Roles** blade.

1. Under **Manage**, select **Roles**, and then select the **Global reader** role. 

1. Select **Settings** (top) and notice all the configuration settings for the role, including requiring MFA. 

1. Click **Edit**.

1. On the **Activation** tab, check the box for **Require approval to activate**. 

1. Under **Select member(s)**, select **No member selected**, choose **aaduser3**, then **Select**.

1. Click **Next:Assignment**.

1. Uncheck the box **Allow permanent eligible assignment**. Leave the rest as default.

1. Click **Next:Notification**.

1. Review the defaults and click **Update**.

	> Anyone trying to use the Global Reader role will now need approval from aaduser3. 

1. Continue working with the **Global Reader** role.

1. Select **Add assignments**.

1. Under **Select member(s)**, select **No member selected**, choose **aaduser2**, then **Select**.

1. Click **Next**. 

1. Ensure the **Assignment type** is **Eligible**. 

1. Ensure the **Permanently eligible** option is not selected. Notice the eligible duration settings.

1. Click **Assign**.

	> User aaduser2 is eligible for the Global Reader role. 
 
#### Task 3: Give a user permanent assignment to a role.

1. In the Azure Portal, continue in the PIM **Azure AD Roles** blade.

1. Under **Manage** select **Roles** and then **Add assignments**.

1. In the **Select a role** drop-down, select **Security Administrator**.

1. Under **Select member(s)**, select **No member selected**, choose **aaduser2**, then **Select**.

1. Click **Next**. 

1. Ensure the **Assignment type** is **Eligible**. 

1. Click **Assign**.

1. Under **Manage** select **Assignments**.

1. Under **Security Administrator** locate **aaduser2** and on the far right click **Update**.

1. Click the box for **Permanently eligible** and **Save** your changes. 

	> User aaduser2 is now permanently assigned the Security Administrator role.
	
## Exercise 2 - Activate PIM roles with and without approval

### Estimated timing: 15 minutes

In this exercise, you will complete:

- Task 1: Activate a role that does not require approval. 
- Task 2: Activate a role that requires approval. 

#### Task 1: Activate a role that does not require approval.

In this task, you will activate a role that does not require approval..

1. Open an InPrivate Microsoft Edge window.

1. Navigate to the Azure portal and sign in using the **aaduser2** user account. You are required to use MFA. 

     > To sign in you will need to provide a fully qualified name of the **aaduser2** user account, including the Azure AD tenant DNS domain name, as noted earlier in this lab.For example, aaduser2@adatumlab50004.onmicrosoft.com where you replace **adatumlab50004** with your unique domain name. 

1. Click **All services**, search for and select **Azure AD Privileged Identity Management**.

1. Under **Tasks** click **My roles**.

1. You should see three **Eligible roles** for **aaduser2**: **Global Reader**, **Billing Administrator** and **Security Administrator**. Notice that **Security Administrator** is a **Permanent** role.

1. Locate the **Billing Administrator** role and click **Activate** (far right).

1. Click the warning **Additional verification required.  Click to continue**. 

	> You only have to authenticate once per session. 
 
1. Follow the instructions to verify your identity.

1. Once returned to the Azure Portal, enter a **Reason** for the activation, and then click **Activate**.

	> When you activate a role in PIM, it can take up to 10 minutes before you can access the desired administrative portal or perform functions within a specific administrative workload. 	
	
	>  This role does not require approval, so you will be able to sign out and log back in to begin using the activated role. 

1. Click **sign out**.

1. Log back in as **aaduser2**.

1. Navigate to **Azure AD Privileged Identity Management**.

1. Under **Tasks** click **My Roles**.

1. Select **Active roles**. Notice the **Billing Administrator** role is **Activated**.

	>  Once a role has been activated, it automatically deactivates when its time limit under **End time**(eligible duration) is reached.

	> If you complete your administrator tasks early, you can deactivate a role manually.

1.  For the Billing Administrator role, click **Deactivate** (far right).

1.  Click **Deactivate** again to confirm the action. 


#### Task 2: Activate a role that requires approval. 

In this task, you will activate a role that requires approval.

1. Continue in the Portal as **aaduser2**.

1. Navigate to the **Azure AD Privileged Identity Management** role.

1. Under **Tasks** select **My Roles**.

1. Locate the **Global Reader** role, and click **Activate** (far right). 

1. Provide a **Reason** for the activation and click **Activate**. 

1. Notice the message that your request is pending. This means it requires approval.

	>  As the Privileged role administrator you can review and cancel requests at any time. 

1. Locate the **Security Administrator** role, and click **Activate** (far right). 

1. If prompted for **Additional verification required**, click the message and provide the verification.

1. Provide a **Reason** for the activation and click **Activate**. The auto approval process should complete.

1. Type in a reason then click **Activate**. 

1. Click the **Active roles** tab and notice the **Security Administrator** role is available, but the **Global Reader** role is not yet available.

	> You will now approve the Global Reader role.

1. Sign out of the Portal as **aaduser2**.

1. Sign into the Portal as **aaduser3**.

	> Remember if you have a user has sign in problems, you can sign in as the subscription owner and use Azure Identity Protection to reset their password or unblock their account.

1. Navigate to **Azure AD Privileged Identity Management**.

1. Under **Tasks**, click **Approve Requests**.

1. Under **Requests for role activations** notice **aaduser2** has requested the **Global Reader** role.

1. Click the **Global Reader** role request and provide a **Justification**. Notice the start and end times. 

1. **Approve** the request. 

	> Notice you can also Deny a request.

1. Sign into the Azure portal as **aaduser2**

1. Navigate to **Azure AD Privileged Identity Management**.

1. Under **Tasks** select **Azure AD Roles**.

1. Select the **Active roles** tab. Notice the Global Reader role is now active.

> Result: You have practiced activating PIM roles with and without approval. 

## Exercise 3 - Create an Access Review and review PIM auditing features

### Estimated timing: 10 minutes

#### Task 1: Configure and conduct an access review

In this task, you will reduce the risk associated with "stale" role assignments. You will do this by creating a PIM access review to ensure assigned roles are still valid. Specifically, you will review the Global Reader role. 

1. Sign in to the Portal with the Global Administrator Account.

2. Navigate to the **Azure AD Privileged Identity Management** blade. 

1. Under **Manage** select **Azure AD Roles**.

1. Under **Manage** select **Access reviews**.

1. Click **New** and configure the access review. 

	- Review name:  **Global Reader Review**
	
	- Start Date:  **Today's Date** 
	
	- Frequency: **One time**
	
	- End Date:  **End of next month**
	
	- Review role membership:  **Global Reader** - Notice you could select several roles to review. 
	
	- Reviewers:  **Select your account** - Notice you could delegate the review to someone else. 

1. Once you have configured the review, click **Start**:
 
1. It will take a minute for the review to deploy and appear on the Access Reviews page. If needed, Refresh the page. The review status will be **Active**. 

1. Under **Global Admin Review** select **Global Reader**. 

1. Notice on the **Overview** page the **Progress** charts shows 1 **Not reviewed** item. 

1. Under **Manage** select **Results**. Notice aaduser2 is listed as having access to this role.

1. Click **aaduser2** to see a detailed audit log of when the role was used. 

1. Return to the PIM **Azure AD Roles** page.

1. Under **Tasks** select **Review access** and then select the **Global Reader Review**. 

1. Select **aaduser2**. 

1. Type a **Reason** and then select either **Approve** to continue access or **Deny** to remove access. 

1. Return to the PIM **Azure AD Roles** page.

1. Under **Manage** select **Access reviews**.

1. Select the **Global Reader** review. Notice the **Progress** chart has been updated to show your review. 

#### Task 2: Configure security alerts for Azure AD directory roles in PIM

In this task, you will review PIM alerts, summary information, and detailed audit information. 

1. Return to the PIM **Azure AD Roles** page.

1. Under **Manage** select **Alerts** and then **Setting**.

1. Review the preconfigured alerts and risk levels, click an alert for more detailed information. 

1. Return to the PIM **Azure AD Roles** page.

1. Select the **Overview** page. 

1. Review this page for summary information about **Role activations**, **PIM activities**, **Alerts**, and **Role assignments**.

1. Under **Activity** select **Resource audit**. Audit history is available for all privileged role assignments and activations within the past 30 days.

1. Notice you can retrieve detailed information by **Time**, **Requestor**, **Action**, **Resource name**, **Scope** and **Subject**. 

> Result: You have configured an access review and reviewed audit information. 

**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 