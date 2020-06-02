---
lab:
    title: '13 - Azure Monitor'
    module: 'Module 04 - Manage security operations'
---

# Lab 13 - Azure Monitor

# Student lab manual

## Lab scenario

You have been asked to create a proof of concept demonstration for monitoring virtual machine performance. Specifically, you want to:

- Configure a virtual machine so data can be collected.
- Show what data can be collected.
- Show how the data can be used including how to query the data. 

## Lab objectives

In this lab, you will complete:

- Exercise 1: Collect data from an Azure virtual machine with Azure Monitor

## Exercise 1: Collect data from an Azure virtual machine with Azure Monitor

### Exercise timing: 20 minutes

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is the region to use for class. 

In this exercise, you will complete: 

- Task 1: Deploy an Azure virtual machine 
- Task 2: Create a Log Analytics workspace
- Task 3: Enable the Log Analytics virtual machine extension
- Task 4: Collect virtual machine event and performance data
- Task 5: View and query collected data 

#### Task 1: Deploy an Azure virtual machine

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. Create a new resource group. This resource group will be used for labs 13, 14, and 15. 

    ```
    New-AzResourceGroup -Name AZ500LAB131415 -Location EastUS
    ```

1. Create a new virtual machine. 

    ```
    New-AzVm -ResourceGroupName "AZ500LAB131415" -Name "myVM" -Location "East  US" -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName   "myNetworkSecurityGroup" -PublicIpAddressName "myPublicIpAddress"     -OpenPorts 80,3389
    ```

1.  When prompted for credentials:

	- User: **localadmin** 

	- Password for user localadmin: **Pa55w.rd**

1. Wait for the resources to be created. 

1. Confirm that your virtual machine, **myVM**, was created and the **ProvisioningState** is **Succeeded**.

	```
	Get-AzVM
	```

1. Close the Cloud Shell. 

#### Task 2: Create a Log Analytics workspace

In this task, you will create a Log Analytics workspace. 

1. Continue in the Portal.

1. Use the Portal menu and select **All services**. 

1. Search for and select **Log Analytics workspaces**.

1. Click **+ Add** and complete the required information. Take the default value for a setting that is not specified.

	- Resource group: **AZ500LAB131415**

	- Name: **Select a unique name that is available**

	- Region: **EastUS** 
  
1. Move to the **Pricing tier** tab and notice you are on **Pay-as-you-go (Per GB 2018)**.

1. Click **Review + Create** and then **Create**.

1. Wait for the resource to deploy, then click **Go to resource**.

#### Task 3: Enable the Log Analytics virtual machine extension

In this task, you will enable the Log Analytics virtual machine extension. This extension installs an agent on Windows and Linux virtual machines. This agent provides data from the virtual machine to the Log Analytics workspace. Once the agent is installed it will be automatically upgraded ensuring you always have the latest features and fixes. 

1. Continue working with your new Log Analytics workspace.

1. Under **Workspace Data Sources** select **Virtual machines**.

	> For the agent to be successfully installed, the virtual machine must be running.

1. Notice **myVM** is listed as **Not connected**.

1. Click **myVM** and then select **Connect**. 

1. Wait for Log Analytics to connect to the virtual machine. 

	> This may take a few minutes. The **Status** will change from **Connecting** to **This workspace**. 

#### Task 4: Collect virtual machine event and performance data

In this task, you will configure collecting data from the Windows System log and several common performance counters. You will also review the other sources that are available.

1. Return to your Log Analytics workspace.

1. Under **Settings** select **Advanced settings**.

1. Select **Data** and notice your choices for Windows Event Logs, Windows Performance Counters, Linux Performance Counters, IIS Logs, and Syslog. 

3. Select **Windows Event Logs**.

1. In the **Collect events from the following event logs** type in **System** and then click the **+** sign.

	> This is how you add event logs to the workspace. Other choices could be **Hardware events** and **Key Management Service**.  

1. Select only the **Error** and **Warning** check boxes.

1. To add an event log, use the  You add an event log by typing in the name of the log.  Type **System** and then select the plus sign **+**.

1. Select **Windows Performance Counters**.

1. Notice there is a suggested list of performance counters. You can customize this list. 

1. Click **Add the selected performance counters**. The counters are added and preset with a ten second collection sample interval.
  
1. **Save** (top of page) and then click **OK**.

#### Task 5: View and query collected data

In this task, you will run a log search on your data collection. 

1. Continue working with your Log Analytics workspace.

1. Under **General** select **Logs**.

1. Click **Get started**.  

1. In the **All queries** pane, select **Virtual machines**.

1. Notice the large number of predefined queries. Take a minute to review the list.

1. Select a query. For example, Virtual machine available memory.

1. Notice the query opens in the editor. Log analytics uses the Kusto query language. You can customize the existing queries or create your own. 

1. Click *Run**.

	> Since this virtual machine was just created, there may not be any data yet. 

1. Notice the ability to **Chart** your data, **Save** your query, and create a **New alert rule** based on the query.

> Results: In this lab, you learned how to use a Log Analytics workspace to configure data sources and query logs. 

**Clean up resources**

	> Do not remove the resources from this lab as they are needed for the Azure Security Center lab and the Azure Sentinel lab.