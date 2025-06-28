# Red Hat Ansible Automation Platform (AAP) 2.5 integration with Red Hat Advanced Cluster Management for Kubernetes

This repository helps you quickly set up the AWX CLI (`awxkit`) in a Python 3.11 virtual environment and retrieve your AAP Controller API token for use with Red Hat Advanced Cluster Management (RHACM). It's a required step to create AAP credentials at RHACM.
There are several importent changes with API provided by AAP 2.4 and 2.5 . Following steps apply to 2.5 only.
In addition to that it's handy to have awx CLI configured and ready to interact with your AAP 2.5 .

## Prerequisites

- **macOS** (for other OS, adjust Python install steps)
- [Homebrew](https://brew.sh/) installed
- Access to an Red Hat OpenShift cluster with AAP 2.5 deployed (in form of an operator)
- `oc` CLI installed and logged in
- `jq` installed (`brew install jq`)

## Setup Instructions

### 1. Install and Configure AWX CLI

Run the setup script to install Python 3.11 (Python 3.13 causes troubles for awx cli), create a virtual environment, and install AWX CLI:

```bash
./00-setup-awx-cli.sh
```

This will:
- Install Python 3.11 (if not already present)
- Create a fresh `venv` directory
- Install `awxkit` in the virtual environment

### 2. Retrieve Your AAP Controller API Token and AAP Controller host URL

Run the following script to activate the virtual environment, detect your AAP Controller route, and retrieve your API token:

```bash
./01-show-aap-controller-token.sh
```

This script will:
- Activate the Python virtual environment
- Show your Python and AWX CLI versions
- Detect the `dev-controller` route in your AAP namespace
- Retrieve the AAP admin password from the `dev-admin-password` secret
- Log in to the AAP Controller and display your API token

**Sample Output:**
```
Ansible Tower host: https://dev-controller-aap.apps.example.com
Ansible Tower token: <your-api-token>
```

Use these details to configure your AAP credentials in RHACM.

## Notes

- The `venv/` directory is git-ignored and should not be committed.
- If you need to setup or reset your environment, simply re-run `00-setup-awx-cli.sh`.
- If you encounter issues, ensure your `oc` context is set to the correct RHACM hub cluster and namespace.

## Troubleshooting

- **Missing `jq`**: Install with `brew install jq`
- **Python 3.11 not found**: Ensure Homebrew is installed and in your PATH
- **oc not logged in**: Run `oc login` to authenticate to your OpenShift cluster

---

Enjoy automating with AAP and RHACM!
