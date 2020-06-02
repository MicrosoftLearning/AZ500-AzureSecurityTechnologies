---
lab:
    title: '04 - MFA, Conditional Access and AAD Identity Protection'
    module: 'Module 01 - Manage Identity and Access'
---

# Lab 04: MFA, Conditional Access and AAD Identity Protection

# Student lab manual

Lab files:

-  **2020\\Allfiles\\Labs\\LAB_04\\az-101-04b_azuredeploy.json**
-  **2020\\Allfiles\\Labs\\LAB_04\\az-101-04b_azuredeploy.parameters.json**

## Lab scenario

You have been asked to create a proof of concept xxxx. Specifically, you want to:

- xxx
- xxx
- xxx

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is the region to use for class. 

## Lab Objectives

In this lab, you will complete:

- Exercise 0: Deploy an Azure VM by using an Azure Resource Manager template
- Exercise 1: Implement Azure MFA
- Exercise 2: Implement Azure AD Conditional Access Policies 
- Exercise 3: Implement Azure AD Identity Protection

## Exercise 0: Deploy an Azure VM by using an Azure Resource Manager template

### Estimated timing: 10 minutes

In this exercise, you will complete:

- Task 1: Deploy an Azure VM by using an Azure Resource Manager template.

#### Task 1: Deploy an Azure VM by using an Azure Resource Manager template

In this task, you will create a virtual machine from an ARM template. This machine will be used in the last exercise for this lab. 

> You must sign-in to the Portal using a Microsoft account that has the Owner role in the Azure subscription you are using.

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

1. From the Portal menu select **Create a resource**.

1. Search for and select **Template deployment (deploy using custom templates)**.

1. Click **Create**.

1. On the **Custom deployment** blade, select the **Build your own template in the editor**.

1. From the **Edit template** blade, click **Load file** and locate the **2020\\Allfiles\\Labs\\LAB_04\\az-500-04_azuredeploy.json** file.

     > Review the content of the template and note that it deploys an Azure VM hosting Windows Server 2016 Datacenter.

1. **Save** the template to return to the **Custom deployment** blade.

1. From the **Custom deployment** blade, select **Edit parameters**.

1. From the **Edit parameters** blade, click **Load file** and open the **2020\\Allfiles\\Labs\\LAB_04\\az-500-04_azuredeploy.parameters.json** file.

	> Review the content of the parameters file noting the adminUsername and adminPassword values.

1. **Save** the parameters file to return to the **Custom deployment** blade.

1. From the **Custom deployment** blade, complete the **Basics** tab information.

    - Subscription: <name of the subscription you are using in class>
    
	- Resource group: **Create new** and name it **AZ500LAB04**
    
	- Location: <ask your instructor for the Azure region closest to the lab location>
    
	- Vm Size: **Standard_DS1_v2**
    
	- Vm Name: **az500-04-vm1**
    
	- Admin Username: **Student**
    
	- Admin Password: **Pa55w.rd**
    
	- Virtual Network Name: **az500-04-vnet1**

	> To identify Azure regions where you can provision Azure VMs, refer to [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

1. Click **Review + create** and then click **Create**. 

	> Do not wait for the deployment to complete but proceed to the next exercise. You will use the virtual machine included in this deployment in the last exercise of this lab.

> Result: You have initiated a template deployment of an Azure VM **az500-04-vm1** that you will use in the next exercise of this lab.


## Exercise 1: Implement Azure MFA

### Estimated timing: 30 minutes

In this exercise, you will complete:

- Task 1: Create a new Azure AD tenant.
- Task 2: Activate Azure AD Premium v2 trial.
- Task 3: Create Azure AD users and groups.
- Task 4: Assign Azure AD Premium v2 licenses to Azure AD users.
- Task 5: Configure Azure MFA settings.
- Task 6: Validate MFA configuration

#### Task 1: Create a new Azure AD tenant

In this task, you will create a new Azure AD tenant. 

1. In the Azure portal, select **Create a resource**.

1. From the **New** blade, search Azure Marketplace for **Azure Active Directory** and select it from the drop-down menu.

1. Click **Create**.

1. From the **Create tenant** blade, complete the configuration settings.

  - Organization name: **AdatumLab500-04**
  - Initial domain name: <a unique name consisting of a combination of letters and digits>
  - Country or region: **United States**

	> Make a note of the initial domain name. You will need it later in this lab.

1. Click **Create**.

1. Use the **Notification** icon to view the deployment status. 

1. Wait for the new tenant to be created. 

#### Task 2: Activate Azure AD Premium v2 trial

In this task, you will sign up for the Azure AD Premium P2 free trial. 

1. In the Azure portal select the **Directory + subscription** icon. This icon is located next to the Cloud icon on the Azure portal tool bar. 

1. Select your new tenant, **AdatumLab500-04**.

	> You may need to refresh the browser window if the **AdatumLab500-04** entry does not appear in the **Directory + subscription** filter list.

1. Under **Manage**, select **Licenses**.

1. Under **Manage** select **All products**.

1. Click **+ Try / Buy**.

1. Under Azure AD Premium P2, click **Free Trial** , and then click **Activate**.


#### Task 3: Create Azure AD users and groups.

In this task, you will create three users: aaduser1 (Global Admin), aaduser2 (user), and aaduser3 (user). You will need each user's principal name and password for later tasks. 

1. Return to the **AdatumLab500-04** Azure Active Directory page. 

1. Under **Manage** select **Users**.

1. Click **New User**,complete the new user configuration settings, and then click **Create**.

    - User name: **aaduser1** 
	
	> The full user principal name is the username@your_domain_name. You will need this later in this lab. 
    
	- Name: **aaduser1**
    
	- Password: Select the option **Auto-generate password**, select **Show Password**
	
	> Make a note of the user's password. You will need this later in this lab. 
    
	- Groups: **0 groups selected**
    
	- Roles: Select **user**, then select **Global administrator**, and **Select**. 
    
	- Usage Location: **United States**  

1. Click **New User**,complete the new user configuration settings, and then click **Create**.

    - User name: **aaduser2** 
	
	> The full user principal name is the username@your_domain_name. You will need this later in this lab. 
    
	- Name: **aaduser2**
    
	- Password: Select the option **Auto-generate password**, select **Show Password**
	
	> Make a note of the user's password. You will need this later in this lab. 
    
	- Groups: **0 groups selected**
    
	- Roles: Select **User**
    
	- Usage Location: **United States** 

1. Click **New User**,complete the new user configuration settings, and then click **Create**.

    - User name: **aaduser3** 
	
	> The full user principal name is the username@your_domain_name. You will need this later in this lab. 
    
	- Name: **aaduser3**
    
	- Password: Select the option **Auto-generate password**, select **Show Password**
	
	> Make a note of the user's password. You will need this later in this lab. 
    
	- Groups: **0 groups selected**
    
	- Roles: Select **User**
    
	- Usage Location: **United States** 

	> At this point, you should have three new users on the **Users** page. 
	
#### Task 4: Assign Azure AD Premium v2 licenses to Azure AD users

In this task, you will assign each user to the Azure Active Directory Premium P2 license.

1. For each user, aaduser1, adduser2, and aaduser3, do the following steps.

	- Select the user. 
	
	- Under **Manage**, select **Licenses**.
	
	- Click **Assignments**, and check the box for ***Azure Active Directory Premium P2**.
	
	- Ensure all the licensing options are selected, including Microsoft Azure Multi-Factor Authentication.
	
	- Click **Save**. 

1. Your account should also be listed on the **Users** page.

2. Select your account, and under **Settings** use the drop-down to change the **Usage location** to **United States**.

1. Be sure to **Save** the location change.

1. Under **Licenses** assign yourself to the **Azure Active Directory Premium P2** license.

1. **Save** your licenses assignments.

1. Sign out from the portal and sign back in using the same account you are using for this lab. This step is necessary in order for the license assignment to take effect.

	> At this point, you have assign all the new users and yourself to the Azure Active Directory Premium P2 license. Be sure to sign out and then sign back in. 

#### Task 5: Configure Azure MFA settings.

In this task, you will configure MFA and enable MFA for aaduser1. 

1. In the Azure portal, navigate to the **Azure Active Directory**. 

	> Make sure you are in the AdatumLab500-04 Azure AD tenant.

1. Under **Manage** click **Security**.

1. Under **Manage** click **MFA**.

1. Under **Configure** select the link **Additional cloud-based MFA settings**. This will bring up a separate tab to configure MFA.

	> The next steps are in the MFA separate tab.

1. Select the **service settings** tab. Review the **verification options**. Note that **Text message to phone**, **Notification through mobile app**, and **Verification code from mobile app or hardware token** are enabled. Click **Save**.

1. Switch to the **users** tab, select **aaduser1** entry, and **Enable** (link on the right) MFA.

1. Notice the **Multi-Factor Auth status** column for **aaduser1** is now **Enabled**.

1. Select **aaduser1** and notice there is now an **Enforced** option. 

     > Changing the user status from Enabled to Enforced impacts only legacy Azure AD integrated apps which do not support Azure MFA and, once the status changes to Enforced, requires the use of app passwords.

1. For **aaduser1** select **Manage user settings** and review the options: 

    - Require selected users to provide contact methods again.
    - Delete all existing app passwords generated by the selected users.
    - Restore multi-factor authentication on all remembered devices.

1. Click **Cancel** and switch back to the Azure portal.

1. In the Azure portal, navigate to the **Azure Active Directory** blade.

	> Make sure you are in the AdatumLab500-04 Azure AD tenant.

1. Under **Manage** select **Security**.

1. Under **Manage** select **MFA**.

1. Under **Settings** click **Fraud alert** and configure the settings.

    - Allow users to submit fraud alerts: **On**
    - Automatically block users who report fraud: **On**
    - Code to report fraud during initial greeting: **0**

1. Click **Save**

	> At this point, you have enabled MFA for aaduser1 and setup fraud alert settings. 

#### Task 6: Validate MFA configuration

In this task, you will validate the MFA configuration by testing a user as they sign in with MFA for the first time. 

1. Open an InPrivate Microsoft Edge window.

1. Navigate to the Azure portal and sign in using the **aaduser1** user account. 

     > To sign in you will need to provide a fully qualified name of the **aaduser1** user account, including the Azure AD tenant DNS domain name, as noted earlier in this lab.For example, aaduser1@adatumlab50004.onmicrosoft.com where you replace **adatumlab50004** with your unique domain name. 

1. When prompted with the **More information required** message, continue to the **Additional security verification** page by clicking **Next** .

1. On the **How should we contact you?** page, note that you need to set up one of the following options:

    - **Authentication phone**
    - **Mobile app**

1. Select the **Authentication phone** option with the **Send me a code by text message** method.

1. Provide your phone number, click **Next**, and then provide the code that is texted to your phone. 

1. After you have verified your phone number, read the Additional security verification page and then click **Done**.

1. When prompted, update your password. Make a note of the new password.

1. Verify that you successfully signed in to the Azure portal.

1. Sign out as **aaduser1** and close the InPrivate browser window.

	> Result: You have created a new AD tenant, configured AD users, configured MFA, and tested the MFA experience for a user. 


## Exercise 2: Implement Azure AD Conditional Access Policies 

### Estimated timing: 15 minutes

In this exercise, you will complete: 

- Task 1: Configure a conditional access policy.
- Task 2: Test the conditional access policy.

#### Task 1 - Configure a conditional access policy. 

In this task, you will review conditional access policy settings and create a policy that requires MFA when signing in to the Portal. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

	> Ensure that you are signed-in to the **AdatumLab500-04** Azure AD tenant. You can use the **Directory + subscription** filter to switch between Azure AD tenants. Ensure you are signed in as the tenant owner.

1. Navigate to  **Azure Active Directory**.

1. Under **Manage** select **Security**.

1. Under **Protect** select **Conditional access**.

1. Select **New Policy** and complete the configuration settings.

	- Name: **AZ500Policy1**
	
	- Users and groups > Select users and groups > Users and Groups > Select: **aaduser2**, **Select** > **Done**. 
	
	- Cloud apps or actions > Select apps > Select: **Microsoft Azure Management** > **Select** > Review the warning that this policy impacts Portal access > Select **Done**
	
	- Conditions > Sign-in risk > Review the risk levels > Do not make any changes
	
	- Device platforms > Review the devices that can included, such as Android and iOS.
	
	- Locations > Review the location selections.
	
	- Under **Access controls** click **Grant**.
	
	- Review the Grant options such as MFA. You may require one or more of the controls.
	
	- Select **Require multi-factor authentication** > **Select**
	
	- For **Enable policy** select **On**. 

1. Click **Create**. 

	> If you get an error stating that "Security defaults must be disabled to enable Conditional access policy". you will need to add the following step. From **Azure Active Directory** > **Properties**  > **Manage Security defaults**. Change to **No** > **My Organization is using Conditional Access** > Click **Save**. You can change this back after the lab ends.

	> At this point, you have a conditional access policy that requires MFA to sign in to the Portal. 

#### Task 2 - Test the conditional access policy.

In this task, you will sign in to the Portal as **aaduser2** and verify MFA is required. You will also delete the policy before continuing on to the next exercise. 

1. Open an InPrivate Microsoft Edge window.

1. In the new browser window, navigate to the Azure portal and sign in with the **aaduser2** user account.

1. When prompted with the **More information required** message, continue to the **Additional security verification** page by clicking **Next** .

1. On the **How should we contact you?** page, select the **Authentication phone** option with the **Send me a code by text message** method.

1. Provide your phone number, click **Next**, and then provide the code that is texted to your phone. 

1. After you have verified your phone number, read the Additional security verification page and then click **Done**.

1. When prompted, update your password. Make a note of the new password.

1. Change the users password and take note of the new password.

	> You have now verified that your conditional access policy has enforced MFA when aaduser2 signs into the Azure portal.

1. Sign **aaduser2** out of the Portal.

2. Sign in to the Portal with your subscription account. Notice you are not prompted for MFA. 

1. Navigate to **Azure Active Directory**.

1. Under **Manage** select **Security**.

1. Under **Protect** select **Conditional access**.

1. Click the ellipsis next to **AZ500Policy1** and select **Delete**.

1. Confirm that the policy should be deleted. 

	> Result: In this exercise you implement a conditional access policy to require MFA when a user signs into the portal. 

## Exercise 3: Implement Azure AD Identity Protection

### Estimated timing: 30 minutes

In this exercise, you will complete: 

- Task 1: View Azure AD Identity Protection options in the Portal
- Task 2: Configure a user risk policy
- Task 3: Configure a sign-in risk policy
- Task 4: Simulate risk events against the Azure AD Identity Protection policies 
- Task 5: Review the Azure AD Identity Protection reports

#### Task 1: Enable Azure AD Identity Protection

In this task, you will view the Azure AD Identity Protection options in the Portal. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

	> Ensure that you are signed-in to the **AdatumLab500-04** Azure AD tenant. You can use the **Directory + subscription** filter to switch between Azure AD tenants. Ensure you are signed in as the tenant owner.

1. From the Portal menu (top left), select **All services**.

1. Search for and select **Azure AD Identity Protection**.

1. Select the **Azure AD Identity Protection** in the list of search results.

1. Review the **Protect**, **Report**, and **Notify** options. 

#### Task 2: Configure a user risk policy

In this task, you will create a user risk policy. 

1. Proceed from the **Azure AD Identity Protection** blade.

1. Under **Protect** select **user risk policy**

1. Configure the **User risk remediation policy**. As you make your selections click **Done** to save. 

    - Assignments (Users)	
    	- Include tab: **All users**
		- Exclude tab: Exclude your current admin account to avoid getting locked out of the tenant.
	
	- Assignment (Conditions):
		- User risk level: **Low and above**
    
	- Controls (Access):
		- **Allow access**
		- **Require password change**
    
	- Enforce Policy: **On**

1. Once your user policy is configured, click **Save**.


#### Task 3: Configure sign-in risk policy

In this task, you will configure a sign-in risk policy. 

1. Proceed from the **Azure AD Identity Protection** blade.

1. Under **Protect** select **Sign-in risk policy**

1. Configure the **Sign-in risk remediation policy**. As you make your selections click **Done** to save. 

	- Assignments (Users): 
    	- Include tab: **All users**
	- Assignment (Conditions):
		- User risk: **Medium and above**
  	- Controls:
		- **Allow access**
		- **Require multi-factor authentication**
    - Enforce Policy: **On**

1. Once your user policy is configured, click **Save**.


#### Task 4: Simulate risk events against the Azure AD Identity Protection policies 

> Before you start this task, ensure that the template deployment you started in Exercise 0 has completed. You should have a running virtual machine named **az500-04-vm1**. 

1. In the Azure portal, set the **Directory + subscription** filter to the **Default Directory** (the original Azure AD tenant.)

1. Use the Portal menu (top left) to select **Virtual machines**. 

1. Select the **az500-04-vm1** virtual machine. 

1. From the **Overview** blade, click **Connect** and **RDP**. 

1. Click **Download RDP file** and open the file.

1. In the **Remote Desktop Connection** dialog select **Connect**.

1. Select **More choices** and then **Use a different account**.

	- Email address: **Student**
    - Password: **Pa55w.rd**

1. Click **OK** and click **Yes** to verify the identity of the virtual machine. 

1. Wait for the Remote Desktop session and **Server Manager** to load.  

	> The following steps are performed in the virtual machine remote desktop session. 

1. In **Server Manager**, click **Local Server** (left pane) and then click **IE Enhanced Security Configuration**.

1. In the dialog box, set both options to **Off** and click **OK**.

1. Open **Internet Explorer**, if prompted to set up IE11 select **Ask me later.**.

1. From **Settings**, select **Safety** and **InPrivate Browsing**.

1. Browse to the ToR Browser Project at [**https://www.torproject.org/projects/torbrowser.html.en**](https://www.torproject.org/projects/torbrowser.html.en).

1. Download and install the Windows version of the ToR Browser. Use the default options. 

1. Once the installation completes, start the ToR Browser, use the **Connect** option on the initial page, and browse to the Application Access Panel at [**https://myapps.microsoft.com**](https://myapps.microsoft.com).

1. When prompted, sign in with the **aaduser3** account. When prompted to change to your password, do so. 

	> You will be presented with the message **Your sign-in was blocked**. This is expected, since this account is not configured with multi-factor authentication, which is required due to increased sign-in risk associated with the use of ToR Browser.

1. Use the **Sign out and sign in with a different account option** to sign in as **aaduser1** account you created and configured for multi-factor authentication in the previous exercise.

	> This time, you will be presented with the **Suspicious activity detected** message. Again, this is expected, since this account is configured with multi-factor authentiation. Considering the increased sign-in risk associated with the use of ToR Browser, you will have to use multi-factor authentication.

1. Use the **Verify** option and specify whether you want to verify your identity via text or a call.

1. Complete the verification and ensure that you successfully signed in to the Application Access Panel.

1. Close your RDP session. 

	> At this point, you have generated several sign attempts to to the Portal. Next, you will review the Azure Identity Protection reports.

#### Task 5: Review the Azure AD Identity Protection reports

In this task, you will review the Azure AD Identity Protection reports generated from the ToR browser logins.

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

	> Ensure that you are signed-in to the **AdatumLab500-04** Azure AD tenant. You can use the **Directory + subscription** filter to switch between Azure AD tenants. Ensure you are signed in as the tenant owner.

1. Navigate to **Azure AD Identity Protection**.

1. Under **Reports** select **Risky users**. 

1. Review the entries for **aaduser3**. 

1. Under **Reports** select **Risky sign-ins**.

1. Review the entries for failed and successful logins.

1. Under **Reports** select **Risk detections**.

1. Notice any **Sign-in from anonymous IP address** entries. 

	> Result: You have enabled Azure AD Identity Protection, configured user risk policy and sign-in risk policy, as well as validated Azure AD Identity Protection configuration by simulating risk events.

**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 

These steps disable the identity protection policies in the **AdatumLab500-04** Azure AD tenant.

1. From the **Azure AD Identity Protection** blade.

1. Under **Protect** select **user risk policy**.

1. Set **Enforce policy** to **off** and then click **Save**.

1. Under **Protect** select **Sign-in risk policy**

1. Set **Enforce policy** to **off** and then click **Save**.

These steps stop the virtual machine in the original lab subscription Azure AD tenant. 

1. From the **Virtual machine** blade.

1. Select the **az500-04-vm1** virtual machine and select **Stop**. 

1. Click **OK** to deallocate the virtual machine. 

>  Do not remove any other resources from this lab as the PIM lab has a dependency on it.