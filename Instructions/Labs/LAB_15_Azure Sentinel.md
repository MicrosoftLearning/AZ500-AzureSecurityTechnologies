---
lab:
    title: '15 - Azure Sentinel'
    module: 'Module 04 - Manage Security Operations'
---

# Lab 15 - Azure Sentinel

# Student lab manual

## Lab scenario

You have been asked to create a proof of concept demonstration of Azure Sentinel. Specifically, you want to:

- Start collecting data from Azure Activity and Security Center.
- Add some alerts both built in and custom
- Show how Playbooks can be used to automate a response to an incident.

Lab files:

-  **2020\\Allfiles\\Labs\\LAB_14\\template.json**

## Lab objectives

In this lab, you will complete:

- Exercise 1: Implement Azure Sentinel

## Exercise 1: Implement Azure Sentinel

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is the region to use for class. 

### Exercise timing: 30 minutes

In this exercise, you will complete:

- Task 1: on-board Azure Sentinel
- Task 2: Connect Azure Activity to Sentinel
- Task 3: Review and create a rule that uses the Azure Activity data connector. 
- Task 4: Create a playbook
- Task 5: Create a custom alert and configure the playbook as an automated response.
- Task 6: Invoke an incident and review the associated actions.

#### Task 1: On-board Azure Sentinel

In this task, you will on-board Azure Sentinel and connect the Log Analytics workspace. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

1. Use the Portal menu and select **All services**. 

1. Search for and select **Azure Sentinel**.

1. Click **Connect workspace**.

1. Choose the Log Analytics workspace that was created earlier. 

	> Azure Sentinel has very specific requirements for workspaces. For example, workspaces created by Azure Security Center can not be used. Read more at [Quickstart: On-board Azure Sentinel](https://docs.microsoft.com/en-us/azure/sentinel/quickstart-onboard)
	
1. Click **Add Azure Sentinel**.

#### Task 2: Configure Azure Sentinel to use the Azure Activity data connector. 

In this task, you will configure Sentinel to use the Azure Activity data connector.  

1. Continue working with Azure Sentinel. 

1. Under **Configuration** select **Data connectors**. 

1. Review the list of available connectors. 

1. Select **Azure Activity**, read about the connector, and then click **Open connector page**.

1. Select **Configure Azure Activity logs**.

1. Click on **your subscription** and click **Connect**.

1. Return to the **Data connectors** page. 

1. Select **Azure Activity**. 

1. You should see a summary of the data in the **Data received** graph, and connectivity status of the data types. 

	> It may take a few minutes for the data to start coming through. 

#### Task 3: Review and create a rule that uses the Azure Activity data connector. 

In this task, you will review and create a rule that uses the Azure Activity data connector. 

1. Continue working with Azure Sentinel. 

1. Under **Configuration** select **Analytics**. 

1. Select the **Rule templates** tab. 

1. Take a minute to look through the types of rules you can create. Notice each rule is associated with a Data Source.

1. Sort by **Data Sources** and select **Suspicious number of resource creation or deployment**. 

	> This rule has Medium severity associated with Azure Activity. 

1. Click **Create Rule**.

	- Accept the defaults and click **Next: Set rule logic**.

	- Accept the defaults and click **Next: Incident settings**.

	- Accept the defaults and click **Next: Automated response**. This is where we can add a playbook(Logic App) to a rule to automate the remediation of an issue.

	- Click **Next: Review**.

1. Click **Create**.

	> You now have an active rule.

#### Task 4: Create a playbook

In this task, you will create a playbook. A security playbook is a collection of procedures that can be run from Azure Sentinel in response to an alert. 

1. In the Portal menu select **Create a resource**.

1. Search for and select **Template deployment (deploy using custom templates)**.

1. Click **Create**.

1. On the **Custom deployment** blade, select the **Build your own template in the editor**.

1. From the **Edit template** blade, click **Load file** and locate the **22020\Allfiles\Labs\LAB_15\changeincidentseverity.json** file.

	> Take a minute to review the other playbooks that are available - https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks

1. Click **Save**.

1. Complete the template parameters. Take the default value for a setting that is not specified.

	- Resource group: **AZ500LAB131415**

	- Region: **East US**

	- Playbook name: **Change-Incident-Severity**

	- User name: **your global admin account**

1. Select ***I agree to the terms and conditions stated above.*** and then click **Purchase**.

1. Wait for the template to deploy. 

1. Navigate to the resource group. 

1. Select the new Logic app **Change-Incident-Severity**.

1. Click **Edit**.

1. Notice there are four connections and each has a warning. This means it needs to reviewed and if necessary configured.

1. Click on the first **Connections** trigger.

	- Click **Add new**.

	- Ensure your default directory is selected and then click **Sign-in**.

1. Repeat the above step for each of other **Connections**.

1. Ensure there are no warning symbols on any of the steps.

1. **Save** your changes.

#### Task 5 Create a custom alert and configure a playbook as an automated response

1. Return to **Azure Sentinel**.

1. Select your workspace.

1. Under **Configuration** select **Analytics**.

1. Click **Create**.

1. Select **Scheduled query rule** and complete the required information. 

	- Name: **Playbook Demo**

	- Tactics: **Initial Access**

1. Click **Next: Set rule logic**.

	- Paste in the following rule query. This rule tell us when someone makes a change to Just In Time rules.

     ```
     AzureActivity
     | where ResourceProviderValue == "Microsoft.Security" 
     | where OperationNameValue == "Microsoft.Security/locations/jitNetworkAccessPolicies/delete" 
     ```

	- Under **Query scheduling** change **Run query every** to **5 minutes**

1. Click **Next:Incident Settings**

	- Take the defaults and click **Next:Automated response**

1. Select **Change-Incident-Severity** then click **Next:Review** 

1. Click **Create**

	> You should now see a new Alert called **Playbook Demo**. When this incident occurs it should have a medium level severity

#### Task 6: Invoke an incident and review the associated actions.

1. Navigate to **Security Center**.

	> Check your secure score. By now it should have updated. 

1. Under **Advanced cloud defense** select **Just in time VM access**.

1. Select **myVM** then click on the **ellipses** and select **Remove** > then **Yes**.

1. Under **Monitor** select **Activity Log**.

	> There should be an entry showing **Delete JIT Network Access Policies**. This may take a minute to appear. 

1. Return to Azure Sentinel.

1. Select your workspace.

1. The dashboard should show a few alerts that just occured. 

1. Under **Threat Management** select **Incidents**.

1. There should be multiple Incidents at Medium severity level.

    > Note it can take up to 5 minutes for the incident to come through. If after 5 minutes nothing has occured manually run the KQL rule from Task 5 in Logs to ensure the activity has come through. If it has not re-enable the JIT rule and delete it again.

1. Wait at least 5 minutes for the playbook to be invoked. 

	> View the playbook page and look for the status. It shows Runs, Succeeded, and Failed attempts.

1. Return to **Incidents** and notice the incident has been escalated to a **High** Severity.

1. If we want to manually change the severity or Status of an incident we can simply select the incident and click on **Actions**.

1. You can also choose the Severity level and the Status of the Incident.

> Results: You have created

**Clean up resources**

1. Open Cloud Shell in Powershell

1.  Remove the resource group by running the following command (When prompted to confirm press Y and press enter):(Use the Resource Group names that werecreated in your lab)
    ```
    Remove-AzResourceGroup -Name "AZ500LAB131415"
    ```

1. Close the **Cloud Shell** prompt at the bottom of the portal.

1. Set Security Center back to a **Free** tier

> **Result**: In this exercise, you removed the resources used in this lab.