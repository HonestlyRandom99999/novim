#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "                      _"
echo "  _ __   _____   __ (_)_ __ ___"
echo " | '_ \ / _ \ \ / / | | '_ \` _ \\"
echo " | | | | (_) \ V /  | | | | | | |"
echo " |_| |_|\___/ \_/   |_|_| |_| |_|"
echo ""
echo -e "${NC}A friendly terminal editor for vibe coders"
echo ""

INSTALL_DIR="${HOME}/.local/bin"
NOVIM_DIR="${HOME}/.local/share/novim"
REPO="link2004/novim"

# Check for Neovim
check_neovim() {
  if command -v nvim &> /dev/null; then
    echo -e "${GREEN}✓${NC} Neovim found"
    return 0
  else
    echo -e "${YELLOW}!${NC} Neovim not found"
    return 1
  fi
}

# Install Neovim
install_neovim() {
  echo -e "${BLUE}Installing Neovim...${NC}"

  if command -v brew &> /dev/null; then
    brew install neovim
  elif command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y neovim
  elif command -v pacman &> /dev/null; then
    sudo pacman -S neovim
  else
    echo -e "${RED}✗${NC} Could not install Neovim automatically."
    echo "  Please install Neovim manually: https://neovim.io/"
    exit 1
  fi

  echo -e "${GREEN}✓${NC} Neovim installed"
}

# Download and install novim
install_novim() {
  echo -e "${BLUE}Installing novim...${NC}"

  # Create directories
  mkdir -p "$INSTALL_DIR"
  mkdir -p "$NOVIM_DIR"

  # Download latest release
  LATEST_URL="https://github.com/${REPO}/releases/latest/download/novim.tar.gz"

  if command -v curl &> /dev/null; then
    curl -fsSL "$LATEST_URL" | tar -xz -C "$NOVIM_DIR" --strip-components=1
  elif command -v wget &> /dev/null; then
    wget -qO- "$LATEST_URL" | tar -xz -C "$NOVIM_DIR" --strip-components=1
  else
    echo -e "${RED}✗${NC} curl or wget required"
    exit 1
  fi

  # Create symlink
  ln -sf "$NOVIM_DIR/bin/novim" "$INSTALL_DIR/novim"
  chmod +x "$INSTALL_DIR/novim"

  echo -e "${GREEN}✓${NC} novim installed to $INSTALL_DIR/novim"
}

# Check PATH
check_path() {
  if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo -e "${YELLOW}!${NC} Add this to your shell config (.zshrc or .bashrc):"
    echo ""
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
  fi
}

# Main
main() {
  if ! check_neovim; then
    install_neovim
  fi

  install_novim
  check_path

  echo ""
  echo -e "${GREEN}Done!${NC} Run ${BLUE}novim${NC} to start editing."
  echo "Press ${BLUE}?${NC} for help."
  echo ""
}

main
