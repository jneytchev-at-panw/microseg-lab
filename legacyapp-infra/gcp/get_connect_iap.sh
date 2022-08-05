#!/bin/bash
#set -ex
# Get gcp ssh through IaP connection commands for all instances

prj=$(terraform output -raw project)

for i in {1..3}; do
  name=$(terraform output -raw vm${i}_name)
  zone=$(terraform output -raw vm${i}_zone)
  echo "gcloud compute ssh --zone $zone $name --tunnel-through-iap --project $prj"
done
