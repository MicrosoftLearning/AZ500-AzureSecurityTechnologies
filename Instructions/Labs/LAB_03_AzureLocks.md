---
lab:
    title: '03 - Resource Manager Locks'
    module: 'Module 01 - Manage Identity and Access'
---

# Lab 03 - Resource Manager Locks

# Student lab manual

## Lab scenario 

You have been asked to create a proof of concept showing how resource locks can be used to prevent accidental deletion or changes. Specifically, you need to:

- 

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is the region to use for class. 
 
## Lab objectives

In this lab, you will complete:

- Exercise 1: Resource Manager Locks

## Exercise 1: Resource Manager Locks

### Estimated timing: 20 minutes

In this exercise, you will complete:

- Task 1: Create a resource group with a storage account.
- Task 2: Add a ReadOnly lock on the storage account. 
- Task 3: Test the ReadOnly lock. 
- Task 4: Remove the ReadOnly lock and create a Delete lock.
- Task 5: Test the Delete lock.

#### Task 1: Create a resource group with a storage account.

In this task, you will create a resource group and storage account for the lab. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

1. Open the Azure Cloud Shell.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

    ```
    New-AzResourceGroup -Name AZ500LAB03 -Location 'EastUS'
    ```
    
    ```
    New-AzStorageAccount -ResourceGroupName AZ500LAB03 -Name (Get-Random -Maximum 999999999999999) -Location  EastUS -SkuName Standard_LRS -Kind StorageV2 
	```

#### Task 2: Add a ReadOnly lock on the storage account. 

In this task, you will add a read only lock to the storage account. This will protect the resource from accidental deletion or modification. 

1. Navigate to the **AZ500LAB03** resource group.

1. Select the new storage account. 

1. Under **Settings**, click the "Locks" icon.

1. Click **Add**.

	- Lock name: **ReadOnly Lock** 

	- Lock type: **Read-only**

1. Click **OK**. 

1. The resource is now protected from accidental deletion and modification.

#### Task 3: Test the ReadOnly lock 

1. Under **Settings** in the main storage account blade choose **Configuration**.

1. Under **Secure transfer required** click **Disabled** and then **Save**.

	> Secure transfer required support HTTPS for custom domain names.

1. You should received an error - **Update failed**.

1. The **Notification** in the top right provides more information: 

	> **"Failed to update storage account 'xxxxxxxx'. Error: The scope 'xxxxxxxx' cannot perform write operation because following scope(s) are locked: '/subscriptions/xxxxx-xxx-xxxx-xxxx-xxxxxxxx/resourceGroups/AZ500LAB03/providers/Microsoft.Storage/storageAccounts/xxxxxxx'. Please remove the lock and try again"**

1. Return the the **Configuration** page and **Discard** any changes. 

1. From the **Overview** page click **Delete**.

1. Type in the name of the storage account to confirm, then click **Delete**.

1. Again the **Notification** icon provides detailed information:

	> **"Failed to delete storage account 'xxxxxxx'. Error: The scope 'xxxxxxx' cannot perform delete operation because following scope(s) are locked: '/subscriptions/xxxx-xxxx-xxxx-xxxx-xxxxxx/resourceGroups/AZ500LAB03/providers/Microsoft.Storage/storageAccounts/xxxxxxx'. Please remove the lock and try again."**

1. You have now verified that a ReadOnly lock will stop accidental deletion and modification of a resource.

#### Task 4: Remove the ReadOnly lock and create a Delete lock.

In this task, you remove the ReadOnly lock from the storage account and create a Delete lock. 

1. Return to your Storage account.

1. Under **Settings** select **Locks**.  

1. Click on the **Delete** icon (far right) of the **ReadOnly Lock**.

1. Click **Add**

	- Lock name: **Delete Lock** 
	
	- Lock type: **Delete**
 
1. Click **OK**.

#### Task 5: Test the Delete lock.

In this task, you will test the Delete lock. You should be able to modify the storage account, but not delete it. 

1. Under **Settings** in the main storage account blade choose **Configuration**.

1. Under **Secure transfer required** click **Enabled** and then **Save**.

1. You should be able to update the storage account without an error.

1. Click the **Overview** blade.

1. Click **Delete** (top) to remove the storage account.  

1. You should receive a warning.  

	> **'xxxxxx' can't be deleted because this resource or its parent has a delete lock. Locks must be removed before this resource can be deleted. Learn more"**

1. You have now verified that a **Delete** lock will allow configuration changes but stop accidental deletion.

	> By using Resource Locks you can put in place an extra line of defense against accidental or malicious changing and/or deletion of your most important resources. It's not perfect, as your administrators can still remove these locks, but doing so requires a conscious effort, as the only purpose for removing a lock is to circumvent it. As these locks sit outside of RBAC you can apply them and be sure that they are impacting all your users, regardless of what roles or custom permissions you may have granted them.

> Results: In this exercise, you learned to use Resource Manager locks to protect resources from modification and accidental deletion.

**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs.

1. To remove the lock use the following 3 commands. After the 3rd command appears you may need to press **Enter** .(When prompted to confirm press Y and press enter):

     ```
    $Storageaccountname = (get-azstorageaccount -ResourceGroupName AZ500LAB03).StorageAccountName
    $LockName = (Get-AzResourceLock -ResourceGroupName AZ500LAB03 -ResourceName $Storageaccountname -ResourceType Microsoft.Storage/storageAccounts).Name
    Remove-AzResourceLock -LockName $LockName -ResourceName $Storageaccountname  -ResourceGroupName AZ500LAB03 -ResourceType Microsoft.Storage/storageAccounts
     ```
1.  Remove the resource group by running the following command (When prompted to confirm press Y and press enter):
    ```
    Remove-AzResourceGroup -Name "AZ500LAB03"
    ```
1.  Close the **Cloud Shell**. 