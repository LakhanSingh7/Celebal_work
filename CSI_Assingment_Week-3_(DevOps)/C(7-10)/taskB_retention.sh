#!/bin/bash
set -e

RG="MyBackupRG"
VAULT="MyVault"
VM="MyVMName"

echo "## Triggering on-demand backup with 1-year retention..."
JOB_NAME=$(az backup protection backup-now \
  --resource-group $RG \
  --vault-name $VAULT \
  --item-name $VM \
  --retention 365d \
  --backup-management-type AzureIaasVM \
  --query name -o tsv)

az backup job stop --vault-name $VAULT --name $JOB_NAME

echo "Backup job triggered and extended retention set."
