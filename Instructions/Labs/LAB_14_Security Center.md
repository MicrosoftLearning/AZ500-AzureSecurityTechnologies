---
lab:
    title: '14 - Azure Security Center'
    module: 'Module 04 - Manage Security Operations'
---

# Lab 14 - Azure Security Center

# Student lab manual

## Lab scenario

You have been asked to create a proof of concept demonstration for Security Center. Specifically, you want to:

- Configure Security Center to monitor a virtual machine.
- Review Security Center recommendations for the virtual machine.
- Implement recommendations for endpoint protection and Just in time VM access. 
- Review how the Secure Score can be used to determine progress toward creating a more secure infrastructure.

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete:

- Exercise 1: Implement Security Center

## Exercise 1: Implement Security Center

- Task 1: Configure Security Center
- Task 2: Implement the Security Center recommendation to install endpoint protection
- Task 3: Implement the Security Center recommendation to enable Just in time VM Access

### Task 1: Configure Security Center

In this task, you will on-board and configure Security Center.

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

1. Use the Portal menu and select **All services**. 

1. Search for and select **Security Center**.

1. On the **Getting started** blade click **Upgrade**.
     
1. Select **Pricing & settings**.

1. Click your subscription and ensure **Standard** is selected. Review all the features that are available and ensure each resource type is **Enabled**. 

1. **Save** any changes you make.

1. Select **Data Collection**.

	- Set **Auto provisioning** to **On**. 

	- Under **Workspace configuration** select **Use another workspace**. 

	- Choose the Log Analytics workspace you created in Lab 13. 

	- Click **Save** and then **Yes**.

1. Click **Workflow automation**  and then **+ Add workflow automation**.

1. Review the settings. Notice you can trigger actions based threat detection alerts and Security Center recommendations. Notice you can also an action based on Logic apps. 

1. Click **Cancel**.

	> Security Center provides many insights into virtual machines including system update status, OS security configurations, and endpoint protection.


#### Task 2: Implement the Security Center recommendation to install endpoint protection

In this task, you will implement the Security Center recommendation to install endpoint protection on the virtual machine. 

1. Continue in the Security Center.

1. Under **Policy & Compliance** select **Secure Score**. Make a note of your score.

1. Under **Resource Security and Hygiene** select **Compute & apps**.

1. On the **VMs and Servers** tab, select **myVM**.

1. Review the **Recommendations list** and select **Install endpoint protection solution on virtual machines**.

1. Ensure **myVM**is selected and then click **Install on 1 VMs**.

1. Select **Microsoft Antimalware**, read about the product, click **Create**.

1. Accept the defaults and click **OK**. 

1. Monitor the **Notifications** icon. 

	> You can also verify the installation by viewing your virtual machine. Under **Settings** select **Extensions** and you will see IaaSAntimalware with a status of Provisioning succeeded.

1. Security Center will rescan the virtual machine and the recommendation will be marked green resolved and the  secure score will increase. 

	> Do not wait for everything to complete. Continue to the next task. 

#### Task 3: Implement the Security Center recommendation to enable Just in time VM Access

In this task, you will implement the Security Center recommendation to enable Just in time VM Access on the virtual machine. 

1. Continue in the Security Center.

1. Under **Resource Security and Hygiene** select **Compute & apps**.

1. On the **VMs and Servers** tab, select **myVM**.

1. Review the **Recommendations list** and select **Management ports of virtual machines should be protected with just-in-time network access control**.

1. Review the list of ports that will be affected.

1. Click **Remediate** and then **Save**.

1. Monitor the **Notifications**. 

	> It can take some time for the recommendations in this lab to be completed. Periodically check the Secure Score to view the impact of implementing these features. 

> Results: You have on-boarded Security Center and implemented virtual machine recommendations. 

**Clean up resources**

	> Do not remove the resources from this lab as they are needed for the next lab, the Azure Sentinel lab.