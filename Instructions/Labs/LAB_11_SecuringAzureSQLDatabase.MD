---
lab:
    title: '11 - Securing Azure SQL Database'
    module: 'Module 03 - Secure data and applications'
---

# Lab 11 - Securing Azure SQL Database

# Student lab manual

## Lab scenario

You have been asked to recommend security features for Azure SQL database. Specifically, you are interested in:

- Protection against attacks such as SQL injection and data exfiltration. 
- Ability to discover and classify database information into categories such as Confidential. 
- Ability to audit database server and database queries and log events. 

Lab files:

- **2020\Allfiles\Labs\LAB_11\azuredeploy.json**
- **2020\Allfiles\Labs\LAB_11\azuredeploy.parameters.json**


## Lab objectives

In this lab, you will complete:

- Exercise 1: Implement SQL Database security features

## Instructions

## Exercise 1: Implement SQL Database security features

### Estimated timing: 30 minutes

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is region to use for you class. 

In this exercise, you will complete:

- Task 1: Deploy an Azure SQL Database
- Task 2: Configure Advanced Data Protection
- Task 3: Configure Data Classification
- Task 4: Configure Auditing


#### Task 1: Deploy an Azure SQL Database

In this task, you will use a template to deploy the lab infrastructure. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

1. Under **Azure services** select **Create a resource**.

1. From the **New** blade, search Azure Marketplace for **Template deployment (deploy using custom templates)**.

1. Use the list of search results to navigate to the **Template deployment (deploy using custom templates)** blade. 

1. Click **Create**.

1. On the **Custom deployment** blade, select the **Build your own template in the editor**.

1. From the **Edit template** blade, click **Load file** and locate the **2020\\Allfiles\\Labs\\LAB_08\\template.json** file.

1. Review the content of the template. This template will a SQL Server.

1. Click **Save**.

1. Click **Edit parameters**.

1. Click **Load file**, select **2020\Allfiles\Labs\LAB_11\azuredeploy.parameters.json** and then click **Open**. 

1. Click **Save**.

1. Complete the required parameters.

	- Resource group: **Create new** - **AZ500LAB11**

	- Region: **East US**

	- SQL Server Name: **this must be a globally unique name**

1. Click **Review + Create** and then **Create**.

1. Before proceeding, wait for the SQL database to deploy. 

#### Task 2: Configure Advanced Data Protection

1. Navigate to **Resource Groups** and select your new resource group **AZ500LAB11**

1. Click your new SQL Server. 

1. Under **Security** click **Advanced data security**.

1. Select **ON** and read the information about pricing and the trial period.

1. Click **Advanced Threat Protection Types**. Read through the threat types. Click **OK**

1. **Click Save**.

1. Continue working on the **Advanced data security** blade.  

1. Under **Vulnerability Assessment Settings** select **storage account**.

1. Click **create new** and complete the required information. Take the defaults for everything except **Name**.

	- Name: **this must be unique**

1. Click **OK** to create the storage account. 

1. Click **Save** to save the Advanced Data Security settings. 

	> If you receive an error about the storage container path then the storage account may not have completely deployed. Wait a few minutes and simply reselect the same storage account. Then click Save again.

#### Task 3: Configure Data Classification

In this task, you will discover and classify information in SQL database for GPDR and data protection compliance.
1. Continue working with your SQL Server.

1. Under **Settings** select **SQL Databases**.

1. Select the **AZ500LabDb** database. This was created by the template. 

1. Under **Security** select **Advanced data security** pane

1. Click the **Data discovery & classification** card.

1. Select the **Classification tab**.

	> The classification engine scans your database for columns containing potentially sensitive data and provides a list of recommended column classifications.

1. Click the **We have found 15 columns with classification recommendations** (blue bar) at the top.    

1. Review the listed columns and the recommended sensitivity label. 

1. Click **Select all** and then **Accept Selected Recommendations**.

	> Notice you could select only certain columns and you could dismiss the recommendations. 

	> Notice you can change the Information type and Sensitivity label. 

1. When you have completed your review click **Save**. This will complete the classification and persistently label (**tag**) the database columns with the new classification metadata. 

1. Notice the **Data Discovery & Classification** card has been updated with the latest classification information.  page. 


### Task 4 : Configure auditing 

In this task, you will first configure server level auditing and then configure database level auditing. 

1. Return to your **SQL Server**.

1. Under **Security**, select **Auditing**.

	> This is server level auditing. The default auditing settings include all the queries and stored procedures executed against the database, as well as successful and failed logins.

1. Click **ON** to enable auditing. 

1. Select **Storage** as the audit log location. 

1. Under **Storage details** click **Configure**. Complete the required information. 

	- Storage account: **Create New** - The storage account must be unique. 

	- Click **OK** to finish creating the storage account. 

1. Change the **Retention (days)** to **5** and click **OK** 

1. Click **Save** to save the auditing settings. 

	> If you receive an error about the storage container path then the storage account may not have completely deployed. Wait a few minutes and simply reselect the same storage account. Then click Save again.


1. Under **Settings** select **SQL Databases**.

1. Select the **AZ500LabDb** database. 

1. Under **Security** select **Auditing**. 

1. Click **AZ500LabDb (az500labserver2/AZ500LabDb)** to select your test database

1. **Under Security**, select **Auditing**.

	> This is database level auditing. Notice Server-level Auditing is Enabled. The Database level audit will exist side-by-side with the server audit.
  
1. Notice audits can be written to an Azure storage account, to a Log Analytics workspace for consumption by Azure Monitor logs, or to the Event Hub.. You can configure any combination of these storage options.

1. Click **View Audit Logs**.

1. Notice you can switch between Server audit and Database. 

	> Since this SQL server and database were created recently, there will probably not be any log events. 

> Results: You have created a SQL server and database, configured data classification, and auditing. 


**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 

1. Access the Cloud Shell.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. Remove the resource group using the Cloud Shell and PowerShell.

    ```
    Remove-AzResourceGroup -Name "AZ500LAB11"
    ```