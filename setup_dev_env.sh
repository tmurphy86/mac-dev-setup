#!/bin/bash

# Exit script on any error
set -e

echo "Starting macOS development environment setup..."

# Function to check if a command exists
command_exists() {
  command -v "$1" &>/dev/null
}

# Function to check if a Homebrew package is installed
brew_package_installed() {
  brew list "$1" &>/dev/null
}

# Function to check if a Homebrew cask package is installed
brew_cask_installed() {
  brew list --cask "$1" &>/dev/null
}

# Install Xcode Command Line Tools
if ! command_exists xcode-select; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install || { echo "Failed to install Xcode Command Line Tools."; exit 1; }
else
  echo "Xcode Command Line Tools are already installed."
fi

# Install Homebrew
if ! command_exists brew; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { echo "Failed to install Homebrew."; exit 1; }
else
  echo "Homebrew is already installed. Updating Homebrew..."
  brew update && brew upgrade || { echo "Failed to update Homebrew."; exit 1; }
fi

# Install essential development tools via Homebrew
echo "Installing essential development tools..."
for tool in git node python3 docker wget zsh jq htop gh awscli kubectl helm ngrok; do
  if ! brew_package_installed "$tool"; then
    echo "Installing $tool..."
    if ! brew install "$tool"; then 
      echo "Failed to install $tool. Skipping..."
    fi
  else
    echo "$tool is already installed."
  fi
done

# Install Terraform using HashiCorp tap and Homebrew formulae
if ! command_exists terraform; then
  echo "Installing Terraform..."
  
  # Add HashiCorp tap if not already added
  if ! brew tap | grep -q "^hashicorp/tap$"; then
    echo "Adding HashiCorp tap..."
    brew tap hashicorp/tap || { echo "Failed to add HashiCorp tap."; exit 1; }
  else 
    echo "HashiCorp tap is already added."
  fi
  
  # Install Terraform from the HashiCorp tap
  brew install hashicorp/tap/terraform || { echo "Failed to install Terraform."; exit 1; }
else 
  echo "Terraform is already installed. Checking for updates..."
  
  # Upgrade Terraform if an update is available
  brew upgrade hashicorp/tap/terraform || echo "Terraform is up-to-date."
fi

# Verify Terraform installation and version
echo "Verifying Terraform installation..."
terraform --version || { echo "Terraform installation failed."; exit 1; }

# Enable Terraform autocomplete (optional)
if [ -f ~/.zshrc ] || [ -f ~/.bashrc ] || [ -f ~/.zprofile ]; then
  terraform -install-autocomplete || echo "Failed to enable Terraform autocomplete."
fi

# Install VS Code via Homebrew Cask
if ! brew_cask_installed visual-studio-code; then
  echo "Installing Visual Studio Code..."
  brew install --cask visual-studio-code || { echo "Failed to install Visual Studio Code."; exit 1; }
else
  echo "Visual Studio Code is already installed."
fi

# Install additional tools and applications via Homebrew Cask
echo "Installing additional applications..."
for app in google-chrome iterm2 slack postman; do
  if ! brew_cask_installed "$app"; then
    echo "Installing $app..."
    brew install --cask "$app" || { echo "Failed to install $app."; exit 1; }
  else
    echo "$app is already installed."
  fi
done

# Install VS Code extensions (with CLI check)
if command_exists code; then
  extensions=(ms-python.python dbaeumer.vscode-eslint esbenp.prettier-vscode ms-vscode.vscode-typescript-next)
  for extension in "${extensions[@]}"; do
    if ! code --list-extensions | grep -q "$extension"; then
      echo "Installing VS Code extension: $extension"
      code --install-extension "$extension" || { echo "Failed to install VS Code extension: $extension."; }
    else
      echo "VS Code extension $extension is already installed."
    fi
  done
else
  echo "VS Code CLI ('code') not found. Skipping extension installation."
fi

# Create a Brewfile for future use (optional)
echo "Creating a Brewfile for backup..."
brew bundle dump --file=~/Brewfile --force || { echo "Failed to create Brewfile."; exit 1; }

# Set macOS defaults for developers (optional)
echo "Configuring macOS defaults for development..."
defaults write com.apple.finder AppleShowAllFiles -bool true # Show hidden files in Finder
defaults write com.apple.dock autohide -bool true            # Auto-hide Dock
killall Finder && killall Dock                               # Restart Finder and Dock to apply changes

# Git configuration (optional)
echo "Configuring Git..."
if ! git config --global user.name &>/dev/null; then
  git config --global user.name "Tim Murphy" || { echo "Failed to set Git user name."; exit 1; }
fi

if ! git config --global user.email &>/dev/null; then
  git config --global user.email "tim@murphy.dev" || { echo "Failed to set Git user email."; exit 1; }
fi

git config --global core.editor "code --wait" || { echo "Failed to set Git core editor."; exit 1; }

# Install Docker Desktop (optional)
if ! brew_cask_installed docker; then
  echo "Installing Docker Desktop..."
  brew install --cask docker || { echo "Failed to install Docker Desktop."; exit 1; }
else
  echo "Docker Desktop is already installed."
fi

# Set Zsh as the default shell
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "Setting Zsh as the default shell..."
  chsh -s /bin/zsh || { echo "Failed to set Zsh as the default shell."; exit 1; }
else
  echo "Zsh is already the default shell."
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || { echo "Failed to install Oh My Zsh."; exit 1; }
else
  echo "Oh My Zsh is already installed."
fi

# Post-installation cleanup
echo "Cleaning up Homebrew cache..."
brew cleanup || { echo "Failed to clean up Homebrew cache."; exit 1; }

echo "macOS development environment setup complete!"
