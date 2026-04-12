#!/usr/bin/env bash

set -euo pipefail

echo "🚀 Starting dotfiles setup..."

# ---------------------------
# 0. Check Arch
# ---------------------------
if ! command -v pacman &> /dev/null; then
  echo "❌ This script is for Arch Linux only."
  exit 1
fi

# ---------------------------
# 1. Update system
# ---------------------------
echo "🔄 Updating system..."
sudo pacman -Syu --noconfirm

# ---------------------------
# 2. Install base tools
# ---------------------------
echo "📦 Installing base tools..."
sudo pacman -S --needed --noconfirm \
  git base-devel stow curl wget

# ---------------------------
# 3. Install yay (AUR helper)
# ---------------------------
if ! command -v yay &> /dev/null; then
  echo "📦 Installing yay..."
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

# ---------------------------
# 4. Install pacman packages
# ---------------------------
echo "📦 Installing pacman packages..."
if [ -f packages/pacman ]; then
  sudo pacman -S --needed --noconfirm --ask 4 $(grep -v '^#' packages/pacman)
fi

if command -v rustup &> /dev/null; then
  rustup default stable
fi

pip install --user screeninfo || true

# ---------------------------
# 5. Install AUR packages
# ---------------------------
echo "📦 Installing AUR packages..."
if [ -f packages/aur ]; then
  yay -S --needed --noconfirm --ask 4 $(grep -v '^#' packages/aur)
fi

# ---------------------------
# 6. Stow dotfiles
# ---------------------------
echo "🔗 Stowing dotfiles..."

STOW_DIRS="zsh nvim kitty hyprland waybar rofi tmux"

for dir in $STOW_DIRS; do
  if [ -d "$dir" ]; then
    stow "$dir"
  fi
done

# ---------------------------
# 7. Set Zsh as default shell
# ---------------------------
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "🐚 Setting zsh as default shell..."
  chsh -s /bin/zsh
fi

# ---------------------------
# 8. Enable services
# ---------------------------
echo "⚙️ Enabling services..."

sudo systemctl enable NetworkManager

# Power profiles
sudo systemctl enable power-profiles-daemon || true

# ---------------------------
# 9. Fix environment (IMPORTANT)
# ---------------------------
echo "🌱 Fixing environment variables..."

if ! grep -q "XDG_DATA_DIRS" ~/.zprofile 2>/dev/null; then
  echo 'export XDG_DATA_DIRS="/usr/local/share:/usr/share:$XDG_DATA_DIRS"' >> ~/.zprofile
fi

# ---------------------------
# 10. Font cache refresh
# ---------------------------
echo "🔤 Refreshing font cache..."
fc-cache -fv

# ---------------------------
# 11. Create user dirs
# ---------------------------
xdg-user-dirs-update

# ---------------------------
# 12. Done
# ---------------------------
echo "✅ Setup complete!"
echo "👉 Reboot recommended."
