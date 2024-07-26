#!/usr/bin/env bash

REPO_DIR="/home/rew/_"
HARDWARE_CONF="/etc/nixos/hardware-configuration.nix"

check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

cd $REPO_DIR || { echo "Error: Unable to change to $REPO_DIR"; exit 1; }

echo "Forcefully pulling latest changes from git..."
git fetch origin
git reset --hard origin/main  
check_status "Failed to pull changes from git"

echo "Copying hardware configuration..."
sudo cp $HARDWARE_CONF ./hosts/bones/
check_status "Failed to copy hardware configuration"

echo "Adding changes to git..."
git add .
check_status "Failed to add changes to git"

echo "Switching to new configuration using flake..."
sudo nixos-rebuild switch --flake .#bones --option eval-cache false --show-trace --verbose
check_status "Failed to switch to new configuration"

echo "Development update completed successfully!"
