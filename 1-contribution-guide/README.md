# Azure Policy samples

This repository contains all currently available Azure Policy samples contributed by the community. The following information is relevant to get started with contributing to this repository.

+ [**Contribution guide**](/1-contribution-guide/README.md#contribution-guide). Describes the minimal guidelines for contributing.
+ [**Git tutorial**](/1-contribution-guide/git-tutorial.md#git-tutorial). Step by step to get you started with Git.
+ [**Useful Tools**](/1-contribution-guide/useful-tools.md#useful-tools). Useful resources and tools for Azure development.

## Deploying Samples

To deploy the samples into your own Azure environment, download the repository and extract the sample(s) (azurepolicy.json) you want to use.

![media](./images/downloadrepo.png)

Once extracted, you can use this [PowerShell script example](/1-contribution-guide/psscript.md) to modify the files to work in your environment, and assign the policy to the preferred scope (subscription or Resource Group).

## Contribution guide

To make sure your Azure Policy sample is added to this repository, please follow these guidelines. Any Azure Policy sample that is out of compliance will be added to the **blacklist** and not be merged.

## Files, folders and naming conventions

1. Every Azure Policy sample its associated files must be contained in its own **folder**, into the folder representing the relevant Resource Provider (Compute for VM based policies, Storage for storage based policies etc.) Name this folder something that describes what your policy does. Usually this naming pattern looks like **deny-vm-storage-account** or **allowed-network-locations**.

**Protip** - Try to keep the name of your template folder short so that it fits inside the Github folder name column width.
2. Github uses ASCII for ordering files and folder. For consistent ordering **create all files and folders in lowercase**. The only **exception** to this guideline is the **README.md**, that should be in the format **UPPERCASE.lowercase**.
3. Include a **README.md** file that explains how the Azure Policy works, and how to assign it at scope.
 + Guidelines on the README.md file below.
4. An Azure Policy needs to include the following files:
 + **azurepolicy.json** - The JSON that describes the policy.
 + **README.md** - Documentation and instruction on how to use the Azure Policy, including Azure CLI/PowerShell samples to create definition and assignment. See more information below.
5. Images used in the README.md must be placed in a folder called **images**.

![alt text](./images/structure.png "Files, folders and naming conventions")
 
## README.md

The README.md describes your policy. A good description helps other community members to understand your deployment. The README.md uses [Github Flavored Markdown](https://guides.github.com/features/mastering-markdown/) for formatting text. If you want to add images to your README.md file, store the images in the **images** folder. Reference the images in the README.md with a relative path (e.g. `![alt text](images/namingConvention.png "Files, folders and naming conventions")`). This ensures the link will reference the target repository if the source repository is forked. A good README.md contains the following sections

+ Deployment instructions
+ PowerShell/CLI example of automated import
+ Description of what the Azure Policy will do
+ *Optional: Prerequisites
+ *Optional: Notes

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
