---
lab:
    title: '03 - Microsoft Entra Privileged Identity Management'
    module: 'Module 01 - Manage Identity and Access'
---

# Lab 03: Microsoft Entra Privileged Identity Management
# Student lab manual

## Lab scenario

You have been asked to create a proof of concept that uses Microsoft Entra Privileged Identity Management (PIM) to enable just-in-time administration and control the number of users who can perform privileged operations. The specific requirements are:

- Create a permanent assignment of the aaduser2 Microsoft Entra ID user to the Security Administrator role. 
- Configure the aaduser2 Microsoft Entra ID user to be eligible for the Billing Administrator and Global Reader roles.
- Configure the Global Reader role activation to require an approval of the aaduser3 Microsoft Entra ID user
- Configure an access review of the Global Reader role and review auditing capabilities.

> For all the resources in this lab, we are using the **East US** region. Verify with your instructor this is the region to use for class. 

> Before you proceed, ensure that you have completed Lab 02: MFA, Conditional Access and Microsoft Entra Identity Protection . You will need the Microsoft Entra tenant, AdatumLab500-04, and the aaduser1, aaduser2, and aaduser3 user accounts.

## Lab objectives

In this lab, you will complete the following exercises:

- Exercise 1: Configure PIM users and roles.
- Exercise 2: Activate PIM roles with and without approval.
- Exercise 3: Create an Access Review and review PIM auditing features.

## Microsoft Entra Privileged Identity Management diagram

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/aef34a22-8ebd-4015-a04a-7ac3c357b862)

## Instructions

### Exercise 1 - Configure PIM users and roles

#### Estimated timing: 15 minutes

In this exercise, you will complete the following tasks:

- Task 1: Make a user eligible for a role.
- Task 2: Configure a role to require approval to activate and add an eligible member.
- Task 3: Give a user permanent assignment to a role. 

#### Task 1: Make a user eligible for a role

In this task, you will make a user eligible for an Microsoft Entra ID role.

1. Sign-in to the Azure portal at **`https://portal.azure.com/`**.

    >**Note**: Ensure that you are signed-in to the **AdatumLab500-04** Microsoft Entra tenant. You can use the **Directory + subscription** filter to switch between Microsoft Entra tenants. Ensure you are signed in as a user with the Global Administrator role.
    
    >**Note**: If you still don't see the AdatumLab500-04 entry, click on the Switch Diretory link, select the AdatumLab500-04 line and click the Switch button.

2. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Microsoft Entra Privileged Identity Management** and press the **Enter** key.

3. On the **Privileged Identity Management** blade, in the **Manage** section, click **Microsoft Entra ID roles**.

4. On the **AdatumLab500-04 \| Quick start** blade, in the **Manage** section, click **Roles**.

5. On the **AdatumLab500-04 \| Roles** blade, click **+ Add assignments**.

6. On the **Add assignments** blade, in the **Select role** drop-down, select **Billing Administrator**.

7. Click the **No member selected** link, on the **Select a member** blade, click **aaduser2**, and then click **Select**.

8. Back on the **Add assignments** blade, click **Next**. 

9. Ensure the **Assignment type** is set to **Eligible** and click **Assign**.
 
10. Back on the **AdatumLab500-04 \| Roles** blade, in the **Manage** section, click **Assignments**.

11. Back on the **AdatumLab500-04 \| Assignments** blade, note the tabs for **Eligible assignments**, **Active assignments**, and **Expired assignments**.

12. Verify on the **Eligible assignments** tab that **aaduser2** is shown as a **Billing administrator**. 

    >**Note**: During sign-in, aaduser2 will be eligible to use the Billing administrator role. 

#### Task 2: Configure a role to require approval to activate and add an eligible member

1. In the Azure Portal, navigate back to the **Privileged Identity Management** blade and click **Microsoft Entra ID roles**.

2. On the **AdatumLab500-04 \| Quick start** blade, in the **Manage** section, click **Roles**.

3. On the **AdatumLab500-04 \| Roles** blade, click the **Global reader** role entry. 

4. On the **Global Reader \| Assignments** blade, click the **Role settings** icon in the toolbar of the blade and review configuration settings for the role, including Azure Multi-Factor Authentication requirements.

5. Click **Edit**.

6. On the **Activation** tab, enable the **Require approval to activate** check box.

7. Click **Select approvers(s)**, on the **Select a member** blade, click **aaduser3**, and then click **Select**.

8. Click **Next:Assignment**.

9. Clear the **Allow permanent eligible assignment** check box, leaving all other settings with their default values.

10. Click **Next:Notification**.

11. Review the **Notification** settings, leave everything set by default and click **Update**.

    >**Note**: Anyone trying to use the Global Reader role will now need approval from aaduser3. 

12. On the **Global Reader \| Assignments** blade, click **+ Add assignments**.

13. On the **Add assignments** blade, click **No member selected**, on the **Select a member** blade, click **aaduser2**, and then click **Select**.

14. Click **Next**. 

15. Ensure the **Assignment type** is **Eligible** and review the eligible duration settings.

16. Click **Assign**.

    >**Note**: User aaduser2 is eligible for the Global Reader role. 
 
#### Task 3: Give a user permanent assignment to a role.

1. In the Azure Portal, navigate back to the **Privileged Identity Management** blade and click **Microsoft Entra ID roles**.

2. On the **AdatumLab500-04 \| Quick start** blade, in the **Manage** section, click **Roles**.

3. On the **AdatumLab500-04 \| Roles** blade, click **+ Add assignments**.

4. On the **Add assignments** blade, in the **Select role** drop-down, select **Security Administrator**.

5. On the **Add assignments** blade, click the **No member selected**, on the **Select a member** blade, click **aaduser2**, and then click **Select**.

6. Click **Next**. 

7. Review the **Assignment type** settings and click **Assign**.

8. In the left navigation panel, click **Assignments**. On the **Eligible Assignments** tab, under **Security Administrator**, select **Update** for the **aaduser2** assignment. Select **Permanently Eligible** and **Save**.

    >**Note**: User aaduser2 is now permanently eligible for the Security Administrator role.
	
### Exercise 2 - Activate PIM roles with and without approval

#### Estimated timing: 15 minutes

In this exercise, you will complete the following tasks:

- Task 1: Activate a role that does not require approval. 
- Task 2: Activate a role that requires approval. 

#### Task 1: Activate a role that does not require approval.

In this task, you will activate a role that does not require approval.

1. Open an InPrivate browser window.

2. In the InPrivate browser window, navigate to the Azure portal at **`https://portal.azure.com/`** and sign in using the **aaduser2** user account.

    >**Note**: To sign in you will need to provide a fully qualified name of the **aaduser2** user account, including the Microsoft Entra tenant DNS domain name, which you recorded earlier in this lab. This user name is in the format aaduser2@`<your_tenant_name>`.onmicrosoft.com, where `<your_tenant_name>` is the placeholder representing your unique Microsoft Entra tenant name. 

3. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Microsoft Entra Privileged Identity Management** and press the **Enter** key.

4. On the **Privileged Identity Management** blade, in the **Tasks** section, click **My roles**.

5. You should see three **Eligible roles** for **aaduser2**: **Global Reader**, **Security Administrator**, and **Billing Administrator**. 

6. In the row displaying the **Billing Administrator** role entry, click **Activate**.

7. If needed, click the warning **Additional verification required. Click to continue** and follow the instructions to verify your identity.

8. On the **Activate - Billing Administrator** blade, in the **Reason** text box, type a text providing justification for the activation, and then click **Activate**.

    >**Note**: When you activate a role in PIM, it can take up to 10 minutes for the activation to take effect. 
	
    >**Note**: Once your role assignment is active, your browser will refresh (If anything goes wrong, simply sign out and sign back into the Azure portal by using the **aaduser2** user account).

9. Navigate back to the **Privileged Identity Management** blade and, in the **Tasks** section, click **My roles**.

10. On the **My roles \| Microsoft Entra ID roles** blade, switch to the **Active assignments** tab. Notice the **Billing Administrator** role is **Activated**.

    >**Note**: Once a role has been activated, it automatically deactivates when its time limit under **End time**(eligible duration) is reached.

    >**Note**: If you complete your administrator tasks early, you can deactivate a role manually.

11.  In the list of **Active Assignments**, in the row representing the Billing Administrator role, click the **Deactivate** link.

12.  On the **Deactivate - Billing Administrator** blade, click **Deactivate** again to confirm.


#### Task 2: Activate a role that requires approval. 

In this task, you will activate a role that requires approval.

1. In the InPrivate browser window, in the Azure portal, while signed in as the **aaduser2** user, navigate back to the **Privileged Identity Management \| Quick start** blade. 

2. On the **Privileged Identity Management \| Quick start** blade, in the **Tasks** section, click **My roles**.

3. On the **My roles \| Microsoft Entra ID roles** blade, in the list of **Eligible assignments**, in the row displaying the **Global Reader** role, click **Activate**. 

4. On the **Activate - Global Reader** blade, in the **Reason** text box, type a text providing justification for the activation, and then click **Activate**.

5. Click the **Notifications** icon in the toolbar of the Azure portal and view the notification informing that your request is pending approval.

    >**Note**: As the Privileged role administrator you can review and cancel requests at any time. 

6. On the **My roles \| Microsoft Entra ID roles** blade, locate the **Security Administrator** role, and click **Activate**. 

7. If needed, click the warning **Additional verification required. Click to continue** and follow the instructions to verify your identity.

    >**Note**: You only have to authenticate once per session. 

8. Once you are back in the Azure Portal interface, on the **Activate - Security Administrator** blade, in the **Reason** text box, type a text providing justification for the activation, and then click **Activate**.

    >**Note**: The auto approval process should complete.

9. Back on the **My roles \| Microsoft Entra ID roles** blade, click the **Active assignments** tab and notice that the listing of **active assignments** includes **Security Administrator** but not the **Global Reader** role.

    >**Note**: You will now approve the Global Reader role.

10. Sign out of the Azure portal as **aaduser2**.

11. In the InPrivate browser, sign into the Azure portal at **`https://portal.azure.com/`** as **aaduser3**.

    >**Note**: If you run into problems with authenticating by using any of the user accounts, you can sign in to the Microsoft Entra tenant by using your user account to reset their passwords or reconfigure their sign-in options.

12. In the Azure portal, navigate to **Microsoft Entra Privileged Identity Management** (In the Search resources, services, and docs text box at the top of the Azure portal page, type Microsoft Entra Privileged Identity Management and press the Enter key).

13. On the **Privileged Identity Management \| Quick start** blade, in the **Tasks** section, click **Approve requests**.

14. On the **Approve requests \| Microsoft Entra ID roles** blade, in the **Requests for role activations** section, select the checkbox for the entry representing the role activation request to the **Global Reader** role by **aaduser2**.

15. Click **Approve**. On the **Approve Request** blade, in the **Justification** text box, type a reason for activation, note the start and end times, and then click **Confirm**. 

    >**Note**: You also have the option of denying requests.

16. Sign out of the Azure portal as **aaduser3**.

17. In the InPrivate browser, sign into the Azure portal at **`https://portal.azure.com/`** as **aaduser2**

18. In the Azure portal, navigate to **Microsoft Entra Privileged Identity Management** (In the Search resources, services, and docs text box at the top of the Azure portal page, type Microsoft Entra Privileged Identity Management and press the Enter key).

19. On the **Privileged Identity Management \| Quick start** blade, in the **Tasks** section, click **My roles**.

20. On the **My roles \| Microsoft Entra ID roles** blade, click the **Active Assignments** tab and verify that the Global Reader role is now active.

    >**Note**: You might have to refresh the page to view the updated list of active assignments.

21. Sign out and close the InPrivate browser window.

> Result: You have practiced activating PIM roles with and without approval. 

### Exercise 3 - Create an Access Review and review PIM auditing features

#### Estimated timing: 10 minutes

In this exercise, you will complete the following tasks:

- Task 1: Configure security alerts for Microsoft Entra ID roles in PIM
- Task 2: Review PIM alerts, summary information, and detailed audit information

#### Task 1: Configure security alerts for Microsoft Entra ID roles in PIM

In this task, you will reduce the risk associated with "stale" role assignments. You will do this by creating a PIM access review to ensure that assigned roles are still valid. Specifically, you will review the Global Reader role. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`** using your account.

    >**Note**: Ensure that you are signed-in to the **AdatumLab500-04** Microsoft Entra tenant. You can use the **Directory + subscription** filter to switch between Microsoft Entra tenants. Ensure you are signed in as a user with the Global Administrator role.
    
    >**Note**: If you still don't see the AdatumLab500-04 entry, click on the Switch Diretory link, select the AdatumLab500-04 line and click the Switch button.

2. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Microsoft Entra Privileged Identity Management** and press the **Enter** key.

3. Navigate to the **Privileged Identity Management** blade. 

4. On the **Privileged Identity Management \| Quick start** blade, in the **Manage** section, click **Microsoft Entra Roles**.

5. On the **AdatumLab500-04 \| Quick start** blade, in the **Manage** section, click **Access reviews**.

6. On the **AdatumLab500-04 \| Access reviews** blade, click **New**:

7. On the **Create an access review** blade, specify the following settings (leave others with their default values): 

   |Setting|Value|
   |---|---|
   |Review name|**Global Reader Review**|
   |Start Date|today's date| 
   |Frequency|**One time**|
   |End Date|end of the current month|
   |Role, Select Privileged Role(s)|**Global Reader**|
   |Reviewers|**Selected users**|
   |Select reviewers|your account|

8. On the **Create an access review** blade, click **Start**:
 
    >**Note**: It will take about a minute for the review to deploy and appear on the **AdatumLab500-04 \| Access reviews** blade. You might have to refresh the web page. The review status will be **Active**. 

9. On the **AdatumLab500-04 \| Access reviews** blade, under the **Global Reader Review** header, click the **Global Reader** entry. 

10. On the **Global Reader Review** blade, examine the **Overview** page and note that the **Progress** charts shows a single users in the **Not reviewed** category. 

11. On the **Global Reader Review** blade, in the **Manage** section, click **Results**. Note that aaduser2 is listed as having access to this role.

12. Click **view** on **aaduser2** line to view a detailed audit log with entries representing PIM activities that involve that user.

13. Navigate back to the **AdatumLab500-04 \| Access reviews** blade.

14. On the the **AdatumLab500-04 \| Access reviews** blade, in the **Tasks** section, click **Review access** and then, click the **Global Reader Review** entry. 

15. On the **Global Reader Review** blade, click the **aaduser2** entry. 

16. In the **Reason** text box, type a rationale for approval and then click either **Approve** to maintain the current role membership or **Deny** to revoke it. 

17. Navigate back to the **Privileged Identity Management** blade and, in the **Manage** section, click **Microsoft Entra ID roles**.

18. On the **AdatumLab500-04 \| Quick start** blade, in the **Manage** section, click **Access reviews**.

19. Select the entry representing the **Global Reader** review. Note that the **Progress** chart has been updated to show your review. 

#### Task 2: Review PIM alerts, summary information, and detailed audit information. 

In this task, you will review PIM alerts, summary information, and detailed audit information. 

1. Navigate back to the **Privileged Identity Management** blade and, in the **Manage** section, click **Microsoft Entra ID roles**.

2. On the **AdatumLab500-04 \| Quick start** blade, in the **Manage** section, click **Alerts**, and then click **Setting**.

3. On the **Alert settings** blade, review the preconfigured alerts and risk levels. Click on any of them for more detailed information. 

4. Return to the **AdatumLab500-04 \| Quick start** blade and click **Overview**. 

5. On the **AdatumLab500-04 \| Overview** blade, review summary information about role activations, PIM activities, alerts, and role assignments.

6. On the **AdatumLab500-04 \| Overview** blade, in the **Activity** section, click **Resource audit**. 

    >**Note**: Audit history is available for all privileged role assignments and activations within the past 30 days.

7. Notice you can retrieve detailed information, including **Time**, **Requestor**, **Action**, **Resource name**, **Scope**, **Primary Target** and **Subject**. 

> Result: You have configured an access review and reviewed audit information. 

**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 

1. In the Azure portal, set the **Directory + subscription** filter to the the Microsoft Entra tenant associated with the Azure subscription into which you deployed the **az500-04-vm1** Azure VM.

    >**Note**: If you don't see your main Microsoft Entra tenant entry, click on the Switch Diretory link, select your main tenant line and click the Switch button.

2. In the Azure portal, open the Cloud Shell by clicking the first icon in the top right of the Azure Portal. If prompted, click **PowerShell** and **Create storage**.

3. Ensure **PowerShell** is selected in the drop-down menu in the upper-left corner of the Cloud Shell pane.

4. In the PowerShell session within the Cloud Shell pane, run the following to remove the resource group you created in the previous lab:
  
    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB04" -Force -AsJob
    ```

5. Close the **Cloud Shell** pane. 

6. Back in the Azure portal, use the **Directory + subscription** filter to switch to the **AdatumLab500-04** AMicrosoft Entra tenant.

7. Navigate to the **AdatumLab500-04 Microsoft Entra** blade and, in the **Manage** section, click **Licenses**.

8. On the **Licenses** | Overview blade, click **All products**, select the checkbox of **Microsoft Entra ID P2** and click it to open.

    >**Note**: In the Lab 2 - Exercise 2 - Task 4 **Assign Microsoft Entra ID P2 licenses to Microsoft Entra users** was to assign the Premium Licenses to the users **aaduser1, aaduser2, and aaduser3**, make sure we remove those licenses from the assigned users

9. On the **Microsoft Entra ID P2 - Licensed users** blade, select the checkboxes of the user accounts to which you assigned **Microsoft Entra ID P2** licenses. Click **Remove license** from the top pane and when prompted to confirm, select **Yes**.

10. In the Azure portal, navigate to the **Users - All users** blade, click the entry representing the **aaduser1** user account, on the **aaduser1 - Profile** blade click **Delete**, and, when prompted to confirm, select **Yes**.

11. Repeat the same sequence of steps to delete the remaining user accounts you created.

12. Navigate to the **AdatumLab500-04 - Overview** blade of the Microsoft Entra tenant, select **Manage tenants** and then on the next screen, select the checkbox next to **AdatumLab500-04** and select **Delete**. On the **Delete tenant 'AdatumLab500-04'** blade, select **Get permission to delete Azure resources** link, on the **Properties** blade of AMicrosoft Entra ID, set **Access management for Azure resources** to **Yes** and select **Save**.

13. Sign out from the Azure portal and sign in back. 

14. Navigate back to the **Delete directory 'AdatumLab500-04'** blade and click **Delete**.

    >**Note**: Still not able to delete the tenant and throwing an error **Delete all license-based and subscriptions**, then it might be due to any subscriptions that have been linked to the tenant. Here **Free P2 license** could be throwing the validation error. Deleting the trial subscription of the P2 License using the Global admin id from the M365 admin>> **Your Products** and from the **Business Store** portal would solve this issue. Also note that deleting the tenant takes more time. Check the End date of the subscription, once after the end of the trial period, revisit Microsoft Entra ID and then try to delete the tenant.    

> For any additional  information regarding this task, refer to [https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-delete-howto](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-delete-howto)
