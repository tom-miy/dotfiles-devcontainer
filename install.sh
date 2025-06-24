#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Installing dotfiles...${NC}"

# Check if chezmoi is installed
if ! command -v chezmoi &> /dev/null; then
    echo -e "${YELLOW}📦 Installing chezmoi...${NC}"
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
fi

# Determine if we're running from a cloned repository or via curl
if [ -f "$(dirname "$0")/home/dot_zshrc" ] && [ -f "$(dirname "$0")/.chezmoiroot" ]; then
    # We're running from a cloned repository
    echo -e "${YELLOW}🔧 Initializing chezmoi from local repository...${NC}"
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    chezmoi init --apply "$SCRIPT_DIR"
else
    # We're running via curl or in a different context
    echo -e "${YELLOW}🔧 Initializing chezmoi from remote repository...${NC}"
    chezmoi init --apply $REPO_URL
fi

# Install mise
if ! command -v mise &> /dev/null; then
    echo -e "${YELLOW}📦 Installing mise...${NC}"
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
    
    # Add mise to shell rc files
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(mise activate bash)"' >> ~/.bashrc
    
    if [ -f ~/.zshrc ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
    fi
fi

# Install sheldon
if ! command -v sheldon &> /dev/null; then
    echo -e "${YELLOW}📦 Installing sheldon...${NC}"
    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
        | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

# Install zsh plugins via sheldon
if command -v sheldon &> /dev/null; then
    echo -e "${YELLOW}🔧 Installing zsh plugins...${NC}"
    sheldon lock
fi

# Install tools via mise
if command -v mise &> /dev/null; then
    echo -e "${YELLOW}🔧 Installing development tools via mise...${NC}"
    mise install
fi

echo -e "${GREEN}✅ Dotfiles installation complete!${NC}"
echo -e "${BLUE}📝 Next steps:${NC}"
echo -e "  1. Restart your shell or run: ${YELLOW}exec zsh${NC}"
echo -e "  2. Run: ${YELLOW}p10k configure${NC} to setup Powerlevel10k theme"
echo -e "  3. Enjoy your new environment! 🎉"