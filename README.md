# cjlm's dotfiles

Managed with [chezmoi](https://www.chezmoi.io/)

## Quick Setup (New Machine)

Run this one-liner to set up everything:

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/cjlm/dotfiles/main/executable_setup-new-machine.sh)"
```

## Manual Setup

If you prefer to do it step by step:

1. Install Homebrew:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install chezmoi:
   ```bash
   brew install chezmoi
   ```

3. Initialize and apply dotfiles:
   ```bash
   chezmoi init --apply https://github.com/cjlm/dotfiles.git
   ```

4. Set OpenAI API key for llm tool:
   ```bash
   llm keys set openai
   ```

5. Restart terminal for shell changes to take effect

## What's Included

- Shell: zsh with oh-my-zsh, aliases, functions
- Editor: Neovim and Zed configurations
- Terminal: Kitty configuration
- Window Management: Aerospace, Karabiner, Hammerspoon
- Text Expansion: Espanso
- Git: Global gitconfig and ignore files
- Development tools: All Homebrew packages and casks

## Updating

Pull and apply latest changes:
```bash
chezmoi update
```

## Daily Usage

Add a file to dotfiles:
```bash
chezmoi add ~/.some-config-file
```

Edit a managed file:
```bash
chezmoi edit ~/.zshrc
```

Apply changes:
```bash
chezmoi apply
```

See what would change:
```bash
chezmoi diff
```

Commit and push changes:
```bash
cd $(chezmoi source-path)
git add .
git commit -m "Update configs"
git push
```