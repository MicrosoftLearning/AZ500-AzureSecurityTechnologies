---
lab:
    title: '10 - Key Vault (Implementing Secure Data by setting up Always Encrypted)'
    module: 'Module 03 - Secure Data and Applications'
---

# Lab 10 - Key Vault (Implementing Secure Data by setting up Always Encrypted)

# Student lab manual

## Lab scenario

You have been asked to create a proof of concept application that makes use of Always encrypted in SQL. Secrets, keys, and certificates should be stored in the key vault. It would be nice if this was combined with some of the advantages in Azure app registration to improve the security posture of the application. Specifically, the proof of concept should include:

- Creating a key vault and storing keys and secrets in the vault.
- Create a SQL Database and encrypting column information using Always Encrypted.

## Lab objectives

In this lab, you will complete:

- Exercise 1: Configure the key vault with a key and a secret
- Exercise 2: Create an application to demonstrate using the key vault for encryption
 
## Exercise 1: Introduction to Azure Key Vault

### Estimated timing: xx minutes

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is region to use for you class. 

In this exercise, you will complete:

- Task 1: Download and install SQL Server Management Studio
- Task 2: Create and configure a key vault
- Task 3: Add a key to the key vault
- Task 4: Add a secret to the key vault

#### Task 1: Download and install SQL Server Management Studio

In this task, you will download and install SQL Server Management Studio (SSMS).

1. Visit the [Download SQL Server Management Studio](**https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017) page.

2. Use the link to download the executable and then run the installer.  

	> You do not need to wait for the SQL Management Studio to install before continuing.

#### Task 2: Create and configure a Key Vault

In this task, you will create a lab resource group and a key vault. You will also configure the key vault permissions.

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

1. Open the Cloud Shell. 

1. Ensure **PowerShell** is selected in the upper-left drop-down menu.

1. Create a new resource group for the lab. 

    ```
    New-AzResourceGroup -Name 'AZ500LAB10' -Location 'eastus'
    ```

1. Create a key vault in the resource group. The key vault name must be unique. Remember the name you have chosen. You will need it throughout this lab.  

    ```
    New-AzKeyVault -VaultName '<keyvault name>' -ResourceGroupName 'AZ500LAB10' -Location 'eastus'
    ```

	> The output of this shows important pieces of information: Vault Name and the Vault URI. The Vault URI takes the form: https://your_name.vault.azure.net/

1. Close the Cloud Shell. 

1. In the Azure Portal navigate to the **AZ500LAB10** Resource Group.

1. Select your key vault. 

1. Under **Settings** select **Access Policies** and then **+ Add Access Policy**.

1. Configure the Access Policy. Take the default if the value is not specified. 

	- Configure from template (optional): **Key, Secret, & Certificate Management**

	- Key permissions: **Select all** - total of 16 permissions.
	
	- Secret permissions: **Select all** - total of 8 permissions.

	- Certification permissions: **Select all** - total of 16 permissions. 

	- Select principal: **Add your account** > **Select**

1. Click **Add** to add the access policy. 

1. **Save** your changes. 

	> Take a minute to check back on your SMSS installation. 

#### Task 3: Add a key to Key Vault

In this task, you will ad a key to the kev vault and view information about the key. 

1. Open the Cloud Shell.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu.

1. Add a software-protected key to the Key Vault. Change YourVaultName to the name of your vault. Notice the name of the key is MyLabKey. 

    ```
    $key = Add-AZKeyVaultKey -VaultName '<YourVaultName>' -Name 'MyLabKey' -Destination 'Software'
    ```

1. Verify the key was created. Change YourVaultName to the name of your vault. Review the key information. 
    ```
    Get-AZKeyVaultKey -VaultName '<YourVaultName>'
    ```

1. Display the key identifier.
    ```
    $Key.key.kid
    ```

1. Move back to the Azure portal and your key vault.

1. Under **Settings** click **Keys**.

1. Select **MyLabKey** and then click on the current version. 

1. Examine the information about the key you created.

	> You can always reference this key by using its URI. 

	> To get the most current version, reference `https://keyvaultps.vault.azure.net/keys/MyLabKey` or get the specific version with: `https://keyvaultps.vault.azure.net/keys/MyLabKey/da1a3a1efa5dxxxxxxxxxxxxxd53c5959e`


#### Task 4: Add a Secret to Key Vault

1. Return to the Cloud Shell.

	> Use *cls* at the prompt to clear the command window. 

1. Add a secret to the key vault by first creating a variable with the secure string value. 

    ```
    $secretvalue = ConvertTo-SecureString 'Pa55w.rd' -AsPlainText -Force
    ```

1.  Next add the secret to the vault. Again, change YourVaultName to the name of your vault. Notice the name of the secret is SQLPassword. 

    ```
    $secret = Set-AZKeyVaultSecret -VaultName 'YourVaultName' -Name 'SQLPassword' -SecretValue $secretvalue
    ```

1. Verify the secret was created.

    ```
    Get-AZKeyVaultSecret -VaultName 'YourVaultName'
    ```

1. Move back to the Azure portal and your key vault.

1. Under **Settings** click **Secrets**.

1. Select **SQLPassword** and review the information. 

1. Move back to the Azure Portal on **KeyVaultPS** and click **Secrets**

1. Select **SQLPassword** and then click on the current version. 

1. Examine the information about the secret you created.

	> You can always reference this secret by using its URI. 

	> To get the most current version, reference `https://keyvaultps.vault.azure.net/secrets/SQLPassword` or get the specific version with: `https://keyvaultps.vault.azure.net/secrets/SQLPassword/c5aada85d3acxxxxxxxxxxe8701efafcf3`


## Exercise 2: Create an application to demonstrate using the key vault for encryption

### Estimated timing: xx minutes

In this exercise, you will complete:

- Task 1: Enable a client application to access the Azure SQL Database service. 
- Task 2: Add a Key Vault policy allowing the application access to the Key Vault.
- Task 3: Create a SQL Database.
- Task 4: Create a table in the SQL Database and select data columns for encryption.


#### Task 1: Enable a client application to access the Azure SQL Database service. 

In this task, you will enable a client application to access the Azure SQL Database service. This will be done by setting up the required authentication and acquiring the Application ID and Secret that you will need to authenticate your application. T

1. Continue in the Azure portal. 

1. Navigate to the Azure Active Directory blade.

1. Under **Manage** click **App Registrations**.

1. Click **+ New registration** and complete the required information. 

	- Name: **sqlApp** 

	- Redirect URI (optional): **Web** - **https://sqlapp**

1.  Click **Register**. 

1.  When the registration is complete you should be automatically taken to sqlApp. If not, select sqlApp from the App Registrations page. 

1.  On the **Overview** tab, copy your Application (client) ID. You will need this later to set the application permissions. 

1.  Under **Manage** click **Certificates & secrets**.

1.  Click **+ New client secret**

	- Description: **Key1**

	- Expires: **in 1 year**
	
1. Click **Add** to update the application credentials.

1. Copy the Key1 **value**. You will need this later. 

	> If you close and reopen the blade, the value will show as hidden.

#### Task 2: Add a Key Vault policy allowing the application access to the Key Vault

In this task, you will ensure required permissions are correctly configured. This validates previous tasks. 

1. Continue in the Azure Portal.

1. Open the **AZ500LAB10** resource group. 

1. Select your key vault. 

1. Under **Settings** select **Access Policies**.

1. Select the account associated with your Azure subscription.

1. In the **Key Permissions** drop-down ensure all 16 key permissions are selected. If changes are required, be sure to click **Save**. 

1. Open the Cloud Shell.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu.

1. In the next steps, you will set the sqlApp key permissions. 

1. Create a variable for the Application (client) ID. You copied this information previously. 
   
    ```
    $applicationId = '[Azure_AD_Application_ID]'
	```

1. Create a variable for your key vault name.
	```
    $vaultName = '[KeyVault_Name]' 
    ```

1. Set the permissions. 

    ```
    Set-AZKeyVaultAccessPolicy -VaultName $vaultName -ResourceGroupName AZ500LAB10 -ServicePrincipalName $applicationId -PermissionsToKeys get,wrapKey,unwrapKey,sign,verify,list
    ```

#### Task 3: Create a SQL Database

In this task, you will create an empty SQL Database and determine the ADO.NET connection string. 


1. Continue in the Azure Portal.

1. In the search box at the top of Portal, search for and then select **SQL Databases**.

1. Click **+ Add** and provide the required information. 

	- Resource Group: (use existing) **AZ500LAB10**
      
	- Database Name: **medical**

	- Server: **Create new**

		- Server name: **[Unique Server Name]**

		- Server Admin Login: **demouser**

		- Password: **Pa55w.rd**

		- Location: **East US** - same location as the key vault

		- Click **OK** to save the server information. 

1. Click **Review + create** and then **Create**.

1. Wait for the SQL Database to deploy.

1. Navigate to your new SQL Database. If you miss the **Go to resource** link you can get there from the lab resource group. 

1. On the **Overview** blade, click **Show database connection strings**. 

1. The tabs show different connection strings for ADO.NET, JDBC, ODBC, PHP, and Go. 
   
1. Copy the **ADO.NET Connection String**.

	> When you use the connection string be sure to replace {your_username} with **demouser** and {your_password} with **Pa55w.rd**.


#### Task 4: Create a table in the SQL Database and select data columns for encryption

In this task, you will connect to the SQL Database with SQL Server Management Studio and create a table. You will then encrypt two data columns using an autogenerated key from the Azure Key Vault. 

1. Continue in the Azure Portal with your SQL Database.

1. From the **Overview** blade, make a note of the **Server name**. You will need this in an upcoming step. 

1. From the **Overview** blade, click on **Set server firewall**.  

1. Click **+ Add client IP** and then click **Save**. This will provide access to the server databases. 
	
1. Open SQL Server Management Studio. 

1. Provide the **Connect to Server** dialog box information. 

	- Server Type: **Database Engine**

    - Server Name: **[found on the Database Overview Blade]**

	- Authentication: **SQL Server Authentication**

    - Login: **demouser**

    - Password: **Pa55w.rd**

1. Click **Connect**.

1. In the **Object Explorer** pane, expand the **Databases** folder.

1. Right-click the **medical** database and select **New Query**.

1. Paste the following code into the query window and click **Execute**. This will create a **Patients** table.

     ```
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
1.  After the table is created successfully, expand **medical > tables > right-click dbo.Patients** and select **Encrypt Columns**.

1. The **Always Encrypted** wizard displays. 

	- Review the Information page and then click **Next**.

	- On the Column Selection page check **SSN** and **Birthdate**. Set the Encryption Type for SSN to **Deterministic** and for Birthdate choose **Randomized**. Click **Next**.

	- On the Master Key Configuration page, select **Azure Key Vault.** Click **Sign in** and authenticate. Select your Azure Key Vault. Click **Next**.

	- On the Run Settings page, click **Next**.
	
	- On the Summary page, click **Finish** to proceed with the encryption.

1. When the encryption process is complete, click **Close**.

1. Expand **medical > security > Always Encrypted Keys**.

	> There are now Column Master Keys and Column Encryption Keys. 


George - is there another way to show this without a console app? Maybe we can just add a few records then do a query and how the data is encrypted?

#### Task x: Build a Console Application to work with Encrypted Columns

Then you will create a Console application using Visual Studio to load data into the encrypted columns and then access that data securely using a connection string that accesses the key in the Key Vault.

1. Open Visual Studio 2019.

1. Sign in using your Azure account.

1. Click **File > New > Project**

    > In the next step **DO NOT CHOOSE** **Console App (.NET Core)**  
 
1. Select **Visual C#** > Search for **Console App** > Choose **Console App (.NET Framework)** and provide the name **OpsEncrypt** in the location **C:\\** and then click **OK**.

1. **Right-Click** the **OpsEncrypt** project > click **Properties**.

1.  Change the **Target Framework** to **.NET Framework 4.7.2.** Click **Yes** when prompted to change the **Target Framework.**

1.  Install the following **NuGet** packages by going to **Tools** > **NuGet Package Manager** > **Package Manager Console.**

    ```
    Install-Package     Microsoft.SqlServer.Management.AlwaysEncrypted.AzureKeyVaultProvider
    ```

    ```
    Install-Package Microsoft.IdentityModel.Clients.ActiveDirectory
    ```

1.  Open the **program.cs** file in notepad from Allfiles\\Labs\\Mod1_Lab02 and copy the code.

1.  Replace the code in **Program.cs** in Visual Studio with the code you just copied.

1.  Locate the **Connection string, clientId, and clientSecret** settings in the Main method and replace them with the values that you copied from the previous steps.

1.  **Click** the **Start Button** in **Visual Studio**.


1.  **The Console Application** will **Build** and then start. First it will ask for your password, then the app will add data to the database.

    - Server Password: **Pa55w.rd1234**

1.  **Leave** the **Console Application Running** and move to the **SQL Management Studio**. Right-Click the medical database and click **New Query**.



1.  Run the following query to see the data that was loaded into the database is encrypted.

    ```
    SELECT FirstName, LastName, SSN, BirthDate FROM Patients;
    ```


1.  Now, move back to the console application where you will be asked to **Enter** a **Valid SSN**. This will query the encrypted column for the data. Notice that with the key called from the Key Vault, now the data is unencrypted and shown to the console window.

    ```
    999-99-0003
    ```

1.  To **Exit** you press enter.




**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 

1. Access the Cloud Shell.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. Remove the resource group using the Cloud Shell and PowerShell.

    ```
    Remove-AzResourceGroup -Name "AZ500LAB10"
    ```