#!/bin/bash

# Step 1: Login to Azure
az login

# Variables
RG="MyDemoRG"
LOCATION="eastus"
VNET="MyVNet"
SUBNET="MySubnet"
PIP="MyPublicIP"
NSG="MyNSG"
VM="MyLinuxVM"

# Step 2: Create Resource Group
az group create --name $RG --location $LOCATION

# Step 3: Create Virtual Network with Subnet
az network vnet create \
  --resource-group $RG \
  --name $VNET \
  --address-prefixes 10.0.0.0/16 \
  --subnet-name $SUBNET \
  --subnet-prefixes 10.0.1.0/24

# Step 4: Create Public IP
az network public-ip create \
  --resource-group $RG \
  --name $PIP \
  --allocation-method Dynamic

# Step 5: Create Network Security Group (NSG)
az network nsg create --resource-group $RG --name $NSG

# Step 6: Create NSG Rule to Allow SSH
az network nsg rule create \
  --resource-group $RG \
  --nsg-name $NSG \
  --name AllowSSH \
  --protocol tcp --priority 1000 \
  --destination-port-range 22 --access allow

# Step 7: Deploy Virtual Machine in the VNet
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

# Step 8: Verify Virtual Network
az network vnet show --resource-group $RG --name $VNET --output table

# Step 9: Verify Virtual Machine
az vm show --resource-group $RG --name $VM --show-details --output table

