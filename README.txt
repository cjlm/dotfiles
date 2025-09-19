cjlm's dotfiles
===============

Managed with chezmoi (https://www.chezmoi.io/)

QUICK SETUP (NEW MACHINE)
-------------------------
Run this one-liner to set up everything:

sh -c "$(curl -fsLS https://raw.githubusercontent.com/cjlm/dotfiles/main/executable_setup-new-machine.sh)"


MANUAL SETUP
------------
If you prefer to do it step by step:

1. Install Homebrew:
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

2. Install chezmoi:
   brew install chezmoi

3. Initialize and apply dotfiles:
   chezmoi init --apply https://github.com/cjlm/dotfiles.git

4. Set OpenAI API key for llm tool:
   llm keys set openai

5. Restart terminal for shell changes to take effect


WHAT'S INCLUDED
---------------
- Shell: zsh with oh-my-zsh, aliases, functions
- Editor: Neovim and Zed configurations
- Terminal: Kitty configuration
- Window Management: Aerospace, Karabiner, Hammerspoon
- Text Expansion: Espanso
- Git: Global gitconfig and ignore files
- Development tools: All Homebrew packages and casks


UPDATING
--------
Pull and apply latest changes:
chezmoi update


DAILY USAGE
-----------
Add a file to dotfiles:
chezmoi add ~/.some-config-file

Edit a managed file:
chezmoi edit ~/.zshrc

Apply changes:
chezmoi apply

See what would change:
chezmoi diff

Commit and push changes:
cd $(chezmoi source-path)
git add .
git commit -m "Update configs"
git push