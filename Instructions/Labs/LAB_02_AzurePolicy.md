---
lab:
    title: '02 - Azure Policy'
    module: 'Module 01 - Manage Identity and Access'
---

# Lab 02 - Azure Policy

# Student lab manual

## Lab scenario

You have been asked to create a proof of concept showing how Azure policy is used. Specifically, you need to:

- Create an Allowed Locations policy that ensures resource are only created in a specific region.
- Test to ensure resources are only created in the Allowed location

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete:

- Exercise 1: Implement Azure Policy. 

## Exercise 1: Implement Azure Policy

### Estimated timing: 20 minutes

In this exercise, you will complete:

- Task 1: Create a resource group for the policy. 
- Task 2: Create an Allowed Locations policy assignment.
- Task 3: Verify the Allowed Locations policy assignment is working. 

#### Task 1: Create a resource group for the lab. 

In this task, you will create a resource group for the lab. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

1. Open the Cloud Shell. 

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

	**Previously, you created a resource group in the Portal. Now, you will create the group using PowerShell. 

1. Create a resource group. Consult your instructor for the preferred region.

    ```
    New-AzResourceGroup -Name AZ500LAB02 -Location 'East US'
    ```

1. Verify the list of resource groups.

	```
	Get-AzResourceGroup | format-table
	```

1. Close the **Cloud Shell**.

#### Task 2: Create an Allowed Locations policy assignment.

In this task, you will create an Allowed Locations policy assignment and specify which Azure regions the policy can use. 

1. In the Portal menu select **All services**. 

1. Search for and select **Policy**.

1. Under **Authoring** select **Definitions**.

1. Take a minute to browse the built-in definitions. Use the **Category** drop-down to narrow your review.

1. In the **Search** filter type **Allowed locations**. 

	> This policy only restricts resource locations, not resource group locations. There is a separate policy for 'Allowed locations for resource groups'.

1.  Click on the **Allowed locations** policy definition to open the definition details view. 

	> This policy definitions take an array of locations as parameters. A policy rule is an ‘if-then’ statement. The ‘if’ clause checks to see if the resource location is included in the parameter list, and if not the ‘then’ clause denies the resource creation.

1.  Click **Assign**.

1.  Under **Scope** click the Ellipsis (...) button and assign the policy to **your Subscription** and then  the **AZ500LAB02** resource group.

1. Click **Select** to make the assignment.
 
1. Complete the remainder of the policy assignment **Basics** tab.

	-   Exclusions: **Leave blank**
    
	-   Assignment name: **Allow UK South for AZ500LAB02**
    
	-   Description: **Allow resources to be created in UK South Only for AZ500LAB02**
    
	-   Policy enforcement: **Enabled**
    
	-   Assigned by: **Your name**

1. Click **Next** to proceed to the **Parameters** tab. 

1. Select **UK South** as the allowed location. Notice you can select more than one location. If the policy required a different set of parameters, this tab would provide those selections. 

1. Click **Review + create**, followed by **Create** to create the policy assignment. 

1.  You will see a notification that the assignment was successful, and that the assignment will take around 30 minutes to complete.

	> The reason the Azure policy assignment takes up to 30 minutes to be assigned is that is has to replicate globally although in the real world it generally only takes 2 - 3 minutes to be implemented.  If the next task fails, simply wait a few minutes and attempt the steps again.

#### Task 2: Test the Allowed Locations policy assignment

In this task, you will test the Allowed Locations policy. 

1. In the Portal menu select **All services**. 

1. Search for and select **Virtual networks**.

1.  On the **Virtual Networks** blade, click **Add**.

	> First, you will try to create a virtual network in East US. Since this is not an allowed location, the request should be blocked. 

1. On the **Create virtual network** blade, complete the **Basics** tab.

	-   Resource group: **AZ500LAB02**
	
    -   Name: **myVnet**
 
    -   Location: **East US**

1. Click **Review + Create** and then **Create**. 

1. Notice the **Deployment failed** message. 

1. Click the error to open the error details. You will see the resource deployment was disallowed by policy.

1. Try again to create a virtual network, but this time change the resource location to **UK South**. This is the location permitted by the policy. 

2. Click **Create** again and verify that the operation is successful.  

> Exercise results: In this exercise, you learned to use Azure policy by browsing the built-in policy definitions and creating a policy assignment.

**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs.

1. Access the Cloud Shell.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. Remove the resource group by running the following command (When prompted to confirm press Y and press enter):
  
    ```
    Remove-AzResourceGroup -Name "AZ500LAB02"
    ```
1.  Close the **Cloud Shell**. 