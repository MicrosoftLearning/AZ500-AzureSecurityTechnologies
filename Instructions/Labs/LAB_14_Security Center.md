---
lab:
    title: '14 - Azure Security Center'
    module: 'Module 04 - Manage Security Operations'
---

# Lab 14 - Azure Security Center

# Student lab manual

## Lab scenario

You have been asked to create a proof of concept of Security Center-based environment. Specifically, you want to:

- Configure Security Center to monitor a virtual machine.
- Review Security Center recommendations for the virtual machine.
- Implement recommendations for guest configuration and Just in time VM access. 
- Review how the Secure Score can be used to determine progress toward creating a more secure infrastructure.

> For all the resources in this lab, we are using the **East US** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete the following exercise:

- Exercise 1: Implement Security Center

## Exercise 1: Implement Security Center

In this exercise, you will complete the following tasks:

- Task 1: Configure Security Center
- Task 2: Implement the Security Center recommendation to install guest configuration extension
- Task 3: Implement the Security Center recommendation to enable Just in time VM Access

### Task 1: Configure Security Center

In this task, you will on-board and configure Security Center.

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

    >**Note**: Sign in to the Azure portal using an account that has the Owner or Contributor role in the Azure subscription you are using for this lab.

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Security Center** and press the **Enter** key.

1. On the **Security Center | Getting started** blade, click **Upgrade** and then click **Install agents**.
     
1. On the **Security Center | Getting started** blade, click **Pricing & settings**.

1. Click the entry representing your subscription and, on the **Settings | Pricing tier** blade, ensure that the **Standard** pricing tier is selected. 

    >**Note**: Review all the features that are available as part of the Standard pricing tier and ensure the Standard plan is enabled fro each resource type. 

1. If you made any changes, click **Save**.

1. On the **Settings | Pricing tier** blade, click **Data Collection**.

1. On the **Settings | Data Collection** blade, set **Auto provisioning** to **On**. 

1. On the **Settings | Data Collection** blade, in the **Workspace configuration** section, select the **Use another workspace** option and, in the drop-down list, select the Log Analytics workspace you created in the previous lab. 

1. On the **Settings | Data Collection** blade, click **Save**.

1. On the **Settings | Data Collection** blade, click **Workflow automation**.

1. On the **Settings | Workflow automation** blade, click **+ Add workflow automation**.

1. On the **Add workflow automation** blade, review the available settings. 

    >**Note**: You can trigger actions based threat detection alerts and Security Center recommendations. You can also configure an action based on Logic apps. 

1. On the **Add workflow automation** blade, click **Cancel**.

    >**Note**: Security Center provides many insights into virtual machines including system update status, OS security configurations, and endpoint protection.

#### Task 2: Implement the Security Center recommendation to install guest configuration extension

In this task, you will implement the Security Center recommendation to install endpoint protection on the virtual machine. 

1. In the Azure portal, navigate back to the **Security Center | Overview** blade. 

1. On the **Security Center | Overview** blade, in the **POLICY & COMPLIANCE** section, click **Secure Score**. 

    >**Note**: Record the current score.

1. On the **Security Center | Secure Score** blade, in the **RESOURCE SECURITY HYGIENE** section, click **Compute & apps**.

1. On the **Security Center | Compute & apps** blade, click the **VMs and Servers** tab, and then click the **myVM** entry.

1. On the **myvm** blade, in the **Recommendations list** section, on the **Recommendations** tab, review the recommendations and click the **Guest configuration extension should be installed on Windows virtual machines** entry.

1. On the **Guest configuration extension should be installed on Windows virtual machines** blade, click **Remediate**.

1. On the **Remediate resources** blade, ensure that **myVM** is listed as the selected resource and click **Remediate 1 resource**.

    >**Note**: Monitor the progress of installation by clicking on the **Notifications** icon in the toolbar and viewing the **Notifications** blade. 

    >**Note**: You can also verify the installation by viewing the configuration of the **myVM** virtual machine. On the **myVM** virtual machine blade, in the **Settings** section, click **Extensions** and, on the **myVM | Extensions** blade, you should see the **AzurePolicyforWindows** extension listed with the status of **Provisioning succeeded**.

    >**Note**: Security Center will automatically rescan the virtual machine. That will be reflected by an increase in the secure score.

    >**Note**: Do not wait for the intallation to complete but instead continue to the next task. 

#### Task 3: Implement the Security Center recommendation to enable Just in time VM Access

In this task, you will implement the Security Center recommendation to enable Just in time VM Access on the virtual machine. 

1. In the Azure portal, navigate back to the **Security Center | Overview** blade. 

1. On the **Security Center | Overview** blade, in the **RESOURCE SECURITY HYGIENE** section, click **Compute & apps**.

1. On the **Security Center | Compute & apps** blade, click the **VMs and Servers** tab, and then click the **myVM** entry.

1. On the **myvm** blade, in the **Recommendations list** section, on the **Recommendations** tab, click the **Management ports of virtual machines should be protected with just-in-time network access control** entry.

1. On the **Management ports of virtual machines should be protected with just-in-time network access control** blade, expand the **Remediation steps** section and review the steps. 

1. On the **Management ports of virtual machines should be protected with just-in-time network access control** blade, click **Remediate**.

1. On the **JIT VM access configuration** blade, on the far right of the row referencing the port **22**, click the ellipsis button and then click **Delete**.

1. On the **JIT VM access configuration** blade, click **Save**.

    >**Note**: Monitor the progress of configuration by clicking on the **Notifications** icon in the toolbar and viewing the **Notifications** blade. 

    >**Note**: It can take some time for the implementation of recommendations in this lab to be reflected by Secure Score. Periodically check the Secure Score to determine the impact of implementing these features. 

> Results: You have on-boarded Security Center and implemented virtual machine recommendations. 

**Clean up resources**

>**Note**: Do not remove the resources from this lab as they are needed for the Azure Sentinel lab.