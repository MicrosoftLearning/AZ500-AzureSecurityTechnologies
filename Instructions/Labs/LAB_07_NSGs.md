---
lab:
    title: '07 - Network Security Groups and Application Security Groups'
    module: 'Module 02 - Implement Platform Protection'
---

# Lab 07 - Network Security Groups and Application Security Groups

# Student lab manual

## Lab scenario

You have been asked to implement your organization's virtual networking infrastructure and test to ensure it is working correctly. Specifically,

- The organization has two groups of servers: Web Servers and Management Servers.
- Each group of servers should be in it's own Application Security Group. 
- You should be able to RDP into the Management Servers, but not the Web Servers.
- The Web Servers should display the IIS web page when accessed from the internet. 
- Network security group rules should be created to ensure traffic is correctly routed. 

## Lab objectives

In this lab, you will complete:

- Exercise 1: Create the virtual networking infrastructure
- Exercise 2: Deploy virtual machines and test the network filters

## Exercise 1: Create the virtual networking infrastructure

### Exercise timing: 20 minutes

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is region to use for you class. 

In this exercise, you will complete:

- Task 1: Create a virtual network with one subnet.
- Task 2: Create two application security groups.
- Task 3: Create a network security group and associate it with the virtual network subnet.
- Task 4: Create inbound NSG security rules to all traffic to web servers and RDP to the management servers.

#### Task 1:  Create a virtual network

In this task, you will create a virtual network to use with the network and application security groups. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

1. On the Portal menu (top left) select **All services**.

1. Select **Networking**, and then select **Virtual networks**.

1. Click **Add** and configure the **Basics** tab.

	- Resource group: Select **Create new** and enter **AZ500LAB07**. 

	- Name: **myVirtualNetwork**

	- Region: **East US**

1. Click **Next: IP Addresses**. 

1. Review the IPv4 address space (10.0.0.0/16) and the default subnet (10.0.0.0/24). 

1. Click **Review + Create** and then **Create**.

1. Monitor your deployment using the **Notification** icon, top right. 
                                      |
#### Task 2:  Create application security groups

In this task, you will create an application security group.

1. On the Portal menu (top left) select **All services**.

1. Select **Networking**, and then select **Application security groups**.

2. Click **Add** and configure the required settings. This group will be for the web servers.

	- Resource group: **AZ500LAB07**.

	- Name: **myAsgWebServers**

	- Region: **East US**

1. Click **Review + Create** and then **Create**.

1. Using the steps above, create another application security group for the management servers.

	- Resource group: **AZ500LAB07**.

	- Name: **myAsgMgmtServers**

	- Region: **East US**

1. Click **Review + Create** and then **Create**.

1. Monitor your deployment using the **Notification** icon, top right. 

#### Task 3:  Create a network security group and associate the NSG to the subnet

In this task, you will create a network security group. 

1. On the Portal menu (top left) select **All services**.

1. Select **Networking**, and then select **Network security groups**.

1. Click **Add** and configure the required settings.

	- Resource group: **AZ500LAB07**

	- Name: **myNsg**

	- Region: **East US**

1. Click **Review + Create** and then **Create**.

1. Monitor your deployment using the **Notification** icon, top right. 

1. Once the NSG deploys, **Go to resource**.

1. Under **Settings**, select **Subnets** and then select **+ Associate**. 

	- Virtual network: **myVirtualNetwork**
	
	- Subnet: **default**

1. Click **OK** to finish the association.

1. Monitor your deployment using the **Notification** icon, top right. 

#### Task 4:  Create inbound NSG security rules to all traffic to web servers and RDP to the management servers. 

1. Continue working with your network security group.

1. Under **Settings**, select **Inbound security rules**.

1. Take a minute to review the default inbound security rules and then select **Add**.

1. Configure the inbound security rule to allow ports 80 and 443 to the **myAsgWebServers** application security group. Take the default value for any setting that is not listed. 

	- Destination: Select **Application security group**, and then select **myAsgWebServers** 

	- Destination port ranges: **80,443**                                                                                                    
	
	- Protocol: **TCP**      
	                                                                                                 
	- Name: **Allow-Web-All**                                                                                                   

1. Click **Add** to deploy the new inbound rule. 

1. Under **Settings**, select **Inbound security rules** and then click **Add**.

3. Configure an inbound security rule to allow RDP (port 3389) to **myAsgMgmtServers** virtual machines. Take the default value for any setting that is not specified. 

	> This port will be exposed to the internet. For production environments, instead of exposing port 3389 to the internet, it's recommended that you connect to Azure resources that you want to manage using a VPN or private network connection. 

	- Destination: **Application security group** - **myAsgMgmtServers** 

	- Destination port ranges: **3389**                                                                                                      
	
	- Protocol: **TCP**                                                                                                      
	
	- Priority: 110                                                                                                       

	- Name: **Allow-RDP-All**                                                                                                   

1. Click **Add** to deploy the new inbound rule. 

> Result: You have deployed a virtual network, network security with inbound security rules, and two application security groups. 

## Exercise 2: Deploy virtual machines and test network filters

### Exercise timing: 25 minutes

In this exercise, you will complete:

- Task 1: Create a virtual machine to use as a web server.
- Task 2: Create a virtual machine to use as a management server. 

#### Task 1: Create a virtual machine to use as a web server.

In this task, you will create a virtual machine to use as a web server.

1. On the Portal menu (top left) select **Create a resource**.

1. Under **Popular**, select **Windows Server 2016 Datacenter**.

1. Configure the **Basic** information. Take the default value for any setting that is not specified. 

	- Resource group: **AZ500LAB07**

	- Virtual machine name: **myVmWeb**
	
	- Region: **East US**

	- User: **localadmin**

	- Password: **Pa55w.rd**

	- Public Inbound ports: **None** - We will rely on our NSG rules. 

1. Move to the **Networking** tab (top) and verify this information. Take the default value for any setting that is not specified. 

	- Virtual network: **myVirtualNetwork**

	- NIC network security group: **None**

1. Move to the **Management** tab, and ensure **Boot diagnostics** is **Off**.

1. Click **Review + Create** and then **Create**.

1. You do not need to wait for this virtual machine to deploy. Continue to the next task.

#### Task 2: Create a virtual machine to use as a management server. 

In this task, you will create a virtual machine to use as a management server.

1. On the Portal menu (top left) select **Create a resource**.

1. Under **Popular**, select **Windows Server 2016 Datacenter**.

1. Configure the **Basic** information. Take the default value for any setting that is not specified. 

	- Resource group: **AZ500LAB07**

	- Virtual machine name: **myVMMgmt**
	
	- Region: **East US**

	- User: **localadmin**

	- Password: **Pa55w.rd**

	- Public Inbound ports: **None** - We will rely on our NSG rules. 

1. Move to the **Networking** tab (top) and verify this information. Take the default value for any setting that is not specified. 

	- Virtual network: **myVirtualNetwork**

	- NIC network security group: **None**

1. Move to the **Management** tab, and ensure **Boot diagnostics** is **Off**.

1. Click **Review + Create** and then **Create**.

1. Wait for both virtual machines to be deployed before continuing. 


#### Task 3:  Associate each virtual machines network interface to it's application security group.

In this task, you will associate each virtual machines network interface with a application security group. The myVMWeb virtual machine interface will be associated to the myAsgWebServers ASG. The myVMMgmt virtual machine interface will be associated to the myAsgMgmtServers ASG. 

1. On the Portal menu (top left) select **Virtual machines**.

1. Ensure both of your virtual machines are **Running**.

1. Select **myVMWeb. 

1. Under **Settings**, select **Networking** and then **Application security groups** tab.

1. Select **Configure the application security groups** and then select **myAsgWebServers**.

1. **Save** your changes. 

1. Return to the **Virtual machines** blade.

1. Select **myVMMgmt**.

1. Under **Settings**, select **Networking** and then **Application security groups** tab.

1. Select **Configure the application security groups** and then select **myAsgMgmtServers**.

1. **Save** your changes. 

### Task 4:  Test the network traffic filters

In this task, you will test the network traffic filters. You should be able to RDP into the myVMMgmnt virtual machine. You should be able to connect from the internet to the myVMWeb virtual machine and view the default IIS web page.  

1. Continue working with the **myVMMgmt** virtual machine.

1. On the **Overview** pane, click **Connect** > **RDP**.

1. Click **Download RDP file** and open the file.

1. In the **Remote Desktop Connection** dialog select **Connect**.

1. Select **More choices** and then **Use a different account**.

	- Email address: **localadmin**

    - Password: **Pa55w.rd**

1. Click **OK** and click **Yes** to verify the identity of the virtual machine. 

1. Wait for the remote session to open. 

	> The connection succeeds because port 3389 is allowed inbound from the internet to the *myAsgMgmtServers* application security group. The **myVMMgmt** network interface is associate with ASG. 

1. Within the remote session, wait for the **Server Manager Dashboard** to display.

1. Select the **Tools** menu (top right) and then **Windows PowerShell**.
 
1. You now need to connect to the **myVMWeb** virtual machine. This is necessary to install the Web Server feature on that machine. Remember you do not have the ability to RDP into **myVMWeb**. 

1. Connect to **myVMWeb** with command. The command will open a **Enter your credentials** dialog box.

    ```
    mstsc /v:myVmWeb
    ```

	> You are able to connect to the myVmWeb VM from the myVmMgmt VM because VMs in the same virtual network can communicate with each other over any port, by default. You can't, however, create a remote desktop connection to the *myVmWeb* VM from the internet because the security rule for the *myAsgWebServers* doesn't allow port 3389 inbound from the internet, and inbound traffic from the Internet is, by default, denied to all resources.

1. Use the **Enter your credentials** dialog box to login to **myVMWeb**. 

	- Email address: **localadmin**

    - Password: **Pa55w.rd**

1. Click **OK** to connect.

1. The myVMWeb virtual machine will be used as a web server. To install Microsoft IIS you will need to open a PowerShell session.

1. From the **Server Manager Dashboard**, select the **Tools** menu (top right) and then **Windows PowerShell**.

1. Install IIS on the **myVmWeb** VM. This will take a couple of minutes to complete.

    ```
    Install-WindowsFeature -name Web-Server -IncludeManagementTools
    ```

1.  Disconnect your remote sessions.

	> At this point you have confirmed you can RDP into myVMMgmt and you have installed the Web Server feature on myVMWeb. Now, you will check to ensure myVMWeb can be accessed as a web server.

1. In the Portal, navigate to the **Overview** blade of myVMWeb.

1. Copy the Public IP address to the clipboard (icon on the right of the address). 

1. Open an internet browser and browse to `http://<public-ip-address-from-previous-step>`. 

	> The default IIS welcome page should display because port 80 is allowed inbound from the internet to the **myAsgWebServers** application security group. The myVMWeb network interface is associated with that application security group. 

> Result: You have validated that the NSG and ASG configuration is working and traffic is being correctly managed. 


**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 

1. Access the Cloud Shell.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. Remove the resource group using the Cloud Shell and PowerShell.

    ```
    Remove-AzResourceGroup -Name "AZ500LAB07"
    ```