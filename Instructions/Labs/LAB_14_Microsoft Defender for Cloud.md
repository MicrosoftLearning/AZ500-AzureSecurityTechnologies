---
lab:
    title: '14 - Microsoft Defender for Cloud'
    module: 'Module 04 - Microsoft Defender for Cloud'
---

# Lab 14: Microsoft Defender for Cloud
# Student lab manual

## Lab scenario

You have been asked to create a proof of concept of Microsoft Defender for Cloud-based environment. Specifically, you want to:

- Configure Microsoft Defender for Cloud to monitor a virtual machine.
- Review Microsoft Defender for Cloud recommendations for the virtual machine.
- Implement recommendations for guest configuration and Just in time VM access. 
- Review how the Secure Score can be used to determine progress toward creating a more secure infrastructure.

> For all the resources in this lab, we are using the **East US** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete the following exercise:

- Exercise 1: Implement Microsoft Defender for Cloud

## Microsoft Defender for Cloud diagram

![image](https://user-images.githubusercontent.com/91347931/157537800-94a64b6e-026c-41b2-970e-f8554ce1e0ab.png)

## Instructions

### Exercise 1: Implement Microsoft Defender for Cloud

In this exercise, you will complete the following tasks:

- Task 1: Configure Microsoft Defender for Cloud
- Task 2: Review the Microsoft Defender for Cloud recommendations
- Task 3: Implement the Microsoft Defender for Cloud recommendation to enable Just in time VM Access

#### Task 1: Configure Microsoft Defender for Cloud

In this task, you will on-board and configure Microsoft Defender for Cloud.

1. Sign-in to the Azure portal **`https://portal.azure.com/`**.

    >**Note**: Sign in to the Azure portal using an account that has the Owner or Contributor role in the Azure subscription you are using for this lab.

2. In the Azure portal, in the **Search resources, services, and docs** text box at the top of the Azure portal page, type **Microsoft Defender for Cloud** and press the **Enter** key.

3. On the **Microsoft Defender for Cloud \| Getting started** blade, click **Upgrade**.
     
4. On the **Microsoft Defender for Cloud \| Getting started** blade, in the Install agents tab, scroll down and click Install agents. 

5. On the **Microsoft Defender for Cloud \| Getting started** blade, on the **Upgrade** tab >> scroll down until the **Select workspaces with enhanced security features** section is visible >> turn on the **Microsoft Defender plan** by selecting your Log Analytics Workspace, then click the large Blue Upgrade button.  

    >**Note**: Review all the features that are available as part of Microsoft Defender plans. 

6. Navigate to **Microsoft Defender for Cloud** and click **Environment Settings** under the Management settings, in the vertical menu bar on the left side.

7. On the **Microsoft Defender for Cloud \| Environment Settings** blade, click the relevant subscription. 

8. On the **Defender plans** blade, select **Enable all Microsoft Defender for Cloud Plans**.

9. Navigate back to the **Microsoft Defender for Cloud \| Environment Settings** blade, expand until your subscription appears, and click the entry representing the Log Analytics workspace you created in the previous lab.

10. On the **Settings \| Defender plans** blade, ensure that **Enable all Microsoft Defender for Cloud plans**.

11. Select **Data collection** from the **Microsoft Defender for Cloud \| Settings** blade. Select **All Events** and **Save**.

#### Task 2: Review the Microsoft Defender for Cloud recommendation

In this task, you will review the Microsoft Defender for Cloud recommendations. 

1. In the Azure portal, navigate back to the **Microsoft Defender for Cloud \| Overview** blade. 

2. On the **Microsoft Defender for Cloud \| Overview** blade, review the **Secure Score** tile.

    >**Note**: Record the current score if it is available.

3. Navigate back to the **Microsoft Defender for Cloud \| Overview** blade, select **Assessed resources**.

4. On the **Inventory** blade, select the **myVM** entry.

    >**Note**: You might have to wait a few minutes and refresh the browser page for the entry to appear.
    
5. On the **Resource health** blade, on the **Recommendations** tab, review the list of recommendations for **myVM**.

#### Task 3: Implement the Microsoft Defender for Cloud recommendation to enable Just in time VM Access

In this task, you will implement the Microsoft Defender for Cloud recommendation to enable Just in time VM Access on the virtual machine. 

1. In the Azure portal, navigate back to the **Microsoft Defender for Cloud \| Overview** blade and select the **Workload protections** under **Cloud Security** tile.

2. On the **Workload protections** blade, in the **Advanced protection** section, click the **Just-in-time VM access** tile and, on the **Just-in-time VM access** blade.

3. On the **Just in time VM access** blade, under the **Virtual machines** section, select **Not Configured** and then click the **myVM** entry.

4. Click the **Enable JIT on 1 VM** option on the far right of the **Virtual machines** section.

    >**Note**: You might have to wait a few minutes before the **myVM** entry becomes available.

5. On the **JIT VM access configuration** blade, on the far right of the row referencing the port **22**, click the ellipsis button and then click **Delete**.

6. On the **JIT VM access configuration** blade, click **Save**.

    >**Note**: Monitor the progress of configuration by clicking on the **Notifications** icon in the toolbar and viewing the **Notifications** blade. 

    >**Note**: It can take some time for the implementation of recommendations in this lab to be reflected by Secure Score. Periodically check the Secure Score to determine the impact of implementing these features. 

> Results: You have on-boarded Microsoft Defender for Cloud and implemented virtual machine recommendations. 

    >**Note**: Do not remove the resources from this lab as they are needed for the Microsoft Sentinel lab.
