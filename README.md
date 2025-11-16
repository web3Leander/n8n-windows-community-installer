# n8n Windows Community Installer

An unofficial, community-created installation wizard for [n8n](https://n8n.io) on Windows systems.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1-blue.svg)](https://github.com/web3Leander/n8n-windows-community-installer)

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

- **Two Installation Modes:**
  - Quick Install: Fast, standard setup with sensible defaults
  - Custom Install: Full control over every aspect of the installation

- **Flexible Installation Options:**
  - Global installation (system-wide npm install)
  - Folder-specific installation (isolated, portable setup)
  - Custom data directory selection
  - Network configuration (custom host/IP and port)

- **Smart Installation:**
  - Automatic prerequisite checking (Node.js and npm)
  - Installation verification (ignores npm warnings, validates actual installation)
  - Automatic PATH configuration for folder installations
  - Creates ready-to-use start scripts

- **Complete Documentation:**
  - Generates comprehensive README.txt in installation folder
  - Includes quick start guide, troubleshooting tips, and resource links
  - Start scripts with configured network settings

## 📦 System Requirements

### Required

- **Operating System:** Windows 10 or Windows 11 (64-bit)
- **Node.js:** Version 18.x or later ([Download](https://nodejs.org/))
  - Recommended: Latest LTS version
- **npm:** Version 8.x or later (included with Node.js)
- **PowerShell:** 5.1 or later (included with Windows)

### Recommended

- **RAM:** 4GB minimum, 8GB recommended
- **Disk Space:** 2GB free space for n8n and dependencies
- **Internet Connection:** Required for downloading n8n packages
- **Administrator Rights:** Optional, but recommended for global installations

## 🚀 Quick Start

1. **Download** the `n8n-Installer.bat` file
2. **Right-click** and select "Run as Administrator" (optional, but recommended for global installations)
3. **Follow the prompts** in the installation wizard
4. **Start n8n** using the generated start script or command

## 📖 Installation Modes

### Quick Install

Perfect for users who want to get started quickly with standard settings:

```
1. Installs n8n globally via npm
2. Data stored in: %USERPROFILE%\.n8n
3. Configure network settings (host and port)
4. Ready to use with 'n8n start' command
```

### Custom Install

For users who need more control:

```
1. Choose between global or folder-specific installation
2. Select custom data directory
3. Configure network settings (host/IP and port)
4. Automatic PATH configuration
5. Generated start scripts with your settings
```

### Installation Mode Comparison

| Feature | Quick Install | Custom Install |
|---------|--------------|----------------|
| Installation Speed | ⚡ Fast | ⏱️ Moderate |
| Installation Type | Global only | Global or Folder |
| Data Directory | Default (`%USERPROFILE%\.n8n`) | Custom location |
| Network Config | Configurable | Configurable |
| Command Access | `n8n` (system-wide) | `n8n` or local script |
| Best For | Quick setup, single instance | Multiple instances, testing, portable setups |

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

- **n8n application** (globally or in your chosen folder)
- **start_n8n.bat** - Configured start script
- **README.txt** - Complete installation documentation
- **Data folder** - Your workflows, credentials, and settings

## 🎯 Usage

### Starting n8n

After installation:

1. **Using the start script:**
   ```
   Double-click start_n8n.bat
   ```

2. **Using command line** (global install):
   ```
   n8n start
   ```

3. **Access the web interface:**
   ```
   Open your browser to: http://localhost:5678
   (or your configured host:port)
   ```

### Stopping n8n

Press `Ctrl+C` in the terminal window where n8n is running.

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

<details>
<summary><strong>Can I run multiple n8n instances?</strong></summary>

Yes! Use the Custom Install option with folder-specific installations. Install each instance to a different folder with different ports, and each will run independently with its own data.
</details>

<details>
<summary><strong>How do I uninstall n8n?</strong></summary>

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
</details>

<details>
<summary><strong>How do I upgrade n8n?</strong></summary>

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
</details>

<details>
<summary><strong>Can I move my installation to another computer?</strong></summary>

Yes! For folder installations, copy the entire installation folder and data directory. Update the paths in `start_n8n.bat`. For global installations, you'll need to reinstall globally on the new machine and copy over your data directory.
</details>

<details>
<summary><strong>Does this work with Docker?</strong></summary>

Not yet, but Docker installation support is planned for a future release! For now, this installer handles native Windows installations only.
</details>

<details>
<summary><strong>Is my data safe?</strong></summary>

Yes! All your workflows, credentials, and settings are stored locally in your data directory. This installer doesn't send any data anywhere. Always backup your data directory before major updates.
</details>

<details>
<summary><strong>Can I use this in a production environment?</strong></summary>

This installer sets up n8n for you, but for production use, consider:
- Using a process manager (PM2, NSSM)
- Setting up automatic backups
- Configuring HTTPS with proper certificates
- Using authentication and proper security measures
- Reviewing n8n's official production setup guide
</details>

## 🚀 Upcoming Features

We're actively working on enhancing this installer! Planned features include:

- **Docker Installation Support** - Option to install and run n8n in Docker containers
- **Update Manager** - Check for and install n8n updates directly from the installer
- **Backup/Restore Tools** - Easy backup and restoration of your workflows and settings
- **Port Validation** - Automatic port availability checking before installation

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

**Made with ❤️ for the n8n community**
