---
lab:
    title: '10 - Key Vault (Implementing Secure Data by setting up Always Encrypted)'
    module: 'Module 03 - Secure Data and Applications'
---

# Lab 10: Key Vault (Implementing Secure Data by setting up Always Encrypted)
# Student lab manual

## Lab scenario

You have been asked to create a proof of concept application that makes use of the Azure SQL Database support for Always Encrypted functionality. All of the secrets and keys used in this scenario should be stored in the key vault. The application should be registered in Azure Active Directory (Azure AD) in order to enhance its security posture. To accomplish these objectives, the proof of concept should include:

- Creating an Azure key vault and storing keys and secrets in the vault.
- Create a SQL Database and encrypting content of columns in database tables by using Always Encrypted.

> For all the resources in this lab, we are using the **East US** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete the following exercises:

- Exercise 1: Configure the key vault with a key and a secret
- Exercise 2: Create an application to demonstrate using the key vault for encryption

## Lab files:

- **\\Allfiles\\Labs\\10\\az-500-10_azuredeploy.json**
- **\\Allfiles\\Labs\\10\\az-500-10_azuredeploy.parameters.json**
- **\\Allfiles\\Labs\\10\\program.cs**
 
### Exercise 1: Configure the key vault with a key and a secret

### Estimated timing: 60 minutes

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is region to use for you class. 

In this exercise, you will complete the following tasks:

- Task 1: Deploy and configure an Azure VM with Visual Studio 2019 and SQL Server Management Studio
- Task 2: Create and configure a key vault
- Task 3: Add a key to the key vault
- Task 4: Add a secret to the key vault

#### Task 1: (Optional Prerequisite) Deploy and configure an Azure VM with Visual Studio 2019 and SQL Server Management Studio
    
    >**Note**: If you are using a lab provider that has both Visual Studio 2019 and SQL Server Management studio installed you can skip this step and go straight to Task 2.


In this task, you will deploy an Azure VM, connect to it, and download and install Visual Studio 2019 and SQL Server Management Studio (SSMS).

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

    >**Note**: Sign in to the Azure portal using an account that has the Owner or Contributor role in the Azure subscription you are using for this lab.

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Deploy a custom template** and press the **Enter** key.

1. On the **Custom deployment** blade, click the **Build your own template in the editor** option.

1. On the **Edit template** blade, click **Load file**, locate the **\\Allfiles\\Labs\\10\\az-500-10_azuredeploy.json** file and click **Open**.

1. On the **Edit template** blade, click **Save**.

1. Back on the **Custom deployment** blade, click **Edit parameters**.

1. On the **Edit parameters** blade, click **Load file**, locate the **\\Allfiles\\Labs\\10\\az-500-10_azuredeploy.parameters.json** file and click **Open**.

1. On the **Edit parameters** blade, click **Save**.

1. On the **Custom deployment** blade, ensure that the following settings are configured (leave any others with their default values):

   |Setting|Value|
   |---|---|
   |Subscription|the name of the Azure subscription you will be using in this lab|
   |Resource group|click **Create new** and type the name **AZ500LAB10**|
   |Location|**(US) East US**|
   |Vm Size|**Standard_D2s_v3**|
   |Vm Name|**az500-10-vm1**|
   |Admin Username|**Student**|
   |Admin Password|**Pa55w.rd1234**|
   |Virtual Network Name|**az500-10-vnet1**|

    >**Note**: To identify Azure regions where you can provision Azure VMs, refer to [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

1. Click the **I agree to the terms and conditions stated above** checkbox, and click **Purchase**.

    >**Note**: Wait for the deployment to complete. 

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Virtual machines** and press the **Enter** key.

1. On the **Virtual machines** blade, click the **az500-10-vm1** entry. 

1. On the **az500-10-vm1** blade, click **Connect** and, in the drop down menu, click **RDP**. 

1. Click **Download RDP File** and use it to connect to the **az500-10-vm1** Azure VM via Remote Desktop. When prompted to authenticate, provide the following credntials:

   |Setting|Value|
   |---|---|
   |User name|**Student**|
   |Password|**Pa55w.rd1234**|

    >**Note**: Wait for the Remote Desktop session and **Server Manager** to load.  

    >**Note**: The remaining steps in this lab are performed within the Remote Desktop session to the **az500-10-vm1** Azure VM. 

1. Within the Remote Desktop session to the **az500-10-vm1** Azure VM, in **Server Manager**, click **Local Server** and then click **IE Enhanced Security Configuration**.

1. In the **Internet Explorer Enhanced Security Configuration** dialog box, set both options to **Off** and click **OK**.

1. Start **Internet Explorer**, and browse to the [Download SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15) page.

1. Download and start the SQL Server Management Studio installer.  

    >**Note**: Do not wait for the SQL Server Management Studio installation to complete but instead proceed to the next step. 

1. Start **Internet Explorer**, and browse to the [Visual Studio Downloads](https://visualstudio.microsoft.com/downloads/) page.

1. Initiate download and installation of Visual Studio 2019 Community Edition. When prompted, in the **Visual Studio Installer** window, click **Continue**.

1. When prompted, in the **Workloads** window, in the **Desktop & Mobile** section, select the **.NET desktop development** checkbox, and click **Install*.

    >**Note**: Do not wait for the Visual Studio 2019 installation to complete but instead proceed to the next task. 

> Result: You have deployed and initiated configuration of an Azure VM **az500-10-vm1** that you will use in the second exercise of this lab.

#### Task 2: Create and configure a Key Vault

In this task, you will create a lab resource group and a key vault. You will also configure the key vault permissions.

1. Within the Remote Desktop session to the **az500-10-vm1** Azure VM, sign-in to the Azure portal **`https://portal.azure.com/`**. (Skip this step if you did not complete Task 1)

    >**Note**: Sign in to the Azure portal using an account that has the Owner or Contributor role in the Azure subscription you are using for this lab.

1. Open the Cloud Shell by clicking the first icon in the top right of the Azure Portal. If prompted, select **PowerShell** and **Create storage**.

1. Ensure **PowerShell** is selected in the drop-down menu in the upper-left corner of the Cloud Shell pane.

1. In the PowerShell session within the Cloud Shell pane, run the following to create a key vault in the resource group **AZ500LAB10**. The key vault name must be unique. Remember the name you have chosen. You will need it throughout this lab.  

1. If you skipped Task 1 run the following command to create a Resource Group, otherwsie go to the next task

    ```powershell
    New-AzResourceGroup -Name 'AZ500LAB10' -Location eastus
    ```

1. Create a key vault

    ```powershell
    $kvName = 'az500kv' + $(Get-Random)
    New-AzKeyVault -VaultName $kvName -ResourceGroupName 'AZ500LAB10' -Location 'eastus'
    ```

    >**Note**: The output of this displays the vault name and the vault URI. The Vault URI is in the format `https://<vault_name>.vault.azure.net/`

1. Close the Cloud Shell pane. 

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Resource groups** and press the **Enter** key.

1. On the **Resource groups** blade, in the list of resource group, click the **AZ500LAB10** entry.

1. On the **AZ500LAB10** blade, click the entry representing the newly created key vault. 

1. On the key vault blade, in the **Settings** section, click **Access Policies** and then click **+ Add Access Policy**.

1. On the **Add access policy** blade, specify the following settings (leave all others with their default values): 

    |Setting|Value|
    |----|----|
    |Configure from template (optional)|**Key, Secret, & Certificate Management**|
    |Key permissions|click **Select all** resulting in **16 selected** permissions|
    |Secret permissions|click **Select all** resulting in total of **8 selected** permissions|
    |Certification permissions|click **Select all** resulting in total of **16 selected** permissions|
    |Select principal|click **None selected**, on the **Principal** blade, select your user account, and click **Select**|

1. Back on the **Add access policy** blade, click **Add** to add the access policy and, back on the access policies blade of the key vault, click **Save** to your changes. 

#### Task 3: Add a key to Key Vault

In this task, you will add a key to the key vault and view information about the key. 

1. In the Azure portal, open a PowerShell session in the Cloud Shell pane.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. In the PowerShell session within the Cloud Shell pane, run the following to add a software-protected key to the Key Vault: 

    ```powershell
    $kv = Get-AzKeyVault -ResourceGroupName 'AZ500LAB10'

    $key = Add-AZKeyVaultKey -VaultName $kv.VaultName -Name 'MyLabKey' -Destination 'Software'
    ```

    >**Note**: The name of the key is MyLabKey

1. In the PowerShell session within the Cloud Shell pane, run the following to verify the key was created:

    ```powershell
    Get-AZKeyVaultKey -VaultName $kv.VaultName
    ```

1. In the PowerShell session within the Cloud Shell pane, run the following to display the key identifier:

    ```powershell
    $key.key.kid
    ```

1. Minimize the Cloud Shell pane. 

1. Back in the Azure portal, on the key vault blade, in the **Settings** section, click **Keys**.

1. In the list of keys, click the **MyLabKey** entry and then, on the **MyLabKey** blade, click the entry representing the current version of the key.

    >**Note**: Examine the information about the key you created.

    >**Note**: You can reference any key by using the key identifier. To get the most current version, reference `https://<key_vault_name>.vault.azure.net/keys/MyLabKey` or get the specific version with: `https://<key_vault_name>.vault.azure.net/keys/MyLabKey/<key_version>`


#### Task 4: Add a Secret to Key Vault

1. Restore the Cloud Shell pane.

1. In the PowerShell session within the Cloud Shell pane, run the following to create a variable with a secure string value:

    ```powershell
    $secretvalue = ConvertTo-SecureString 'Pa55w.rd1234' -AsPlainText -Force
    ```

1.  In the PowerShell session within the Cloud Shell pane, run the following to add the secret to the vault:

    ```powershell
    $secret = Set-AZKeyVaultSecret -VaultName $kv.VaultName -Name 'SQLPassword' -SecretValue $secretvalue
    ```

    >**Note**: The name of the secret is SQLPassword. 

1.  In the PowerShell session within the Cloud Shell pane, run the following to verify the secret was created.

    ```powershell
    Get-AZKeyVaultSecret -VaultName $kv.VaultName
    ```

1. Minimize the Cloud Shell pane. 

1. In the Azure portal, navigate back to the key vault blade, in the **Settings** section, click **Secrets**.

1. In the list of secrets, click the **SQLPassword** entry and then, on the **SQLPassword** blade, click the entry representing the current version of the secret.

    >**Note**: Examine the information about the secret you created.

    >**Note**: To get the most current version of a secret, reference `https://<key_vault_name>.vault.azure.net/secrets/<secret_name>` or get a specific version, reference `https://<key_vault_name>.vault.azure.net/secrets/<secret_name>/<secret_version>`


### Exercise 2: Create an application to demonstrate using the key vault for encryption

### Estimated timing: 60 minutes

In this exercise, you will complete the following tasks:

- Task 1: Enable a client application to access the Azure SQL Database service. 
- Task 2: Create a policy allowing the application access to the Key Vault
- Task 3: Create an Azure SQL database.
- Task 4: Create a table in the SQL Database and select data columns for encryption.
- Task 5: Build a Console Application to work with Encrypted Columns

#### Task 1: Enable a client application to access the Azure SQL Database service. 

In this task, you will enable a client application to access the Azure SQL Database service. This will be done by setting up the required authentication and acquiring the Application ID and Secret that you will need to authenticate your application.

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **App Registrations** and press the **Enter** key.

1. On the **App Registrations** blade, click **+ New registration**. 

1. On the **Register an application** blade, specify the following settings (leave all others with their default values):

    |Setting|Value|
    |----|----|
    |Name|**sqlApp**|
    |Redirect URI (optional)|**Web** and **https://sqlapp**|

1. On the **Register an application** blade, click **Register**. 

    >**Note**: Once the registration is completed, the browser will automatically redirect you to **sqlApp** blade. 

1. On the **sqlApp** blade, identify the value of **Application (client) ID**. 

    >**Note**: Record this value. You will need it in the next task.

1. On the **sqlApp** blade, in the **Manage** section, click **Certificates & secrets**.

1. On the **sqlApp \| Certificates & secrets** blade, click **+ New client secret**

1. In the **Add a client secret** pane, specify the following settings:

    |Setting|Value|
    |----|----|
    |Description|**Key1**|
    |Expires|**in 1 year**|
	
1. Click **Add** to update the application credentials.

1. On the **sqlApp \| Certificates & secrets** blade, identify the value of **Key1**.

    >**Note**: Record this value. You will need it in the next task. 

    >**Note**: Make sure to copy the value *before* you navigate away from the blade. At that point, it is no longer possible to retrieve its clear text value.


#### Task 2: Create a policy allowing the application access to the Key Vault

In this task, you will grant the newly registered app permissions to access secrets stored in the key vault.

1. In the Azure portal, open a PowerShell session in the Cloud Shell pane.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. In the PowerShell session within the Cloud Shell pane, run the following to create a variable storing the **Application (client) ID** you recorded in the previous task (replace the `<Azure_AD_Application_ID>` placeholder with the value of the **Application (client) ID**):
   
    ```powershell
    $applicationId = '<Azure_AD_Application_ID>'
    ```
1. In the PowerShell session within the Cloud Shell pane, run the following to create a variable storing the key vault name.
	```
    $kvName = (Get-AzKeyVault -ResourceGroupName 'AZ500LAB10').VaultName
    ```

1. In the PowerShell session within the Cloud Shell pane, run the following to grant permissions on the key vault to the application you registered in the previous task:

    ```powershell
    Set-AZKeyVaultAccessPolicy -VaultName $kvName -ResourceGroupName AZ500LAB10 -ServicePrincipalName $applicationId -PermissionsToKeys get,wrapKey,unwrapKey,sign,verify,list
    ```

1. Close the Cloud Shell pane. 

#### Task 3: Create an Azure SQL database

In this task, you will create an Azure SQL database and identify its ADO.NET connection string. 

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **SQL databases** and press the **Enter** key.

1. On the **SQL databases** blade, click **+ Add**.

1. On the **Basics** tab of the **Create SQL Database** blade, specify the following settings (leave others with their default values):

    |Setting|Value|
    |---|--- |
    |Subscription|the name of the Azure subscription you will be using in this lab|
    |Resource group|**AZ500LAB10**|
    |Database name|**medical**|

1. Directly below the **Server** drop down list, click the **Create new** and, on the **New server** blade, specify the following settings and click **OK** (leave others with their default values):

    |Setting|Value|
    |---|---|
    |Server name|any valid, globally unique name|
    |Server admin login|**Student**|
    |Password|**Pa55w.rd1234**|
    |Location|**(US) East US**|

1. Click **Review + create** and then click **Create**. 

    >**Note**: Wait for the SQL database to be created. Provisioning should take about 2 minutes. 

1. In the Azure portal, navigate back to the **SQL databases** blade and, in the list of SQL databases, click the **medical** entry.

1. On the SQL database blade, in the **Settings** section, click **Connection strings**. 

    >**Note**: The interface includes connection strings for ADO.NET, JDBC, ODBC, PHP, and Go. 
   
1. Record the **ADO.NET Connection String**.

    >**Note**: When you use the connection string, make sure to replace the `{your_password}` placeholder with **Pa55w.rd1234**.


#### Task 4: Create a table in the SQL Database and select data columns for encryption

>**Note**: Before you proceed with this task, make sure that the installation of SQL Server Management Studio you started at the beginning of this lab is completed.

In this task, you will connect to the SQL Database with SQL Server Management Studio and create a table. You will then encrypt two data columns using an autogenerated key from the Azure Key Vault. 

1. In the Azure portal, on the blade of the **medical** SQL database, click **Overview**, identify **Server name**, and then click **Set server firewall**.  

    >**Note**: Record the server name. You will need the server name later in this task.

1. On the **Firewall settings** blade, click **+ Add client IP**, next click **Save** and then click **OK**.

    >**Note**: This modifies the server firewall settings, allowing connections to the medical database from the public IP address associated with the computer you are currently using. 

1. Click **Start**, in the **Start** menu, expand the **Microsoft SQL Server Tools 18** folder, and click the **Micosoft SQL Server Management Studio** menu item.

1. In the **Connect to Server** dialog box, specify the following settings: 

    |Setting|Value|
    |---|---|
    |Server Type|**Database Engine**|
    |Server Name|the server name you identified earlier in this task|
    |Authentication: **SQL Server Authentication**
    |Login|**Student**|
    |Password|**Pa55w.rd1234**|

1. In the **Connect to Server** dialog box, click **Connect**.

1. Within the **SQL Server Management Studio** console, in the **Object Explorer** pane, expand the **Databases** folder.

1. In the **Object Explorer** pane, right-click the **medical** database and click **New Query**.

1. Paste the following code into the query window and click **Execute**. This will create a **Patients** table.

     ```sql
     CREATE TABLE [dbo].[Patients](
		[PatientId] [int] IDENTITY(1,1),
		[SSN] [char](11) NOT NULL,
		[FirstName] [nvarchar](50) NULL,
		[LastName] [nvarchar](50) NULL,
		[MiddleName] [nvarchar](50) NULL,
		[StreetAddress] [nvarchar](50) NULL,
		[City] [nvarchar](50) NULL,
		[ZipCode] [char](5) NULL,
		[State] [char](2) NULL,
		[BirthDate] [date] NOT NULL 
     PRIMARY KEY CLUSTERED ([PatientId] ASC) ON [PRIMARY] );
     ```
1. After the table is created successfully, in the **Object Explorer** pane, expand the **medical** database node, the **tables** node, right-click the **dbo.Patients** node, and click **Encrypt Columns**. 

    >**Note**: This will initiate the **Always Encrypted** wizard displays. 

1. On the **Introduction** page, click **Next**.

1. On the **Column Selection** page, select the **SSN** and **Birthdate** columns, set the **Encryption Type** of the **SSN** column to **Deterministic** and of the **Birthdate** column to **Randomized**, and click **Next**.

1. On the **Master Key Configuration** page, select **Azure Key Vault**, click **Sign in**, when prompted, authenticate by using the same user account you used to provision the Azure Key Vault instance earlier in this lab, ensure that that key vault appears in the **Select an Azure Key Vault** drop down list, and click **Next**.

1. On the **Run Settings** page, click **Next**.
	
1. On the **Summary** page, click **Finish** to proceed with the encryption. When prompted, sign in again by using the same user account you used to provision the Azure Key Vault instance earlier in this lab.

1. Once the encryption process is complete, on the **Results** page, click **Close**.

1. In the **SQL Server Management Studio** console, in the **Object Explorer** pane, under the **medical** node, expand the **Security** and **Always Encrypted Keys** subnodes. 

    >**Note**: The **Always Encrypted Keys** subnode contains the **Column Master Keys** and **Column Encryption Keys** subfolders.


#### Task 5: Build a Console Application to work with Encrypted Columns

>**Note**: Before you proceed with this task, make sure that the installation of Visual Studio 2019 you started at the beginning of this lab is completed.

Then you will create a Console application using Visual Studio to load data into the encrypted columns and then access that data securely using a connection string that accesses the key in the Key Vault.

1. Switch to the window displaying Visual Studio 2019 welcome message, click the **Not now, maybe later** link and then click **Start Visual Studio**.

1. On the **Get started** page, click **Create a new project**. 

1. In the list of project templates, search for **Console App (.NET Framework)**, in the list of results, click **Console App (.NET Framework)** for **C#**, and click **Next**.

1. On the **Configure your new project** page, specify the following settings (leave other settings with their default values):

    |Setting|Value|
    |---|---|
    |Project name|**OpsEncrypt**|
    |Solution name|**OpsEncrypt**|
    |Framework|**.NET Framework 4.7.2.**|

1. In the Visual Studio console, click the **Tools** menu, in the drop down menu, click **NuGet Package Manager**, and, in the cascading menu, click **Package Manager Console**.

1. In the **Package Manager Console** pane, run the following to install the required **NuGet** packages:

    ```powershell
    Install-Package Microsoft.SqlServer.Management.AlwaysEncrypted.AzureKeyVaultProvider
    Install-Package Microsoft.IdentityModel.Clients.ActiveDirectory
    ```

1. Navigate to **\\Allfiles\\Labs\\10\\program.cs**, open it in Notepad, and copy its content into Clipboard.

1. Switch to the Visual Studio console, in the **Solution Explorer** window, click **Program.cs** and replace its content with the code you copied into Clipboard.

1. In the Visual Studio window, in the **Program.cs** pane, in line 15, replace the `<connection string noted earlier>` placeholder with the Azure SQL database **ADO.NET** connection string you recorded earlier in the lab.

1. In the Visual Studio window, in the **Program.cs** pane, in line 16, replace the `<client id noted earlier>` placeholder with the value of **Application (client) ID** of the registered app you recorded earlier in the lab. 

1. In the Visual Studio window, in the **Program.cs** pane, in line 17, replace the `<key value noted earlier>` placeholder with the the value of **Key1** of the registered app you recorded earlier in the lab. 

1. In the Visual Studio console, click the **Start** button to initiate the build of the console application and start it.

1. The application will start a Command Prompt window. When prompted for password, type **Pa55w.rd1234** to connect to Azure SQL Database. 

1. Leave the console app running and switch to the **SQL Management Studio** console. 

1. In the **Object Explorer** pane, right-click the medical database and, in the right-click menu, click **New Query**.

1. From the query window, run the following query to verify that the data that loaded into the database from the console app is encrypted.

    ```sql
    SELECT FirstName, LastName, SSN, BirthDate FROM Patients;
    ```

1. Switch back to the console application where you are prompted to enter a valid SSN. This will query the encrypted column for the data. At the Command Prompt, type the following and press the Enter key:

    ```cmd
    999-99-0003
    ```

    >**Note**: Verify that the data returned by the query is not encrypted.

1. To terminate the console app, press the Enter key

**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs.

1. In the Azure portal, open the Cloud Shell by clicking the first icon in the top right of the Azure Portal. 

1. In the upper-left drop-down menu of the Cloud Shell pane, select **PowerShell** and, when prompted, click **Confirm**.

1. In the PowerShell session within the Cloud Shell pane, run the following to remove the resource groups you created in this lab:
  
    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB10" -Force -AsJob
    ```

1.  Close the **Cloud Shell** pane. 
