---
lab:
    title: '13 - Azure Monitor'
    module: 'Module 04 - Manage security operations'
---

# Lab 13: Azure Monitor
# Student lab manual

## Lab scenario

You have been asked to create a proof of concept of monitoring virtual machine performance. Specifically, you want to:

- Configure a virtual machine such that telemetry and logs can be collected.
- Show what telemetry and logs can be collected.
- Show how the data can be used and queried. 

> For all the resources in this lab, we are using the **East US** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete the following exercise:

- Exercise 1: Collect data from an Azure virtual machine with Azure Monitor

## Azure Monitor

![image](https://user-images.githubusercontent.com/91347931/157536648-0a286514-a7e2-4058-9dea-e42da21eef76.png)

## Instructions

### Exercise 1: Collect data from an Azure virtual machine with Azure Monitor

### Exercise timing: 20 minutes

In this exercise, you will complete the following tasks: 

- Task 1: Deploy an Azure virtual machine 
- Task 2: Create a Log Analytics workspace
- Task 3: Enable the Log Analytics virtual machine extension
- Task 4: Collect virtual machine event and performance data
- Task 5: View and query collected data 

#### Task 1: Deploy an Azure virtual machine

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

    >**Note**: Sign in to the Azure portal using an account that has the Owner or Contributor role in the Azure subscription you are using for this lab.

2. Open the Cloud Shell by clicking the first icon in the top right of the Azure Portal. If prompted, select **PowerShell** and **Create storage**.

3. Ensure **PowerShell** is selected in the drop-down menu in the upper-left corner of the Cloud Shell pane.

4. In the PowerShell session within the Cloud Shell pane, run the following to create a resource group that will be used in this lab:
  
    ```powershell
    New-AzResourceGroup -Name AZ500LAB131415 -Location 'EastUS'
    ```

    >**Note**: This resource group will be used for labs 13, 14, and 15. 

5. In the PowerShell session within the Cloud Shell pane, run the following to create a new Azure virtual machine. 

    >**Attention**: The New-AzVm command doesn't work in the Azure CLI version 4.24 and Microsoft is currently investigating for resolution.  The work around in this lab is to install and revert back to Az.Compute version 4.23.0, which is unaffected by this issue.
   
    >**Instructions**: Reverting back to Az.Compute version 4.23.0 
  
   #### Step 1: Download the working version of the module (4.23.0) into your cloud shell session 
   **Type**: Install-Module -Name Az.Compute -Force -RequiredVersion 4.23.0

   #### Step 2: Start a new PowerShell session that will allow the Az.Compute assembly version to be loaded 
   **Type**: pwsh

   #### Step 3: Verify that version 4.23.0 is loaded
   **Type**: Get-Module -Name Az.Compute
   
    ```powershell
    New-AzVm -ResourceGroupName "AZ500LAB131415" -Name "myVM" -Location 'EastUS' -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName   "myNetworkSecurityGroup" -PublicIpAddressName "myPublicIpAddress" -OpenPorts 80,3389
    ```

6.  When prompted for credentials:

    |Setting|Value|
    |---|---|
    |User |**localadmin**|
    |Password|**Please use your personal password created in Lab 04 > Exercise 1 > Task 1 > Step 9.**|

    >**Note**: Wait for the deployment to complete. 

7. In the PowerShell session within the Cloud Shell pane, run the following to confirm that the virtual machine named **myVM** was created and its **ProvisioningState** is **Succeeded**.

    ```powershell
    Get-AzVM -Name 'myVM' -ResourceGroupName 'AZ500LAB131415' | Format-Table
    ```

8. Close the Cloud Shell pane. 

#### Task 2: Create a Log Analytics workspace

In this task, you will create a Log Analytics workspace. 

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Log Analytics workspaces** and press the **Enter** key.

2. On the **Log Analytics workspaces** blade, click **+ Create**.

3. On the **Basics** tab of the **Create Log Analytics workspace** blade, specify the following settings (leave others with their default values):

    |Setting|Value|
    |---|---|
    |Subscription|the name of the Azure subscription you are using in this lab|
    |Resource group|**AZ500LAB131415**|
    |Name|any valid, globally unique name|
    |Region|**(US) East US**|

4. Select **Review + create**.

5. On the **Review + create** tab of the **Create Log Analytics workspace** blade, select **Create**.

#### Task 3: Enable the Log Analytics virtual machine extension

In this task, you will enable the Log Analytics virtual machine extension. This extension installs the Log Analytics agent on Windows and Linux virtual machines. This agent collects data from the virtual machine and transfers it to the Log Analytics workspace that you designate. Once the agent is installed it will be automatically upgraded ensuring you always have the latest features and fixes. 

1. In the Azure portal, navigate back to the **Log Analytics workspaces** blade, and, in the list of workspaces, click the entry representing the workspace you created in the previous task.

2. On the Log Analytics workspace blade, on the **Overview** page, in the **Connect a Data Source** section, click the **Azure Virtual machines (VMs)** entry.

    >**Note**: For the agent to be successfully installed, the virtual machine must be running.

3. In the list of virtual machines, locate the entry representing the Azure VM **myVM** you deployed in the first task of this exercise and note that it is listed as **Not connected**.

4. Click the **myVM** entry and then, on the **myVM** blade, click **Connect**. 

5. Wait for the virtual machine to connect to the Log Analytics workspace.

    >**Note**: This may take a few minutes. The **Status** displayed on the **myVM** blade, will change from **Connecting** to **This workspace**. 

#### Task 4: Collect virtual machine event and performance data

In this task, you will configure collection of the Windows System log and several common performance counters. You will also review other sources that are available.

1. In the Azure portal, navigate back to the Log Analytics workspace you created earlier in this exercise.

2. On the Log Analytics workspace blade, in the **Settings** section, click **Agents configuration**.

3. On the **Agents configuration** blade, review the configurable settings including Windows Event Logs, Windows Performance Counters, Linux Performance Counters, IIS Logs, and Syslog. 

4. Ensure that **Windows Event Logs** is selected, click **+ Add windows event log**, in the listing of event log types, select **System**.

    >**Note**: This is how you add event logs to the workspace. Other choices include, for example, **Hardware events** or **Key Management Service**.  

5. Deselect the **Information** checkbox, leaving the **Error** and **Warning** check boxes selected.

6. Click **Windows Performance Counters**, click **+ Add performance counter**, review the listing of available performance counters, and add the following ones:

    - Memory(\*)\Available Memory Mbytes
    - Process(\*)\%Processor Time
    - Event Tracing for Windows\Total Memory Usage --- Non-Paged Pool
    - Event Tracing for Windows\Total Memory Usage --- Paged Pool

    >**Note**: The counters are added and configured with 60 second collection sample interval.
  
7. On the **Agents configuration** blade, click **Apply**.

#### Task 5: View and query collected data

In this task, you will run a log search on your data collection. 

1. In the Azure portal, navigate back to the Log Analytics workspace you created earlier in this exercise.

2. On the Log Analytics workspace blade, in the **General** section, click **Logs**.

3. If needed, close the **Welcome to Log Analysis** window. 

4. On the **Queries** pane, in the **All Queries** column, scroll down to the bottom of the list of resource types, and click **Virtual machines**
    
5. Review the list of predefined queries, select **Memory and CPU usage**, and click the corresponding **Run** button.

    >**Note**: You can start with the query **Virtual machine available memory**. If you don't get any results check the scope is set to virtual machine

6. The query will automatically open in a new query tab. 

    >**Note**: Log Analytics uses the Kusto query language. You can customize the existing queries or create your own. 

    >**Note**: The results of the query you selected are automatically displayed below the query pane. To re-run the query, click **Run**.

    >**Note**: Since this virtual machine was just created, there may not be any data yet. 

    >**Note**: You have the option of displaying data in different formats. You also have the option of creating an alert rule based on the results of the query.

    >**Note**: You can generate some additional load on the Azure VM you deployed earlier in this lab by using the following steps:

    1. Navigate to the Azure VM blade.
    2. On the Azure VM blade, in the **Operations** section, select **Run command**, on the **RunPowerShellScript** blade, type the following script, and click **Run**:
    3. 
       ```cmd
       cmd
       :loop
       dir c:\ /s > SWAP
       goto loop
       ```
       
    4. Switch back ot the Log Analytics blade and re-run the query. You might need to wait a few minutes for data to be collected and re-run the query again.

> Results: You used a Log Analytics workspace to configure data sources and query logs. 

**Clean up resources**

>**Note**: Do not remove the resources from this lab as they are needed for the Azure Security Center lab and the Azure Sentinel lab.
 
