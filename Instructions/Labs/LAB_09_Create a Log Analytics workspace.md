---
lab:
    title: 'Exercise 0x - Create a Log Analytics workspace'
    module: 'Module 04 - Create a Log Analytics workspace'
---


>**Note**: To complete this lab, you will need an [Azure subscription.](https://azure.microsoft.com/en-us/free/?azure-portal=true) in which you have administrative access. 


When you collect logs and data, the information is stored in a workspace. A workspace has a unique workspace ID and resource ID. The workspace name must be unique for a given resource group. After you've created a workspace, configure data sources and solutions to store their data there. 

---

## Skilling task

- Create a Log Analytics workspace.
- Associate the workspace with an existing resource group.
- Specify a specific region to deploy the workspace.

## Exercise instructions 

### Use the Log Analytics workspaces menu to create a workspace.

1. Start a browser session and sign-in to the [Azure portal menu.](https://portal.azure.com/)
   
2. In the search box at the top of the portal, type **log analytics workspaces.** Select **Log Analytics workspaces** in the search results.

3. On the **Log Analytics workspaces** page, select **+ Create.**

4. On the **Basics** page of **Create Log Analytics workspace,** enter or select this information:
   
   |Setting|Value|
   |---|---|
   |**Project details**|
   |Subscription|Select your subscription.|
   |Resource group|Enter **az-rg-1.**|
   |**Instance details**|
   |Name|Enter **azwrkspc1a.**|
   |Region|Select **East US.**|

5. Select the **Review + create** tab at the bottom of the page.
  
6. Select **Create.**

> **Results:** You have created a Log Analytics workspace, to collect data from Azure reources.
