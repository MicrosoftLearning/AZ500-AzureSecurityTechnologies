---
lab:
    title: '11 - Securing Azure SQL Database'
    module: 'Module 03 - Secure data and applications'
---

# Lab 11: Securing Azure SQL Database
# Student lab manual

## Lab scenario

You have been asked to review security features for Azure SQL database. Specifically, you are interested in:

- Protection against attacks such as SQL injection and data exfiltration. 
- Ability to discover and classify database information into categories such as Confidential. 
- Ability to audit database server and database queries and log events. 

> For all the resources in this lab, we are using the **East US** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete the following exercise:

- Exercise 1: Implement SQL Database security features

## Lab files:

- **\\Allfiles\\Labs\\11\\azuredeploy.json**

### Exercise 1: Implement SQL Database security features

### Estimated timing: 30 minutes

In this exercise, you will complete the following tasks:

- Task 1: Deploy an Azure SQL Database
- Task 2: Configure Advanced Data Protection
- Task 3: Configure Data Classification
- Task 4: Configure Auditing

#### Task 1: Deploy an Azure SQL Database

In this task, you will use a template to deploy the lab infrastructure. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

    >**Note**: Sign in to the Azure portal using an account that has the Owner or Contributor role in the Azure subscription you are using for this lab.

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Deploy a custom template** and press the **Enter** key.

1. On the **Custom deployment** blade, click the **Build your own template in the editor** option.

1. On the **Edit template** blade, click **Load file**, locate the **\\Allfiles\\Labs\\11\\azuredeploy.json** file and click **Open**.

    >**Note**: Review the content of the template and note that it deploys an Azure SQL database.

1. On the **Edit template** blade, click **Save**.

1. On the **Custom deployment** blade, ensure that the following settings are configured (leave any others with their default values):

   |Setting|Value|
   |---|---|
   |Subscription|the name of the Azure subscription you will be using in this lab|
   |Resource group|click **Create new** and type the name **AZ500LAB11**|
   |Location|**(US) East US**|

1. Click the **I agree to the terms and conditions stated above** checkbox, and click **Purchase**.

    >**Note**: Wait for the deployment to complete. 

#### Task 2: Configure Advanced Data Protection

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Resource groups** and press the **Enter** key.

1. On the **Resource groups** blade, in the list of resource group, click the **AZ500LAB11** entry.

1. On the **AZ500LAB11** blade, click the entry representing the newly created SQL Server.

1. On the server blade, in the **Security** section, click **Advanced data security**.

1. Set the **ADVANCED DATA SECURITY** switch to **ON**.

    >**Note**: Review the information about pricing and the trial period.

1. Click **Advanced Threat Protection Types**. 

1. On the **Advanced Threat Protection Types** blade, review the listing of threat types, click **OK** and back on the **ADVANCED DATA SECURITY**  pane, click **Save**.

1. In the **VULNERABILITY ASSESSMENT SETTINGS** section, click **Storage account**.

1. On the **Create storage account** blade, in the **Name** box, type a globally unique name consisting of between 3 and 24 lower case letters and digits, click **OK**, and back on the **ADVANCED DATA SECURITY** pane, click **Save**.

    >**Note**: If you receive an error message regarding invalid storage container path then the storage account may not have been provisioned yet. Wait a few minutes, click **Storage account**, on the **Choose storage account** blade, select the newly created storage account and back on the **ADVANCED DATA SECURITY**  pane, click **Save**.

#### Task 3: Configure Data Classification

In this task, you will discover and classify information in SQL database for GPDR and data protection compliance.

1. On the server blade, in the **Settings** section, click **SQL Databases**.

1. In the list of databases, select the **AZ500LabDb** entry. 

1. On the **AZ500LabDb** SQL database blade, in the **Security** section, click **Advanced data security**.

1. On the Advanced data security blade, click the **Data Discovery & Classification** tile.

1. On the **Data Discovery & Classification** blade, click the **Classification** tab.

    >**Note**: The classification engine scans your database for columns containing potentially sensitive data and provides a list of recommended column classifications.

1. Click the text message **We have found 15 columns with classification recommendations** displayed on blue bar at the top of the blade.

1. Review the listed columns and the recommended sensitivity label. 

1. Enable the **Select all** checkbox and then click **Accept Selected Recommendations**.

    >**Note**: Alternatively, you could select only certain columns and dismiss others. 

    >**Note**: You have the option to change the information type and sensitivity label. 

1. Once you have completed your review click **Save**. 

    >**Note**: This will complete the classification and persistently label the database columns with the new classification metadata. 

1. Back on the Advanced data security blade, note that the **Data Discovery & Classification** tile has been updated to account for the latest classification information. 

#### Task 4 : Configure auditing 

In this task, you will first configure server level auditing and then configure database level auditing. 

1. In the Azure portal, navigate back to the SQL Server blade.

1. On the SQL Server blade, in the **Security** section, click **Auditing**.

    >**Note**: This is server level auditing. The default auditing settings include all the queries and stored procedures executed against the database, as well as successful and failed logins.

1. Set the **Auditing** switch to **ON** to enable auditing. 

1. Select the **Storage** checkbox and click **Configure**. 

1. On the **Storage settings** blade, click **Storage account**.

1. On the **Create storage account** blade, in the **Name** box, type a globally unique name consisting of between 3 and 24 lower case letters and digits, click **OK**, 

1. Back on the **Storage settings** blade, set **Retention (days)** to **5** and click **OK**. 

1. Back on the Auditing blade, click **Save** to save the auditing settings. 

    >**Note**: If you receive an error message regarding invalid storage container path then the storage account may not have have been provisioned yet. Wait a few minutes, click **Storage account**, on the **Choose storage account** blade, select the newly created storage account and back on the Auditing blade, click **Save**.

1. On the server blade, in the **Settings** section, click **SQL Databases**.

1. In the list of databases, select the **AZ500LabDb** entry. 

1. On the **AZ500LabDb** SQL database blade, in the **Security** section, click **Auditing**. 

    >**Note**: This is database level auditing. Server-level auditing is already enabled. 
  
    >**Note**: Audits can be written to an Azure storage account, to a Log Analytics workspace, or to the Event Hub. You can configure any combination of these options.

    >**Note**: If storage-based auditing is enabled on the server, it will always apply to the database, regardless of the database settings.

1. Click **View Audit Logs**.

1. On the **Audit records** blade, note that you can switch between Server audit and Database audit. 

    >**Note**: Since this SQL server and database were created recently, it is unlikely that any events will be available at this point. 

> Results: You have created a SQL server and database, configured data classification, and auditing. 


**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 

1. In the Azure portal, open the Cloud Shell by clicking the first icon in the top right of the Azure Portal. If prompted, click **PowerShell** and **Create storage**.

1. Ensure **PowerShell** is selected in the drop-down menu in the upper-left corner of the Cloud Shell pane.

1. In the PowerShell session within the Cloud Shell pane, run the following to remove the resource group you created in this lab:
  
    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB11" -Force -AsJob
    ```
1. Close the **Cloud Shell** pane. 
