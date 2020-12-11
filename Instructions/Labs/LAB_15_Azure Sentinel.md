---
lab:
    title: '15 - Azure Sentinel'
    module: 'Module 04 - Manage Security Operations'
---

# Lab 15: Azure Sentinel
# Student lab manual

## Lab scenario

You have been asked to create a proof of concept of Azure Sentinel-based threat detection and response. Specifically, you want to:

- Start collecting data from Azure Activity and Security Center.
- Add built in and custom alerts 
- Review how Playbooks can be used to automate a response to an incident.

> For all the resources in this lab, we are using the **East US** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete the following exercise:

- Exercise 1: Implement Azure Sentinel

## Lab files:

- **\\Allfiles\\Labs\\15\\changeincidentseverity.json**

### Exercise 1: Implement Azure Sentinel

### Estimated timing: 30 minutes

In this exercise, you will complete the following tasks:

- Task 1: On-board Azure Sentinel
- Task 2: Connect Azure Activity to Sentinel
- Task 3: Create a rule that uses the Azure Activity data connector. 
- Task 4: Create a playbook
- Task 5: Create a custom alert and configure the playbook as an automated response.
- Task 6: Invoke an incident and review the associated actions.

#### Task 1: On-board Azure Sentinel

In this task, you will on-board Azure Sentinel and connect the Log Analytics workspace. 

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

    >**Note**: Sign in to the Azure portal using an account that has the Owner or Contributor role in the Azure subscription you are using for this lab.

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Azure Sentinel** and press the **Enter** key.

1. On the **Azure Sentinel** blade, click **Connect workspace**.

1. On the **Choose a workspace to add to Azure Sentinel** blade, select the Log Analytics workspace you created in the Azure Monitor lab and click **Add**.

    >**Note**: Azure Sentinel has very specific requirements for workspaces. For example, workspaces created by Azure Security Center can not be used. Read more at [Quickstart: On-board Azure Sentinel](https://docs.microsoft.com/en-us/azure/sentinel/quickstart-onboard)
	
#### Task 2: Configure Azure Sentinel to use the Azure Activity data connector. 

In this task, you will configure Sentinel to use the Azure Activity data connector.  

1. In the Azure portal, on the **Azure Sentinel \| Overview** blade, in the **Configuration** section, click **Data connectors**. 

1. On the **Azure Sentinel \| Data connectors** blade, review the list of available connectors, click the entry representing the **Azure Activity** connector (scroll to the right if needed), review its description, and then click **Open connector page**.

1. On the **Azure Activity** blade, click the **Configure Azure Activity logs** link.

1. On the **Azure Activity log** blade, click the entry representing the Azure subscription you are using in this lab and then click **Connect**.

1. Navigate back to the **Azure Sentinel \| Data connectors** blade and click **Refresh**.

1. On the **Azure Sentinel \| Data connectors** blade, click **Azure Activity**. 

1. Verify that the **Azure Activity** pane displays the **Data received** graph (you might have to refresh the browser page). 

    >**Note**: It may take over 5 minutes before the graph will reflect the any events included in the Azure Activity logs.

#### Task 3: Create a rule that uses the Azure Activity data connector. 

In this task, you will review and create a rule that uses the Azure Activity data connector. 

1. On the **Azure Sentinel \| Configuration** blade, click **Analytics**. 

1. On the **Azure Sentinel \| Analytics** blade, click the **Rule templates** tab. 

    >**Note**: Review the types of rules you can create. Each rule is associated with a specific Data Source.

1. In the listing of rules, type **Suspicious** into the search bar form and click the **Suspicious number of resource creation or deployment** entry associated with the **Azure Activity** data source. And then, in the pane displaying the rule template properties, click **Create rule** (scroll to the right of the page if needed).

    >**Note**: This rule has the medium severity. 

1. On the **General** tab of the **Analytic rule wizard - Create new rule from template** blade, accept the default settings and click **Next: Set rule logic >**.

1. On the **Set rule logic** tab of the **Analytic rule wizard - Create new rule from template** blade, accept the default settings and click **Next: Incident settings >**.

1. On the **Incident settings** tab of the **Analytic rule wizard - Create new rule from template** blade, accept the default settings and click **Next: Automated response >**. 

    >**Note**: This is where you can add a playbook, implemented as a Logic App, to a rule to automate the remediation of an issue.

1. On the **Automated response** tab of the **Analytic rule wizard - Create new rule from template** blade, accept the default settings and click **Next: Review >**. 

1. On the **Review and create** tab of the **Analytic rule wizard - Create new rule from template** blade, click **Create**.

    >**Note**: You now have an active rule.

#### Task 4: Create a playbook

In this task, you will create a playbook. A security playbook is a collection of tasks that can be invoked by Azure Sentinel in response to an alert. 

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Deploy a custom template** and press the **Enter** key.

1. On the **Custom deployment** blade, click the **Build your own template in the editor** option.

1. On the **Edit template** blade, click **Load file**, locate the **\\Allfiles\\Labs\\15\\changeincidentseverity.json** file and click **Open**.

    >**Note**: You can find sample playbooks at [https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks).

1. On the **Edit template** blade, click **Save**.

1. On the **Custom deployment** blade, ensure that the following settings are configured (leave any others with their default values):

    |Setting|Value|
    |---|---|
    |Subscription|the name of the Azure subscription you are using in this lab|
    |Resource group|**AZ500LAB131415**|
    |Location|**(US) East US**|
    |Playbook Name|**Change-Incident-Severity**|
    |User Name|your email address|

1. Click **Review + create** and then click **Create**.

    >**Note**: Wait for the deployment to complete.

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Resource groups** and press the **Enter** key.

1. On the **Resource groups** blade, in the list of resource group, click the **AZ500LAB131415** entry.

1. On the **AZ500LAB131415** resource group blade, in the list of resources, click the entry representing the newly created **Change-Incident-Severity** logic app.

1. On the **Change-Incident-Severity** blade, click **Edit**.

    >**Note**: On the **Logic Apps Designer** blade, each of the four connections displays a warning. This means that each needs to reviewed and configured.

1. On the **Logic Apps Designer** blade, click the first **Connections** step.

1. Click **Add new**, ensure that the entry in the **Tenant** drop down list contains your Azure AD tenant name and click **Sign-in**.

1. When prompted, sign in with the user account that has the Owner or Contributor role in the Azure subscription you are using for this lab.

1. Repeat the previous three steps in for each of other **Connections**.

    >**Note**: Ensure there are no warnings displayed on any of the steps.

1. On the **Logic Apps Designer** blade, click **Save** to save your changes.

#### Task 5 Create a custom alert and configure a playbook as an automated response

1. In the Azure portal, navigate back to the **Azure Sentinel \| Overview** blade.

1. On the the **Azure Sentinel \| Overview** blade, in the **Configuration** section, click **Analytics**.

1. On the **Azure Sentinel \| Analytics** blade, click **+ Create** and, in the drop-down menu, click **Scheduled query rule**. 

1. On the **General** tab of the **Analytic rule wizard - Create new rule** blade, specify the following settings (leave others with their default values):

    |Setting|Value|
    |---|---|
    |Name|**Playbook Demo**|
    |Tactics|**Initial Access**|

1. Click **Next: Set rule logic >**.

1. On the **Set rule logic** tab of the **Analytic rule wizard - Create new rule** blade, in the **Rule query** text box, paste the following rule query. 

    ```
    AzureActivity
     | where ResourceProviderValue == "Microsoft.Security" 
     | where OperationNameValue == "Microsoft.Security/locations/jitNetworkAccessPolicies/delete" 
    ```

    >**Note**: This rule identifies removal of Just in time VM access policies.

    >**Note** if you receive a parse error, intellisense may have added values to your query. Ensure the query matches otherwise paste the query into notepad and then from notepad to the rule query. 


1. On the **Set rule logic** tab of the **Analytic rule wizard - Create new rule** blade, in the **Query scheduling** section, set the **Run query every** to **5 Minutes**.

1. On the **Set rule logic** tab of the **Analytic rule wizard - Create new rule** blade, accept the default values of the remaining settings and click **Next: Incident settings >**.

1. On the **Incident settings** tab of the **Analytic rule wizard - Create new rule** blade, accept the default settings and click **Next: Automated response >**. 

1. On the **Automated response** tab of the **Analytic rule wizard - Create new rule** blade, select the **Change-Incident-Severity** checkbox and click **Next: Review >**. 

1. On the **Review and create** tab of the **Analytic rule wizard - Create new rule** blade, click **Create**.

    >**Note**: You now have a new active rule called **Playbook Demo**. If an event identified by the rue logic occurs, it will result in a medium severity alert, which will generate a corresponding incident.

#### Task 6: Invoke an incident and review the associated actions.

1. In the Azure portal, navigate to the **Security Center \| Overview** blade.

    >**Note**: Check your secure score. By now it should have updated. 

1. On the **Security Center \| Azure Defender** blade, click **Just-in-time vm access** section.

1. On the **Security Center \| Just in time VM access** blade, on the right hand side of the row referencing the **myVM** virtual machine, click the **ellipses** button,  click **Remove** and then click **Yes**.

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Activity log** and press the **Enter** key.

1. On the **Activity log** blade, note an **Delete JIT Network Access Policies** entry. 

    >**Note**: This may take a minute to appear. 

1. In the Azure portal, navigate back to the **Azure Sentinel \| Overview** blade.

1. On the **Azure Sentinel \| Overview** blade, review the dashboard and verify that it displays an alert corresponding to the deletion of the Just in time VM access policy.

    >**Note**: It can take up to 5 minutes for alerts to appear on the **Azure Sentinel \| Overview** blade. If you are not seeing an alert at that point, run the query rule referenced in the previous task to verify that the Just In Time access policy deletion activity has been propagated to the Log Analytics workspace associated with your Azure Sentinel instance. If that is not the case, re-create the Just in time VM access policy and delete it again.

1. On the **Azure Sentinel \| Overview** blade, in the **Threat Management** section, click **Incidents**.

1. Verify that the blade displays an incident with either medium or high severity level.

    >**Note**: It can take up to 5 minutes for the incident to appear on the **Azure Sentinel \| Incidents** blade. 

    >**Note**: Review the **Azure Sentinel \| Playbooks** blade. You will find there the count of succesfull and failed runs.

    >**Note**: You have the option of assigning a different severity level and status to an incident.

> Results: You have created an Azure Sentinel workspace, connected it to Azure Activity logs, created a playbook and custom alerts that are triggered in response to the removal of Just in time VM access policies, and verified that the configuration is valid.

**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 

1. In the Azure portal, open the Cloud Shell by clicking the first icon in the top right of the Azure Portal. If prompted, click **PowerShell** and **Create storage**.

1. Ensure **PowerShell** is selected in the drop-down menu in the upper-left corner of the Cloud Shell pane.

1. In the PowerShell session within the Cloud Shell pane, run the following to remove the resource group you created in this lab:
  
    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB131415" -Force -AsJob
    ```
1. Close the **Cloud Shell** pane.
