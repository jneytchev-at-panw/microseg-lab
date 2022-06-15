#!/bin/bash
#set -ex

# Format an azure cli bastion ssh connect command

rg=$(terraform output --raw resource_group_name)
bname=$(terraform output --raw bastion_name)

for id in $(az vmss list-instances -g jneytchev-lab-rg -n jneytchev-lab-vmss1 | jq -r .[].id); do
    echo "az network bastion ssh --name ${bname} --resource-group ${rg} --target-resource-id ${id} --auth-type ssh-key --username ubuntu --ssh-key ~/.ssh/id_rsa"
done
