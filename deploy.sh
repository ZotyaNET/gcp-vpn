#!/bin/bash
if [ -z "$1" ]
  then
    echo "Specify the name of deployment as an argument .e.g.  deploy.sh vpn-1"
    exit 1
fi
export deploymentname=$1

# Get the first PROJECT_ID from the list
PROJECT_ID=$(gcloud projects list --format="value(PROJECT_ID)" | head -n 1)
echo "Setting project to $PROJECT_ID..."
gcloud config set project "$PROJECT_ID"
gcloud deployment-manager deployments create  $deploymentname --config main.vpn.yaml
echo "$deploymentname was deployed."
sleep 5
export staticip="`gcloud compute instances describe $deploymentname | grep -Po 'natIP: \K(.*)'`"
if [[ ! -z "$staticip" ]]; then
    echo 'Congratulations! VPN deployment is completed.'
    echo 'Now, do DNS mapping with static IP:' $staticip
    echo 'then, run change-domain.sh via ssh'
fi
