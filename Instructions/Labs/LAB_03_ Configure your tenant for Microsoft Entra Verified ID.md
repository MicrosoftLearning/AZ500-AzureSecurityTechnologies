---
lab:
    title: '03 - Configure your tenant for Microsoft Entra Verified ID'
    module: 'Module 01 - Manage Identity and Access'
# Customer intent: As an enterprise, we want to enable customers to manage information about themselves by using verifiable credentials.

---
# Lab 03: Configure your tenant for Microsoft Entra Verified ID
# Student lab manual

## Lab scenario

# Configure your tenant for Microsoft Entra Verified ID

>[!Note] 
> Azure Active Directory Verifiable Credentials is now Microsoft Entra Verified ID and part of the Microsoft Entra family of products. Learn more about the [Microsoft Entra family](https://aka.ms/EntraAnnouncement) of identity solutions and get started in the [unified Microsoft Entra admin center](https://entra.microsoft.com).

Microsoft Entra Verified ID is a decentralized identity solution that helps you safeguard your organization. The service allows you to issue and verify credentials. Issuers can use the Verified ID service to issue their own customized verifiable credentials. Verifiers can use the service's free REST API to easily request and accept verifiable credentials in apps and services. In both cases, your Azure AD tenant needs to be configured to either issue your own verifiable credentials, or verify the presentation of a user's verifiable credentials issued by a third party. In the event that you are both an issuer and a verifier, you can use a single Azure AD tenant to both issue your own verifiable credentials and verify those of others.

In this tutorial, you learn how to configure your Azure AD tenant to use the verifiable credentials service.

Specifically, you learn how to:

> - Create an Azure Key Vault instance.
> - Set up the Verified ID service.
> - Register an application in Azure AD.
> - Verify domain ownership to your Decentralized Identifier (DID)

The following diagram illustrates the Verified ID architecture and the component you configure.

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/8d4d01c2-3110-421a-91a8-7b052bc8d793)


## Prerequisites

- Ensure that you have the global administrator or the authentication policy administrator permission for the directory you want to configure. If you're not the global administrator, you need the application administrator permission to complete the app registration including granting admin consent.
- Ensure that you have the contributor role for the Azure subscription or the resource group where you are deploying Azure Key Vault.

## Create a key vault

Azure Key Vault is a cloud service that enables the secure storage and access of secrets and keys. The Verified ID service stores public and private keys in Azure Key Vault. These keys are used to sign and verify credentials.

### Use the Azure portal to create an Azure Key Vault.

1. Start a browser session and sign-in to the [Azure portal menu.](https://portal.azure.com/)
   
2. In the Azure portal Search box, enter **Key Vault.**

3. From the results list, choose **Key Vault.**

4. On the Key vaults section, choose **Create.**

5. On the **Basics** tab of **Create a key vault,** enter or select this information:
   
   |Setting|Value|
   |---|---|
   |**Project details**|
   |Subscription|Select your subscription.|
   |Resource group|Enter **azure-rg-1.** Select **OK**|
   |**Instance details**|
   |Key vault name|Enter **Contoso-vault2.**|
   |Region|Select **East US**|
   |Pricing tier|System default **Standard**|
   |Days to retain deleted vaults|System default **90**|

6. Select the **Review + create tab,** or select the blue Review + create button at the bottom of the page.
  
7. Select **Create.**

Take note of these two properties:

* **Vault Name**: In the example, this is **Contoso-Vault2**. You'll use this name for other steps.
* **Vault URI**: In the example, the Vault URI is `https://contoso-vault2.vault.azure.net/`. Applications that use your vault through its REST API must use this URI.

At this point, your Azure account is the only one authorized to perform operations on this new vault.

>[!NOTE]
>By default, the account that creates a vault is the only one with access. The Verified ID service needs access to the key vault. You must configure your key vault with access policies allowing the account used during configuration to create and delete keys. The account used during configuration also requires permissions to sign so that it can create the domain binding for Verified ID. If you use the same account while testing, modify the default policy to grant the account sign permission, in addition to the default permissions granted to vault creators.

### Set access policies for the key vault

A Key Vault defines whether a specified security principal can perform operations on Key Vault secrets and keys. Set access policies in your key vault for both the Verified ID service administrator account, and for the Request Service API principal that you created.
After you create your key vault, Verifiable Credentials generates a set of keys used to provide message security. These keys are stored in Key Vault. You use a key set for signing, updating, and recovering verifiable credentials.

### Set access policies for the Verified ID Admin user

1. Sign in to the [Azure portal](https://portal.azure.com).

2. Go to the key vault you use for this tutorial.

3. Under **Settings**, select **Access policies**.

4. In **Add access policies**, under **USER**, select the account you use to follow this tutorial.

5. For **Key permissions**, verify that the following permissions are selected: **Get**, **Create**, **Delete**, and **Sign**. By default, **Create** and **Delete** are already enabled. **Sign** should be the only key permission you need to update.

      ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/7c8a92ea-24f1-41e6-9656-869e8486af72)


6. To save the changes, select **Save**.

## Set up Verified ID

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/b4b857a2-24b8-4c3f-9f5c-43d23b58427f)


To set up Verified ID, follow these steps:

1. Sign in to the [Azure portal](https://portal.azure.com).

2. Search for *Verified ID*. Then, select **Verified ID**.

3. From the left menu, select **Setup**.

4. From the middle menu, select **Define organization settings**

5. Set up your organization by providing the following information:

    1. **Organization name**: Enter a name to reference your business within Verified IDs. Your customers don't see this name.

    1. **Trusted domain**: Enter a domain that's added to a service endpoint in your decentralized identity (DID) document. The domain is what binds your DID to something tangible that the user might know about your business. Microsoft Authenticator and other digital wallets use this information to validate that your DID is linked to your domain. If the wallet can verify the DID, it displays a verified symbol. If the wallet can't verify the DID, it informs the user that the credential was issued by an organization it couldn't validate.

        >[!IMPORTANT]
        > The domain can't be a redirect. Otherwise, the DID and domain can't be linked. Make sure to use HTTPS for the domain. For example: `https://did.woodgrove.com`.

    1. **Key vault**: Select the key vault that you created earlier.

    1. Under **Advanced**, you may choose the **trust system** that you want to use for your tenant. You can choose from either **Web** or **ION**. Web means your tenant uses [did:web](https://w3c-ccg.github.io/did-method-web/) as the did method and ION means it uses [did:ion](https://identity.foundation/ion/).

        >[!IMPORTANT]
        > The only way to change the trust system is to opt-out of the Verified ID service and redo the onboarding.

1. Select **Save**.  

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/b191676e-03e3-423f-aa28-1e3d2887ea07)


### Set access policies for the Verified ID service principals

When you set up Verified ID in the previous step, the access policies in Azure Key Vault are automatically updated to give service principals for Verified ID the required permissions.  
If you ever are in need of manually resetting the permissions, the access policy should look like below.

| Service Principal | AppId | Key Permissions |
| -------- | -------- | -------- |
| Verifiable Credentials Service | bb2a64ee-5d29-4b07-a491-25806dc854d3 | Get, Sign |
| Verifiable Credentials Service Request | 3db474b9-6a0c-4840-96ac-1fceb342124f | Sign |



![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/896b8ea0-b88b-43b8-a93b-4771defedfde)


## Register an application in Azure AD

Your application needs to get access tokens when it wants to call into Microsoft Entra Verified ID so it can issue or verify credentials. To get access tokens, you have to register an application and grant API permission for the Verified ID Request Service. For example, use the following steps for a web application:

1. Sign in to the [Azure portal](https://portal.azure.com) with your administrative account.

1. If you have access to multiple tenants, select the **Directory + subscription**. Then, search for and select your **Azure Active Directory**.

1. Under **Manage**, select **App registrations** > **New registration**.  

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/03ca3d13-5564-4ce2-b42c-f8333bc97fb5)


1. Enter a display name for your application. For example: *verifiable-credentials-app*.

1. For **Supported account types**, select **Accounts in this organizational directory only (Default Directory only - Single tenant)**.

1. Select **Register** to create the application.

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/d0a15737-c8a9-4522-990d-1cf6bc12cc1e)


### Grant permissions to get access tokens

In this step, you grant permissions to the **Verifiable Credentials Service Request** Service principal.

To add the required permissions, follow these steps:

1. Stay in the **verifiable-credentials-app** application details page. Select **API permissions** > **Add a permission**.

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/adf97022-2081-4273-8d61-f2b53628e989)

1. Select **APIs my organization uses**.

1. Search for the **Verifiable Credentials Service Request** service principal and select it.

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/01691eb2-ab7f-4778-9911-342eb9350f99)

1. Choose **Application Permission**, and expand **VerifiableCredential.Create.All**.

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/3c5e008e-2ba5-417a-90ff-22e8f622ad34)


1. Select **Add permissions**.

1. Select **Grant admin consent for \<your tenant name\>**.

You can choose to grant issuance and presentation permissions separately if you prefer to segregate the scopes to different applications.

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/640def45-e666-423e-bf69-598e8980b125)

## Register decentralized ID and verify domain ownership

After Azure Key Vault is setup, and the service have a signing key, you must complete step 2 and 3 in the setup.

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/40e10177-b025-4d10-b16a-d66c06762c3f)

1. Navigate to the Verified ID service in the Azure portal.  
1. From the left menu, select **Setup**.
1. From the middle menu, select **Verify domain ownership**.

# Verify domain ownership to your Decentralized Identifier (DID)

## Verify domain ownership and distribute did-configuration.json file

The domain needs to be a domain under your control and it should be in the format `https://www.example.com/`. 

1. From the Azure portal, navigate to the VerifiedID page.

1. Select **Setup**, then **Verify domain ownership** and choose **Verify** for the domain

1. Copy or download the `did-configuration.json` file.

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/342fa12f-2d0d-40cf-a2f9-8796a86f0824)

1. Host the `did-configuration.json` file at the location specified. Example: If you specified domain `https://www.example.com` the file need to be hosted at this URL `https://www.example.com/.well-known/did-configuration.json`.
   There can be no additional path in the URL other than the `.well-known path` name.

1. When the `did-configuration.json` is publicly available at the .well-known/did-configuration.json URL, verify it by pressing the **Refresh verification status** button.

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/49a06251-af56-49b2-9059-0bd4ca678da6)

> Result: You have successfully created an Azure Key Vault instance, set up the Verified ID service, registered an application in Azure AD, and verified domain ownership for your Decentralized Identifier (DID).

**Clean up resources**

> Remember to remove any newly created Azure resources that you no longer use. Removing unused resources ensures you will not incur unexpected costs. 
