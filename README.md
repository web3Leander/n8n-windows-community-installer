# n8n Windows Community Installer

An unofficial, community-created installation wizard for [n8n](https://n8n.io) on Windows systems.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1.6-blue.svg)](https://github.com/web3Leander/n8n-windows-community-installer)

## ⚠️ IMPORTANT DISCLAIMER

**This is an UNOFFICIAL community-made installer and is NOT affiliated with, endorsed by, or connected to n8n.io or n8n GmbH in any way.**

For official n8n support, please visit:

- [n8n Official Website](https://n8n.io)
- [n8n GitHub Repository](https://github.com/n8n-io/n8n)
- [n8n Community Forum](https://community.n8n.io)
- [n8n Documentation](https://docs.n8n.io)

For issues with this installer, please open an issue in this repository.

## 📋 Overview

This installer is a guided Windows batch wizard for setting up [n8n](https://n8n.io) without having to assemble every command by hand. It supports native npm installs and Docker-based installs, then writes a local `README.txt` with the exact settings chosen during setup.

It is designed for local development, personal automation, and small Windows-hosted n8n setups. For hardened production deployments, use this as a starting point and review n8n's official production guidance.

## ✨ Features

- **Three installation methods**
  - Global npm install with the `n8n` command available system-wide
  - Folder-specific npm install for isolated or test instances
  - Docker install using the official `docker.n8n.io/n8nio/n8n` image

- **n8n 2.x compatibility checks**
  - Native installs require Node.js `20.19+` or `22.x LTS`
  - Unsupported current releases such as Node.js 25 are blocked before `npm install`
  - Docker installs avoid forcing external task-runner flags and let n8n use its default runner behavior

- **Guided setup and safety checks**
  - Checks Node.js, npm, Docker availability, and default port `5678`
  - Detects existing global, folder, or Docker installations before overwriting
  - Checks available disk space for native installs
  - Prompts for folder paths, Docker container/volume names, host, port, update checks, and shortcuts

- **Windows-friendly launch configuration**
  - Creates `start_n8n.bat` for global and folder installs
  - Sets `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false` for native Windows launches
  - Optionally creates a desktop shortcut for the current user or all users
  - Optionally checks for n8n updates whenever the generated start script runs

- **Generated documentation**
  - Writes a `README.txt` with the selected install type, paths, ports, Docker names, and useful commands
  - Documents data folder behavior and backup reminders
  - Includes troubleshooting notes for the installed instance

## 📦 System Requirements

### Required for the installer

- **Operating system:** Windows 10 or Windows 11, 64-bit
- **PowerShell:** 5.1 or later, included with Windows
- **Internet connection:** Required to download npm packages or Docker images
- **Node.js and npm:** The current wizard checks for both before installation choices are shown

### Native npm requirements

- **Node.js:** `20.19+` or `22.x LTS` from [nodejs.org](https://nodejs.org/)
- **npm:** Included with supported Node.js versions
- **Disk space:** At least 1.2 GB free on the target drive
- **Administrator rights:** Optional, but recommended for global installs and all-users shortcuts

Avoid Node.js 24+, Node.js 25, and other unsupported current release lines for native npm installs. They can force native dependency compilation and fail with `node-gyp`, Python, or Visual Studio build-tool errors.

### Docker requirements

- **Docker Desktop:** Installed and running from [docker.com](https://www.docker.com/products/docker-desktop)
- **Docker volume storage:** Enough space for workflows, credentials, logs, and package data

If Docker is available, the installer can offer Docker even when the detected Node.js version is not supported for native installs.

## 🚀 Quick Start

1. Download `n8n-Installer.bat`.
2. Install Node.js `22.x LTS` for the smoothest native install path.
3. Start Docker Desktop first if you plan to use Docker.
4. Right-click `n8n-Installer.bat` and choose **Run as Administrator** when using global installs or all-users shortcuts.
5. Follow the prompts and confirm the final summary.
6. Start n8n with the generated `start_n8n.bat`, Docker Desktop, or the Docker command shown in the generated `README.txt`.

## 📖 Installation Options

### Global Installation

Uses `npm install -g n8n`.

- Best when you want the `n8n` command available from any terminal
- Creates the launcher and generated README under `%USERPROFILE%\n8n`
- Can detect and confirm before replacing an existing global n8n package
- Supports optional start-time update checks with `npm update -g n8n`

### Folder-Specific Installation

Uses `npm install n8n` inside a folder you choose.

- Best for isolated installs, testing, and multiple side-by-side instances
- Keeps the package, launcher, generated README, and data base path together
- Adds the folder's `node_modules\.bin` path to the current user's PATH
- Supports optional start-time update checks with `npm update n8n`

### Docker Installation

Creates a Docker volume, pulls the official n8n image, and starts one container.

- Best when you want a containerized n8n runtime
- Lets you choose the container name and Docker volume name
- Auto-detects the Windows timezone and maps common zones to IANA names
- Maps your chosen Windows port to container port `5678`
- Uses Docker Desktop or Docker CLI commands for start, stop, logs, and updates

The installer runs a single n8n container. It does not enable external task runners or start a separate `n8nio/runners` container.

## 🎯 How It Works

1. **System verification** checks Node.js, npm, Docker status, and default port `5678`.
2. **Installation setup** collects the install type, target folder or Docker names, network settings, update preference, and shortcut preference.
3. **Installation** runs npm or Docker commands and verifies that n8n was installed or the container started.
4. **Completion** creates generated documentation and, for native installs, a configured `start_n8n.bat` launcher.

## 🔧 Network Configuration

### Native network settings

For global and folder installs, the wizard asks for both host and port.

- `127.0.0.1` keeps n8n available only on the local computer and is the default.
- `0.0.0.0` listens on all network interfaces and can expose n8n to your LAN.
- A specific local IP such as `192.168.1.100` limits listening to that interface.
- Port `5678` is the default, with common alternatives such as `3000`, `5000`, or `8080`.

### Docker network settings

For Docker installs, the wizard asks for the Windows host port only. The container always listens on port `5678` internally, and Docker maps your chosen host port to it.

### Security Notes

- Prefer `127.0.0.1` for personal/local use.
- Use `0.0.0.0` only when you intentionally need LAN access.
- Check Windows Firewall rules when exposing n8n beyond localhost.
- Add HTTPS, authentication, backups, and process supervision before treating an installation as production-ready.

## 📁 What Gets Installed

### Native installed files

- n8n installed through npm
- A configured `start_n8n.bat` launcher
- A generated `README.txt` with the exact paths and settings chosen
- A data folder created by n8n on first launch
- Optional desktop shortcut

The generated start script sets:

```batch
N8N_USER_FOLDER=<your configured data base path>
N8N_HOST=<your selected host>
N8N_PORT=<your selected port>
N8N_PROTOCOL=http
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false
```

n8n stores workflows, credentials, settings, the local database, and the encryption key in its user folder. The generated `README.txt` shows the exact path for the installation you created.

### Docker installed files

- One Docker container running `docker.n8n.io/n8nio/n8n`
- One Docker volume mounted to `/home/node/.n8n`
- Port mapping from your selected Windows port to container port `5678`
- A generated `README.txt` in the installer folder with container and volume details

## 🔐 Backup Your Encryption Key

On first startup, n8n creates an encryption key used to protect credentials and other sensitive data. Back up the full n8n data folder or Docker volume, not only exported workflows.

Back up before:

- Upgrading n8n
- Moving an installation
- Reinstalling Windows or changing computers
- Deleting a folder, global package, container, or Docker volume

Without the original encryption key, encrypted credentials cannot be recovered.

## 🎯 Usage

### Starting n8n

For global or folder installs, run:

```batch
start_n8n.bat
```

Use the generated shortcut if you created one, or run the script from a terminal to keep logs visible.

For Docker installs, run:

```bash
docker start n8n
```

Replace `n8n` with your custom container name if you chose one during setup.

### Stopping n8n

- Native installs: press `Ctrl+C` in the terminal running n8n.
- Docker installs: use Docker Desktop or run `docker stop <container-name>`.

### Viewing Logs

- Native installs: read the terminal window running `start_n8n.bat`.
- Docker installs: run `docker logs -f <container-name>`.

### Updating n8n

Native start scripts can optionally check for updates each time they run. You can also update manually:

```bash
npm install -g n8n@latest
```

For folder installs, run this in the installation folder:

```bash
npm install n8n@latest
```

For Docker installs, pull the latest image and recreate the container with the same volume. The Docker volume keeps your n8n data.

## 🛠️ Troubleshooting

### Unsupported Node.js version

Native npm installs require Node.js `20.19+` or `22.x LTS`. If you see a warning about Node.js 24, 25, or another unsupported current release, install Node.js 22 LTS and rerun the installer.

Check your version with:

```bash
node --version
```

### `isolated-vm`, `node-gyp`, Python, or build tools errors

These usually happen when npm cannot use a prebuilt native package for your Node version and tries to compile locally. Use Node.js 22 LTS for native installs. Installing Python or Visual Studio build tools is usually the wrong fix for this installer path.

### npm peer dependency warnings

n8n has a large dependency tree, so npm may print peer dependency or deprecation warnings. Warnings are not always fatal. The installer fails only if npm exits with an error and n8n is not found afterward.

### n8n starts but the browser cannot connect

- Confirm the terminal or Docker container is still running.
- Try `http://localhost:5678` or the custom port you selected.
- Check whether the port is already in use: `netstat -ano | findstr :5678`.
- Review Windows Firewall rules if you selected `0.0.0.0` or a LAN IP.

### Windows settings file permission errors

Use the generated `start_n8n.bat`. It disables strict Linux-style settings file permission enforcement for native Windows installs with `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false`.

### Docker container does not start

Check container status and logs:

```bash
docker ps -a
docker logs -f <container-name>
```

If the container name already exists, remove it only after confirming your data is in the Docker volume you expect:

```bash
docker rm -f <container-name>
```

### Cleanup warnings on Windows

If npm reports `EPERM`, `EBUSY`, or locked `node_modules` folders, close terminals and editors using that install folder, stop any running n8n process, and try again. For folder installs, starting with an empty folder is often the cleanest recovery.

For more help, visit the [n8n Community Forum](https://community.n8n.io).

## ❓ Frequently Asked Questions

### Can I run multiple n8n instances?

Yes. Use folder-specific installs with different folders and ports, or Docker installs with different container names, volumes, and host ports.

### Does this work with Docker?

Yes. Docker Desktop must be installed and running. The installer creates one n8n container and one Docker volume, then documents the names in the generated `README.txt`.

### Is my data safe?

The installer stores data locally in your n8n user folder or Docker volume and does not send workflows or credentials anywhere. Your responsibility is backing up the full data folder or Docker volume so the encryption key is preserved.

### How do I uninstall n8n?

For global installs:

```bash
npm uninstall -g n8n
```

Then remove the generated `%USERPROFILE%\n8n` folder and your n8n data folder if you no longer need the data.

For folder installs, delete the installation folder after backing up any data you want to keep. If the installer added `node_modules\.bin` to PATH, remove that entry from the user environment variables.

For Docker installs, remove the container and, only if you no longer need the data, the Docker volume:

```bash
docker rm -f <container-name>
docker volume rm <volume-name>
```

### Can I move my installation to another computer?

Yes, but preserve the encryption key.

- Native installs: back up the full n8n data folder and restore it before first launch on the new machine.
- Folder installs: also copy or recreate the installation folder and update paths in `start_n8n.bat` if needed.
- Docker installs: back up and restore the Docker volume, then recreate the container with the same volume.

### Can I use this in production?

This installer can help bootstrap a Windows installation, but production use needs additional hardening: HTTPS, authentication, backups, monitoring, process supervision, and the official n8n production guidance.

## 🚀 Roadmap Ideas

Future improvements that would fit this installer include:

- Backup and restore helpers for native data folders
- Docker volume backup and restore helpers
- An uninstaller workflow
- Process manager integration with PM2 or NSSM
- More complete Docker update and recreate tooling

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
