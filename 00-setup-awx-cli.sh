#!/bin/bash

# Than script sets up the AWX CLI (awxkit) in a Python 3.11 virtual environment.
# It installs Python 3.11 via Homebrew if not already installed, creates a virtual environment,
# and installs the AWX CLI tool.
# It's designed to be run on macOS, for other systems, you may need to adjust the Python installation command.

export PYTHONWARNINGS="ignore::UserWarning:awxkit.cli.client"

set -e  # Exit on error
echo "🔧 Installing Python 3.11 via Homebrew (if not already installed)..."
brew install python@3.11 || true

echo "🧹 Cleaning up existing virtual environment..."
rm -rf ./venv

echo "🌀 Creating a new Python 3.11 virtual environment..."
python3.11 -m venv ./venv
source ./venv/bin/activate

echo "⬆️ Installing awxkit..."
pip install --upgrade pip
pip install awxkit

echo "✅ Done!"
echo "🐍 Python version: $(python -V)"
echo "🛠️  AWX version: $(awx --version)"

