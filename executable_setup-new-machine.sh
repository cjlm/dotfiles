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
  llm

# Install casks
brew install --cask \
  kitty \
  nikitabobko/tap/aerospace \
  hammerspoon

# Install borders for AeroSpace
brew tap FelixKratz/formulae
brew install borders

# Install ttok from custom tap
brew install simonw/llm/ttok

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install uv (still needed by the yt-summarize script)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Setup fzf
$(brew --prefix)/opt/fzf/install

# Initialize chezmoi with your dotfiles
# Replace with your actual repo
# chezmoi init --apply https://github.com/yourusername/dotfiles.git

# Configure OpenAI API key for llm
echo "Remember to set your OpenAI API key:"
echo "llm keys set openai"