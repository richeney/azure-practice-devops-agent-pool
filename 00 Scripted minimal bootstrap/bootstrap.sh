#!/bin/bash

error() {
    echo "Error: $1"
    exit 1
}

# Variables
RESOURCE_GROUP_NAME="terraform"
STORAGE_ACCOUNT_PREFIX="terraformbootstrap"
CONTAINER_NAME="bootstrap"
# KEY="terraform.tfstate"
KEY=""
LOCATION="uksouth"

# Get subscription ID
SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Get resource group ID and generate storage account name
RESOURCE_GROUP_ID=$(az group show --name $RESOURCE_GROUP_NAME --query id --output tsv)
STORAGE_ACCOUNT_NAME="${STORAGE_ACCOUNT_PREFIX}$(echo -n $RESOURCE_GROUP_ID | sha1sum | cut -c1-6)"
echo "Storage account name is $STORAGE_ACCOUNT_NAME"

# Create storage account
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION \
  --min-tls-version TLS1_2 --sku Standard_LRS --https-only true
az storage account blob-service-properties update --account-name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME \
  --enable-versioning --enable-delete-retention --delete-retention-days 1
STORAGE_ACCOUNT_ID=$(az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --query id --output tsv)

# Create storage container
echo "Creating storage container $CONTAINER_NAME"
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --auth-mode login

# Get the signed-in user's object ID
SIGNED_IN_USER_OBJECT_ID=$(az ad signed-in-user show --query id --output tsv)

# Set scope variable to storage account level or container level
SCOPE="$STORAGE_ACCOUNT_ID"
# SCOPE="$STORAGE_ACCOUNT_ID/blobServices/default/containers/$CONTAINER_NAME"

# Assign RBAC role for blob contributor to the container
az role assignment create --assignee $SIGNED_IN_USER_OBJECT_ID --role "Storage Blob Data Contributor" --scope $SCOPE

# Create backend configuration file
cat <<EOF > backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "$RESOURCE_GROUP_NAME"
    storage_account_name = "$STORAGE_ACCOUNT_NAME"
    container_name       = "$CONTAINER_NAME"
    key                  = "$KEY"
  }
}
EOF

# Create backend.auto.tfvars file
cat <<EOF > backend.auto.tfvars
subscription_id      = "$SUBSCRIPTION_ID"
resource_group_name  = "$RESOURCE_GROUP_NAME"
storage_account_name = "$STORAGE_ACCOUNT_NAME"
container_name       = "$CONTAINER_NAME"
terraform_state_key  = "$KEY"
EOF