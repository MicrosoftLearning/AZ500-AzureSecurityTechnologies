---
lab:
    title: 'Exercise 04 - Create a data collection rule and install the Azure Monitor Agent'    
    module: 'Module 05 - Collect guest operating system monitoring data from Azure and hybrid virtual machines using Azure Monitor Agent'
---


>**Note**: To complete this lab, you will need an [Azure subscription.](https://azure.microsoft.com/en-us/free/?azure-portal=true) in which you have administrative access. 


Data Collection Rules (DCRs) specify the data to be collected, while the Azure Monitor Agent applies these rules to gather logs and metrics from virtual machines in Azure, other clouds, or on-premises. Together, they enable consistent and centralized monitoring across different environments.

---

## Skilling tasks

- Create and define a Data Collection Rule.

- Select target resources for data collection.

- Install the Azure Monitor Agent.
  
- Configure data sources and destinations.

- Select data source types and data to collect.

- Choose a data delivery destination.

## Exercise instructions 

### Create and define a Data Collection Rule, and install the Azure Monitor Agent.

>**Note**: Create the data collection rule in the same region as your Log Analytics or Azure Monitor workspace. You can associate it with machines or containers from any subscription or resource group within the tenant. The Azure Monitor Agent will be automatically installed on Azure virtual resources.

1. Start a browser session and sign-in to the [Azure portal menu.](https://portal.azure.com/)
  
3. In the search box at the top of the portal, enter **data collection rules.** Select **Data collection rules** in the search results.
  
4. On the **Data collection rules** page, select **+ Create.**
  
    ![image](https://github.com/user-attachments/assets/a472bc6f-fa96-4615-a67c-c99e8b9ce7a4)

5. On the **Basics** page of the **Create Data Collection Rule blade**, specify the following settings (leave the others at their default values):

    |Setting|Value|
    |---|---|
    |**Rule details**|
    |Rule Name|**dcr-1**|
    |Subscription|Select your subscription.|
    |Resource group|**az-rg-1**|
    |Region|**East US**|
    |Platform Type|**Windows**|
    |Data Collection Endpoint|Leave the default setting as none|

   ![image](https://github.com/user-attachments/assets/6c63c48f-f7a9-4fb2-8fc0-e22084cd5013)

6. Click the button at the bottom of the **Basics** page labeled **Next: Resources >** to proceed.
   
7. On the **Resources** page, select **+ Add resources.**

   ![image](https://github.com/user-attachments/assets/7e45996b-478b-4be4-9df3-df6127da6cb4)

8. In the **Select a scope** template, check the **Subscription** box in the **Scope.**

   ![image](https://github.com/user-attachments/assets/0d228e47-039e-4418-ae66-025957e368bc)

9. At the bottom of the **Select a scope** template, click **Apply.**
  
10. At the bottom of the **Resources** page, select **Next: Collect and deliver >.**

    ![image](https://github.com/user-attachments/assets/95556211-654f-4810-98a0-5cd8fac13bff)  

11. On the **Collect and deliver page**, click **+ Add data source.**

    ![image](https://github.com/user-attachments/assets/8274b0c1-8617-4889-9aef-78e050f2bd00)

12. On the **Add data source** template, under **Data source type**, select the following settings:
    
    |Setting|Value|
    |---|---|
    |**Add data source**|
    |Select which data source type and the data to collect for your resource(s).|
    |Data source type*|**Windows Event Logs**|
    |Choose Basic to to enable collection of event logs.|
    |Configure the event logs and levels to collect:|
    |Application|**Critical**, **Error**, **Warning**|
    |Security|**Audit success**, **Audit failure**|
    |System|**Critical**, **Error**, **Warning**|

    ![image](https://github.com/user-attachments/assets/33039994-0613-40f4-9c55-03f795b38b9b)

13. At the bottom of the **Add data source** template, select **Next: Destination >.**

14. In the **Add data source** template, under the **Destination** tab, select the following settings.
    
    |Setting|Value|
    |---|---|
    |**Add data source**|
    |Destination|**+ Add destination**|
    |Destination type|**Azure Monitor Logs**|
    |Subscription|Select your Subscription.|
    |Destination Details|**azwrkspc1a (az-rg-1**)|

     ![image](https://github.com/user-attachments/assets/dc2d2906-4a57-4df9-a33c-fd6ae34a8457)

15. At the bottom of the **Add data source** template, select **Add data source.**

16. At the bottom of the **Collect and deliver** page, select **Review + create.**

    ![image](https://github.com/user-attachments/assets/4277089c-971c-4334-a49d-6ac6bfe93ff4)

17. At the bottom of the **Review + create** page, select **Create.**

    ![image](https://github.com/user-attachments/assets/b532f92e-af10-4b4d-bb52-10d15ad38d4a)

> **Results**: You have created a data collection rule and installed the Azure Monitor Agent.
