
# This is a demo multi-container app!

## Deployment instructions

1. From the Deploy folder, deploy the supporting infrastructure by running 
   > `az deployment group create --name <deployment_name> --resource-group <resource_group_name> --template-file .\resources.bicep`
2. **Build** and **Push** the two Docker images to your Azure Container Registry
3. From the Deploy folder or from your Release pipeline in Azure DevOps, run 
   > `az deployment group create --name <deployment_name> --resource-group <resource_group_name> --template-file .\main.bicep --parameters imageTag=<imageTag>`
 
   >Note: In Azure DevOps, your image tag will be **$(Build.BuildId)**