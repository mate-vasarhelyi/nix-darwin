#!/bin/bash

# Nix-Darwin Clean Installation Script
# Run this on a fresh macOS installation

set -e

echo "🚀 Starting Nix-Darwin Clean Installation..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script is only for macOS${NC}"
    exit 1
fi

# Check if mate user already exists
if id "mate" &>/dev/null; then
    echo -e "${YELLOW}⚠️  User 'mate' already exists${NC}"
else
    echo -e "${GREEN}👤 Creating mate user...${NC}"
    sudo sysadminctl -addUser mate -fullName "mate" -password - -admin
fi

# Check if Nix is already installed
if command -v nix &> /dev/null; then
    echo -e "${YELLOW}⚠️  Nix is already installed${NC}"
else
    echo -e "${GREEN}📦 Installing Nix...${NC}"
    curl -L https://nixos.org/nix/install | sh
    
    # Source Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
fi

# Clone nix-darwin if not already present
if [ -d "/Users/mate/nix-darwin" ]; then
    echo -e "${YELLOW}⚠️  Nix-darwin already exist at /Users/mate/nix-darwin${NC}"
else
    echo -e "${GREEN}📁 Cloning nix-darwin...${NC}"
    sudo -u mate git clone https://github.com/mate-vasarhelyi/nix-darwin.git /Users/mate/nix-darwin
    sudo chown -R mate:staff /Users/mate/nix-darwin
fi

echo -e "${GREEN}⚙️  Applying nix-darwin configuration...${NC}"
cd /Users/mate/nix-darwin
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#mates-macbook

echo -e "${GREEN}✅ Installation complete!${NC}"
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Log out and log in as the 'mate' user"
echo "2. Open a new terminal to verify Fish shell is working"
echo "3. Test your development environment with: go version, mise --version"
echo "4. Enjoy your declaratively configured macOS! 🎉" 