---
lab:
    title: ' 12 - Service Endpoints and Securing Storage'
    module: 'Module 03 - xxx'
---

# Lab 12 - Service Endpoints and Securing Storage

# Student lab manual

## Lab scenario

You have been asked to create a proof of concept to demonstrate securing Azure file shares. Specifically, you want to:
	
	- Create a storage endpoint so traffic destined to the storage always stays on the Azure backbone network.
	- Configure the storage endpoint so only resources from a specific subnet can access the storage.
	- Confirm that resources outside the designated subnet cannot access the storage. 

## Lab objectives

In this lab, you will complete:

- Exercise 1: Service endpoints and security storage

## Exercise 1: Service endpoints and security storage

### Estimated timing: 45 minutes

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is region to use for your class. 

In this exercise, you will complete:

- Task 1: Create a virtual network.
- Task 2: Add a subnet to the virtual network and configure a storage endpoint.
- Task 3: Configure a network security group to restrict access to the subnet.
- Task 4: Create a storage account with a file share.
- Task 5: Connect to the private subnet virtual machine and map a drive to the file share. 
- Task 6: Test the storage connection from the private subnet - confirm access.
- Task 7: Test the storage connection from the public subnet - access denied.  

#### Task 1: Create a virtual network

In this task, you will create a virtual network.

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

1. On the Portal menu (top left) select **All services**.

1. Select **Networking**, and then select **Virtual networks**.

1. Click **Add** and configure the **Basics** tab.

	- Resource group: Select **Create new** and enter **AZ500LAB12**. 

	- Name: **myVirtualNetwork**

	- Region: **East US**

1. Click **Next: IP Addresses**. 

	- Review the IPv4 address space (10.0.0.0/16).

	- Select the **default** subnet (10.0.0.0/24) and rename it to **Public**.

	- **Save** your changes. 

1. Click **Next: Security**. 

	- DDoS protection: **Basic**

	- Firewall: **Disabled**

1. Click **Review + Create** and then **Create**.

1. Monitor your deployment using the **Notification** icon, top right. 
                                      |
#### Task 2: Add a subnet to the virtual network and configure a storage endpoint

In this task, you will create a subnet and enable a service endpoint for the subnet. Service endpoints are enabled per service, per subnet. 

1. Continue working with your new virtual network.

	> You can locate this virtual network by using the Portal search box (top).

2. Under **Settings**, select **Subnets**.

1. Select **+ Subnet** and create the required information. Take the default value for a setting that is not specified.

3.  Under **Add subnet**, select or enter the following information, and then select **OK**:

	- Name: **Private**

	- Address range: **10.0.1.0/24**

	- Service endpoints: **Services - **Microsoft.Storage** 

1. Click **OK** to add the new subnet.

	> The virtual network should now have two subnets: default and Private. 
	
#### Task 3: Configure a network security group to restrict access to the subnet

In this task, you will create a network security group with two outbound security rules (Storage and internet) and one inbound security rule (RDP). You will also associate the network security group with the Private subnet. By default, all virtual machines in a subnet can communicate with all resources. This task will limit communication. 

1. On the Portal menu (top left) select **All services**.

1. Select **Networking**, and then select **Network security groups**.

1. Click **Add** and configure the required settings.

	- Resource group: **AZ500LAB12**

	- Name: **myNsgPrivate**

	- Region: **East US**

1. Click **Review + Create** and then **Create**.

1. Monitor your deployment using the **Notification** icon, top right. 

1. Once the NSG deploys, **Go to resource**.

1. In the next steps, you will create an outbound security rule that allows communication to the Azure Storage service. 

1. Under **Settings**, select **Outbound security rules**.

1. Select **+ Add** and complete the required information. Take the default value for any setting that is not specified. 

	- Source: **VirtualNetwork**

	- Destination: **Service Tag**

	- Destination service tag: **Storage**

	- Destination port ranges: *                                                                                               

	- Protocol: **Any**

	- Action: **Allow**

	- Name: **Allow-Storage-All**

1. Click **Add** to complete the outbound rule.

1. In the next steps, you will create another outbound security rule. This rule will deny outbound communication to the internet. This rule overrides a default rule in all network security groups that allows outbound internet communication. 

1. Under **Settings**, select **Outbound security rules**.

1. Select **+ Add** and complete the required information. Take the default value for any setting that is not specified. 

	- Source: **VirtualNetwork**

	- Destination: **Service Tag**

	- Destination service tag: **Internet**

	- Destination port ranges: *                                                                                               

	- Protocol: **Any**

	- Action: **Deny**

	- Priority: **110**

	- Name: **Deny-Internet-All**

1. Click **Add** to complete the outbound rule.

1. In the next steps, you will create an inbound security rule that allows Remote Desktop Protocol (RDP) traffic to the subnet. The rule overrides a default security rule that denies all inbound traffic from the internet. Remote desktop connections are allowed to the subnet so that connectivity can be tested in a later step.

1. Under **Settings**, select **Inbound security rules**.

1. Select **+ Add** and complete the required information. Take the default value for any setting that is not specified. 

	- Source: **Any**

	- Source port ranges: *

	- Destination: **VirtualNetwork**

	- Destination port ranges: **3389**                                                                                              

	- Protocol: **Any**

	- Action: **Allow**

	- Priority: **120**

	- Name: **Allow-RDP-All**

1. Click **Add** to complete the outbound rule.

1. Lastly, you will associate the network security group with the Private subnet.

1. Under **Settings**, select **Subnets** and then select **+ Associate**. 

	- Virtual network: **myVirtualNetwork**
	
	- Subnet: **Private**

1. Click **OK** to finish the association.

#### Task 4: Create a storage account with a file share

In this task, you will create a storage account with a file share and obtain the storage account key.  

1. On the Portal menu (top left) select **All services**.

1. Under **Storage** select **Storage accounts**. 

1. Click **+ Add** and complete the Basics required information. Take the default value for any setting that is not specified. 

	- Resource group:  **AZ500Lab12**

	- Account storage name: **select a name that is unique across all Azure regions**

	- Account kind: **StorageV2 (general purpose v2)
   
1. Click **Review + Create** and then **Create**.

1. Wait for the storage account to deploy.

1. Continue working with your storage account and create a file share. 

1. Under **File service** select **File shares**.

1. Click **+ File Share** and complete the required information.

	- Name: **my-file-share**

	- Quota: **10**

1. Click **Create**.

1. Continue working with your storage account by configuring access from the storage account to the Private subnet.

1. Under **Settings** select **Firewalls and virtual networks**.

1. Click **Selected networks**.

1. Click **+ Add existing virtual network** and complete the required information.

	- Virtual networks: **myVirtualNetwork**

	- Subnet: **Private**

1. Click **Add** and then **Save**.

1. Lastly, retrieve the storage account access key. 

1. Under **Settings** select **Access keys**

1. Copy the **Key1** key. You will need this in a later when mapping the file share to a drive letter in a virtual machine.  

	> At this point in the lab you have configured a virtual network, network security group, and storage account with file share. 

### Task 5: Create virtual machines

In this task, you will create two virtual machines one in the Private subnet and one in the Public subnet. 

1. This first virtual machine will be in the Private subnet.

1. On the Portal menu (top left) select **Create a resource**.

1. Under **Popular**, select **Windows Server 2016 Datacenter**.

1. Configure the **Basic** information. Take the default value for any setting that is not specified. 

	- Resource group: **AZ500LAB12**

	- Virtual machine name: **myVmPrivate**
	
	- Region: **East US**

	- User: **localadmin**

	- Password: **Pa55w.rd**

1. Move to the **Networking** tab.

	- Virtual network: **myVirtualNetwork**

	- Subnet: **Private**

1. Move to the **Management** tab, and ensure **Boot diagnostics** is **Off**.

1. Click **Review + Create** and then **Create**.
   
1. Click **Review + create**.

1. This second virtual machine will be in the Public subnet. 

1. On the Portal menu (top left) select **Create a resource**.

1. Under **Popular**, select **Windows Server 2016 Datacenter**.

1. Configure the **Basic** information. Take the default value for any setting that is not specified. 

	- Resource group: **AZ500LAB12**

	- Virtual machine name: **myVmPublic**
	
	- Region: **East US**

	- User: **localadmin**

	- Password: **Pa55w.rd**

1. Move to the **Networking** tab.

	- Virtual network: **myVirtualNetwork**

	- Subnet: **Public**

1. Move to the **Management** tab, and ensure **Boot diagnostics** is **Off**.

1. Click **Review + Create** and then **Create**.
   
1. Click **Review + create**.

1. You can continue once myVMPrivate has been deployed and is running.

### Task 6: Test the storage connection from the Private subnet - confirm access.

In this task, you will connect to the myVMPrivate virtual machine and map a drive to the file share. 

1. Navigate to the **myVmPrivate** virtual machine.

1. On the **Overview** pane, click **Connect** > **RDP**.

1. Click **Download RDP file** and open the file.

1. In the **Remote Desktop Connection** dialog select **Connect**.

1. Select **More choices** and then **Use a different account**.

	- Email address: **localadmin**

    - Password: **Pa55w.rd**

1. Click **OK** and click **Yes** to verify the identity of the virtual machine. 

1. Wait for the remote session to open and Server Manager to display.

1. On the **Tools** menu select **Windows PowerShell**.

1. You will now map the Azure file share to drive Z. Change storage-account-name to your storage account name (two occurrences). Change storage-account-key to your storage account key. 

	> Try each command separately so you can ensure each completes without error. Also, you will need these completed commands in the next task. 

	```
	$acctKey = ConvertTo-SecureString -String "<storage-account-key>" -AsPlainText -Force
	```
	```
	$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\<storage-account-name>", $acctKey
	```
	```
	New-PSDrive -Name Z -PSProvider FileSystem -Root "\\<storage-account-name>.file.core.windows.net\my-file-share"  -Credential $credential
	```

1. Lastly, confirm that the virtual machine has no outbound connectivity to the internet. This request should time out. 

	 ```
	ping bing.com
	```

   	> You receive no replies because the network security group associated to the Private subnet does not allow outbound access to the internet.

1. Disconnect the **myVMPrivate** remote desktop session.

	> At this point, you have confirmed that the virtual machine in the Private subnet can access the storage account. 

####  Task 7: Test the storage connection from the Public subnet - access denied

1. Navigate to your **myVMPublic** virtual machines.

1. Use **Connect** > **RDP** to open a remote desktop session to the virtual machine.

	> If you need help doing review the steps in the previous task.

1. Wait for the remote session to open and Server Manager to display.

1. On the **Tools** menu select **Windows PowerShell**.

1. Again, run each of the PowerShell commands (previous task) to map Azure file share to drive Z on this machine. 

1. You will receive an **New-PSDrive : Access is denied** error. 

	> Access is denied because the *myVmPublic* virtual machine is deployed in the Public subnet. The Public subnet does not have a service endpoint enabled for the Azure Storage. The storage account only allows network access from the Private subnet.

1. Disconnect the **myVMPrivate** remote desktop session.

	> At this point, you have confirmed that the virtual machine in the Public subnet cannot access the storage account. 


**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 

1. Access the Cloud Shell.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. Remove the resource group using the Cloud Shell and PowerShell.

    ```
    Remove-AzResourceGroup -Name "AZ500LAB12"
    ```