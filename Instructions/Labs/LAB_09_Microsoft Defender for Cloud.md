---
lab:
    title: '09 - Microsoft Defender for Cloud'
    module: 'Module 03 - Manage security posture by using Microsoft Defender for Cloud'
---

# Lab 09: Microsoft Defender for Cloud
# Student lab manual

## Lab scenario

You have been asked to create a proof of concept of Microsoft Defender for Cloud-based environment. Specifically, you want to:

- Configure Microsoft Defender for Cloud enhanced security features for servers to monitor a virtual machine.
- Review Microsoft Defender for Cloud recommendations for the virtual machine.
- Implement recommendations for guest configuration and Just-in-time VM access. 
- Review how the Secure Score can be used to determine progress toward creating a more secure infrastructure.

> For all the resources in this lab, we are using the **East US** region. Verify with your instructor this is the region to use for class. 

## Lab objectives

In this lab, you will complete the following exercise:

- Exercise 1: Implement Microsoft Defender for Cloud

## Microsoft Defender for Cloud diagram

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/c31055cc-de95-41f6-adef-f09d756a68eb)

## Instructions

### Exercise 1: Implement Microsoft Defender for Cloud

In this exercise, you will complete the following tasks:

- Task 1: Configure Microsoft Defender for Cloud
- Task 2: Review the Microsoft Defender for Cloud recommendations
- Task 3: Implement the Microsoft Defender for Cloud recommendation to enable Just-in-time VM Access

#### Task 1: Configure Microsoft Defender for Cloud Enhanced Security Features for Servers

In this task, you will on-board and configure Microsoft Defender for Cloud Enhanced Security Features for Servers.

1. Start a browser session and sign-in to the  [Azure subscription.](https://azure.microsoft.com/en-us/free/?azure-portal=true) in which you have administrative access.

2. In the Azure portal, in the Search resources, services, and docs text box at the top of the Azure portal page, type Microsoft Defender for Cloud and press the Enter key.

3. On the Microsoft Defender for Cloud, Management blade, go to the Environment settings. Expand the environment settings folders until the subscription section is displayed, then click the subscription to view details.

4. In the Settings blade, under Defender plans, expand Cloud Workload Protection (CWP).
  
5. From the Cloud Workload Protection (CWP) Plan list, select Servers. On the right side of the page, change the Status from Off to On, then click Save.
  
6. To review the details of Microsoft Defender for Servers Plan 2, select Change plan >.

>**Note**: Enabling the Cloud Workload Protection (CWP) Servers plan from Off to On enables Microsoft Defender for Servers Plan 2.

#### Task 2: Review the Microsoft Defender for Cloud recommendation

In this task, you will review the Microsoft Defender for Cloud recommendations. 

1. In the Azure portal, navigate back to the **Microsoft Defender for Cloud \| Overview** blade. 

2. On the **Microsoft Defender for Cloud \| Overview** blade, review the **Security Posture** tile and the Total secure score within it.

    >**Note**: Record the current score if it is available.

3. Navigate back to the **Microsoft Defender for Cloud \| Overview** blade, click **Assessed resources**.

4. On the **Inventory** blade, click the **myVM** entry.

    >**Note**: You might have to wait a few minutes and refresh the browser page for the entry to appear.
    
5. On the **Resource health** blade, on the **Recommendations** tab, review the list of recommendations for **myVM**.

#### Task 3: Implement the Microsoft Defender for Cloud recommendation to enable Just-in-time VM Access

In this task, you will implement the Microsoft Defender for Cloud recommendation to enable Just-in-time VM Access on the virtual machine. 

1. In the Azure portal, navigate back to the **Microsoft Defender for Cloud \| Overview** blade and click **Workload protections** under **Cloud Security** in the left navigation panel.

2. On the **Microsoft Defender for Cloud \| Workload protections** blade, scroll down to the **Advanced protection** section and click the **Just-in-time VM access** tile.

3. On the **Just-in-time VM access** blade, under the **Virtual machines** section, select **Not Configured** and then select the checkbox for the **myVM** entry.

    >**Note**: You might have to wait a few minutes, refresh the browser page and select **Not Configured** again for the entry to appear.

4. Click the **Enable JIT on 1 VM** option on the far right of the **Virtual machines** section.

5. On the **JIT VM access configuration** blade, on the far right of the row referencing the port **22**, click the ellipsis button and then click **Delete**.

6. On the **JIT VM access configuration** blade, click **Save**.

    >**Note**: Monitor the progress of configuration by clicking on the **Notifications** icon in the toolbar and viewing the **Notifications** blade. 

    >**Note**: It can take some time for the implementation of recommendations in this lab to be reflected by Secure Score. Periodically check the Secure Score to determine the impact of implementing these features. 

> Results: You have on-boarded Microsoft Defender for Cloud and implemented virtual machine recommendations. 

    >**Note**: Do not remove the resources from this lab as they are needed for the Microsoft Sentinel lab.
