# Prompt: Pipeline CI/CD Azure DevOps

## Objetivo
Configurar pipeline completo de CI/CD no Azure DevOps para o projeto SmartServe API com build, teste, análise de qualidade e deploy automatizado.

## Contexto do Projeto
- **Framework:** ASP.NET Core 8.0+
- **Plataforma:** Azure App Service / Azure Container Apps
- **Source Control:** Azure Repos / GitHub
- **Container Registry:** Azure Container Registry (ACR)

## azure-pipelines.yml

```yaml
# Pipeline CI/CD para SmartServe API
# Triggers: commits na main e pull requests

trigger:
  branches:
    include:
      - main
      - develop
  paths:
    exclude:
      - README.md
      - docs/**

pr:
  branches:
    include:
      - main
      - develop

variables:
  # Build Configuration
  buildConfiguration: 'Release'
  dotnetVersion: '8.0.x'
  projectPath: 'SmartServe.Api/SmartServe.Api.csproj'
  
  # Docker
  dockerRegistryServiceConnection: 'SmartServeACR'
  imageRepository: 'smartserve-api'
  containerRegistry: 'smartserve.azurecr.io'
  dockerfilePath: '$(Build.SourcesDirectory)/Dockerfile'
  tag: '$(Build.BuildId)'
  
  # Azure Resources
  azureSubscription: 'SmartServe-Production'
  appServiceName: 'smartserve-api-prod'
  resourceGroupName: 'smartserve-rg'
  
  # SonarCloud
  sonarCloudOrganization: 'smartserve'
  sonarCloudProjectKey: 'smartserve-api'

stages:
  # ========================================
  # STAGE 1: Build & Test
  # ========================================
  - stage: Build
    displayName: 'Build and Test'
    jobs:
      - job: BuildJob
        displayName: 'Build, Test & Analyze'
        pool:
          vmImage: 'ubuntu-latest'
        
        steps:
          # 1. Setup .NET
          - task: UseDotNet@2
            displayName: 'Install .NET SDK'
            inputs:
              version: $(dotnetVersion)
              includePreviewVersions: false
          
          # 2. Restore Dependencies
          - task: DotNetCoreCLI@2
            displayName: 'Restore NuGet Packages'
            inputs:
              command: 'restore'
              projects: '**/*.csproj'
              feedsToUse: 'select'
          
          # 3. SonarCloud - Prepare
          - task: SonarCloudPrepare@1
            displayName: 'Prepare SonarCloud Analysis'
            inputs:
              SonarCloud: 'SonarCloud-SmartServe'
              organization: $(sonarCloudOrganization)
              scannerMode: 'MSBuild'
              projectKey: $(sonarCloudProjectKey)
              projectName: 'SmartServe API'
              extraProperties: |
                sonar.cs.opencover.reportsPaths=$(Build.SourcesDirectory)/coverage/coverage.opencover.xml
                sonar.coverage.exclusions=**Tests*.cs
          
          # 4. Build
          - task: DotNetCoreCLI@2
            displayName: 'Build Solution'
            inputs:
              command: 'build'
              projects: $(projectPath)
              arguments: '--configuration $(buildConfiguration) --no-restore'
          
          # 5. Run Unit Tests
          - task: DotNetCoreCLI@2
            displayName: 'Run Unit Tests'
            inputs:
              command: 'test'
              projects: '**/*Tests/*.csproj'
              arguments: >
                --configuration $(buildConfiguration)
                --no-build
                --logger trx
                --collect:"XPlat Code Coverage"
                --results-directory $(Build.SourcesDirectory)/coverage
                -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover
          
          # 6. Publish Test Results
          - task: PublishTestResults@2
            displayName: 'Publish Test Results'
            condition: succeededOrFailed()
            inputs:
              testResultsFormat: 'VSTest'
              testResultsFiles: '**/*.trx'
              failTaskOnFailedTests: true
              testRunTitle: 'SmartServe API Tests'
          
          # 7. Publish Code Coverage
          - task: PublishCodeCoverageResults@1
            displayName: 'Publish Code Coverage'
            inputs:
              codeCoverageTool: 'Cobertura'
              summaryFileLocation: '$(Build.SourcesDirectory)/coverage/**/coverage.cobertura.xml'
              failIfCoverageEmpty: false
          
          # 8. SonarCloud - Analyze
          - task: SonarCloudAnalyze@1
            displayName: 'Run SonarCloud Analysis'
          
          # 9. SonarCloud - Publish Quality Gate
          - task: SonarCloudPublish@1
            displayName: 'Publish Quality Gate Result'
            inputs:
              pollingTimeoutSec: '300'
          
          # 10. Quality Gate Check
          - task: sonarcloud-buildbreaker@2
            displayName: 'Break Build on Quality Gate Failure'
            inputs:
              SonarCloud: 'SonarCloud-SmartServe'
              organization: $(sonarCloudOrganization)
          
          # 11. Publish Artifacts
          - task: DotNetCoreCLI@2
            displayName: 'Publish Application'
            inputs:
              command: 'publish'
              publishWebProjects: false
              projects: $(projectPath)
              arguments: '--configuration $(buildConfiguration) --output $(Build.ArtifactStagingDirectory)'
              zipAfterPublish: true
          
          - task: PublishBuildArtifacts@1
            displayName: 'Publish Build Artifacts'
            inputs:
              pathToPublish: '$(Build.ArtifactStagingDirectory)'
              artifactName: 'drop'
              publishLocation: 'Container'

  # ========================================
  # STAGE 2: Security Scan
  # ========================================
  - stage: SecurityScan
    displayName: 'Security Analysis'
    dependsOn: Build
    condition: succeeded()
    jobs:
      - job: SecurityJob
        displayName: 'Dependency & Container Scan'
        pool:
          vmImage: 'ubuntu-latest'
        
        steps:
          # 1. Checkout Code
          - checkout: self
          
          # 2. Dependency Check
          - task: dependency-check-build-task@6
            displayName: 'OWASP Dependency Check'
            inputs:
              projectName: 'SmartServe API'
              scanPath: '$(Build.SourcesDirectory)'
              format: 'HTML,JSON'
              failOnCVSS: '7'
          
          # 3. Whitesource Bolt (Vulnerabilidades)
          - task: WhiteSource@21
            displayName: 'WhiteSource Security Scan'
            inputs:
              cwd: '$(Build.SourcesDirectory)'
          
          # 4. Publish Security Report
          - task: PublishBuildArtifacts@1
            displayName: 'Publish Security Reports'
            inputs:
              pathToPublish: '$(Build.SourcesDirectory)/dependency-check-report'
              artifactName: 'SecurityReports'

  # ========================================
  # STAGE 3: Build Docker Image
  # ========================================
  - stage: Docker
    displayName: 'Build & Push Docker Image'
    dependsOn: SecurityScan
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - job: DockerJob
        displayName: 'Docker Build & Push'
        pool:
          vmImage: 'ubuntu-latest'
        
        steps:
          # 1. Build Docker Image
          - task: Docker@2
            displayName: 'Build Docker Image'
            inputs:
              containerRegistry: $(dockerRegistryServiceConnection)
              repository: $(imageRepository)
              command: 'build'
              Dockerfile: $(dockerfilePath)
              tags: |
                $(tag)
                latest
              arguments: '--build-arg BUILD_CONFIGURATION=$(buildConfiguration)'
          
          # 2. Scan Docker Image (Trivy)
          - task: CmdLine@2
            displayName: 'Scan Image with Trivy'
            inputs:
              script: |
                docker run --rm \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                  aquasec/trivy image \
                  --severity HIGH,CRITICAL \
                  --exit-code 1 \
                  $(containerRegistry)/$(imageRepository):$(tag)
          
          # 3. Push to ACR
          - task: Docker@2
            displayName: 'Push to Azure Container Registry'
            inputs:
              containerRegistry: $(dockerRegistryServiceConnection)
              repository: $(imageRepository)
              command: 'push'
              tags: |
                $(tag)
                latest

  # ========================================
  # STAGE 4: Deploy to Staging
  # ========================================
  - stage: DeployStaging
    displayName: 'Deploy to Staging'
    dependsOn: Docker
    condition: succeeded()
    jobs:
      - deployment: DeployStaging
        displayName: 'Deploy to Staging Environment'
        environment: 'smartserve-staging'
        pool:
          vmImage: 'ubuntu-latest'
        strategy:
          runOnce:
            deploy:
              steps:
                # 1. Azure Login
                - task: AzureCLI@2
                  displayName: 'Azure CLI - Deploy to App Service'
                  inputs:
                    azureSubscription: $(azureSubscription)
                    scriptType: 'bash'
                    scriptLocation: 'inlineScript'
                    inlineScript: |
                      az webapp config container set \
                        --name $(appServiceName)-staging \
                        --resource-group $(resourceGroupName) \
                        --docker-custom-image-name $(containerRegistry)/$(imageRepository):$(tag) \
                        --docker-registry-server-url https://$(containerRegistry)
                      
                      az webapp restart \
                        --name $(appServiceName)-staging \
                        --resource-group $(resourceGroupName)
                
                # 2. Run Database Migrations
                - task: AzureCLI@2
                  displayName: 'Run EF Migrations'
                  inputs:
                    azureSubscription: $(azureSubscription)
                    scriptType: 'bash'
                    scriptLocation: 'inlineScript'
                    inlineScript: |
                      az webapp exec \
                        --name $(appServiceName)-staging \
                        --resource-group $(resourceGroupName) \
                        --command "dotnet ef database update"
                
                # 3. Smoke Tests
                - task: PowerShell@2
                  displayName: 'Smoke Tests'
                  inputs:
                    targetType: 'inline'
                    script: |
                      $response = Invoke-WebRequest -Uri "https://$(appServiceName)-staging.azurewebsites.net/health" -Method Get
                      if ($response.StatusCode -ne 200) {
                        Write-Error "Health check failed!"
                        exit 1
                      }
                      Write-Host "Staging deployment successful!"

  # ========================================
  # STAGE 5: Deploy to Production
  # ========================================
  - stage: DeployProduction
    displayName: 'Deploy to Production'
    dependsOn: DeployStaging
    condition: succeeded()
    jobs:
      - deployment: DeployProduction
        displayName: 'Deploy to Production Environment'
        environment: 'smartserve-production'
        pool:
          vmImage: 'ubuntu-latest'
        strategy:
          runOnce:
            deploy:
              steps:
                # 1. Manual Approval (configurado no Environment)
                
                # 2. Blue-Green Deployment
                - task: AzureWebAppContainer@1
                  displayName: 'Deploy to Production Slot'
                  inputs:
                    azureSubscription: $(azureSubscription)
                    appName: $(appServiceName)
                    deployToSlotOrASE: true
                    resourceGroupName: $(resourceGroupName)
                    slotName: 'staging-slot'
                    containers: '$(containerRegistry)/$(imageRepository):$(tag)'
                
                # 3. Warm-up
                - task: PowerShell@2
                  displayName: 'Warm-up Staging Slot'
                  inputs:
                    targetType: 'inline'
                    script: |
                      Start-Sleep -Seconds 30
                      Invoke-WebRequest -Uri "https://$(appServiceName)-staging-slot.azurewebsites.net/health"
                
                # 4. Swap Slots
                - task: AzureAppServiceManage@0
                  displayName: 'Swap Slots (Blue-Green)'
                  inputs:
                    azureSubscription: $(azureSubscription)
                    action: 'Swap Slots'
                    webAppName: $(appServiceName)
                    resourceGroupName: $(resourceGroupName)
                    sourceSlot: 'staging-slot'
                    targetSlot: 'production'
                
                # 5. Health Check Production
                - task: PowerShell@2
                  displayName: 'Production Health Check'
                  inputs:
                    targetType: 'inline'
                    script: |
                      $maxAttempts = 5
                      $attempt = 0
                      $success = $false
                      
                      while ($attempt -lt $maxAttempts -and !$success) {
                        try {
                          $response = Invoke-WebRequest -Uri "https://$(appServiceName).azurewebsites.net/health" -Method Get
                          if ($response.StatusCode -eq 200) {
                            $success = $true
                            Write-Host "Production deployment successful!"
                          }
                        } catch {
                          $attempt++
                          Write-Host "Attempt $attempt failed, retrying..."
                          Start-Sleep -Seconds 10
                        }
                      }
                      
                      if (!$success) {
                        Write-Error "Production health check failed after $maxAttempts attempts!"
                        exit 1
                      }
                
                # 6. Notificar Equipe
                - task: PowerShell@2
                  displayName: 'Send Deployment Notification'
                  inputs:
                    targetType: 'inline'
                    script: |
                      # Enviar para Slack/Teams/Email
                      Write-Host "📦 SmartServe API v$(tag) deployed to production!"
```

## Variáveis no Azure DevOps

### Library (Variable Groups)

**Grupo: SmartServe-Production**
```
DB_CONNECTION_STRING: (secret)
REDIS_CONNECTION: (secret)
RABBITMQ_CONNECTION: (secret)
JWT_SECRET: (secret)
AZURE_STORAGE_CONNECTION: (secret)
```

### Pipeline Variables
```yaml
variables:
  - group: SmartServe-Production
  - name: buildConfiguration
    value: 'Release'
```

## Service Connections

### 1. Azure Resource Manager
- **Name:** SmartServe-Production
- **Subscription:** Azure Subscription
- **Type:** Service Principal

### 2. Docker Registry
- **Name:** SmartServeACR
- **Registry:** smartserve.azurecr.io
- **Type:** Azure Container Registry

### 3. SonarCloud
- **Name:** SonarCloud-SmartServe
- **Token:** (Personal Access Token)

## Environments

### Staging
- **Name:** smartserve-staging
- **Approvers:** Não requer aprovação
- **Checks:** Health check automático

### Production
- **Name:** smartserve-production
- **Approvers:** Tech Lead + Product Owner
- **Checks:** 
  - Manual approval
  - Business hours gate
  - Staging deployment successful

## Notifications

### Configure no Azure DevOps

**Slack Integration:**
```yaml
- task: SlackNotification@1
  inputs:
    SlackApiToken: $(SLACK_TOKEN)
    MessageAuthor: 'Azure DevOps'
    Channel: '#deployments'
    Message: |
      ✅ SmartServe API deployed to production
      Version: $(tag)
      Commit: $(Build.SourceVersion)
```

**Microsoft Teams:**
```yaml
- task: PowerShell@2
  inputs:
    targetType: 'inline'
    script: |
      $body = @{
        text = "SmartServe API v$(tag) deployed successfully!"
      } | ConvertTo-Json
      
      Invoke-RestMethod -Uri "$(TEAMS_WEBHOOK)" -Method Post -Body $body -ContentType 'application/json'
```

## Rollback Strategy

### Manual Rollback
```bash
# Reverter para versão anterior
az webapp config container set \
  --name smartserve-api-prod \
  --resource-group smartserve-rg \
  --docker-custom-image-name smartserve.azurecr.io/smartserve-api:previous-tag
```

### Automatic Rollback (com Health Check)
```yaml
- task: PowerShell@2
  displayName: 'Auto Rollback on Failure'
  condition: failed()
  inputs:
    targetType: 'inline'
    script: |
      Write-Host "Deployment failed, rolling back..."
      az webapp config container set `
        --name $(appServiceName) `
        --resource-group $(resourceGroupName) `
        --docker-custom-image-name $(containerRegistry)/$(imageRepository):$(previousTag)
```

## Monitoramento Pós-Deploy

### Application Insights
```yaml
- task: AzureCLI@2
  displayName: 'Create Deployment Annotation'
  inputs:
    azureSubscription: $(azureSubscription)
    scriptType: 'bash'
    scriptLocation: 'inlineScript'
    inlineScript: |
      az resource create \
        --resource-group $(resourceGroupName) \
        --resource-type "Microsoft.Insights/annotations" \
        --name "deployment-$(Build.BuildId)" \
        --properties "{'AnnotationName':'Deployment','Category':'Deployment','EventTime':'$(Build.FinishTime)'}"
```

## Checklist

- [ ] Pipeline YAML criado
- [ ] Service connections configurados
- [ ] Variable groups criados
- [ ] Environments definidos (Staging, Production)
- [ ] Approvals configurados
- [ ] SonarCloud integrado
- [ ] Security scans habilitados
- [ ] Docker build otimizado
- [ ] Health checks implementados
- [ ] Rollback strategy definida
- [ ] Notifications configuradas
- [ ] Monitoring integrado

## Exemplo de Uso

```
@workspace Use o prompt .github/prompts/devops/azure-pipeline.prompt.md 
para criar um pipeline completo de CI/CD com deploy automatizado para Azure
```

## Comandos Úteis Azure CLI

```bash
# Listar pipelines
az pipelines list --organization https://dev.azure.com/yourorg --project SmartServe

# Executar pipeline
az pipelines run --name "SmartServe-API-CI-CD" --organization https://dev.azure.com/yourorg --project SmartServe

# Ver runs
az pipelines runs list --organization https://dev.azure.com/yourorg --project SmartServe

# Criar service connection
az devops service-endpoint azurerm create --organization https://dev.azure.com/yourorg --project SmartServe
```

