az login

To See generated ARM template => az bicep build -f .\main.bicep

az group create --name juoudot-aca-rg --location "West Europe"

az deployment group create --name joudot-deployment --resource-group juoudot-aca-rg --template-file .\resources.bicep  

az deployment group create --name joudot-deployment --resource-group juoudot-aca-rg --template-file .\main.bicep --parameters imageTag=1