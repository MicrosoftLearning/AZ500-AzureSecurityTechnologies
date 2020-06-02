---
lab:
    title: '08 - Azure Firewall'
    module: 'Module 02 - Implement Platform Protection'
---

# Lab 08 - Azure Firewall

# Student lab manual

## Lab scenario

You have been asked to install Azure Firewall. This will help your organization control outbound network access which is an important part of an overall network security plan. Specifically, you would like to create and test this infrastructure. 

- A virtual network with a workload subnet and a jump subnet.
- A virtual machine is each subnet. 
- A custom route that ensures all outbound workload traffic from the workload subnet must use the firewall.
- Firewall Application rules that only allow outbound traffic to www.bing.com. 
- Firewall Network rules that allow access to DNS server lookups.

Lab files:

-  **2020\\Allfiles\\Labs\\LAB_08\\template.json**

## Lab objectives

In this lab, you will complete:

- Exercise 1: Deploy and test an Azure Firewall

## Exercise 1: Deploy and test an Azure Firewall

### Exercise timing: 40 minutes

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is region to use for you class. 

In this exercise, you will complete:

- Task 1: Use a template to deploy the lab environment. 
- Task 2: Deploy the Azure firewall.
- Task 3: Create a default route.
- Task 4: Configure an application rule.
- Task 5: Configure a network rule. 
- Task 6: Configure the virtual machine DNS servers.
- Task 7: Test the firewall. 

#### Task 1: Use a template to deploy the lab environment. 

In this task, you will review and deploy the lab environment. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**

1. On the Portal menu (top left) select **Create a resource**.

1. Search for and select **Template deployment (deploy using custom templates)**.

1. Click **Create**.

1. On the **Custom deployment** blade, select the **Build your own template in the editor**.

1. From the **Edit template** blade, click **Load file** and locate the **2020\\Allfiles\\Labs\\LAB_08\\template.json** file.

1. Review the content of the template. This template will deploy the virtual network, subnets, and virtual machines needed for the lab.

1. Click **Save**.

1. Complete the template parameters. Leave all the other fields as the pre-populated defaults.

- Resource group: **Create new** - **AZ500LAB08**

- Location: **East US**

1. Check the **I agree to the terms and conditions stated above** box.  

1. Click **Purchase**.

1. Wait for the deployment to complete. 

#### Task 2: Deploy the Azure firewall

In this task you will deploy the Azure firewall into the virtual network. 

1. Continue in the Azure portal.

1. Use the Azure portal menu (top left) to select **All services**.

1. Search for and select **Firewalls**.

1.  On the **Firewalls** blade, click **Create firewall**. 

1.  Configure the firewall. Use the defaults if the value is not specified. 

	- Resource group: **AZ500LAB08**

	- Name: **Test-FW01**

	- Region: **East US**
	
	- Choose a virtual network:**Use existing** - **Test-FW-VN**

	- Public IP address: **Add new** - **TEST-FW-PIP** 

1. Click **Review + create** and then click **Create**. 

    > This will deploy the firewall and a take a few minutes to complete. 

1. Wait for the firewall deployment to complete.

1. Navigate to your **AZ500LAB08** resource group.

	> A quick way to locate the resoure group is to use the top search box. 

1. Take a minute to review the resources that were deployed by the template. You can sort by **Type**.

1. Locate and select the **Test-FW01** firewall.

1. On the **Overview** tab make a note of the **Private IP** address that was assigned to the firewall. You will need this information in the next task.

#### Task 3: Create a default route

In this task, you will create a default route for the **Workload-SN** subnet. This route will configure outbound traffic through the firewall.

1. Continue in the Azure portal.

1. Use the Azure portal menu (top left) to select **All services**.

1. Under **Networking**, select **Route tables**.

1. Click **Add** and complete the required information. Use the defaults if the value is not specified. 

	- Name: **Firewall-route**.

	- Resource group: **Use existing** -**AZ500LAB08**.

1. Click **Create** and wait for the route to deploy. 

1. **Refresh** the page, and click the **Firewall-route** route table.

1. Under **Settings** select **Subnets** and then click **Associate**.

1. In the **Virtual network** drop-down select **Test-FW-VN**. 

1. For **Subnet** select **Workload-SN**. 

	> Ensure the **Workload-SN** subnet is selected for this route, otherwise your firewall won't work correctly.

1. Click **OK** to associate the firewall to the virtual network and subnet. 

1. Under **Settings** select **Routes**.

1. Click **Add** and complete the required information. Use the defaults if the value is not specified.  

	- Route name: **FW-DG**

	- Address prefix: **0.0.0.0/0**

	- Next hop type: **Virtual appliance**. Azure Firewall is actually a managed service, but virtual appliance works in this situation.

	- Next hop address: Use the private IP address for the firewall that you noted previously.
	
1.  Click **OK** to deploy the route. 

#### Task 4: Configure an application rule

In this task you will create an application rule that allows outbound access to `www.bing.com`.

1. In the Portal, navigate to the **Test-FW01** firewall.

1. Under **Settings** select **Rules**.

1. On the **Application rule collection** tab select **Add application rule collection**.

1. Complete the required information. Use the defaults if the value is not specified. 

	- Name: **App-Coll01**

	- Priority: **200**

	- Action: **Allow**.

	- **Target FQDN**

		- Name: **AllowGH**

		- Source type: **IP Address**

		- Source Addresses: **10.0.2.0/24**

		- Protocol port: **http, https**

		- Target FQDNS: **www.bing.com**

1. Click **Add** to complete the application rule.

	> Azure Firewall includes a built-in rule collection for infrastructure FQDNs that are allowed by default. These FQDNs are specific for the platform and can't be used for other purposes. 

#### Task 5: Configure a network rule

In this task, you will create a network rule that allows outbound access to two IP addresses on port 53 (DNS).

1. Continue working with your firewall.

1. On the **Network rule collection** tab select **Add network rule collection**.

	- Name: **Net-Coll01**

	- Priority: **200**

	- Action: **Allow**

	- **Rules** - **IP Addresses**

		- Name:  **AllowDNS**.

		- Protocol: **UDP**

		- Source type: **IP address**

		- Source Addresses: **10.0.2.0/24**

		- Destination type: **IP address**

		- Destination Address: **209.244.0.3,209.244.0.4**

		- Destination Ports: **53**

1. Click **Add** to complete the network rule.

	> The destination addresses used in this are known public DNS servers. 

#### Task 6: Configure the virtual machine DNS servers

In this task, you will configure the primary and secondary DNS addresses for the virtual machine. Generally, this not a firewall requirement. 

1. Navigate to the **AZ500LAB08** resource group.

1. Select the **Srv-Work** virtual machine.

1. Under **Settings**, click **Networking**.

1. Select the **Network interface**

1. Select the NIC

1. Under **Settings** select **DNS servers**.

1. Select **Custom** and add the two DNS servers from the network rule. 

	- **209.244.0.3**
	
	- **209.244.0.4**

1. Click **Save** and wait for the network interface update to complete.

1. Return to the **Srv-Work** virtual machine page.

1. From the **Overview** blade click **Restart**. When prompted, click **Yes** to restart the machine.
 

#### Task 7: Test the firewall

In this task, you will test the firewall to confirm that it works as expected.

1. Navigate to the **AZ500LAB08** resource group.

1. Select the **Srv-Jump** virtual machine.

1. Click **Connect** > **RDP**.

1. Click **Download RDP file** and open the file.

1. In the **Remote Desktop Connection** dialog select **Connect**.

1. Select **More choices** and then **Use a different account**.

	- Email address: **localadmin**

    - Password: **Pa55w.rd**

1. Click **OK** and click **Yes** to verify the identity of the virtual machine. 

1. Wait for the remote session to open. 

	> You should now have a remote session to the **Srv-Jump** virtual machine. 

1. Within the remote session, wait for the **Server Manager Dashboard** to display.

1. Select the **Tools** menu (top right) and then **Windows PowerShell**.
 
	> You will now connect to the **Srv-Work** virtual machine. This is being done so we can test the ability to access the bing.com website.  

1. Connect to **Srv-Work**. The command will open a **Enter your credentials** dialog box.

    ```
    mstsc /v:Srv-Work
    ```

1. Provide the **Srv-Work** credentials.

	- Email address: **localadmin**

    - Password: **Pa55w.rd**

1. Wait for the new remote session to open.

1. On **Srv-work** open Internet Explorer.

1. When prompted to set up IE 11, select **Ask me later.**

1. Browse to **`https://www.bing.com`**. Dismiss any security alerts that appear.

	> The website should successfully display. The firewall allows you access.

1. Browse to **`http://www.microsoft.com/`**

	> The website does not successfully display. There is an error: `HTTP request from 10.0.2.4:49965 to microsoft.com:80. Action: Deny. No rule matched. Proceeding with default action.` The firewall blocks access to this website. 

1. Disconnect your remote session.

> Result: You have successfully configured and tested the Azure Firewall.

**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 

1. Access the Cloud Shell.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. Remove the resource group using the Cloud Shell and PowerShell.

    ```
    Remove-AzResourceGroup -Name "AZ500LAB08"
    ```