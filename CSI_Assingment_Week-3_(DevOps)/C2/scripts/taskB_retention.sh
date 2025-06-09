#!/bin/bash
set -e

RG="MyBackupRG"
VAULT="MyVault"
VM="MyVMName"

echo "5️⃣ Triggering 1‑year retention backup..."
JOB_NAME=$(az backup protection backup-now \
  --resource-group $RG \
  --vault-name $VAULT \
  --item-name $VM \
  --retention 365d \
  --backup-management-type AzureIaasVM \
  --query name -o tsv)

az backup job stop --vault-name $VAULT --name "$JOB_NAME"

echo "✅ On‑demand backup triggered with extended retention."
