---
lab:
    title: 'Exercise 09 - Enable just-in-time access on VMs'    
    module: 'Module 03 - Explore just-in-time VM access'
---


>**Note**: To complete this lab, you will need an [Azure subscription.](https://azure.microsoft.com/en-us/free/?azure-portal=true) in which you have administrative access. 


You can use Microsoft Defender for Cloud's just-in-time (JIT) access to protect your Azure virtual machines (VMs) from unauthorized network access. Many times firewalls contain allow rules that leave your VMs vulnerable to attack. JIT lets you allow access to your VMs only when the access is needed, on the ports needed, and for the period of time needed. 

---

## Skilling tasks

- Enable JIT on your VMs from the Azure portal.

- Request access to a VM that has JIT enabled from the Azure portal.

## Exercise instructions 

### Enable JIT on your VMs from Azure virtual machines

>**Note**: You can enable JIT on a VM from the Azure virtual machines pages of the Azure portal.

1. Start a browser session and sign-in to the [Azure portal menu.](https://portal.azure.com/).
  
2. In the search box at the top of the portal, enter **virtual machines.** Select **Virtual machines** in the search results.

3. Select **vm-1.**
 
4. Select **Configuration** from the **Settings** section of vm-1.
   
5. Under **Just-in-time VM access,** select **Enable just-in-time.**

6. Under **Just-in-time VM access,** click on the link that reads **Open Microsoft Defender for Cloud.**

7. By default, just-in-time access for the VM uses these settings:

   - Windows machines
   
     - RDP port: 3389
     - Maximum allowed access: Three hours
     - Allowed source IP addresses: Any

   - Linux machines
     - SSH port: 22
     - Maximum allowed access: Three hours
     - Allowed source IP addresses: Any
   
8. By default, just-in-time access for the VM uses these settings:

   - From the **Configured** tab, right-click on the VM to which you want to add a port, and select edit.

   ![image](https://github.com/user-attachments/assets/aa4ded55-c5b1-4d40-b5a0-a4c33b9eb81b)
   
   - Under **JIT VM access configuration,** you can either edit the existing settings of an already protected port or add a new custom port.
   - When you've finished editing the ports, select **Save.**   

### Request access to a JIT-enabled VM from the Azure virtual machine's connect page.

>**Note**: When a VM has a JIT enabled, you have to request access to connect to it. You can request access in any of the supported ways, regardless of how you enabled JIT.
   
1. In the Azure portal, open the virtual machines pages.

2. Select the VM to which you want to connect, and open the **Connect** page.

   - Azure checks to see if JIT is enabled on that VM.

        - If JIT isn't enabled for the VM, you're prompted to enable it.
    
        - If JIT is enabled, select **Request access** to pass an access request with the requesting IP, time range, and ports that were configured for that VM.
    
   ![image](https://github.com/user-attachments/assets/f5d0b67c-7731-4261-b0eb-a56c505dadd4)

> **Results**: You have explored various methods on how to enable JIT on your VMs and how to request access to VMs that have JIT enabled in Microsoft Defender for Cloud.
