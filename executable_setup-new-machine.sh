#!/bin/bash

# Install Homebrew (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install tools via Homebrew (alphabetical)
brew install \
  actionlint \
  ast-grep \
  bat \
  chezmoi \
  colima \
  diff-so-fancy \
  docker \
  docker-compose \
  eza \
  fd \
  ffmpeg \
  fnm \
  fzf \
  gh \
  git \
  jq \
  llm \
  macos-trash \
  marp-cli \
  neovim \
  node \
  pnpm \
  python@3.13 \
  repomix \
  ripgrep \
  rustup \
  shellcheck \
  shfmt \
  starship \
  tailscale \
  tesseract \
  tmux \
  tree \
  uv \
  watch \
  wget \
  yt-dlp \
  zizmor \
  zoxide \
  zsh-autosuggestions \
  zsh-syntax-highlighting

# Install casks
brew install --cask \
  kitty \
  nikitabobko/tap/aerospace \
  hammerspoon \
  karabiner-elements \
  bitwarden \
  obsidian \
  sublime-text \
  sublime-merge \
  zed \
  google-chrome \
  firefox \
  librewolf \
  slack \
  espanso \
  jordanbaird-ice \
  helium \
  claude \
  claude-code

# Install borders for AeroSpace
brew tap FelixKratz/formulae
brew install borders
brew services start felixkratz/formulae/borders

# Install ttok from custom tap
brew install simonw/llm/ttok

# Setup fzf (key-bindings + completion, no rc edits — .zshrc sources ~/.fzf.zsh itself)
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

# Setup rustup toolchain (don't modify shell profile — dotfiles' .zshrc sources $HOME/.cargo/env)
rustup-init -y --default-toolchain stable --no-modify-path
source "$HOME/.cargo/env"
rustup component add rust-analyzer rust-src
rustup target add wasm32-unknown-unknown

# Cargo-installed binaries (compiles from source — slow on first run)
cargo install prek cargo-deny

# Python CLI tools via uv (isolated venvs per tool)
uv tool install ruff
uv tool install ty
uv tool install pip-audit

# Node global CLI tools (note: fnm's per-version globals — re-run after switching Node versions)
npm install -g oxlint

# Initialize chezmoi with your dotfiles
chezmoi init --apply https://github.com/cjlm/dotfiles.git

# Configure chezmoi data
echo ""
echo "Remember to configure chezmoi with your personal data:"
echo "  Create/edit ~/.config/chezmoi/chezmoi.toml with:"
echo "  [data]"
echo "      name = \"Your Name\""
echo "      email = \"your.email@example.com\""

# macOS System Preferences
echo "Configuring macOS settings..."

# Finder: show hidden files
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: enable right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Trackpad: disable swipe between pages
defaults write com.apple.trackpad.scroll SwipeBetweenPages -bool false

# Accessibility: enable scroll gesture with modifier keys to zoom
# Note: writes to com.apple.universalaccess require Full Disk Access for the
# terminal running this script (System Settings > Privacy & Security > Full Disk
# Access). If skipped, configure manually in System Settings > Accessibility > Zoom.
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Keyboard: disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Keyboard: set fast key repeat rate + short delay before repeat starts
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Dock: clear all persistent apps from the dock
defaults write com.apple.dock persistent-apps -array; killall Dock

# Menu bar: hide Siri icon
defaults write com.apple.Siri StatusMenuVisible -bool false
killall SystemUIServer

echo "macOS settings configured. Some changes may require a logout/restart."

# App permissions (must be granted manually in System Settings > Privacy & Security):
#   - Karabiner-Elements: Input Monitoring + Driver Extension
#   - AeroSpace:          Accessibility
#   - Hammerspoon:        Accessibility
#   - Espanso:            Accessibility + Input Monitoring
echo ""
echo "Grant required Privacy & Security permissions to:"
echo "  Karabiner-Elements (Input Monitoring + Driver Extension)"
echo "  AeroSpace, Hammerspoon (Accessibility)"
echo "  Espanso (Accessibility + Input Monitoring)"

# Espanso: register as login service (run AFTER granting permissions above)
echo ""
echo "After granting Espanso permissions, run:"
echo "  espanso service register && espanso start"

# Configure OpenAI API key for llm
echo "Remember to set your OpenAI API key:"
echo "llm keys set openai"

# Manual Mac App Store installs
echo ""
echo "Remember to install from Mac App Store:"
echo "  - Dato"
echo "  - 1Blocker"
echo "  - Things 3"