param baseName string = 'juoudot'
param imageTag string
param location string = resourceGroup().location


resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: '${baseName}-container-app-env'
}

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: '${baseName}acr'
}


module webapp 'containerApps.bicep' = {
  name: '${baseName}-frontend-webapp'
  params: {
    containerAppEnvId: containerAppEnvironment.id
    containerAppName: '${baseName}-frontend-webapp'
    containerPort: 80
    containerImage: '${acr.properties.loginServer}/demo-webapp:${imageTag}'
    containerRegistry: acr.properties.loginServer
    containerRegistryPassword: acr.listCredentials().passwords[0].value
    containerRegistryUserName: acr.listCredentials().username
    isExternal: true
    location: location
    baseName: baseName
    containerTag: imageTag
  }
}

module webapi 'containerApps.bicep' = {
  name: '${baseName}-backend-webapi'
  params: {
    containerAppEnvId: containerAppEnvironment.id
    containerAppName: '${baseName}-backend-webapi'
    containerPort: 9000
    containerImage: '${acr.properties.loginServer}/demo-webapi:${imageTag}'
    containerRegistry: acr.properties.loginServer
    containerRegistryPassword: acr.listCredentials().passwords[0].value
    containerRegistryUserName: acr.listCredentials().username
    isExternal: true
    location: location
    baseName: baseName
    containerTag: imageTag
  }
}

output frontendUrl string = webapp.outputs.fqdn
