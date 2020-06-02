---
lab:
    title: '06 - Implement Directory Synchronization'
    module: 'Module 01 - Manage Identity and Access'
---

# Lab 06: Implement Directory Synchronization

# Student lab manual

## Lab scenario

You have been asked to create a proof of concept to demonstrate how on-premises passwords can be synchronized with Azure. Specifically, you want to:

- xx
- xx
- xx


> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete:

- Exercise 1: Deploy an Azure VM hosting an Active Directory domain controller
- Exercise 2: Create and configure an Azure Active Directory tenant
- Exercise 3: Synchronize Active Directory forest with an Azure Active Directory tenant

## Exercise 1: Deploy an Azure VM hosting an Active Directory domain controller

### Estimated timing: 10 minutes

In this exercise, you will complete:

- Task 1: Identify an available DNS name for an Azure VM deployment
- Task 2: Use an ARM template to deploy an Azure VM hosting an Active Directory domain controller

#### Task 1: Identify an available DNS name for an Azure VM deployment

In this task, you will identify a DNS name for your Azure VM deployment. 


1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

	> Ensure you are signed in using a Microsoft account that has the Owner role in the Azure subscription you intend to use in this lab and is a Global Administrator of the Azure AD tenant associated with that subscription.

1. Open the **Cloud Shell**.

1. 1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. Test the availability of your DNS name. Replace **custom-label** with a name that will be unique. The location is the region into which you want to deploy the Azure VM that will host an Active Directory domain controller.

    > To identify Azure regions where you can provision Azure VMs, refer to [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

	```powershell
	Test-AzDnsAvailability -DomainNameLabel <custom-label> -Location '<location>'
	```

1. Verify that the command returned **True**. If not, rerun the same command with a different value of the DomainNameLabel until the command returns **True**.

	> You will need the DomainNameLabel in the next task. 

1. Close the Cloud Shell.

#### Task 2: Use an ARM template to deploy an Azure VM hosting an Active Directory domain controller

In this task, you will deploy an Azure VM that will host an Active Directory domain controller

1. Continue in the Portal.

1. From the Portal menu select **Create a resource**.

1. Search for and select **Template deployment (deploy using custom templates)**.

1. Click **Create**.

1. Select **active-directory-new-domain** and click **Select template**.

	> You can also find this template in the following location at the GitHub Azure QuickStart Templates page at  [**https://github.com/Azure/azure-quickstart-templates/tree/master/active-directory-new-domain**](https://github.com/Azure/azure-quickstart-templates/tree/master/active-directory-new-domain).

1. On the **Create an Azure VM with a new AD Forest** blade, initiate a template deployment with the following settings. Take the default value for a setting that is not specified.

    - Resource group: Create new - **AZ500LAB06**

    - Location: **use the same region as the previous task**

    - Admin Username: **Student**

    - Admin Password: **Pa55w.rd**

    - Domain Name: **adatum.com**

    - Dns Prefix: the unique DomainNameLabel you identified in the previous task

    - VM Size: **Standard_D2s_v3**

    - Click on **I agree to the terms and conditions stated above**

    - Click **Purchase**

    > Do not wait for the deployment to complete but proceed to the next exercise. You will use the virtual machine deployed in this task in the third exercise of this lab. Also note it may take between 20 and 30 minutes for the configuration of the Domain Controller to complete)


> Result: After you completed this exercise, you have initiated deployment of an Azure VM that will host an Active Directory domain controller by using an Azure Resource Manager template



### Exercise 2: Create and configure an Azure Active Directory tenant

The main tasks for this exercise are as follows:

- Task 1: Create an Azure Active Directory (AD) tenant
- Task 2: Add a custom DNS name to the new Azure AD tenant
- Task 3: Create an Azure AD user with the Global Administrator role


#### Task 1: Create an Azure Active Directory (AD) tenant

In this task, you will cr3ate a new Azure AD tenant to use in this lab. 

1. From the Portal menu select **Create a resource**.

1. Search for and select **Azure Active Directory**.

1. Click **Create**.

1. From the **Create directory** blade, create a new Azure AD tenant with the following settings:

  - Organization name: **AdatumSync**

  - Initial domain name: a unique name consisting of a combination of letters and digits.

  - Country or region: **United States**

    > The green check mark in the **Initial domain name** text box will indicate whether the domain name you typed in is valid and unique. (Record your initial domain name for later use).

- Click **Create**.

#### Task 2: Add a custom DNS name to the new Azure AD tenant

In this task, you will add your custom DNS name to the new Azure AD tenant. 

1. In the Azure portal, set the **Directory + subscription** filter to the newly created Azure AD tenant.

    > The **Directory + subscription** filter appears to the left of the notification icon in the toolbar of the Azure portal

    > You might need to refresh the browser window if the **AdatumSync** entry does not appear in the **Directory + subscription** filter list.

1. In the Azure portal, Select Azure Active Directory.

1. From the **AdatumSync - Overview** blade, display the **AdatumSync - Custom domain names** blade.

1. Under **Manage** click **Custom domain names**, identify the primary, default DNS domain name associated with the Azure AD tenant. Note its value - you will need it in the next task.

1. Click **+ Add custom domain** , add the **adatum.com** custom domain. Click **Add Domain**.

1. On the **adatum.com** blade, review the information necessary to perform verification of the Azure AD domain name.

    > You will not be able to complete the validation process because you do not own the **adatum.com** DNS domain name. This will not prevent you from synchronizing the **adatum.com** Active Directory domain with the Azure AD tenant. You will use for this purpose the default primary DNS name of the Azure AD tenant (the name ending with the **onmicrosoft.com** suffix), which you identified earlier in this task. However, keep in mind that, as a result, the DNS domain name of the Active Directory domain and the DNS name of the Azure AD tenant will differ. This means that Adatum users will need to use different names when signing in to the Active Directory domain and when signing in to Azure AD tenant.


#### Task 3: Create an Azure AD user with the Global Administrator role

In this task, you will add a new Azure AD user and assign them to the Global Administrator role. 

1. In the Azure portal, navigate to **Azure Active Directory** > **Users** blade of the **AdatumSync** Azure AD tenant.

1. Click **+ New user** and create a new user with the following settings:

     - User name: **syncadmin** Take a note of this users User Principal Name. You will need it later in this lab.

    - Name: **syncadmin**

    - Password: click **Let me create the password** and type **Pa55w.rd** in the **initial password** text box. (Take note of the password)

    - Groups: **0 groups selected**

    - Roles: click **User** and select **Global administrator** > **Select**

    - Click **Create**

    > An Azure AD user with the Global Administrator role is required in order to implement Azure AD Connect.

1. Open an InPrivate Microsoft Edge window.

1. In the new browser window, navigate to the Azure portal and sign in using the **syncadmin** user account. When prompted, change the password to a new value.

    > You will need to provide the fully qualified name of the **syncadmin** user account, including the Azure AD tenant DNS domain name.

1. Sign out as **syncadmin** and close the InPrivate browser window.

> **Result**: After you completed this exercise, you have created an Azure AD tenant, added a custom DNS name to the new Azure AD tenant, and created an Azure AD user with the Global Administrator role.



### Exercise 3: Synchronize Active Directory forest with an Azure Active Directory tenant

The main tasks for this exercise are as follows:

- Task 1: Configure Active Directory in preparation for directory synchronization
- Task 2: Install Azure AD Connect
- Task 3: Verify directory synchronization


#### Task 1: Configure Active Directory in preparation for directory synchronization

In this task, you will connect to the virtual machine and create a directory synchronization account. 

   > Before you start this task, ensure that the template deployment you started in Exercise 1 has completed.

1. In the Azure portal, set the **Directory + subscription** filter back to the **Default Directory** (the Azure AD tenant associated with the Azure subscription you used in the first exercise of this lab.)

    > The **Directory + subscription** filter appears to the left of the notification icon in the toolbar of the Azure portal.

1. In the Azure portal, Click **Virtual Machines** then select **adVM** blade, displaying the properties of the Azure VM hosting an Active Directory domain controller that you deployed in the first exercise of this lab.

1. On the **Overview** pane of the **adVM** blade, click **Connect** > **RDP**.

1. On the **Connect to virtual machine** blade, select the load balancer public IP address in the **IP address** drop-down list, download the corresponding RDP file, then **Download RDP file**  and use it to connect to **adVM**.

1. When prompted, authenticate by specifying the following credentials:

    - User name: **Student**

    - Password: **Pa55w.rd**

1. Within the Remote Desktop session to **adVM**, From **Server Manager** click **Tools** from the top left then select **Active Directory Administrative Center**.

1. From **Active Directory Administrative Center**, **right click** on **adatum(local)** > select **New** > **organizational unit** named **ToSync**. Click **Ok**

1. Click on **adatum(local)** and verify that the OU was created.

1. From **Active Directory Administrative Center**, click on the new organizational unit **ToSync**, from **Tasks** to the right, click **New** > **User** with the following settings:

    - Full name: **aduser1**

    - User UPN logon: **aduser1@adatum.com**

    - User SamAccountName logon: **adatum\aduser1**

    - Password: **Pa55w.rd**

    - Other password options: **Password never expires**

    - Click **OK**


#### Task 2: Install Azure AD Connect

In this task, you will install AD Connect on the virtual machine. 

1. Within the RDP session to **adVM**, from Server Manager, click **Local** disable temporarily **IE Enhanced Security Configuration**.

1. Within the RDP session to **adVM**, start Internet Explorer and download **Azure AD Connect** from [**https://www.microsoft.com/en-us/download/details.aspx?id=47594**](https://www.microsoft.com/en-us/download/details.aspx?id=47594)

1. Start **Microsoft Azure Active Directory Connect** wizard, accept the licensing terms, and, on the **Express Settings** page, select the **Customize** option.

1. On the **Install required components** page, leave all optional configuration options deselected and start the installation.

1. On the **User sign-in** page, ensure that only the **Password Hash Synchronization** is enabled. Click **Next**

1. When prompted to connect to Azure AD, authenticate by using the credentials of the **syncadmin** account you created in the previous exercise.

1. When prompted to connect your directories, add the **adatum.com** forest, choose the option to **Create new AD account**, and authenticate by using the following credentials:

    - User name: **ADATUM\\Student**

    - Password: **Pa55w.rd**

1. Click **Next**

1. On the **Azure AD sign-in configuration** page, note the warning stating **Users will not be able to sign-in to Azure AD with on-premises credentials if the UPN suffix does not match a verified domain name** and enable the checkbox **Continue without matching all UPN suffixes to verified domain**. Click **Next**

    > As explained earlier, this is expected, since you could not verify the custom Azure AD DNS domain **adatum.com**.

1. On the **Domain and OU filtering** page, ensure that only the **ToSync** OU is selected. Click **Next**.

1. On the **Uniquely identifying your users** page, accept the default settings. Click **Next**.

1. On the **Filter users and devices** page, accept the default settings. Click **Next**.

1. On the **Optional features** page, accept the default settings. Click **Next**.

1. On the **Ready to configure** page, ensure that the **Start the synchronization process when configuration completes** checkbox is selected and continue with the installation process. Click **Install**.

    > Installation should take about 2 minutes.

1. Click **Exit** to close the Microsoft Azure Active Directory Connect window once the configuration is completed.


#### Task 3: Verify directory synchronization

In this task, you will verify that directory synchronization is working. 

1. In the lab virtual machine, in the Microsoft Edge window showing the Azure portal, set the **Directory + subscription** filter back to the **AdatumSync** directory.

    > The **Directory + subscription** filter appears to the left of the notification icon in the toolbar of the Azure portal

1. Navigate to **Azure Active Directory** and then open the **Users - All users** blade of the AdatumSync Azure AD tenant.

1. On the **Users - All users** blade, note that the list of user objects includes the **aduser1** account, with the **Windows Server AD** appearing in the **SOURCE** column.

1. From the **Users - All users** blade, display the **aduser1 - Profile** blade. Note that the **Department** attribute is not set.

1. Within the RDP session to **adVM**, switch to the **Active Directory Administrative Center**, select **adatum(local)** > **ToSync** and open the window displaying properties of the **aduser1** user account, and set the value of its **Department** attribute to **Sales**. Click **OK**

1. Within the RDP session to **adVM**, start **Windows PowerShell** as Administrator.

1. From the Windows PowerShell prompt, start Azure AD Connect delta synchronization by running the following:

	```
	Import-Module -Name 'C:\Program Files\Microsoft Azure AD Sync\Bin\ADSync\ADSync.psd1'
	```
   
	```
	Start-ADSyncSyncCycle -PolicyType Delta
   ```

1. From the lab virtual machine, in Microsoft Edge, refresh the **Users - All users** blade of the AdatumSync Azure AD tenant.

1. From the **Users - All users** blade, display the **aduser1 - Profile** blade. Note that the **Department** attribute is now set to **Sales**.

    > You might need to wait for another minute and refresh the page again if the **Department** attribute remains not set.


> **Result**: After you completed this exercise, you have configured Active Directory in preparation for directory synchronization, installed Azure AD Connect, and verified directory synchronization.


**Clean up resources**

#### Task 1: Delete the Azure AD tenant.

1. Within the RDP session to **adVM**, start Windows PowerShell as Administrator.

1. From the Windows PowerShell console, install the MsOnline PowerShell module by running the following (when prompted, in the NuGet provider is required to continue dialog box, type **Yes** and hit Enter.):

   ```
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
   Install-Module MsOnline -Force
   ```

1. From the Windows PowerShell console, connect to the AdatumSync Azure AD tenant by running the following (when prompted, sign in with the SyncAdmin credentials):

   ```
   Connect-MsolService
   ```

1. From the Windows PowerShell console, disable the Azure AD Connect synchronization by running the following:

   ```
   Set-MsolDirSyncEnabled -EnableDirSync $false -Force
   ```

1. From the Windows PowerShell console, verify that the operation was successful by running the following:

   ```
   (Get-MSOLCompanyInformation).DirectorySynchronizationEnabled
   ```

    > The result should be `False`; if not, wait a minute and re-run the command.

1. Sign out from the Azure portal and close the Internet Explorer window.

1. Start Internet Explorer, navigate to the Azure portal, and sign in by using the SyncAdmin credentials.

1. In the Azure portal, navigate to the **Users - All users** blade of the AdatumSync Azure AD tenant and delete all users with the exception of the SyncAdmin account.

    > You might need to wait a few hours before you can complete this task in the portal. If the Delete user option is not avalable, switch back to the PowerShell window and run the following command:
    >```
    >Get-MsolUser | where DisplayName -NE "syncadmin" | Remove-MsolUser -Force
    >```
    >Then retun to the portal and **Refresh** the Users list.

1. Navigate to the AdatumSync - Overview blade and click **Properties**.

1. On the **Properties** blade of Azure Active Directory click **Yes** in the **Access management for Azure resource** section and then click **Save**.

1. Sign out from the Azure portal and sign back in by using the SyncAdmin credentials.

1. Navigate to the **AdatumSync - Overview** blade and delete the Azure AD tenant by clicking **Delete directory**.

1. On the **Delete directory 'AdatumSync'?** blade, click **Delete**.

1. Click the `Directory 'AdatumSync' was successfully schedulded for deletion.` notification and then close the RDP session.

> For any additional  information regarding this task, refer to [https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-delete-howto](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-delete-howto)


#### Task 2: Open Cloud Shell

1. In the lab virtual machine, in the Edge window showing the Azure portal, set the **Directory + subscription** filter back to the **Default Directory** (the Azure AD tenant associated with the Azure subscription you used in the first exercise of this lab.)

    > The **Directory + subscription** filter appears to the left of the notification icon in the toolbar of the Azure portal.

1. Open Cloud Shell in Powershell

1.  Remove the resource group by running the following command (When prompted to confirm press Y and press enter):
    ```
    Remove-AzResourceGroup -Name "AZ500LAB06"
    ```

1. Close the **Cloud Shell** prompt at the bottom of the portal.

> **Result**: In this exercise, you removed the resources used in this lab.