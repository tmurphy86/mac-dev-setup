# macOS Development Environment Setup Script

This repository contains a shell script (`setup_dev_env.sh`) to automate the configuration of a macOS development environment optimized for Visual Studio Code (VS Code). The script installs essential tools, applications, and configurations for a fast, repeatable setup.

## 🚀 Features

- **Xcode Command Line Tools** installation
- **Homebrew** package management
- Development tools setup:
  - Git
  - Node.js
  - Python3
  - Docker
  - wget
  - Zsh
  - jq
  - htop
  - gh
  - awscli
  - yarn

## 📋 Prerequisites

- macOS operating system
- Active internet connection
- Basic terminal knowledge

## 🛠 Installation

### Clone Repository

`git clone https://github.com/tmurphy86/mac-dev-setup.git`
`cd mac-dev-setup`

### Make the Script Executable
`chmod +x setup_dev_env.sh`

### Run Setup Script
`./setup_dev_env.sh`

## 🔧 Customization Options

Edit the script to customize:
- Add/remove Homebrew packages
- Modify VS Code extensions
- Update Git configurations

## 📦 Installed Applications

- Visual Studio Code
- Google Chrome
- iTerm2
- Slack
- Postman
- Docker Desktop
- Github CLI
- AWS CLI
- Terraform CLI

## 🛡️ Configurations

- macOS developer defaults
- Git global configuration
- VS Code extensions
- Zsh as the default shell
- Oh My Zsh installation

## 🔍 Troubleshooting

### Permission Issues

`sudo ./setup_dev_env.sh`

### Homebrew Verification

`brew doctor`

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit changes
4. Push to the branch
5. Create pull request

## 📄 License

MIT License - See [LICENSE](LICENSE) for details

## 💡 Quick Tips

- Always review the script before running
- Backup important data before system modifications
- Keep your macOS updated

---

**Happy Developing!** 👩‍💻👨‍💻
