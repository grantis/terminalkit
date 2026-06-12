#!/usr/bin/env bash
# install.sh - Terminal Kit installer
# Works on Ubuntu/Debian, Arch, and most derivatives
# Usage: bash install.sh

set -e

# ==============================================================================
# Colors
# ==============================================================================
_b="\033[1m"
_r="\033[0m"
_g="\033[1;32m"
_c="\033[0;36m"
_y="\033[1;33m"
_red="\033[0;31m"

ok()   { echo -e "${_g}✓${_r} $1"; }
info() { echo -e "${_c}→${_r} $1"; }
warn() { echo -e "${_y}!${_r} $1"; }
fail() { echo -e "${_red}✘${_r} $1"; exit 1; }
ask()  { echo -e "${_y}?${_r} $1"; }

# ==============================================================================
# Detect distro and set package manager
# ==============================================================================
detect_distro() {
  if command -v apt >/dev/null 2>&1; then
    PKG_MANAGER="apt"
    PKG_INSTALL="sudo apt install -y"
    PKG_UPDATE="sudo apt update -y"
  elif command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="pacman"
    PKG_INSTALL="sudo pacman -S --noconfirm"
    PKG_UPDATE="sudo pacman -Sy"
  elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"
    PKG_INSTALL="sudo dnf install -y"
    PKG_UPDATE="sudo dnf check-update || true"
  else
    fail "Could not detect a supported package manager (apt, pacman, dnf)"
  fi
  ok "Detected package manager: $PKG_MANAGER"
}

# ==============================================================================
# Install a package (with friendly output)
# ==============================================================================
install_pkg() {
  local pkg="$1"
  local label="${2:-$pkg}"
  if command -v "$pkg" >/dev/null 2>&1; then
    ok "$label already installed, skipping"
  else
    info "Installing $label..."
    $PKG_INSTALL "$pkg" >/dev/null 2>&1 && ok "$label installed" || warn "Failed to install $label - skipping"
  fi
}

# ==============================================================================
# Install Starship
# ==============================================================================
install_starship() {
  if command -v starship >/dev/null 2>&1; then
    ok "Starship already installed"
    return
  fi
  info "Installing Starship prompt..."
  if command -v curl >/dev/null 2>&1; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y >/dev/null 2>&1
    ok "Starship installed"
  else
    warn "curl not found, installing curl first..."
    $PKG_INSTALL curl >/dev/null 2>&1
    curl -sS https://starship.rs/install.sh | sh -s -- -y >/dev/null 2>&1
    ok "Starship installed"
  fi
}

# ==============================================================================
# Install NVM (Node Version Manager)
# ==============================================================================
install_nvm() {
  if [ -d "$HOME/.nvm" ]; then
    ok "NVM already installed"
    return
  fi
  info "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash >/dev/null 2>&1
  ok "NVM installed (run: nvm install --lts)"
}

# ==============================================================================
# Install a Nerd Font (JetBrains Mono)
# ==============================================================================
install_font() {
  local font_dir="$HOME/.local/share/fonts"
  local font_name="JetBrainsMonoNerdFont-Regular.ttf"

  if fc-list 2>/dev/null | grep -qi "JetBrainsMono"; then
    ok "JetBrains Mono Nerd Font already installed"
    return
  fi

  info "Installing JetBrains Mono Nerd Font..."
  mkdir -p "$font_dir"
  local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  local tmpdir
  tmpdir=$(mktemp -d)

  curl -sL "$url" -o "$tmpdir/JetBrainsMono.zip" && \
    unzip -q "$tmpdir/JetBrainsMono.zip" -d "$tmpdir/fonts" && \
    find "$tmpdir/fonts" -name "*.ttf" -exec cp {} "$font_dir/" \; && \
    fc-cache -fq && \
    ok "JetBrains Mono Nerd Font installed" || \
    warn "Font install failed - install manually from: https://www.nerdfonts.com/font-downloads"

  rm -rf "$tmpdir"
}

# ==============================================================================
# Deploy config files
# ==============================================================================
deploy_configs() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Backup existing .bashrc
  if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$HOME/.bashrc.bak.$(date +%s)"
    warn "Existing .bashrc backed up to ~/.bashrc.bak.*"
  fi

  # Deploy .bashrc
  if [ -f "$script_dir/configs/.bashrc" ]; then
    cp "$script_dir/configs/.bashrc" "$HOME/.bashrc"
    ok "~/.bashrc deployed"
  else
    warn "configs/.bashrc not found, skipping"
  fi

  # Deploy starship.toml
  mkdir -p "$HOME/.config"
  if [ -f "$script_dir/configs/starship.toml" ]; then
    cp "$script_dir/configs/starship.toml" "$HOME/.config/starship.toml"
    ok "~/.config/starship.toml deployed"
  else
    warn "configs/starship.toml not found, skipping"
  fi
}

# ==============================================================================
# Optional installs (ask the user)
# ==============================================================================
optional_installs() {
  echo ""
  echo -e "${_b}Optional extras${_r} (recommended for a full setup)"
  echo ""

  ask "Install neovim? (modern text editor, replaces nano) [y/N]"
  read -r choice
  [[ "$choice" =~ ^[Yy]$ ]] && install_pkg neovim "Neovim"

  ask "Install taskwarrior? (terminal to-do list) [y/N]"
  read -r choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    if [ "$PKG_MANAGER" = "apt" ]; then
      $PKG_INSTALL taskwarrior >/dev/null 2>&1 && ok "Taskwarrior installed" || warn "Failed"
    elif [ "$PKG_MANAGER" = "pacman" ]; then
      $PKG_INSTALL task >/dev/null 2>&1 && ok "Taskwarrior installed" || warn "Failed"
    fi
  fi

  ask "Install lazygit? (terminal git UI) [y/N]"
  read -r choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    if [ "$PKG_MANAGER" = "apt" ]; then
      LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f4 | tr -d v)
      curl -sLo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
      tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
      sudo install /tmp/lazygit -D -t /usr/local/bin/
      ok "Lazygit installed"
    elif [ "$PKG_MANAGER" = "pacman" ]; then
      $PKG_INSTALL lazygit >/dev/null 2>&1 && ok "Lazygit installed" || warn "Failed"
    fi
  fi

  ask "Install NVM? (Node.js version manager, needed for JS/web dev) [y/N]"
  read -r choice
  [[ "$choice" =~ ^[Yy]$ ]] && install_nvm

  ask "Install JetBrains Mono Nerd Font? (makes the prompt look correct) [y/N]"
  read -r choice
  [[ "$choice" =~ ^[Yy]$ ]] && install_font
}

# ==============================================================================
# Main
# ==============================================================================
main() {
  echo ""
  echo -e "${_b}${_g}Terminal Kit Installer${_r}"
  echo -e "Setting up a friendly, modern terminal environment."
  echo ""

  detect_distro

  echo ""
  info "Updating package lists..."
  $PKG_UPDATE >/dev/null 2>&1
  ok "Package lists updated"

  echo ""
  echo -e "${_b}Core tools${_r}"

  install_pkg curl "curl"
  install_pkg git "git"
  install_pkg fzf "fzf"
  install_pkg htop "htop"
  install_pkg tree "tree"
  install_pkg unzip "unzip"

  # tldr has different package names
  if ! command -v tldr >/dev/null 2>&1; then
    info "Installing tldr (plain-english man pages)..."
    $PKG_INSTALL tldr >/dev/null 2>&1 || $PKG_INSTALL tealdeer >/dev/null 2>&1 || warn "tldr not available, skipping"
    command -v tldr >/dev/null 2>&1 && ok "tldr installed"
  else
    ok "tldr already installed"
  fi

  echo ""
  install_starship

  echo ""
  deploy_configs

  optional_installs

  # Done
  echo ""
  echo -e "${_b}${_g}All done!${_r}"
  echo ""
  echo -e "Open a new terminal or run: ${_c}source ~/.bashrc${_r}"
  echo ""
  echo -e "Then try: ${_c}helpme${_r}   ${_c}tips${_r}   ${_c}sysinfo${_r}   ${_c}cheat tar${_r}"
  echo ""

  # WSL font reminder
  if grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
    echo -e "${_y}WSL users:${_r} Set your terminal font to 'JetBrainsMono Nerd Font' in Windows Terminal settings."
    echo ""
  fi
}

main "$@"
