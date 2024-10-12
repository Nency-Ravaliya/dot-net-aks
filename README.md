# .NET Web Application Deployment Using Azure

This project demonstrates the deployment of a **.NET web application** on **Azure App Service** using **Azure DevOps** for continuous integration and deployment (CI/CD). The deployment process also integrates **Azure Key Vault** for secure configuration management and includes a custom domain setup for the live application.

---

## Key Features

- **Automated Deployment**: The entire process, from build to deployment, is automated using **Azure DevOps** pipelines.
- **Secure Configuration Management**: Application secrets and sensitive configuration values are securely stored and accessed using **Azure Key Vault**.
- **Custom Domain**: The application is deployed on **Azure App Service** with a custom domain for public access.
- **Continuous Integration and Deployment (CI/CD)**: Azure DevOps pipelines are used for both continuous integration and deployment of the application, ensuring smooth delivery to Azure App Service.

---

## Project Architecture

1. **Azure DevOps Pipeline**:
   - Automates the build and deployment process of the .NET web application.
   
2. **Azure App Service**:
   - Hosts the live .NET web application, providing scalability and high availability.

3. **Azure Key Vault**:
   - Secures sensitive information like connection strings and API keys, ensuring they are not hardcoded within the application.

4. **Custom Domain**:
   - The live web application is accessible via a custom domain, providing a professional and user-friendly URL.

---

## Tools and Services Used

### Azure Services:
- **Azure App Service**: Hosts the .NET web application.
- **Azure Key Vault**: Manages secrets and sensitive configurations.
- **Azure DevOps**: Automates the build, test, and deployment processes through CI/CD pipelines.
- **Azure DNS**: Used to manage the custom domain for the web application.

### DevOps Tools:
- **Azure DevOps Pipelines**: For building, testing, and deploying the .NET web application.
- **Service Connections**: Securely connect Azure DevOps to other Azure services, such as App Service and Key Vault.

---

## Pipeline Overview

### 1. **Build Stage**:
- The **Azure DevOps pipeline** triggers when code is pushed to the repository.
- The .NET web application is built, and any necessary tests are run.
- The build artifacts are created and stored for use in the deployment stage.

### 2. **Deploy Stage**:
- The application is deployed to **Azure App Service** using the build artifacts.
- Azure Key Vault is accessed to retrieve any secrets required for the application.
- The application is deployed and made live on the custom domain.

---

## Azure DevOps Pipeline Configuration

### Example YAML Pipeline:

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: 'windows-latest'

variables:
  solution: '**/*.sln'
  buildPlatform: 'Any CPU'
  buildConfiguration: 'Release'
  azureSubscription: '<Azure Service Connection Name>'
  appServiceName: '<Your App Service Name>'
  resourceGroupName: '<Your Resource Group Name>'
  keyVaultName: '<Your Key Vault Name>'

steps:
  - task: UseDotNet@2
    inputs:
      packageType: 'sdk'
      version: '6.x.x'
      installationPath: $(Agent.ToolsDirectory)/dotnet

  - task: NuGetCommand@2
    inputs:
      restoreSolution: $(solution)

  - task: VSBuild@1
    inputs:
      solution: $(solution)
      msbuildArgs: '/p:DeployOnBuild=true /p:WebPublishMethod=Package /p:PackageAsSingleFile=true /p:SkipInvalidConfigurations=true'
      platform: $(buildPlatform)
      configuration: $(buildConfiguration)

  - task: AzureWebApp@1
    inputs:
      azureSubscription: $(azureSubscription)
      appName: $(appServiceName)
      package: '$(System.DefaultWorkingDirectory)/**/*.zip'

  - task: AzureKeyVault@2
    inputs:
      azureSubscription: $(azureSubscription)
      KeyVaultName: $(keyVaultName)
      SecretsFilter: '*'
```

### Key Steps:
- **UseDotNet**: Installs the necessary .NET SDK for the build.
- **NuGet Restore**: Restores any NuGet packages required for the project.
- **Build**: Builds the .NET web application.
- **Deploy**: Deploys the application package to **Azure App Service**.
- **Key Vault Access**: Retrieves secrets from **Azure Key Vault** and injects them into the application configuration during deployment.

---

## Secure Configuration Management

- **Azure Key Vault** is used to securely store sensitive information such as database connection strings and API keys.
- Secrets are referenced in the Azure DevOps pipeline and injected into the application during the deployment stage, ensuring no sensitive data is hardcoded in the codebase.

---

## Custom Domain Setup

1. **Custom Domain Configuration**: 
   - After the application is deployed to **Azure App Service**, a custom domain is configured through **Azure DNS**.
   
2. **SSL/TLS Certificate**: 
   - An SSL/TLS certificate is applied to the custom domain to ensure secure connections over HTTPS.

---

## How to Run

### Prerequisites:

1. **Azure Subscription**: Ensure you have an active Azure subscription.
2. **Azure DevOps Account**: Create a free Azure DevOps account and set up a project.
3. **Azure App Service**: Create an Azure App Service instance where the application will be deployed.
4. **Azure Key Vault**: Create an Azure Key Vault to store your application secrets.
5. **Custom Domain**: Purchase a domain and configure DNS settings with Azure App Service.

### Steps to Deploy:

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   ```
   
2. **Set Up Azure DevOps Pipeline**:
   - Import the provided **Azure DevOps YAML pipeline** in the `.azure-pipelines.yml` file.
   - Set up service connections for Azure App Service and Azure Key Vault.

3. **Commit and Push**:
   - Push your code to the `main` branch, which will trigger the pipeline to build and deploy the application.

4. **Configure Custom Domain**:
   - Set up a custom domain for your Azure App Service in the Azure Portal.
   - Apply an SSL/TLS certificate to ensure secure HTTPS connections.
This project provides a complete CI/CD solution for deploying a .NET web application to **Azure App Service** using **Azure DevOps** pipelines. It incorporates best practices for secure configuration management using **Azure Key Vault**, and it includes the ability to host the application with a custom domain for public access.

---

