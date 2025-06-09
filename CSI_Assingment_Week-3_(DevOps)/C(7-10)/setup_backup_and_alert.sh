#!/bin/bash
set -e

RG="C7MyBackupRG"
LOCATION="eastus"
VAULT="C7MyVault"
POLICY="Daily3AMPolicy"
VM="C7VM"
EMAIL="tusharkhurana0704@gmail.com"

echo "## Creating resource group and vault..."
az group create -n $RG -l $LOCATION
az backup vault create -g $RG -n $VAULT

echo "## Creating backup policy..."
az backup policy set \
  --vault-name $VAULT \
  --resource-group $RG \
  --name $POLICY \
  --workload-type VM \
  --backup-management-type AzureIaasVM \
  --schedule-frequency Daily \
  --schedule-time 03:00 \
  --retention-daily 30

echo "## Enabling VM protection..."
az backup protection enable-for-vm \
  --vault-name $VAULT \
  --resource-group $RG \
  --vm $VM \
  --policy-name $POLICY

echo "## Configuring email alert for CPU > 80%..."
AGID=$(az monitor action-group create \
  --resource-group $RG \
  --name MyEmailAG \
  --action email AdminEmail $EMAIL \
  --query id -o tsv)

VMID=$(az vm show -g $RG -n $VM --query id -o tsv)

az monitor metrics alert create \
  -g $RG \
  -n "HighCPUAlert" \
  --scopes $VMID \
  --condition "avg Percentage CPU > 80" \
  --action $AGID \
  --description "Alert: CPU usage above 80%"

