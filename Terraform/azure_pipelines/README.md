# Azure DevOps Pipeline Creation with Terraform

This guide provides instructions on how to use Terraform to automate the creation of Azure DevOps pipelines based on YAML definitions.

## Prerequisites

Before you begin, make sure you have the following:

- An Azure DevOps organization and the permissions to create and manage build pipelines.
- The Terraform CLI installed on your local machine.
- A Personal Access Token (PAT) from Azure DevOps with appropriate permissions.

## Configuration Files

This setup uses two YAML configuration files to define the project settings and build definitions:

- project.yaml: Contains common settings for all pipelines.
- variables.yaml: Contains definitions for each build pipeline.

### Project Configuration (project.yaml)

The project.yaml file includes the following properties:

- agent_pool_name: The name of the agent pool that will be used for builds.
- project_id: The unique identifier of the Azure DevOps project.
- repo_type: The type of repository (e.g., 'Azure Repos', 'GitHub').
- service_connection_id: The service connection ID to the repository.
- yml_path: The path to the YAML pipeline definition file within the repository.

Example:
```yaml
agent_pool_name: "Default"
project_id: "abcd1234-abcd-1234-abcd-1234abcd1234"
repo_type: "GitHub"
service_connection_id: "abcd1234-abcd-1234-abcd-1234abcd1234"
yml_path: "/azure-pipelines.yml" 
```

### Variables Configuration (variables.yaml)
The variables.yaml file defines build pipelines with specific settings.

Example:
```yaml
build_definitions:
  build1:
    ci_trigger_exclude_branches: [] # List of branches to exclude from CI triggers
    pull_request_trigger_use_yaml: true # Use YAML configuration for pull request triggers
    pull_request_trigger_forks_enabled: false # Enable PR triggers for forks
    pull_request_trigger_forks_share_secrets: false # Share secrets with PR triggers from forks
    pipeline_name: "MyPipeline"
    pipeline_folder: "\\MyPipelines"
    repo: "my-repo-name"
    branch_name: "main"
    ci_trigger: ["feature/*", "main"]
```

### Terraform Module
The Terraform module definitions is used to create each build pipeline as defined in variables.yaml.

Example:
```yaml
module "definitions" {
  source = "./modules"
  for_each = local.build_definitions["build_definitions"]
  
  # Common settings (from project.yaml)
  agent_pool_name       = local.project.agent_pool_name
  project_id            = local.project.project_id
  repo_type             = local.project.repo_type
  service_connection_id = local.project.service_connection_id
  yml_path              = local.project.yml_path

  # Pipeline-specific settings (from variables.yaml)
  ci_trigger_exclude_branches = each.value.ci_trigger_exclude_branches
  pull_request_trigger_use_yaml            = each.value.pull_request_trigger_use_yaml
  pull_request_trigger_forks_enabled       = each.value.pull_request_trigger_forks_enabled
  pull_request_trigger_forks_share_secrets = each.value.pull_request_trigger_forks_share_secrets
  name                        = each.value.pipeline_name
  path                        = each.value.pipeline_folder
  repo_id                     = each.value.repo
  branch_name                 = each.value.branch_name
  ci_trigger_include_branches = each.value.ci_trigger
}
```

### Pipeline template
The pipeline template explains how this entire folder will be execute.

Example:
```yaml
parameters:
  - name: environment
    displayName: Environment
    default: dev
    # do NOT change these values, they are used internally on "if" conditions
    values: ['dev']

trigger: none

resources:
  repositories:
    - repository: insertValue
      type: bitbucket
      endpoint: insertValue
      name: insertValue
      ref: insertValue

stages:
  - stage: Terraform
    variables:
      - group: azure_pipelines_terraform
    pool:
      vmImage: 'ubuntu-22.04'
    jobs:
    - job: Terraform_state
      workspace:
        clean: all
      steps:
        - checkout: insertValue
        - checkout: self
          persistCredentials: true

        - task: AzureCLI@2
          inputs:
            azureSubscription: insertValue
            scriptType: 'bash'
            scriptLocation: 'inlineScript'
            inlineScript: |
              export AZDO_ORG_SERVICE_URL=${AZUREDEVOPS_PROVIDER_DEVOPS_URL}
              export AZDO_PERSONAL_ACCESS_TOKEN=${AZUREDEVOPS_PROVIDER_PERSONAL_ACCESS_TOKEN}
              export ARM_ACCESS_KEY=${AZURERM_BACKEND_ACCESS_KEY}
              cd $(Build.SourcesDirectory)/insertValue

              terraform init
              terraform plan
              terraform apply -auto-approve
```

### Manual deploy
Initialization and Application
To create the Azure DevOps pipelines, follow these steps:

Open a terminal and navigate to the directory containing your Terraform configuration.
Initialize Terraform with the command terraform init.
Apply the configuration with the command terraform apply.
You will need to provide your Azure DevOps Personal Access Token either through environment variables or by input when prompted by Terraform.