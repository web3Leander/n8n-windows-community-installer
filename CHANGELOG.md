# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.4] - 2025-11-28

### Added

- **Auto-update check option** for start scripts:
  - Optional prompt during installation to enable update checking
  - start_n8n.bat checks for newer n8n versions on each launch
  - Prompts user before installing updates (Y/N confirmation)
  - Supports both global (`npm update -g n8n`) and folder (`npm update n8n`) installations
  - Docker excluded (uses its own update mechanism)
- **Desktop shortcut creation**:
  - Optional prompt to create desktop shortcut for start_n8n.bat
  - Choice between current user only or all users (Public Desktop)
  - Uses PowerShell to create proper Windows .lnk shortcut

### Fixed

- Fixed encoding issue with checkmark characters in generated start scripts
  - Replaced UTF-8 `✓` with ASCII-safe `[OK]` for batch file compatibility
- Fixed missing closing parenthesis in auto-update version display

### Changed

- Version display in auto-update now uses square brackets `[v1.x.x]` for reliable escaping

## [0.1.3] - 2025-11-28

### Added

- **Pre-installation checks** for better user experience:
  - Port 5678 availability check during prerequisites
  - Disk space check on target drive after path selection (requires 1.2GB+)
  - Existing folder installation detection with overwrite confirmation
  - Existing Docker container detection with option to remove or rename
- Warning reminder during network configuration if port 5678 is in use

### Fixed

- **Critical**: Fixed Docker configuration prompts appearing during folder installations
  - Batch script labels inside `if` blocks were breaking conditional flow
  - Restructured Docker configuration section with proper `goto` skip logic
- Disk space check now correctly checks the target drive (not just C:)

### Changed

- Disk space check moved from prerequisites to after installation path selection
- Folder installation now requires typing "DELETE" to confirm overwrite of existing n8n installation

## [0.1.2] - 2025-11-17

### Added

- **Docker installation support** - Run n8n in Docker containers
  - Docker Desktop detection in prerequisites check
  - Docker as installation option #3 (alongside Global and Folder)
  - Docker configuration prompts: container name (default: n8n), volume name (default: n8n_data), timezone (default: UTC), port (default: 5678)
  - Automatic Docker volume creation for persistent data storage
  - Automatic Docker image pull: `docker.n8n.io/n8nio/n8n`
  - Container startup with proper environment variables and port mapping
  - Complete Docker documentation in generated README.txt
- Simplified network configuration for Docker installations (port-only, localhost assumed)

### Changed

- Prerequisites check now includes Docker status (optional)
- Installation flow supports three installation types: Global, Folder, Docker
- Network configuration adapts based on installation type
- Generated README.txt includes Docker-specific commands and management instructions
- Documentation updated with Docker installation option and usage
- FAQ updated to reflect Docker support availability

### Fixed

- Fixed ERRORLEVEL checking in prerequisites to use delayed expansion (`!ERRORLEVEL!` instead of `%ERRORLEVEL%`)
- Fixed duplicate port prompts in Docker installation flow

### Technical Details

- Docker image: `docker.n8n.io/n8nio/n8n` (official n8n image)
- Environment variables: `GENERIC_TIMEZONE`, `TZ`, `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS`, `N8N_RUNNERS_ENABLED`
- Port mapping: User-specified host port to container port 5678
- Data persistence: Docker volume mounted to `/home/node/.n8n` in container
- Container verification after startup with 5-second initialization wait

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

- Automatic update manager
- Backup and restore tools
- Uninstaller script
- Process manager integration (PM2/NSSM)

---

**Note:** This is an unofficial community installer and is not affiliated with n8n.io or n8n GmbH.
