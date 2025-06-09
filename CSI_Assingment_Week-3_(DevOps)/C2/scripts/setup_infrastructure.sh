#!/bin/bash
set -e

# Variables
RG="MyDemoRG"
LOCATION="eastus"
VNET="MyVNet"
SUBNET="MySubnet"
PIP="MyPublicIP"
NSG="MyNSG"
VM="MyLinuxVM"

# 1. Create Resource Group
echo "Creating Resource Group..."
az group create --name $RG --location $LOCATION

# 2. Create Virtual Network with Subnet
echo "Creating Virtual Network and Subnet..."
az network vnet create \
  --resource-group $RG \
  --name $VNET \
  --address-prefixes 10.0.0.0/16 \
  --subnet-name $SUBNET \
  --subnet-prefixes 10.0.1.0/24

# 3. Create Public IP
echo "Creating Public IP..."
az network public-ip create \
  --resource-group $RG \
  --name $PIP \
  --allocation-method Dynamic

# 4. Create Network Security Group (NSG) and Rules
echo "Creating NSG and Rules..."
az network nsg create --resource-group $RG --name $NSG
az network nsg rule create \
  --resource-group $RG \
  --nsg-name $NSG \
  --name AllowSSH \
  --protocol tcp --priority 1000 \
  --destination-port-range 22 --access Allow

# 5. Deploy Virtual Machine
echo "Deploying Virtual Machine..."
az vm create \
  --resource-group $RG \
  --name $VM \
  --image Ubuntu2204 \
  --vnet-name $VNET \
  --subnet $SUBNET \
  --public-ip-address $PIP \
  --nsg $NSG \
  --admin-username azureuser \
  --generate-ssh-keys \
  --output json

# 6. Verify Resources
echo "Verifying Resources..."
az network vnet show --resource-group $RG --name $VNET --output table
az vm show --resource-group $RG --name $VM --show-details --output table

echo "Infrastructure setup completed successfully."
