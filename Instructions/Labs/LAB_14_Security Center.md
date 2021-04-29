---
lab:
    title: '14 - Azure Security Center'
    module: 'Module 04 - Manage Security Operations'
---

# Lab 14: Azure Security Center
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

### Exercise 1: Implement Security Center

In this exercise, you will complete the following tasks:

- Task 1: Configure Security Center
- Task 2: Review the Security Center recommendations
- Task 3: Implement the Security Center recommendation to enable Just in time VM Access

#### Task 1: Configure Security Center

In this task, you will on-board and configure Security Center.

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

    >**Note**: Sign in to the Azure portal using an account that has the Owner or Contributor role in the Azure subscription you are using for this lab.

1. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Security Center** and press the **Enter** key.

1. On the **Security Center \| Getting started** blade, click **Upgrade** and then click **Install agents**.
     
1. On the **Security Center \| Getting started** blade, in the vertical menu on the left side, in the **Management** section, click **Pricing & settings**.

1. On the **Security Center \| Pricing & settings** blade, click the entry representing your subscription and, on the **Settings \| Azure Defender plans** blade, ensure that **Azure Defender on** is selected. 

    >**Note**: Review all the features that are available as part of Azure Defender tier and ensure that Azure Defender turned on for each resource type. 

1. If you made any changes, click **Save**.

1. On the **Settings \| Azure Defender plans** blade, in the vertical menu bar on the left side, click **Auto Provisioning**.

1. On the **Settings \| Auto Provisioning** blade, make sure that **Auto provisioning** is set to **On** for the first item **Log Analytics agent for Azure VMs**. 

1. If needed, on the **Settings \| Auto Provisioning** blade, for the first item **Log Analytics agent for Azure VMs** click the **Edit Configuration** link in the **Configuration** column. 

1. On the **Extension deployment configuration** blade, in the **Workspace configuration** section, select the **Connect Azure VMs to a different workspace** option and, in the drop-down list, select the Log Analytics workspace you created in the previous lab. 

1. On the **Extension deployment configuration** blade, click **Apply**, when prompted, select the **Existing and new VMs** option, click **Apply** again, and back on the **Settings** blade, click **Save**.

1. Back on the **Settings \| Auto provisioning** blade, in the vertical menu on the left side, click **Workflow automation**.

1. On the **Settings \| Workflow automation** blade, click **+ Add workflow automation**.

1. On the **Add workflow automation** blade, review the available settings. 

    >**Note**: You can trigger actions based threat detection alerts and Security Center recommendations. You can also configure an action based on Logic apps. 

1. On the **Add workflow automation** blade, click **Cancel**.

    >**Note**: Security Center provides many insights into virtual machines including system update status, OS security configurations, and endpoint protection.

1. Navigate back to the **Security Center \| Pricing & settings** blade and click the entry representing the Log Analytics workspace you created in the previous lab.

1.  On the **Settings \| Azure Defender plans** blade, ensure that **Azure Defender on** is selected and click **Save**.


#### Task 2: Review the Security Center recommendation

In this task, you will review the Security Center recommendations. 

1. In the Azure portal, navigate back to the **Security Center \| Overview** blade. 

1. On the **Security Center \| Overview** blade, review the **Secure Score** tile.

    >**Note**: Record the current score if it is available.

1. Navigate back to the **Security Center \| Overview** blade, select **Assessed resources**.

1. On the **Inventory** blade, select the **myVM** entry.

    >**Note**: You might have to wait a few minutes and refresh the browser page for the entry to appear.
    
1. On the **Resource health** blade, on the **Recommendations** tab, review the list of recommendations for **myVM**.


#### Task 3: Implement the Security Center recommendation to enable Just in time VM Access

In this task, you will implement the Security Center recommendation to enable Just in time VM Access on the virtual machine. 

1. In the Azure portal, navigate back to the **Security Center \| Overview** blade and select the **Azure Defender** tile.

1. On the **Azure Defender** blade, click the **Just-in-time- VM access** tab, select **Not Configured** and then click the **myVM** entry.

1. Select **Enable JIT on 1 VM**.

1. On the **JIT VM access configuration** blade, on the far right of the row referencing the port **22**, click the ellipsis button and then click **Delete**.

1. On the **JIT VM access configuration** blade, click **Save**.

    >**Note**: Monitor the progress of configuration by clicking on the **Notifications** icon in the toolbar and viewing the **Notifications** blade. 

    >**Note**: It can take some time for the implementation of recommendations in this lab to be reflected by Secure Score. Periodically check the Secure Score to determine the impact of implementing these features. 

> Results: You have on-boarded Security Center and implemented virtual machine recommendations. 


>**Note**: Do not remove the resources from this lab as they are needed for the Azure Sentinel lab.
