#!/bin/bash

# This script shows the Ansible Application Platform (AAP) instance details.

set -e  # Exit on error

export PYTHONWARNINGS="ignore::UserWarning:awxkit.cli.client"
export AWXKIT_API_BASE_PATH=/api/controller/

# Set your Python virtual environment path
if [ ! -d "./venv" ]; then
  echo "🧹 You don't have required venv, Please run 00-setup-awx-cli.sh first"
  exit 1
else
  echo "🌀 Activating existing virtual environment..."
  source ./venv/bin/activate
fi
echo "🐍 Python version: $(python -V)"
echo "🛠️ AWX version: $(awx --version)"


echo "🌀 At your aap namespace you have the following routes presented:"
oc get routes -o custom-columns=NAME:.metadata.name,PATH:.spec.host -n aap

export AAP_API_BASE_PATH='https://dev-aap.apps.zenek.sandbox2401.opentlc.com'
export ADMIN_PASSWORD=`oc get secret dev-admin-password -o jsonpath='{.data.password}' -n aap | base64 -d`

echo "✅ Done! Copy over your Controller API token from an output shown below."
awx --conf.host $AAP_API_BASE_PATH \
    --conf.username admin \
    --conf.password $ADMIN_PASSWORD \
  -k login
