#!/bin/bash
set -euo pipefail

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
MIN_NVIM_VERSION="0.8.0"

# Cleanup on error
cleanup() {
  if [[ -d "$NOVIM_DIR" && ! -f "$NOVIM_DIR/bin/novim" ]]; then
    rm -rf "$NOVIM_DIR"
  fi
}
trap cleanup ERR

# Compare versions (compatible with macOS/BSD without sort -V)
version_gte() {
  local v1="${1:-0}" v2="${2:-0}"
  local IFS='.'
  read -ra v1_parts <<< "$v1"
  read -ra v2_parts <<< "$v2"

  for i in 0 1 2; do
    local n1="${v1_parts[i]:-0}"
    local n2="${v2_parts[i]:-0}"
    if (( n1 > n2 )); then return 0; fi
    if (( n1 < n2 )); then return 1; fi
  done
  return 0
}

# Check for Neovim
check_neovim() {
  if command -v nvim &> /dev/null; then
    local version
    version=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    if version_gte "$version" "$MIN_NVIM_VERSION"; then
      echo -e "${GREEN}✓${NC} Neovim $version found"
      return 0
    else
      echo -e "${YELLOW}!${NC} Neovim $version found (need $MIN_NVIM_VERSION+)"
      return 1
    fi
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
    # Ubuntu/Debian repos often have old neovim, use snap instead
    if command -v snap &> /dev/null; then
      echo -e "${YELLOW}!${NC} sudo required for snap"
      sudo snap install nvim --classic
    else
      echo -e "${RED}✗${NC} Ubuntu/Debian apt has outdated Neovim."
      echo "  Install snap first: sudo apt install snapd"
      echo "  Then run this installer again."
      echo "  Or install manually: https://github.com/neovim/neovim/releases"
      exit 1
    fi
  elif command -v pacman &> /dev/null; then
    echo -e "${YELLOW}!${NC} sudo required for pacman"
    sudo pacman -S --noconfirm neovim
  else
    echo -e "${RED}✗${NC} Could not install Neovim automatically."
    echo "  Please install Neovim 0.8+ manually: https://neovim.io/"
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

  local tmp_file
  tmp_file=$(mktemp)

  if command -v curl &> /dev/null; then
    if ! curl -fsSL "$LATEST_URL" -o "$tmp_file"; then
      echo -e "${RED}✗${NC} Failed to download novim"
      rm -f "$tmp_file"
      exit 1
    fi
  elif command -v wget &> /dev/null; then
    if ! wget -q "$LATEST_URL" -O "$tmp_file"; then
      echo -e "${RED}✗${NC} Failed to download novim"
      rm -f "$tmp_file"
      exit 1
    fi
  else
    echo -e "${RED}✗${NC} curl or wget required"
    exit 1
  fi

  # Extract
  if ! tar -xzf "$tmp_file" -C "$NOVIM_DIR" --strip-components=1; then
    echo -e "${RED}✗${NC} Failed to extract novim"
    rm -f "$tmp_file"
    exit 1
  fi

  rm -f "$tmp_file"

  # Create symlink
  ln -sf "$NOVIM_DIR/bin/novim" "$INSTALL_DIR/novim"
  chmod +x "$INSTALL_DIR/novim"
  chmod +x "$NOVIM_DIR/bin/novim"

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
