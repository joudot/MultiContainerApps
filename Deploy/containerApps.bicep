param containerRegistry string
param containerRegistryUserName string
@secure()
param containerRegistryPassword string
param containerImage string
param minReplicas int = 0
param maxReplicas int = 3
param containerAppName string
param containerAppEnvId string
param isExternal bool
param baseName string
param containerTag string

param activeRevisionMode string = 'Single'
param containerPort int = 80
param location string = resourceGroup().location

resource ai 'Microsoft.Insights/components@2020-02-02' existing = {
  name: '${baseName}-ApplicationInsights'
}


resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: location
  properties: {
    managedEnvironmentId: containerAppEnvId
    configuration: {
      activeRevisionsMode: activeRevisionMode
      ingress: {
        allowInsecure: true
        targetPort: containerPort
        external: isExternal
      }
      secrets: [
        {
          name: 'container-registry-password'
          value: containerRegistryPassword
        }
      ]
      registries: [
        {
          server: containerRegistry
          passwordSecretRef:'container-registry-password'
          username: containerRegistryUserName
        }
      ]
      dapr: {
        appId: containerAppName
        appPort: containerPort
        appProtocol: 'http'
        enabled: true
      }
    }
    template: {
      containers: [
        {
          image: containerImage
          name: containerAppName
          env: [
            {
              name: 'ASPNETCORE_ENVIRONMENT'
              value: 'Development'
            }
            {
              name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value: ai.properties.ConnectionString
            }
            {
              name: 'APPLICATIONINSIGHTS_INSTRUMENTATIONKEY'
              value: ai.properties.InstrumentationKey
            }
            {
              name: 'CONTAINER_VERSION'
              value: containerTag
            }
          ]
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
        rules:  [
          {
            name: 'http-rule'
            http: {
              metadata:{
                concurrentRequests: '2'
              }
            }
          }
        ]
      }
  }
}
}
output fqdn string = containerApp.properties.configuration.ingress.fqdn
