#!/bin/bash

set -e

echo "🚀 Setting up dotfiles development environment..."

# Run the main install script
bash /workspaces/$(basename $PWD)/install.sh

echo "✅ Setup complete!"