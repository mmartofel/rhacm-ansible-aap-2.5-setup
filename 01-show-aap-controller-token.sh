#!/bin/bash

# This script shows the Ansible Application Platform (AAP) instance details.

set -e  # Exit on error

export PYTHONWARNINGS="ignore::UserWarning:awxkit.cli.client"
export AWXKIT_API_BASE_PATH=/api/controller/

# Set your Python virtual environment path
if [ ! -d "./venv" ]; then
  # If the virtual environment does not exist, prompt the user to run the setup script
  echo
  echo "🧹 You don't have required venv, Please run 00-setup-awx-cli.sh first"
  echo
  exit 1
else
  # Activate the existing virtual environment
  echo
  echo "🌀 Activating existing virtual environment..."
  source ./venv/bin/activate
fi
echo "🐍 Python version: $(python -V)"
echo "🛠️  AWX version: $(awx --version)"

# echo "🌀 At your aap namespace you have the following routes presented:"
# oc get routes -o custom-columns=NAME:.metadata.name,PATH:.spec.host -n aap

# Dynamically set AAP_API_BASE_PATH to the dev-controller route
AAP_API_HOST=$(oc get routes -o custom-columns=NAME:.metadata.name,PATH:.spec.host -n aap | awk '$1=="dev"{print $2}')
export AAP_API_BASE_PATH="https://$AAP_API_HOST"
echo "🌐 AAP API host URL: $AAP_API_BASE_PATH"
# Get AAP admin password from the secret
echo "🔑 Retrieving AAP admin password from secret 'dev-admin-password' ..."
export ADMIN_PASSWORD=`oc get secret dev-admin-password -o jsonpath='{.data.password}' -n aap | base64 -d`
echo "🔑 AAP admin password: $ADMIN_PASSWORD"

echo "✅ Done! Controller API token retrieved successfully."
AWX_LOGIN_OUTPUT=$(awx --conf.host $AAP_API_BASE_PATH \
    --conf.username admin \
    --conf.password $ADMIN_PASSWORD \
    -k login)
echo $AWX_LOGIN_OUTPUT

# Get the AAP controller host from the route
AAP_CONTROLLER_HOST=$(oc get routes -o custom-columns=NAME:.metadata.name,PATH:.spec.host -n aap | awk '$1=="dev-controller"{print $2}')
# Get the token from the awx login command
AAP_CONTROLLER_TOKEN=$(echo "$AWX_LOGIN_OUTPUT" | jq -r '.token')

echo
echo "Now you are ready to create new Red Hat Ansible Automation Platform credentials in your"
echo "Red Hat Advanced Cluster Management for Kubernetes."
echo "Please use the following details to configure your AAP credentials in RHACM:"
echo
echo "Ansible Tower host: https://$AAP_CONTROLLER_HOST"
echo "Ansible Tower token: $AAP_CONTROLLER_TOKEN"
echo
echo "✅ Done!"
echo