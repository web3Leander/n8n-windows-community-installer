# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2025-11-16

### Added
- Informative message showing where n8n will create the `.n8n` data folder
- Clear documentation in README.txt about n8n's automatic `.n8n` folder creation

### Changed
- **BREAKING**: Removed "Quick Install" mode - all installations now use the streamlined installer
- Simplified installation flow from 5 steps to 4 steps
- Data directory is now automatically set based on installation location (no separate prompt)
- For folder installs: data stored in same folder as installation
- For global installs: data stored in `%USERPROFILE%\.n8n`
- Reduced installer size from 888 lines to 739 lines
- Updated README.md to reflect simplified installation process

### Fixed
- **CRITICAL**: Fixed nested `.n8n\.n8n` folder
- Installer now correctly accounts for n8n's behavior of automatically appending `.n8n` to paths
- Users no longer need to manually specify `.n8n` in data paths
- Updated all prompts and documentation to clarify automatic folder creation

## [0.1.0] - 2025-11-16

### Initial Release

#### Added
- Interactive installation wizard with step-by-step guidance
- Two installation modes: Quick Install and Custom Install
- Global npm installation support
- Folder-specific (portable) installation support
- Custom data directory selection
- Network configuration (custom host/IP and port)
- Automatic Node.js and npm prerequisite checking
- Installation verification with proper error handling
- Automatic PATH configuration for folder installations
- Start script generation with configured settings
- Comprehensive README.txt generation in installation folder
- Credits and disclaimer throughout installer and documentation
- Support for Windows 10 and Windows 11

#### Features
- **Quick Install Mode**
  - Fast, one-click installation with sensible defaults
  - Global npm installation
  - Configurable network settings
  
- **Custom Install Mode**
  - Full control over installation location
  - Choice between global and folder installations
  - Custom data directory
  - Configurable network host and port
  - Automatic PATH setup

#### Documentation
- Complete README.md for GitHub repository
- Installation guide and troubleshooting tips
- FAQ section with common questions
- Security considerations for network configurations
- Links to official n8n resources

#### Known Limitations
- Windows only (PowerShell required)
- No Docker installation support (planned for future release)
- No automatic update checking (planned for future release)
- Manual uninstallation process

---

## [Unreleased]

### Planned Features
- Docker installation support
- Automatic update manager
- Backup and restore tools
- Port availability validation
- Uninstaller script
- Process manager integration (PM2/NSSM)

---

**Note:** This is an unofficial community installer and is not affiliated with n8n.io or n8n GmbH.
