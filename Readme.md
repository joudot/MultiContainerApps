
# This is a demo multi-container app!

## Deployment instructions

Despite the _"Get Sources"_ task there are three tasks more in the build:

1. From the Deploy folder, run 'az deployment group create --name <deployment_name> --resource-group <resource_group_name> --template-file .\resources.bicep'
2. Run the Build pipeline defined in the file 'azure-pipelines.yml' from Azure DevOps
3. From the Deploy folder or from your Release pipeline in Azure DevOps, run 'az deployment group create --name <deployment_name> --resource-group <resource_group_name> --template-file .\main.bicep --parameters imageTag=$(Build.BuildId)'