# Azure Practice training - Azure DevOps Agent Pool

## Overview

1. Scripted deployment of a minimal Terraform bootstrap
1. Create Azure Container Registry with an agent pool image
1. Create an Azure DevOps agent pool
1. Install a Terraform extension to an Azure DevOps organization
1. Create a new project
1. Bootstrap a new managed identity and pipeline using OpenID Connect

## Bootstrap

In _00 Scripted minimal bootstrap_

1. Run bootstrap.sh

Creates storage account with Blob Contributor and generates two files, backend.auto.tfvars and backend.tf. Empty key name.

TODO, merge in backend.data.tf and backend.variables.tf. Make unique.

## Azure Container Registry

In _01 Azure Container Registry_

1. Copy in the backend files and set `terraform_state_key = "acr"`
1. Run terraform init and apply

Review

- Source repo, <https://github.com/richeney/azure_devops_agent>
- terraform state file in storage account
- ACR image, tag and task

## Agent Pool

In _02 Agent Pool_

1. Copy in the backend files and set `terraform_state_key = "acr"`
1. Create a terraform.tfvars file, e.g.

    ```ruby
    agent_pool_name                    = "agent-pool"
    azure_devops_organization_name     = "RichardCheney"
    azure_devops_personal_access_token = "redacted"
    azure_devops_agents_token          = "redacted"
    container_registry_name            = "terraformacr19e058"
    ```

1. Run terraform init and apply

### Generate a token for the agents

1. <https://dev.azure.com>
1. Click the __User settings__ icon in the top right
1. Select __Personal access tokens__
1. Click __+ New Token__
1. Set __Name__, e.g. _Agent Pool_
1. Max the __Expiration__ to 365 days
1. Set __Scopes__ to _Agent Pools: Read & manage_
1. __Create__
1. Copy the token and save it somewhere safe
1. Close

### Create a personal access token

This is short-lived and is only needed for the duration of the bootstrap itself. Once the bootstrap is completed then you may revoke the token.

1. You should still be logged into [dev.azure.com](https://dev.azure.com)
1. Click the `User settings` icon in the top right and select `Personal access tokens`.
1. Click `+ New Token`.
1. Populate the `Name` field.
1. Reduce down the `Expiration` with a custom defined expiration or leave at 30d
1. Select Scopes = `Full access`, or be more selective and set to:
    - Agent Pools: Read & manage
    - Build: Read & execute
    - Code: Full
    - Environment: Read & manage
    - Graph: Read & manage
    - Pipeline Resources: Use & manage
    - Project and Team: Read, write & manage
    - Service Connections: Read, query & manage
    - Variable Groups: Read, create & manage
1. Click `Create`.
1. Copy the token and save it somewhere safe.
1. Click `Close`.

### Agent Pool

In _02 Agent Pool_

1. Copy in the backend files and set `terraform_state_key = "agent-pool"`
1. Create a terraform.tfvars, e.g.:

    ```ruby
    azure_devops_organization_name = "RichardCheney"
    azure_devops_agents_token      = "my_agent_token"
    ```

1. Run terraform init and apply

### Install the extension

This is a one off task per organisation.

1. Go to <https://dev.azure.com/>
1. Select your organization on the left hand side
1. Click on the Marketplace icon at the top right
1. Browse marketplace
1. Install the Terraform extension by Microsoft DevLabs

The source code for this extension is <https://github.com/microsoft/azure-pipelines-terraform>. The extension provides both TerraformInstaller@1 and TerraformTaskV4@4 which are used in the example pipelines.

## Create a new repo

1. Go to <https://dev.azure.com/>
1. Select your organization on the left hand side
1. Click on __+ New project__
1. Add a project name and description
1. Set visibility to Private
1. Click on __Create__
1. Click on Repos > Files
1. Click on Initialize main branch with README checked, plus a Terraform .gitignore



## Create a second personal access token for the private runners

This is the token used by the container instances. Only required if setting `azure_devops_self_hosted_agents = true`.

Same process as above except:
    - Set expiration to one year
    - Set scope to Agent Pools: Read & manage

Use the resulting token value for the azure_devops_agents_token variable.

## Create a terraform.tfvars

Example file:

```shell
subscription_id = "abcdef01-2345-6789-abcd-314159265359"

azure_devops_organization_name     = "RichardCheney"
azure_devops_project_name          = "terraform-bootstrap-devops-test"
azure_devops_personal_access_token = "redacted"
azure_devops_create_pipeline       = true
azure_devops_create_files          = true
azure_devops_self_hosted_agents    = true
azure_devops_agents_token          = true
```

Additional variables may be found in variables.tf.

## Known issues

- The network rules on the storage account adds your current public IP address to ensure that the bootstrap terraform commands will work. Fully private will cause an error. If your public IP changes then you may need to update it via the portal / CLI for terraform plan / apply to work.
- Destroy will fail for the service endpoint as the federated credential deletion does not propagate in time. Rerun the delete.
- Destroy does not remove the environment, despite indicating that it has. Remove manually in the portal.

## Suggestion

This bootstrap is getting large and worth preserving state. Suggest we revert to a minimal scripted bootstrap.sh for the rg and sa - incl RBAC for Blob - and create an auto.tfvars. Then use Terraform to bootstrap the CI/CD environment with a remote state.
