---
lab:
    title: '09 - Configuring and Securing ACR and AKS'
    module: 'Module 02 - Implement Platform Protection'
---

# Lab 09 - Configuring and Securing ACR and AKS

# Student lab manual

## Lab scenario

You have been asked to deploy a proof of concept with Azure Container Registry and Azure Kubernetes Service. Specifically, the proof of concept should demonstrate:

- Using Dockerfile to build an image.
- Using Azure Container Registry to store images.
- Configuring an Azure Kubernetes Service.
- Securing and accessing container applications both internally and externally. 

## Lab objectives

In this lab, you will complete:

- Exercise 1: Configuring and Securing ACR and AKS

## Exercise 1: Configuring and Securing ACR and AKS

### Exercise timing: 45 minutes

> For all the resources in this lab, we are using the **East (US)** region. Verify with your instructor this is region to use for you class. 

In this exercise, you will complete:

- Task 1: Create an Azure Container Registry
- Task 2: Create a Dockerfile, build a container and push it to Azure Container Registry
- Task 3: Create an Azure Kubernetes Service
- Task 4: Give AKS permission to access the ACR 
- Task 5: Deploy an external facing container from ACR to AKS
- Task 6: Verify you can access the container externally
- Task 7: Deploy an internal facing container from ACR to AKS
- Task 8: Verify you can access the container internally

#### Task 1: Create an Azure Container Registry

In this task, you will create a resource group for the lab an an Azure Container Registry.

1. Access the Portal and then the Cloud Shell.

1. Ensure **Bash** is selected in the upper-left drop-down menu.

1. Create a new resource group for this lab.

    ```
    az group create --name AZ500LAB09 --location eastus
    ```

1. Verify the resource group was created.
	```
	az resource list --resource-group AZ500LAB09 -o table
	```

1. Create a new Azure Container Registry (ACR). The name of the ACR must be globally unique. 

    ```
    az acr create --resource-group AZ500LAB09 --name <ACRuniquename> --sku Basic
    ```

1. Wait for the command to execute.

1. Confirm that the new ACR was created. Remember the ACR name you will need it in the next task.

    ```
    az acr list -o table
    ```

### Task 2: Create a Dockerfile, build a container and push it to Azure Container Registry

In this task, you will create a Dockerfile, build an image from the Dockerfile, and deploy the image to the ACR. 

1. Continue working in the **Bash** shell.

1. Create a Dockerfile to deploy to Nginx. 

    ```
    echo FROM nginx > Dockerfile
    ```

1. Build an image from the Dockerfile and push the image to the new ACR. 

    > The fullstop (period) at the end of the command line is required. It means the current directory. Replace ACRuniquename with the name of your ACR. 

    ```
    az acr build --image sample/nginx:v1 --registry <ACRuniquename> --file Dockerfile .
    ```

1. Wait for the command to successfully complete.

1. Close the Cloud Shell and return to the Portal.

1. Navigate to your resource group, **AZ500Lab09** and select your **ACR**. 

1. Under **Services** select **Repositories**. 

1. Verify you have a new container image named sample/nginx.

1. Select the image and notice the **v1** tag that identifies the version.

1. Click on **v1** to view the Manifest information for the container image.

1. At the top is information on the sha256 **Digest**, **Manifest creation date**, and **Platform**. 

### Task 3: Create an Azure Kubernetes Service

In this task, you will create an Azure Kubernetes service and review the deployed resources. 

1. Continue in the Portal.

1. From the Portal menu (top left), select **Create a Resource**.

1. Search for and select **Kubernetes Service**.

1. Click **Create** and configure the **Basics** tab. Take the default value for any setting that is not listed. 

	- Resource group: **AZ500LAB09**

	- Kubernetes cluster name: **MyKubernetesCluster**

	- Region: **East US**

	- Node count: **1**

1. Click **Next: Node pools**.
 
	- Virtual nodes: **disabled**
	
	- VM scale sets: **disabled**


1. Click **Next: Authentication**.

	> Do not make any changes.
	
	> Notice we are creating a cluster infrastructure service principal which is used by the Kubernetes cluster to manage cloud resources attached to the cluster. For more information, visit the [Service principals with Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal) page.

	> Also notice we are enabling Role based access control for Kubernetes. For more information, visit the [Integrate Azure Active Directory with Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration) page. 

1. Click **Next: Networking**.

	- Network configuration: **Advanced**

	> Do not make any changes.
	
	> Notice that AKS can be enabled as a private cluster. This gives the API server a private IP to ensure network traffic between your API server and your node pools remains on the private network only. For more information, visit [Create a private Azure Kubernetes Service cluster](https://docs.microsoft.com/en-us/azure/aks/private-clusters) page.

1. Click **Next: Monitoring**

	- Container monitoring: **Disabled**

1. Click **Review + Create** and then **Create**.

1. Monitor your deployment using the **Notification** icon, top right. 

    > It can take 5 - 15 minutes for AKS to deploy. 

1. Once the deployment is complete, navigate to **Resource Groups**. 

	> Notice a new resource group that holds components of the AKS Nodes, This resource group is named similar to  **MC_AZ500LAB09_MyKubernetesCluster_eastus**. Take a minute to review the resources in this new resource group. 
	
	> Return to the resource group page, and open the *AZ500LAB09** resource group. Notice there is now an AKS Cluster and a new virtual network.

1. Open the Cloud Shell.

1. Ensure **Bash** is selected in the upper-left drop-down menu.

1. Connect to the Kubernetes cluster. 

    ```
    az aks get-credentials --resource-group AZ500LAB09 --name MyKubernetesCluster
    ```

1. View the Kubenetes nodes. The **Status** should be **Ready**.

    ```
    kubectl get nodes
    ```

### Task 4: Give AKS permission to access the ACR

In this task, you will give the AKS permission to access the ACR. 

1. Continue in the **Bash** Cloud shell.

2. Update the AKS cluster to use the ACR. This command grants the 'acrpull' role assignment to the ACR. Change ACRuniquename to the name of your ACR.

    ```
    az aks update -n MyKubernetesCluster -g AZ500LAB09 --attach-acr <ACRuniquename> 
    ```

    > It may take a few minutes for this command to complete. 

### Task 5: Deploy an external facing container from ACR to AKS

In this task,  you will download the Manifest files, edit the YAML file, and apply your changes to the cluster. 

1. Continue in the **Bash** Cloud shell. 

1. Download the Manifest files.

    ```
    wget https://raw.githubusercontent.com/sympa18/AZ-500-Azure-Security/master/2020/Allfiles/Labs/LAB_09/nginxexternal.yaml && wget https://raw.githubusercontent.com/sympa18/AZ-500-Azure-Security/master/2020/Allfiles/Labs/LAB_09/nginxinternal.yaml
    ```

1. Open the nginxexternal.yaml file, so you can make an edit. Notice this is the *external* yaml file.

    ```
    code ./nginxexternal.yaml
    ```

1. On **line 21** replace **ACRUniquename** with your ACR name.

    image: **ACRUniquename**.azurecr.io/sample/nginx:v1

1. Click on the **ellipses** (editor menu bar, far right) and select **Save**.

1. Click on the **ellipses** and select **Close editor**.

1. Apply the change to the cluster.

    ```
    kubectl apply -f nginxexternal.yaml
    ```

1. Review the output to verify your deployment and the service have been created. 

    ```
    deployment.apps/nginxexternal created
    service/nginxexternal created
    ```

### Task 6: Verify the you can access the container externally

In this task, verify the container can be accessed externally using the public IP address.

1. Continue in the **Bash** Cloud shell. 

1. Retrieve information about the external facing pod (container) including name, type, IP addresses, and ports. 

    ```
    kubectl get service nginxexternal
    ```

1. Review your output and make a note of the External-IP address. You will need it in the next step. 

	| NAME | TYPE | CLUSTER-IP | **External-IP** | PORT(S) | AGE |
	| --- |--- | --- | --- | --- | --- |
    | nginxexternal | LoadBalancer | 10.0.60.56 | 52.191.80.141 | 80:32591/TCP | 2m9s |
	| | | | | | |

    > When you view the service details, the IP address of the internal load balancer is shown in the EXTERNAL-IP column. In this context, External is in relation to the external interface of the load balancer, not that it receives a public, external IP address.

1. Open Internet Explorer and browse to your external pod's External-IP address. 

1. Ensure the **Welcome to nginx!** page displays. 

### Task 7: Deploy an internal facing container from ACR to AKS

In this task, you will deploy the internal facing container from ACR to AKS. 

1. Continue in the **Bash** Cloud shell. 

1. Open the nginxintenal.yaml file, so you can make an edit. Notice this is the *internal* yaml file.

    ```
    code ./nginxinternal.yaml
    ```

1. On **line 21** replace **ACRUniquename** with your ACR name.

    image: **ACRUniquename**.azurecr.io/sample/nginx:v1

1. Click on the **ellipses** (editor menu bar, far right) and select **Save**.

1. Click on the **ellipses** and select **Close editor**.

1. Apply the change to the cluster.
    ```
    kubectl apply -f nginxinternal.yaml
    ```

1.  Review the output to verify your deployment and the service have been created.

    ```
    deployment.apps/nginxinternal created
    service/nginxinternal created
    ```


### Task 8: Verify the you can access the container internally

In this task, you will create a virtual machine and verify you can access the container. 

1. Retrieve information about the internal facing pod (container) including name, type, IP addresses, and ports. 

    ```
    kubectl get service nginxinternal
	```

1. Review your output. The External-IP is the private IP address. Make a note of this address. You will need it at the end of this task. 

	| NAME | TYPE | CLUSTER-IP | External-IP | PORT(S) | AGE |
	| --- |--- | --- | --- | --- | --- |
    | nginxinternal | LoadBalancer | 10.0.78.106 | 10.240.0.35  | 80:31834/TCP | 41s |
	| | | | | | |

1. Close the **Bash** Cloud shell.

1. To access the container we need to deploy a virtual machine (AKSJumpBox) in a virtual network subnet (JumpBox). 

1. First, lets create the subnet.

1. In the Portal, navigate to **Resource Groups**.

1. Select the **AZ500LAB09** resource group and then select the **AZ500LAB09-vnet** virtual network.

1. Under **Settings** select **Subnets**. 

1. Click **+ Subnet** and complete the required information. Take the default value for any setting that is not listed. 

	- Name: **JumpBox**

	- Address range: **10.0.0.0/24**

1. Click **OK** to create the subnet. 

2. Now lets create the virtual machine in the JumpBox subnet. 

1. On the Portal menu (top left) select **Create a resource**.

1. Under **Popular**, select **Windows Server 2016 Datacenter**.

1. Configure the **Basic** information. Take the default value for any setting that is not specified. 

	- Resource group: **AZ500LAB09**

	- Virtual machine name: **AKSJumpBox**
	
	- Region: **East US**

	- Size: **Standard DS2 v2**

	- User: **localadmin**

	- Password: **Pa55w.rd**

	- Public inbound ports: **Allow selected ports** - **RDP (3389)**

1. Move the **Networking** tab. Ensure the virtual machine is deployed in the JumpBox subnet. Take the default value for any setting that is not specified. 

	- Virtual network: **AZ400LAB09-vnet**
	
	- Subnet: **JumpBox (10.0.0.0/24)**

1. Move to the **Management** tab. Take the default value for any setting that is not specified. 

	- Boot diagnostics: **Off**

1. Click **Review + Create** then **Create**.

1. Wait for the AKSJumpBox to deploy.

1. Navigate to the **AZ500LAB09** resource group. 

	> Notice the AKSJumpBox has been added to the resource group. You will also notice there is a NSG to control network flow within the virtual network to the AKS Cluster.

1. Select the **AKSJumpBox** virtual machine. 

1. You will need to connect to the virtual machine to test the private container.

1. On the **Overview** pane, click **Connect** > **RDP**.

1. Click **Download RDP file** and open the file.

1. In the **Remote Desktop Connection** dialog select **Connect**.

1. Select **More choices** and then **Use a different account**.

	- Email address: **localadmin**

    - Password: **Pa55w.rd**

1. Click **OK** and click **Yes** to verify the identity of the virtual machine. 

1. Wait for the remote session to open. 

1. Open Internet Explorer and browse to internal pod's External-IP address.

1. Ensure the **Welcome to nginx!** page displays. 

> Result: You have configured and secured ACR and AKS.


**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 

1. Access the Cloud Shell.

1. Ensure **PowerShell** is selected in the upper-left drop-down menu of the Cloud Shell pane.

1. Remove the resource group using the Cloud Shell and PowerShell.

    ```
    Remove-AzResourceGroup -Name "AZ500LAB09"
	```

1. Remove the AKS cluster.    

	```
	Remove-AzResourceGroup -Name "MC_AZ500LAB09_MyKubernetesCluster_eastus"
    ```