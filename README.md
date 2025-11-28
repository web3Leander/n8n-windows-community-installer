# n8n Windows Community Installer

An unofficial, community-created installation wizard for [n8n](https://n8n.io) on Windows systems.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1.5-blue.svg)](https://github.com/web3Leander/n8n-windows-community-installer)

## ⚠️ IMPORTANT DISCLAIMER

**This is an UNOFFICIAL community-made installer and is NOT affiliated with, endorsed by, or connected to n8n.io or n8n GmbH in any way.**

For official n8n support, please visit:

- [n8n Official Website](https://n8n.io)
- [n8n GitHub Repository](https://github.com/n8n-io/n8n)
- [n8n Community Forum](https://community.n8n.io)
- [n8n Documentation](https://docs.n8n.io)

For issues with this installer, please open an issue in this repository.

## 📋 Overview

This interactive installation wizard simplifies the process of installing n8n on Windows systems. It provides a user-friendly, step-by-step interface with full customization options for your n8n installation.

## ✨ Features

- **Three Installation Methods:**
  - Global installation (npm install -g n8n)
  - Folder-specific installation (portable, isolated)
  - Docker installation (containerized, easy updates)

- **Smart Pre-Installation Checks:**
  - Automatic prerequisite checking (Node.js, npm, Docker)
  - Port 5678 availability detection
  - Disk space verification on target drive (1.2GB+ required)
  - Existing installation detection with overwrite confirmation

- **Auto-Update Check:**
  - Optional update checking on each n8n start
  - Compares installed version with latest available
  - Prompts before installing updates
  - Supports both global and folder installations

- **Desktop Shortcut:**
  - Optional desktop shortcut creation for quick access
  - Choose between current user or all users
  - Creates proper Windows .lnk shortcut

- **Streamlined Installation:**
  - Automatic data directory configuration
  - Network configuration (custom host/IP and port)
  - Docker container and volume configuration
  - Installation verification (validates actual installation)
  - Automatic PATH configuration for folder installations

- **Complete Documentation:**
  - Generates comprehensive README.txt in installation folder
  - Creates ready-to-use start scripts with configured settings
  - Includes quick start guide, troubleshooting tips, and resource links
  - Clear explanation of n8n's automatic `.n8n` folder creation

## 📦 System Requirements

### Required

- **Operating System:** Windows 10 or Windows 11 (64-bit)
- **Node.js:** Version 18.x or later ([Download](https://nodejs.org/))
  - Recommended: Latest LTS version
  - *Not required for Docker installation*
- **npm:** Version 8.x or later (included with Node.js)
  - *Not required for Docker installation*
- **PowerShell:** 5.1 or later (included with Windows)

### Optional

- **Docker Desktop:** For Docker installation option ([Download](https://www.docker.com/products/docker-desktop))
  - Provides isolated, containerized n8n installation
  - Easier updates and backups
  - Consistent environment across systems

### Recommended

- **RAM:** 4GB minimum, 8GB recommended
- **Disk Space:** 1.2GB free space for n8n and dependencies
- **Internet Connection:** Required for downloading n8n packages
- **Administrator Rights:** Optional, but recommended for global installations

## 🚀 Quick Start

1. **Download** the `n8n-Installer.bat` file
2. **Right-click** and select "Run as Administrator" (optional, but recommended for global installations)
3. **Follow the prompts** in the installation wizard
4. **Start n8n** using the generated start script or command

## 📖 Installation Options

### Global Installation

Installs n8n system-wide using npm:

- n8n command available from any terminal
- Data stored in `%USERPROFILE%\.n8n`
- Standard installation method
- Easy updates with `npm update -g n8n`

### Folder-Specific Installation

Installs n8n in a specific folder:

- Completely isolated installation
- Data stored in the same folder
- No system-wide changes
- Useful for testing or running multiple versions
- Portable (can be moved/backed up easily)

### Docker Installation

Runs n8n in a Docker container:

- Completely isolated and portable
- Easy updates and backups
- Consistent environment across systems
- Requires Docker Desktop
- Data stored in Docker volume
- Simple container management scripts included

## 🎯 How It Works

The installer will guide you through:

1. **System verification** - Checks Node.js, npm, Docker prerequisites and port availability
2. **Installation setup** - Choose installation type, path, and confirm disk space
3. **Installation** - Downloads and installs n8n (npm or Docker)
4. **Setup completion** - Creates start script and documentation

## 🔧 Network Configuration

The installer allows you to configure:

- **Host/IP Address:**
  - `127.0.0.1` (localhost only - default)
  - `0.0.0.0` (all network interfaces)
  - Custom IP address (e.g., `192.168.1.100`)

- **Port Number:**
  - `5678` (default)
  - Custom port (1024-65535)

### 🔒 Security Considerations

**Important:** Your network configuration affects security!

- **127.0.0.1 (localhost)** - Most secure
  - Only accessible from your computer
  - Recommended for personal use
  - No firewall configuration needed

- **0.0.0.0 (all interfaces)** - Less secure
  - Accessible from any device on your network
  - May be accessible from the internet if router allows
  - **Requires firewall configuration**
  - Only use if you need remote access
  - Consider using authentication and HTTPS in production

- **Specific IP (e.g., 192.168.1.100)** - Moderate security
  - Accessible from devices on the same network
  - Good for LAN access
  - Configure Windows Firewall accordingly

**Best Practice:** Start with `127.0.0.1` for testing, then configure for your specific needs.

## 📁 What Gets Installed

After installation, you'll have:

**For Global/Folder Installations:**

- **n8n application** (globally or in your chosen folder)
- **start_n8n.bat** - Configured start script with network settings
- **README.txt** - Complete installation documentation
- **Data folder** - Automatically created as `.n8n` subfolder on first run
  - Global install: `%USERPROFILE%\.n8n\`
  - Folder install: `<your-folder>\.n8n\`
  - Contains: workflows, credentials, settings, database, and encryption key

### ⚠️ CRITICAL: Backup Your Encryption Key

**IMPORTANT:** On first startup, n8n automatically generates an encryption key that is used to secure your credentials and sensitive data. This key is stored in your `.n8n` folder.

**Why this matters:**

- Your workflows and credentials are encrypted with this key
- Without this key, you **CANNOT** recover your data after reinstalling
- If you lose the encryption key, your workflows and credentials are permanently lost

**How to protect your data:**

1. **Backup the entire `.n8n` folder regularly:**

   ```text
   Global install: %USERPROFILE%\.n8n\
   Folder install: <your-installation-folder>\.n8n\
   ```

2. **To restore after reinstallation:**
   - Install n8n to the same location (or update paths in start_n8n.bat)
   - **Before starting n8n for the first time**, copy your backed-up `.n8n` folder
   - This preserves your encryption key, workflows, and all data

3. **What to backup:**
   - The entire `.n8n` folder (contains everything you need)
   - Your `start_n8n.bat` script (for configuration reference)

**Best Practice:** Create backups before:

- Upgrading n8n
- Changing installation locations
- Major system updates
- Moving to a new computer

**For Docker Installation:**

- **Docker container** - Running n8n in an isolated environment
- **Docker volume** - Persistent data storage for workflows and settings
- **README.txt** - Complete installation documentation with Docker commands
- Manage container via Docker Desktop or docker CLI commands

## 🎯 Usage

### Starting n8n

**Global/Folder Installation:**

1. **Using the start script:**

   ```batch
   Double-click start_n8n.bat
   ```

2. **Using command line** (global install):

   ```bash
   n8n start
   ```

**Docker Installation:**

1. **Using Docker Desktop:**
   - Open Docker Desktop and start the n8n container

2. **Using command line:**

   ```bash
   docker start n8n
   ```

3. **Access the web interface:**

   ```text
   Open your browser to: http://localhost:5678
   (or your configured host:port)
   ```

### Stopping n8n

**Native Installation:** Press `Ctrl+C` in the terminal window where n8n is running.

**Docker Installation:** Use Docker Desktop or run `docker stop n8n`

## 🛠️ Troubleshooting

### n8n won't start

- Check that your configured port is not already in use
- Try running: `netstat -ano | findstr :5678` (replace 5678 with your port)
- Verify Node.js is properly installed: `node --version`

### Can't access web interface

- Ensure n8n is running (check the terminal window)
- Try accessing: `http://localhost:5678`
- Check Windows Firewall settings if using non-localhost IP

### Port already in use

- Edit `start_n8n.bat` and change `N8N_PORT` to a different port
- Common alternatives: 3000, 5000, 8080

For more help, visit the [n8n Community Forum](https://community.n8n.io)

## ❓ Frequently Asked Questions

### Can I run multiple n8n instances?

Yes! Use the Custom Install option with folder-specific installations. Install each instance to a different folder with different ports, and each will run independently with its own data.

### How do I uninstall n8n?

**Global Installation:**

```bash
npm uninstall -g n8n
```

Then delete your data directory (default: `%USERPROFILE%\.n8n`)

**Folder Installation:**

Simply delete the installation folder. To clean up PATH, run:

```bash
setx PATH "%PATH:;C:\your\n8n\folder\node_modules\.bin=%"
```

### How do I upgrade n8n?

**Global Installation:**

```bash
npm install -g n8n@latest
```

**Folder Installation:**

Navigate to your installation folder and run:

```bash
npm install n8n@latest
```

Your data (workflows, credentials) will be preserved.

### Can I move my installation to another computer?

**Yes!** For folder installations:

1. **Copy your entire installation folder** including the `.n8n` subfolder
2. **Install n8n on the new computer** to the same folder path (or update paths in `start_n8n.bat`)
3. **Replace the new `.n8n` folder** with your backed-up `.n8n` folder
4. This preserves your encryption key, workflows, credentials, and all settings

For global installations:

1. **Reinstall n8n globally** on the new machine: `npm install -g n8n`
2. **Copy your backed-up `.n8n` folder** to `%USERPROFILE%\.n8n` on the new machine
3. Run n8n and all your workflows will be there

**Important:** The `.n8n` folder contains your encryption key - without it, your data cannot be decrypted!

### Does this work with Docker?

Yes! Version 0.1.2 adds full Docker installation support. The installer can now create and configure n8n Docker containers with persistent data volumes. Choose the Docker installation option when running the installer (requires Docker Desktop).

### Is my data safe?

**Yes!** All your workflows, credentials, and settings are stored locally in your `.n8n` data directory. This installer doesn't send any data anywhere.

**Important:** Your data is encrypted with an auto-generated encryption key. Always backup your entire `.n8n` folder before:

- Major updates or upgrades
- Moving installations
- System changes or reinstalls

Without the encryption key (stored in `.n8n`), your data cannot be recovered!

### Can I use this in a production environment?

This installer sets up n8n for you, but for production use, consider:

- Using a process manager (PM2, NSSM)
- Setting up automatic backups
- Configuring HTTPS with proper certificates
- Using authentication and proper security measures
- Reviewing n8n's official production setup guide

## 🚀 Upcoming Features

We're actively working on enhancing this installer! Planned features include:

- **Update Manager** - Check for and install n8n updates directly from the installer
- **Backup/Restore Tools** - Easy backup and restoration of your workflows and settings
- **Port Validation** - Automatic port availability checking before installation
- **Docker Volume Management** - Tools for backing up and restoring Docker volumes

Have a feature request? [Open an issue](https://github.com/web3Leander/n8n-windows-community-installer/issues)!

## 📚 Additional Resources

- **Official Website:** [https://n8n.io](https://n8n.io)
- **Documentation:** [https://docs.n8n.io](https://docs.n8n.io)
- **Community Forum:** [https://community.n8n.io](https://community.n8n.io)
- **GitHub Repository:** [https://github.com/n8n-io/n8n](https://github.com/n8n-io/n8n)
- **Workflow Templates:** [https://n8n.io/workflows](https://n8n.io/workflows)
- **YouTube Channel:** [https://www.youtube.com/@n8n-io](https://www.youtube.com/@n8n-io)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

Created by [web3Leander](https://github.com/web3Leander)

## ⭐ Credits

- **n8n** is developed and maintained by [n8n GmbH](https://n8n.io)
- This installer is a community contribution to make n8n more accessible on Windows

## 🔗 Links

- [Report Issues](https://github.com/web3Leander/n8n-windows-community-installer/issues)
- [Request Features](https://github.com/web3Leander/n8n-windows-community-installer/issues)

---

Made with ❤️ for the n8n community
