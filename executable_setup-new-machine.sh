#!/bin/bash

# Install Homebrew (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install tools via Homebrew
brew install \
  bat \
  eza \
  fzf \
  the_silver_searcher \
  tree \
  neovim \
  git \
  diff-so-fancy \
  fnm \
  starship \
  chezmoi \
  ffmpeg \
  yt-dlp \
  llm \
  gh \
  pnpm \
  tmux \
  wget \
  docker \
  docker-compose \
  colima \
  tailscale \
  marp-cli \
  repomix \
  watch \
  tesseract \
  uv \
  rust \
  python@3.13 \
  node \
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
  helium

# Install borders for AeroSpace
brew tap FelixKratz/formulae
brew install borders

# Install ttok from custom tap
brew install simonw/llm/ttok

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Note: zsh-autosuggestions and zsh-syntax-highlighting are now installed via Homebrew above

# Install uv (still needed by the yt-summarize script)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Setup fzf
$(brew --prefix)/opt/fzf/install

# Initialize chezmoi with your dotfiles
chezmoi init --apply https://github.com/cjlm/dotfiles.git

# Configure OpenAI API key for llm
echo "Remember to set your OpenAI API key:"
echo "llm keys set openai"

# Manual Mac App Store installs
echo ""
echo "Remember to install from Mac App Store:"
echo "  - Dato"