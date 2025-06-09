1. Creating an Azure Entra ID Tenant

2. Creating Test Users & Groups
   
   az ad user create \
  --display-name "Test User" \
  --user-principal-name testuser@<yourTenant>.onmicrosoft.com \
  --password "P@ssword123!"

   az ad group create \
  --display-name "TestGroup" \
  --mail-nickname "testgroup"


  az ad group member add \
  --group "$(az ad group show --group TestGroup --query objectId --output    tsv)" \
  --member-id "$(az ad user show --id testuser@... --query objectId --output tsv)"

3. Assiging a Built-In RBAC Role

   az role assignment create \
     --assignee testuser@<...> \
     --role "Reader" \
     --scope /subscriptions/<SubscriptionID>

4. Creating & Assiging a Custom Azure RBAC Role
    
 A)  (json file) 

  {
  "Name": "Custom VM Operator",
  "Description": "Read all compute info; restart VMs",
  "Actions": [
    "Microsoft.Compute/*/read",
    "Microsoft.Compute/virtualMachines/start/action",
    "Microsoft.Compute/virtualMachines/restart/action"
  ],
  "AssignableScopes": [
    "/subscriptions/<SubscriptionID>"
  ],
  "NotActions": [],
  "DataActions": [],
  "NotDataActions": []
}

B)  az role definition create --role-definition @vm-operator-role.json

C) az role definition list \
  --name "Custom VM Operator" \
  --output json
D) az role assignment create \
  --assignee testuser@<...> \
  --role "Custom VM Operator" \
  --scope /subscriptions/<SubscriptionID>
E) Testing

5. Creating Custom Microsoft Entra Role
