#!/usr/bin/env bash

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Set script to exit on error
set -e

# Configuration
HOSTNAME="bones"  # Change this to match your hostname
DOTFILES_DIR="$HOME/crow"
HOST_DIR="$DOTFILES_DIR/hosts/$HOSTNAME"

# Print with colors
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    error "Please don't run as root. Script will use sudo when needed."
fi

# Ensure dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    error "Dotfiles directory not found at $DOTFILES_DIR"
fi

# Create host directory if it doesn't exist
if [ ! -d "$HOST_DIR" ]; then
    info "Creating host directory at $HOST_DIR"
    mkdir -p "$HOST_DIR"
fi

# Pull latest changes
info "Pulling latest changes from git repository..."
cd "$DOTFILES_DIR"
git pull || error "Failed to pull latest changes"

# Backup current hardware configuration if it exists
if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
    info "Backing up hardware configuration..."
    cp "/etc/nixos/hardware-configuration.nix" "$HOST_DIR/hardware-configuration.nix.backup"
    
    # Compare with existing hardware configuration
    if [ -f "$HOST_DIR/hardware-configuration.nix" ]; then
        if ! diff -q "/etc/nixos/hardware-configuration.nix" "$HOST_DIR/hardware-configuration.nix" >/dev/null; then
            warn "Hardware configuration has changed"
            info "Copying new hardware configuration..."
            cp "/etc/nixos/hardware-configuration.nix" "$HOST_DIR/hardware-configuration.nix"
        else
            info "Hardware configuration unchanged"
        fi
    else
        info "Copying hardware configuration for first time..."
        cp "/etc/nixos/hardware-configuration.nix" "$HOST_DIR/hardware-configuration.nix"
    fi
else
    error "No hardware configuration found at /etc/nixos/hardware-configuration.nix"
fi

# Rebuild NixOS
info "Rebuilding NixOS..."
sudo nixos-rebuild switch --flake "$DOTFILES_DIR#$HOSTNAME" || error "Failed to rebuild NixOS"

info "Successfully updated and rebuilt NixOS configuration!"
info "A backup of the hardware configuration is stored at: $HOST_DIR/hardware-configuration.nix.backup"
