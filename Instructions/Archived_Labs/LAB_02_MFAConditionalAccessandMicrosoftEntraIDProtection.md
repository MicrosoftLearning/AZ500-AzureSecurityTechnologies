---
lab:
    title: '02 - MFA, and Conditional Access'
    module: 'Module 01 - Manage Identity and Access'
---

# Lab 02: MFA, and Conditional Access
# Student lab manual

## Lab scenario

You have been asked to create a proof of concept of features that enhance Microsoft Entra ID authentication. Specifically, you want to evaluate:

- Microsoft Entra ID multi-factor authentication
- Microsoft Entra ID conditional access
- Microsoft Entra ID conditional access risk-based policies

> For all the resources in this lab, we are using the **East US** region. Verify with your instructor this is the region to use for class. 

## Lab Objectives

In this lab, you will complete the following exercises:

- Exercise 1: Deploy an Azure VM by using an Azure Resource Manager template
- Exercise 2: Implement Azure MFA
- Exercise 3: Implement Microsoft Entra ID Conditional Access Policies 
- Exercise 4: Implement Microsoft Entra ID Identity Protection

## MFA - Conditional Access - Identity Protection diagram

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/246a3798-6f50-4a41-99c2-71e9ab6a4c8f)

## Instructions

## Lab files:

- **\\Allfiles\\Labs\\04\\az-500-04_azuredeploy.json**
- **\\Allfiles\\Labs\\04\\az-500-04_azuredeploy.parameters.json** 

### Exercise 1: Deploy an Azure VM by using an Azure Resource Manager template

### Estimated timing: 10 minutes

In this exercise, you will complete the following tasks:

- Task 1: Deploy an Azure VM by using an Azure Resource Manager template.

#### Task 1: Deploy an Azure VM by using an Azure Resource Manager template

In this task, you will create a virtual machine by using an ARM template. This virtual machine will be used in the last exercise for this lab. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

    >**Note**: Sign in to the Azure portal using an account that has the Owner or Contributor role in the Azure subscription you are using for this lab and the Global Administrator role in the Microsoft Entra ID tenant associated with that subscription.

2. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Deploy a custom template**.

    >**Note**: You can also select **Template Deployment (deploy using custom templates)** from the **Marketplace** list.

3. On the **Custom deployment** blade, click the **Build your own template in the editor** option.

4. On the **Edit template** blade, click **Load file**, locate the **\\Allfiles\\Labs\\04\\az-500-04_azuredeploy.json** file and click **Open**.

    >**Note**: Review the content of the template and note that it deploys an Azure VM hosting Windows Server 2019 Datacenter.

5. On the **Edit template** blade, click **Save**.

6. Back on the **Custom deployment** blade, click **Edit parameters**.

7. On the **Edit parameters** blade, click **Load file**, locate the **\\Allfiles\\Labs\\04\\az-500-04_azuredeploy.parameters.json** file and click **Open**.

    >**Note**: Review the content of the parameters file noting the adminUsername and adminPassword values.

8. On the **Edit parameters** blade, click **Save**.

9. On the **Custom deployment** blade, ensure that the following settings are configured (leave any others with their default values):

   >**Note**: You will need to create a unique password that will be used for creating VMs (virtual machines) for the rest of the course. The password must be at least 12 characters long and meet the defined complexity requirements (Password must have 3 of the following: 1 lower case character, 1 upper case character, 1 number, and 1 special character). [VM password requirements](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/faq#what-are-the-password-requirements-when-creating-a-vm-). Please make a note of the password.

   |Setting|Value|
   |---|---|
   |Subscription|the name of the Azure subscription you will be using in this lab|
   |Resource group|click **Create new** and type the name **AZ500LAB04**|
   |Location|**East US**|
   |Vm Size|**Standard_D2s_v3**|
   |Vm Name|**az500-04-vm1**|
   |Admin Username|**Student**|
   |Admin Password|**Please create your own password and record it for future reference. You will be prompted for this password for the required lab access.**|
   |Virtual Network Name|**az500-04-vnet1**|

   >**Note**: To identify Azure regions where you can provision Azure VMs, refer to [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

10. Click **Review + create**, and then click **Create**.

    >**Note**: Do not wait for the deployment to complete but proceed to the next exercise. You will use the virtual machine included in this deployment in the last exercise of this lab.

> Result: You have initiated a template deployment of an Azure VM **az500-04-vm1** that you will use in the last exercise of this lab.


### Exercise 2: Implement Azure MFA

### Estimated timing: 30 minutes

In this exercise, you will complete the following tasks:

- Task 1: Create a new Microsoft Entra ID tenant.
- Task 2: Activate Microsoft Entra ID P2 trial.
- Task 3: Create Microsoft Entra ID users and groups.
- Task 4: Assign Microsoft Entra ID P2 licenses to Microsoft Entra ID users.
- Task 5: Configure Azure MFA settings.
- Task 6: Validate MFA configuration

#### Task 1: Create a new Microsoft Entra ID tenant

In this task, you will create a new Microsoft Entra ID tenant. 

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Microsoft Entra ID** and press the **Enter** key.

2. On the blade displaying **Overview** of your current Microsoft Entra ID tenant, click **Manage tenants**, and then on the next screen, click **+ Create**.

3. On the **Basics** tab of the **Create a tenant** blade, ensure that the option **Microsoft Entra ID** is selected and click **Next: Configuration >**.

4. On the **Configuration** tab of the **Create a tenant** blade, specify the following settings:

   |Setting|Value|
   |---|---|
   |Organization name|**AdatumLab500-04**|
   |Initial domain name|a unique name consisting of a combination of letters and digits|
   |Country or region|**United States**|

    >**Note**: Record the initial domain name. You will need it later in this lab.

5. Click **Review + Create** and then click **Create**.
6. Add Captcha code on **Help us prove you're not a robot** blade and then click on **Submit** button. 

    >**Note**: Wait for the new tenant to be created. Use the **Notification** icon to monitor the deployment status. 


#### Task 2: Activate Microsoft Entra ID P2 trial

In this task, you will sign up for the Microsoft Entra ID P2 free trial. 

1. In the Azure portal, in the toolbar, click the **Directory + subscription** icon, located to the right of the Cloud Shell icon. 

2. In the **Directory + subscription** blade, click the newly created tenant **AdatumLab500-04** and click the **Switch** button to set it as the current directory.

    >**Note**: You may need to refresh the browser window if the **AdatumLab500-04** entry does not appear in the **Directory + subscription** filter list.

3. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Microsoft Entra ID** and press the **Enter** key. On the **AdatumLab500-04** blade, in the **Manage** section, click **Licenses**.

4. On the **Licenses \| Overview** blade, under **Quick tasks**, click **Get a free trial**.

5. Expand MICROSFT ENTRA ID P2, then click **Activate.**


#### Task 3: Create Microsoft Entra ID users and groups.

In this task, you will create three users: aaduser1 (Global Admin), aaduser2 (user), and aaduser3 (user). You will need each user's User principal name and password for later tasks. 

1. Navigate back to the **AdatumLab500-04** Microsoft Entra ID blade and, in the **Manage** section, click **Users**.

2. On the **Users \| All users** blade, click **+ New User** and then **Create new user**. 

3. On the **New user** blade, ensure that the **Create user** option is selected, and specify the following settings on the Basics tab (leave all others with their default values) and click **Next: Properties >**:

   |Setting|Value|
   |---|---|
   |User principal name|**aaduser1**|
   |Name|**aaduser1**|
   |Password|ensure that the option **Auto-generate password** is selected|
   
      >**Note**: Record the full User principal name. You can copy its value by clicking the **Copy to clipboard** button on the right-hand side of the drop-down list displaying the domain name. You will need this later in this lab.
   
      >**Note**: Record the user's password. You can copy its value by clicking the **Copy to clipboard** button on the right-hand side of the text box. You will need this later in this lab. 
   
4. On the **Properties** tab, scroll to the bottom and specify the Usage Location: **United States** (leave all others with their default values) and click **Next: Assignments >**.

5. On the **Assignments** tab, click **+ Add role** and search for and select **Global Administrator**. Click **Select** then **Review + create** and then **Create**.

6. Back on the **Users \| All users** blade, click **+ New User**. 

7. On the **New user** blade, ensure that the **Create user** option is selected, and specify the following settings (leave all others with their default values) and click **Next: Properties >**:

   |Setting|Value|
   |---|---|
   |User principal name|**aaduser2**|
   |Name|**aaduser2**|
   |Password|ensure that the option **Auto-generate password** is selected| 

    >**Note**: Record the full User principal name and the password.

8. On the **Properties** tab, scroll to the bottom and specify the Usage Location: **United States** (leave all others with their default values) and click **Review + create** and then **Create**.

9. Back on the **Users \| All users** blade, click **+ New User**. 

10. On the **New user** blade, ensure that the **Create user** option is selected, and specify the following settings (leave all others with their default values) and click **Next: Properties >**:

    |Setting|Value|
    |---|---|
    |User principal name|**aaduser3**|
    |Name|**aaduser3**|
    |Password|ensure that the option **Auto-generate password** is selected|

    >**Note**: Record the full User principal name and the password.

11. On the **Properties** tab, scroll to the bottom and specify the Usage Location: **United States** (leave all others with their default values) and click **Review + create** and then **Create**.

    >**Note**: At this point, you should have three new users listed on the **Users** page. 
	
#### Task 4: Assign Microsoft Entra ID Premium P2 licenses to Microsoft Entra ID users

In this task, you will assign each user to the Microsoft Entra ID Premium P2 license.

1. On the **Users \| All users** blade, click the entry representing your user account. 

2. On the blade displaying the properties of your user accounts, click **Edit properties**.  Confirm that the Usage Location is set to **United States**. If not, set the usage location and click **Save**.

3. Navigate back to the **AdatumLab500-04** Microsoft Entra ID blade and, in the **Manage** section, click **Licenses**.

4. On the **Licenses \| Overview** blade, click **All products**, select the **Microsoft Entra ID Premium P2** checkbox, and click **+ Assign**.

5. On the **Assign license** blade, click **+ Add users and groups**.

6. On the **Users** blade, select **aaduser1**, **aaduser2**, **aaduser3**, and your user account and click **Select**.

7. Back on the **Assign licenses** blade, click **Assignment options**, ensure that all options are enabled, click **Review + assign**, and then click **Assign**.

8. Sign out from the Azure portal and sign back in using the same account. (This step is necessary in order for the license assignment to take effect.)

    >**Note**: At this point, you assigned Microsoft Entra ID Premium P2 licenses to all user accounts you will be using in this lab. Be sure to sign out and then sign back in. 

#### Task 5: Configure Azure MFA settings.

In this task, you will configure MFA and enable MFA for aaduser1. 

1. In the Azure portal, navigate back to the **AdatumLab500-04** Microsoft Entra ID tenant blade.

    >**Note**: Make sure you are using the AdatumLab500-04 Microsoft Entra ID tenant.

2. On the **AdatumLab500-04** Microsoft Entra ID tenant blade, in the **Manage** section, click **Security**.

3. On the **Security \| Getting started** blade, in the **Manage** section, click **Multifactor authentication**.

4. On the **Multi-Factor Authentication \| Getting started** blade, click the **Additional cloud-based multifactor authentication settings** link. 

    >**Note**: This will open a new browser tab, displaying **Multifactor authentication** page.

5. On the **Multifactor authentication** page, click the **service settings** tab. Review **verification options**. Note that **Text message to phone**, **Notification through mobile app**, and **Verification code from mobile app or hardware token** are enabled. Click **Save** and then click **close**.

6. Switch to the **users** tab, click **aaduser1** entry, click the **Enable** link, and, when prompted, click **enable multi-factor auth** and then click **close**.

7. Notice the **Multi-Factor Auth status** column for **aaduser1** is now **Enabled**.

8. Click **aaduser1** and notice that, at this point, you also have the **Enforce** option. 

    >**Note**: Changing the user status from Enabled to Enforced impacts only legacy Microsoft Entra ID integrated apps which do not support Azure MFA and, once the status changes to Enforced, require the use of app passwords.

9. With the **aaduser1** entry selected, click **Manage user settings** and review the available options: 

   - Require selected users to provide contact methods again.

   - Delete all existing app passwords generated by the selected users.

   - Restore multi-factor authentication on all remembered devices.

10. Click **cancel** and switch back to the browser tab displaying the **Multi-Factor Authentication \| Getting started** blade in the Azure portal.

11. In the **Settings** section, click **Fraud alert**.

12. On the **Multi-Factor Authentication \| Fraud alert** blade, configure the following settings:

    |Setting|Value|
    |---|---|
    |Allow users to submit fraud alerts|**On**|
    |Automatically block users who report fraud|**On**|
    |Code to report fraud during initial greeting|**0**|

13. Click **Save**

    >**Note**: At this point, you have enabled MFA for aaduser1 and setup fraud alert settings. 

14. Navigate back to the **AdatumLab500-04** Microsoft Entra ID tenant blade, in the **Manage** section, click **Properties**, next click the **Manage Security defaults** link at the bottom of the blade, on the **Enable Security Defaults** blade, click **Disabled**. Select **My Organization is using Conditional Access** as the *Reason for disabling*, click **Save**, read the warning, and then click **Disable**.

    >**Note**: Ensure that you are signed-in to the **AdatumLab500-04** Microsoft Entra ID tenant. You can use the **Directory + subscription** filter to switch between Microsoft Entra ID tenants. Ensure you are signed in as a user with the Global Administrator role in the Microsoft Entra ID tenant.

#### Task 6: Validate MFA configuration

In this task, you will validate the MFA configuration by testing sign in of the aaduser1 user account. 

1. Open an InPrivate browser window.

2. Navigate to the Azure portal, **`https://portal.azure.com/`**, and sign in using the **aaduser1** user account. 

    >**Note**: To sign in you will need to provide a fully qualified name of the **aaduser1** user account, including the Microsoft Entra ID tenant DNS domain name, which you recorded earlier in this lab. This user name is in the format aaduser1@`<your_tenant_name>`.onmicrosoft.com, where `<your_tenant_name>` is the placeholder representing your unique Microsoft Entra ID tenant name. 

3. When prompted, in the **More information required** dialog box, click **Next**.

    >**Note**: The browser session will be redirected to the **Additional security verification** page.

4. On the **Keep your account secure** page, select the **I want to set up a different method** link, in the **Which method would you like to use?** drop-down list, select **Phone**, and select **Confirm**.

5. On the **Keep your account secure** page, select your country or region, type your mobile phone number in the **Enter phone number** area, ensure that the **Text me a code** option is selected, and click **Next**.
 
6. On the **Keep your account secure** page, type the code you received in the text message on your mobile phone, and click **Next**.

7. On the **Keep your account secure** page, ensure that the verification was successful and click **Next**.

8. If prompted for an additional authentication method, click **I want to use a different method**, select **Email** from the drop-down list, click **Confirm**, provide the  email address you intend to use, and click **Next**. Once you receive the corresponding email, identify the code in the email body, provide it, and then click **Done**.

9. When prompted, change your password. Make sure to record the new password.

10. Verify that you successfully signed in to the Azure portal.

11. Sign out as **aaduser1** and close the InPrivate browser window.

> Result: You have created a new AD tenant, configured AD users, configured MFA, and tested the MFA experience for a user. 


### Exercise 3: Implement Microsoft Entra ID Conditional Access Policies 

### Estimated timing: 15 minutes

In this exercise, you will complete the following tasks: 

- Task 1: Configure a conditional access policy.
- Task 2: Test the conditional access policy.

#### Task 1 - Configure a conditional access policy. 

In this task, you will review conditional access policy settings and create a policy that requires MFA when signing in to the Azure portal. 

1. In the Azure portal, navigate back to the **AdatumLab500-04** Microsoft Entra ID tenant blade.

2. On the **AdatumLab500-04** blade, in the **Manage** section, click **Security**.

3. On the **Security \| Getting started** blade, in the **Protect** section, click **Conditional Access**. In the left navigation panel, click **Policies**.

4. On the **Conditional Access \| Policies** blade, click **+ New policy**. 

5. On the **New** blade, configure the following settings:

   - In the **Name** text box, type **AZ500Policy1**
	
   - Under **Users**, click **0 Users and groups selected**. On the right side under Include, Enable **Select users and groups** >> select the **Users and Groups** checkbox, on the **Select users and groups** blade, select the **aaduser2** checkbox, and click **Select**.
	
   - Under **Target resources**, click **No target resources selected**, click **Select apps**, under Select, click **None**. On the **Select** blade, select the checkbox for **Windows Azure Service Management API** and click **Select**. 

     >**Note**: Review the warning that this policy impacts access to the Azure Portal.
	
   - Under **Conditions**, click **0 conditions selected**, under **Sign-in risk** click **Not configured**. On the **Sign-in risk** blade, review the risk levels but do not make any changes and close the **Sign-in risk** blade.
	
   - Under **Device platforms**, click **Not configured**, review the device platforms that can be included but do not make any changes and click **Done**.
	
   - Under **Locations**, click **Not configured** and review the location options without making any changes.
	
   - Under **Grant** in the **Access controls** section, click **0 controls selected**. On the **Grant** blade, select the **Require multi-factor authentication** checkbox and click **Select**
	
   - Set the **Enable policy** to **On**.

6. On the **New** blade, click **Create**. 

    >**Note**: At this point, you have a conditional access policy that requires MFA to sign in to the Azure portal. 

#### Task 2 - Test the conditional access policy.

In this task, you will sign in to the Azure portal as **aaduser2** and verify MFA is required. You will also delete the policy before continuing on to the next exercise. 

1. Open an InPrivate Microsoft Edge window.

2. In the new browser window, navigate to the Azure portal, **`https://portal.azure.com/`**, and sign in with the **aaduser2** user account.

3. When prompted, in the **More information required** dialog box, click **Next**.

    >**Note**: The browser session will be redirected to the **Keep your account secure** page.
    
4. On the **Keep your account secure** page, select the **I want to set up a different method** link, in the **Which method would you like to use?** drop-down list, select **Phone**, and select **Confirm**.

5. On the **Keep your account secure** page, select your country or region, type your mobile phone number in the **Enter phone number** area, ensure that the **Text me a code** option is selected, and click **Next**.

6. On the **Keep your account secure** page, type the code you received in the text message on your mobile phone, and click **Next**.

7. On the **Keep your account secure** page, ensure that the verification was successful and click **Next**.

8. On the **Keep your account secure** page, click **Done**.

9. When prompted, change your password. Make sure to record the new password.

10. Verify that you successfully signed in to the Azure portal.

11. Sign out as **aaduser2** and close the InPrivate browser window.

    >**Note**: You have now verified that the newly created conditional access policy enforces MFA when aaduser2 signs into the Azure portal.

12. Back in the browser window displaying the Azure portal, navigate back to the **AdatumLab500-04** Microsoft Entra ID tenant blade.

13. On the **AdatumLab500-04** blade, in the **Manage** section, click **Security**.

14. On the **Security \| Getting started** blade, in the **Protect** section, click **Conditional Access**. In the left navigation panel, click **Policies**.

15. On the **Conditional Access \| Policies** blade, click the ellipsis next to **AZ500Policy1**, click **Delete**, and, when prompted to confirm, click **Yes**.

    >**Note**: Result: In this exercise you implement a conditional access policy to require MFA when a user signs into the Azure portal. 

>Result: You have configured and tested Microsoft Entra ID conditional access.

### Exercise 4: Deploy risk-based policies in Conditional Access

### Estimated timing: 30 minutes

In this exercise, you will complete the following tasks:

- Task 1: View Microsoft Entra ID Identity Protection options in the Azure portal
- Task 2: Configure a user risk policy
- Task 3: Configure a sign-in risk policy
- Task 4: Simulate risk events against the Microsoft Entra ID Identity Protection policies 
- Task 5: Review the Microsoft Entra ID Identity Protection reports

#### Task 1: Enable Microsoft Entra ID Identity Protection

In this task, you will view the Microsoft Entra ID Identity Protection options in the Azure portal. 

1. If needed, sign-in to the Azure portal **`https://portal.azure.com/`**.

    >**Note**: Ensure that you are signed-in to the **AdatumLab500-04** Microsoft Entra ID tenant. You can use the **Directory + subscription** filter to switch between Microsoft Entra ID tenants. Ensure you are signed in as a user with the Global Administrator role in the Microsoft Entra ID tenant.

#### Task 2: Configure a user risk policy

In this task, you will create a user risk policy. 

1. Browse to **AdatumLab500-04** Microsoft Entra ID tenant > **Security** > **Conditional Access** > **Policies**.

2. Click **+ New policy**.

3. Type the following policy name in the **Name** text box, type **AZ500Policy2**.

4. Under **Assignments** > **Users**, click **0 Users and groups selected**.

5. Under **Include**, click **Select Users and groups**, click **Users and groups**, select **aaduser2** and **aaduser3** and then click **Select**.

6. Under **Exclude** click **Users and groups**, select **aaduser1** and then click **Select**. 

7. Under **Target resources**, click **No target resources selected**, confirm that **Cloud apps** is selected in the drop-down and, under **Include**, select **All cloud apps**.

8. Under **Conditions**, click **0 conditions selected**, under **User risk** click **Not configured**. On the **User risk** blade, set **Configure** to **Yes**.

9. Under **Configure user risk levels needed for policy to be enforced**, select **High**.

10. Click **Done**.

11. Under **Grant** in the **Access controls** section, click **0 controls selected**. On the **Grant** blade, confirm that **Grant access** is selected.

12. Select **Require multifactor authentication** and **Require password change**.

13. Click **Select**.

14. Under **Session**,  click **0 controls selected**. Select **Sign-in frequency** and then select **Every time**.

15. Click **Select**.

16. Confirm **Enable policy** is set to **Report-only**.

17. Click **Create** to enable your policy.

#### Task 3: Configure a sign-in risk policy

1. Browse to **AdatumLab500-04** Microsoft Entra ID tenant > **Security** > **Conditional Access**> **Policies**.

2. Select **+ New policy**.

3. Type the following policy name in the **Name** text box, type **AZ500Policy3**.

4. Under **Assignments** > **Users**, click **0 Users and groups selected**.

5. Under **Include**, click **Select Users and groups**, click **Users and groups**, select **aaduser2** and **aaduser3** and click **Select**.

6. Under **Exclude** click **Users and groups** select **aaduser1** and click **Select**. 

7. Under **Target resources**, click **No target resources selected**, confirm that **Cloud apps** is selected in the drop-down and, under **Include**, select **All cloud apps**.

8. Under **Conditions**, click **0 conditions selected**, under **Sign-in risk** click **Not configured**. On the **Sign-in risk** blade, set **Configure** to **Yes**.

9. Under **Select the sign-in risk level this policy will apply to**, select **High** and **Medium**.

10. Click **Done**.

11. Under **Grant** in the **Access controls** section, click **0 controls selected**. On the **Grant** blade, confirm that **Grant access** is selected.	

12. Select **Require multifactor authentication**.

13. Click **Select**.

14. Under **Session**,  click **0 controls selected**. Select **Sign-in frequency** and then select **Every time**.

15. Click **Select**.

16. Confirm your settings and set **Enable policy** to **On**.

17. Click **Create** to enable your policy.

#### Task 4: Simulate risk events against the Microsoft Entra ID Identity Protection policies 

> Before you start this task, ensure that the template deployment you started in Exercise 1 has completed. The deployment includes an Azure VM named **az500-04-vm1**. 

1. In the Azure portal, set the **Directory + subscription** filter to the Microsoft Entra ID tenant associated with the Azure subscription into which you deployed the **az500-04-vm1** Azure VM.

2. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Virtual machines** and press the **Enter** key.

3. On the **Virtual machines** blade, click the **az500-04-vm1** entry. 

4. On the **az500-04-vm1** blade, click **Connect**. Confirm that you are on the **RDP** tab.

5. Click **Download RDP File** and use it to connect to the **az500-04-vm1** Azure VM via Remote Desktop. When prompted to authenticate, provide the following credentials:

    |Setting|Value|
    |---|---|
    |User name|**Student**|
    |Password|**Please use your personal password created in Lab 02 > Exercise 1 > Task 1 > Step 9.**|

    >**Note**: Wait for the Remote Desktop session and **Server Manager** to load.  

    >**Note**: The following steps are performed in the Remote Desktop session to the **az500-04-vm1** Azure VM. 

6. In **Server Manager**, click **Local Server** and then click **IE Enhanced Security Configuration**.

7. In the **Internet Explorer Enhanced Security Configuration** dialog box, set both options to **Off** and click **OK**.

8. Start **Internet Explorer**, click the cog wheel icon in the toolbar, in the drop-down menu, click **Safety** and then click **InPrivate Browsing**.

9. In the InPrivate Internet Explorer window, navigate to the ToR Browser Project at **https://www.torproject.org/projects/torbrowser.html.en**.

10. Download and install the Windows version of the ToR browser with the default settings. 

11. Once the installation completes, start the ToR browser, use the **Connect** option on the initial page, and browse to the Application Access Panel at **https://myapps.microsoft.com**.

12. When prompted, attempt to sign in with the **aaduser3** account. 

    >**Note**: You will be presented with the message **Your sign-in was blocked**. This is expected, since this account is not configured with multi-factor authentication, which is required due to increased sign-in risk associated with the use of ToR browser.

13. In the ToR browser, select the back arrow to sign in as **aaduser1** account you created and configured for multi-factor authentication earlier in this lab.

    >**Note**: This time, you will be presented with the **Suspicious activity detected** message. Again, this is expected, since this account is configured with multi-factor authentication. Considering the increased sign-in risk associated with the use of ToR Browser, you will have to use multi-factor authentication.

14. Use the **Verify** option and specify whether you want to verify your identity via text or a call.

15. Complete the verification and ensure that you successfully signed in to the Application Access Panel.

16. Close your RDP session. 

    >**Note**: At this point, you attempted two different sign-ins. Next, you will review the Azure Identity Protection reports.

#### Task 5: Review the Microsoft Entra ID Identity Protection reports

In this task, you will review the Microsoft Entra ID Identity Protection reports generated from the ToR browser logins.

1. Back in the Azure portal, use the **Directory + subscription** filter to switch to the **AdatumLab500-04** Microsoft Entra ID tenant.

2. On the **AdatumLab500-04** blade, in the **Manage** section, click **Security**.

3. On the **Security \| Getting started** blade, in the **Report** section, click **Risky users**. 

4. Review the report and identify any entries referencing the **aaduser3** user account.

5. On the **Security \| Getting started** blade, in the **Reports** section, click **Risky sign-ins**. 

6. Review the report and identify any entries corresponding to the sign-in with the **aaduser3** user account.

7. Under **Reports** click **Risk detections**.

8. Review the report and identify any entries representing the sign-in from anonymous IP address generated by the ToR browser. 

    >**Note**: It may take 10-15 minutes for risks to show up in reports.

> **Result**: You have enabled Microsoft Entra ID Identity Protection, configured user risk policy and sign-in risk policy, as well as validated Microsoft Entra ID Identity Protection configuration by simulating risk events.

**Clean up resources**

> We need to remove identity protection resources that you no longer use. 

Use the following steps to disable the identity protection policies in the **AdatumLab500-04** Microsoft Entra ID tenant.

1. In the Azure portal, navigate back to the **AdatumLab500-04** Microsoft Entra ID tenant blade.

2. On the **AdatumLab500-04** blade, in the **Manage** section, click **Security**.

3. On the **Security \| Getting started** blade, in the **Protect** section, click **Identity Protection**.

4. On the **Identity Protection \| Overview** blade, click **User risk policy**.

5. On the **Identity Protection \| User risk policy** blade, set **Policy Enforcement** to **Disable** and then click **Save**.

6. On the **Identity Protection \| User risk policy** blade, click **Sign-in risk policy**.

7. On the **Identity Protection \| Sign-in risk policy** blade, set **Policy Enforcement** to **Disable** and then click **Save**.

Use the following steps to stop the Azure VM you provisioned earlier in the lab.

1. In the Azure portal, set the **Directory + subscription** filter to the Microsoft Entra ID tenant associated with the Azure subscription into which you deployed the **az500-04-vm1** Azure VM.

2. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Virtual machines** and press the **Enter** key.

3. On the **Virtual machines** blade, click the **az500-04-vm1** entry. 
 
4. On the **az500-04-vm1** blade, click **Stop** and, when prompted to confirm, click **OK** 

>  Do not remove any resources provisioned in this lab, since the PIM lab has a dependency on them.
