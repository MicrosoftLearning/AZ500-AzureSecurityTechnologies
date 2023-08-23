---
lab:
    title: '13 - Azure Monitor' 
    module: 'Module 04 - Manage security operations'
---

# Lab 13: Azure Monitor

# Student lab manual

## Lab scenario

You have been asked to creating an Azure virtual machione and Log Analytics workspace.

- Deploy an Azure virtual machine.
- Create a Log Analytics workspace.
- Create a Storage account.

> For all the resources in this lab, we are using the **East US** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete the following exercise:

- Exercise 1: Create an Azure virtual machine
  
## Instructions

### Exercise 1: Deploy an Azure virtual machine

### Exercise timing: 10 minutes

In this exercise, you will complete the following tasks: 

- Task 1: Deploy an Azure virtual machine 

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

    ```powershell
    New-AzVm -ResourceGroupName "AZ500LAB131415" -Name "myVM" -Location 'EastUS' -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName   "myNetworkSecurityGroup" -PublicIpAddressName "myPublicIpAddress" -PublicIpSku Standard -OpenPorts 80,3389 -Size Standard_DS1_v2 
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
    |Region|**East US**|

4. Select **Review + create**.

5. On the **Review + create** tab of the **Create Log Analytics workspace** blade, select **Create**.


#### Task 3: Create a storage account

In this task, you will create a storage account.

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Storage accounts** and press the **Enter** key.

2. On the **Storage accounts** blade, click **+ Create**.

    ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/73eb9241-d642-455a-a1ff-b504670395c0)

4. On the **Basics** tab of the **Create storage account** blade, specify the following settings (leave others with their default values):

    |Setting|Value|
    |---|---|
    |Subscription|the name of the Azure subscription you are using in this lab|
    |Resource group|**AZ500LAB131415**|
    |Storage account name|any globally unique name between 3 and 24 in length consisting of letters and digits|
    |Location|**(US) EastUS**|
    |Performance|**Standard (general-purpose v2 account)**|
    |Redundency|**Locally redundant storage (LRS)**|

5. On the **Basics** tab of the **Create storage account** blade, click **Review + Create**, wait for the validation process to complete, and click **Create**.

     ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/13c7a0f6-1057-4498-817a-6ccb569a49db)

    >**Note**: Wait for the Storage account to be created. This should take about 2 minutes.
    
   
#### Task 4: Create a diagnostic setting

In this task, you will create and define where to send resource logs for a particular resource. 

1. Under the Monitoring section of your previously created storage resource, select **Diagnostic settings.**
  
   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/5d552991-305a-44bf-b8a5-7d4acae97257)


2. Click your previously created storage resource.
  
   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/8a745437-6408-49be-85af-a18a24218f32)

3. Then select **+ Add diagnostic setting.**

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/0ec0b760-f43d-4269-9d4f-ccba6bd7709d)


    |Setting|Value|
    |---|---|
    |Subscription|the name of the Azure subscription you are using in this lab|
    |Resource group|**AZ500LAB131415**|
    |Storage account name|any globally unique name between 3 and 24 in length consisting of letters and digits|
    |Location|**(US) EastUS**|
    |Performance|**Standard (general-purpose v2 account)**|
    |Redundency|**Locally redundant storage (LRS)**|

8. On the **Basics** tab of the **Create storage account** blade, click **Review + Create**, wait for the validation process to complete, and click **Create**.

  ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/13c7a0f6-1057-4498-817a-6ccb569a49db)


    >**Note**: Wait for the Storage account to be created. This should take about 2 minutes.

> Results: You deployed an Azure virtual machine and created a Log Analytics workspace.

>**Note**: Do not remove the resources from this lab as they are needed for the Microsoft Defender for Cloud lab and the Microsoft Sentinel lab.
 
