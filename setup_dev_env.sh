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
  xcode-select --install || echo "Xcode Command Line Tools already installed."
else
  echo "Xcode Command Line Tools are already installed."
fi

# Install Homebrew
if ! command_exists brew; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed. Updating Homebrew..."
  brew update && brew upgrade
fi

# Install essential development tools via Homebrew
echo "Installing essential development tools..."
for tool in git node python3 docker wget zsh jq htop; do
  if ! brew_package_installed "$tool"; then
    echo "Installing $tool..."
    brew install "$tool"
  else
    echo "$tool is already installed."
  fi
done

# Install VS Code via Homebrew Cask
if ! brew_cask_installed visual-studio-code; then
  echo "Installing Visual Studio Code..."
  brew install --cask visual-studio-code
else
  echo "Visual Studio Code is already installed."
fi

# Install additional tools and applications via Homebrew Cask
echo "Installing additional applications..."
for app in google-chrome iterm2 slack postman; do
  if ! brew_cask_installed "$app"; then
    echo "Installing $app..."
    brew install --cask "$app"
  else
    echo "$app is already installed."
  fi
done

# Configure VS Code extensions
echo "Installing VS Code extensions..."
extensions=(
  ms-python.python 
  dbaeumer.vscode-eslint 
  esbenp.prettier-vscode 
  ms-vscode.vscode-typescript-next
)
for extension in "${extensions[@]}"; do
  if ! code --list-extensions | grep -q "$extension"; then
    echo "Installing VS Code extension: $extension"
    code --install-extension "$extension"
  else
    echo "VS Code extension $extension is already installed."
  fi
done

# Create a Brewfile for future use (optional)
echo "Creating a Brewfile for backup..."
brew bundle dump --file=~/Brewfile --force

# Set macOS defaults for developers (optional)
echo "Configuring macOS defaults for development..."
defaults write com.apple.finder AppleShowAllFiles -bool true # Show hidden files in Finder
defaults write com.apple.dock autohide -bool true            # Auto-hide Dock
killall Finder && killall Dock                               # Restart Finder and Dock to apply changes

# Git configuration (optional)
echo "Configuring Git..."
if ! git config --global user.name &>/dev/null; then
  git config --global user.name "Tim Murphy"
fi

if ! git config --global user.email &>/dev/null; then
  git config --global user.email "tim@murphy.dev"
fi

git config --global core.editor "code --wait"

# Install Docker Desktop (optional)
if ! brew_cask_installed docker; then
  echo "Installing Docker Desktop..."
  brew install --cask docker
else
  echo "Docker Desktop is already installed."
fi


# Set Zsh as the default shell
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "Setting Zsh as the default shell..."
  chsh -s /bin/zsh
else
  echo "Zsh is already the default shell."
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed."
fi

# Post-installation cleanup
echo "Cleaning up Homebrew cache..."
brew cleanup

echo "macOS development environment setup complete!"
