@echo off
REM n8n Installation Wizard for Windows
REM Interactive step-by-step installer with full customization

chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

REM Catch all exits
set "SCRIPTDIR=%~dp0"
if not defined SCRIPTDIR set "SCRIPTDIR=%CD%"
goto START

:END_SCRIPT
echo.
echo [DEBUG] Script ended unexpectedly at this point
pause
exit /b 1

:START
cls
echo.
echo  ══════════════════════════════════════════════════════════════
echo      n8n Installation Wizard for Windows
echo      Community Edition - Version 0.1.5
echo  ══════════════════════════════════════════════════════════════
echo.
echo  IMPORTANT NOTICE:
echo  This is an UNOFFICIAL community-made installer.
echo  NOT affiliated with n8n.io or n8n GmbH.
echo.
echo  Created by: https://github.com/web3Leander
echo  n8n Official: https://n8n.io
echo.
echo  Press any key to continue...
pause >nul

cls
echo.
echo  ════════════════════════════════════════
echo      n8n Installation Wizard
echo  ════════════════════════════════════════
echo.
echo  Step 1 of 4: Verifying System Requirements
echo  ────────────────────────────────────────
echo.

REM Step 1: Check prerequisites
echo  Checking Node.js...
where node >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo  [✗] Node.js is not detected
    echo.
    echo      Please install Node.js before continuing.
    echo      Download: https://nodejs.org/
    echo.
    echo      Recommended: Node.js 18.x or later
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo  [✓] Node.js %NODE_VERSION%

echo.
echo  Checking npm...
where npm >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo  [✗] npm is not detected
    echo.
    echo      npm should be installed with Node.js.
    echo      Download: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
echo  [✓] npm %NPM_VERSION%

echo.
echo  Checking Docker...
where docker >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    set "DOCKER_AVAILABLE=NO"
) else (
    REM Check if Docker is running
    docker ps >nul 2>&1
    if !ERRORLEVEL! NEQ 0 (
        set "DOCKER_AVAILABLE=NO"
    ) else (
        for /f "tokens=*" %%i in ('docker --version') do set DOCKER_VERSION=%%i
        echo  [✓] !DOCKER_VERSION!
        set "DOCKER_AVAILABLE=YES"
    )
)

REM Check for updates (informational only)
echo.
echo  Checking for updates...
echo.

REM Get latest Node.js LTS version (approximate check)
set "NODE_MAJOR=%NODE_VERSION:~1,2%"
if %NODE_MAJOR% GEQ 22 (
    echo  [✓] Node.js %NODE_VERSION% - Latest version
) else if %NODE_MAJOR% GEQ 18 (
    echo  [!] Node.js %NODE_VERSION% - Update available
    echo      Visit: https://nodejs.org/
) else (
    echo  [!] Node.js %NODE_VERSION% - Outdated
    echo      Recommended: Node.js 18.x or later
    echo      Download: https://nodejs.org/
)

REM Get latest npm version info
echo.
for /f "tokens=*" %%i in ('npm view npm version 2^>nul') do set NPM_LATEST=%%i

if defined NPM_LATEST (
    if "%NPM_VERSION%"=="%NPM_LATEST%" (
        echo  [✓] npm %NPM_VERSION% - Latest version
    ) else (
        echo  [!] npm %NPM_VERSION% - Update available: %NPM_LATEST%
        echo.
        set /p "UPDATE_NPM=      Update npm now? (Y/N): "
        if /i "!UPDATE_NPM!"=="Y" (
            echo.
            echo      Installing npm update...
            call npm install -g npm@latest
            if !ERRORLEVEL! EQU 0 (
                echo.
                echo      [✓] npm updated successfully
                for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
                echo      [✓] npm is now version !NPM_VERSION!
            ) else (
                echo.
                echo      [✗] npm update failed, continuing
            )
        )
    )
) else (
    echo  [✓] npm %NPM_VERSION% - Latest version
)

echo.
echo  ════════════════════════════════════════
echo   Prerequisites Verified
echo  ════════════════════════════════════════
echo.
echo   Node.js: %NODE_VERSION%
echo   npm:     %NPM_VERSION%
if "%DOCKER_AVAILABLE%"=="YES" (
    echo   Docker:  Available
) else (
    echo   Docker:  Not available ^(optional^)
)

REM Check if default port 5678 is in use
echo.
echo  Checking default port 5678...
netstat -an 2>nul | findstr /C:":5678 " | findstr /C:"LISTENING" >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo  [!] Warning: Port 5678 is already in use
    echo      You will need to choose a different port during setup
    set "DEFAULT_PORT_IN_USE=YES"
) else (
    echo  [✓] Port 5678 is available
    set "DEFAULT_PORT_IN_USE=NO"
)

echo.
set /p "CONTINUE=  Ready to proceed? (Y/N): "
if /i not "%CONTINUE%"=="Y" (
    echo.
    echo  Installation cancelled.
    pause
    exit /b 0
)

cls

REM Step 2: Installation setup
:CUSTOM_INSTALL
cls
echo.
echo  ════════════════════════════════════════
echo      n8n Installation Wizard
echo  ════════════════════════════════════════
echo.
echo  Step 2 of 4: Installation Setup
echo  ────────────────────────────────────────
echo.

REM Sub-step: n8n installation type
:ASK_N8N_TYPE
echo  n8n Program Installation
echo  ────────────────────────────────────────
echo.
echo  1. Global Installation
echo     • npm install -g n8n
echo     • n8n command available system-wide
echo     • Standard installation method
echo     • NOTE: Will overwrite existing global n8n
echo.
echo  2. Folder-Specific Installation
echo     • Install to a folder you choose
echo     • Completely isolated installation
echo     • Won't affect global n8n installation
echo     • Useful for testing or multiple versions
echo.
if "%DOCKER_AVAILABLE%"=="YES" (
    echo  3. Docker Installation
    echo     • Run n8n in a Docker container
    echo     • Completely isolated and portable
    echo     • Easy updates and backups
    echo     • Requires Docker Desktop
    echo.
)
if "%DOCKER_AVAILABLE%"=="YES" (
    set /p "N8N_TYPE=  Your choice (1, 2, or 3): "
) else (
    set /p "N8N_TYPE=  Your choice (1 or 2): "
)

if "%N8N_TYPE%"=="1" (
    set "N8N_INSTALL_TYPE=GLOBAL"
    set "N8N_INSTALL_PATH=Global npm packages"
    
    REM Check if n8n is already installed globally
    where n8n >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        for /f "tokens=*" %%i in ('n8n --version 2^>nul') do set EXISTING_N8N=%%i
        if defined EXISTING_N8N (
            echo.
            echo  ════════════════════════════════════════
            echo   WARNING: Existing Installation Detected
            echo  ════════════════════════════════════════
            echo.
            echo  An existing global n8n installation was found:
            echo  Version: !EXISTING_N8N!
            echo.
            echo  Installing globally will OVERWRITE the n8n program.
            echo.
            echo  IMPORTANT:
            echo  • Your workflows, credentials, and settings are
            echo    stored in your data folder and will be preserved
            echo  • The n8n program itself will be replaced
            echo.
            echo  ════════════════════════════════════════
            echo   CONFIRMATION REQUIRED
            echo  ════════════════════════════════════════
            echo.
            echo  To proceed with overwriting the existing installation,
            echo  you must type: DELETE
            echo.
            echo  Type DELETE in CAPITAL LETTERS to confirm, or
            echo  type anything else to cancel and go back.
            echo.
            set /p "OVERWRITE_CONFIRM=  Type DELETE to confirm: "
            if not "!OVERWRITE_CONFIRM!"=="DELETE" (
                echo.
                echo  Installation cancelled. Returning to selection...
                timeout /t 2 /nobreak >nul
                cls
                echo.
                echo  ════════════════════════════════════════
                echo      n8n Installation Wizard
                echo  ════════════════════════════════════════
                echo.
                echo  Step 2 of 4: Installation Setup
                echo  ────────────────────────────────────────
                echo.
                goto ASK_N8N_TYPE
            )
            echo.
            echo  Confirmation accepted. Proceeding...
            timeout /t 2 /nobreak >nul
        )
    )
    
    echo.
    echo  [✓] Selected: Global installation
) else if "%N8N_TYPE%"=="2" (
    set "N8N_INSTALL_TYPE=FOLDER"
    echo.
    echo  Enter the full folder path for n8n installation.
    echo.
    echo  Example:  C:\tools\n8n
    echo        or  D:\apps\n8n
    echo.
    set /p "N8N_INSTALL_PATH=  Path: "
    if not exist "!N8N_INSTALL_PATH!" (
        echo.
        echo  [!] Folder does not exist: !N8N_INSTALL_PATH!
        echo.
        set /p "CREATE_N8N_DIR=  Create this folder? (Y/N): "
        if /i not "!CREATE_N8N_DIR!"=="Y" (
            echo.
            echo  Please enter a valid folder path.
            timeout /t 2 /nobreak >nul
            cls
            echo.
            echo  ════════════════════════════════════════
            echo      n8n Installation Wizard
            echo  ════════════════════════════════════════
            echo.
            echo  Step 2 of 4: Installation Setup
            echo  ────────────────────────────────────────
            echo.
            goto ASK_N8N_TYPE
        )
        mkdir "!N8N_INSTALL_PATH!" 2>nul
        if !ERRORLEVEL! NEQ 0 (
            echo.
            echo  [✗] Could not create folder!
            pause
            cls
            echo.
            echo  ════════════════════════════════════════
            echo      n8n Installation Wizard
            echo  ════════════════════════════════════════
            echo.
            echo  Step 2 of 4: Installation Setup
            echo  ────────────────────────────────────────
            echo.
            goto ASK_N8N_TYPE
        )
    ) else (
        REM Folder exists - check if n8n is already installed there
        if exist "!N8N_INSTALL_PATH!\node_modules\n8n" (
            echo.
            echo  ════════════════════════════════════════
            echo   WARNING: Existing Installation Detected
            echo  ════════════════════════════════════════
            echo.
            echo  n8n is already installed in this folder:
            echo  !N8N_INSTALL_PATH!
            echo.
            echo  Reinstalling will OVERWRITE the n8n program files.
            echo.
            echo  IMPORTANT:
            echo  • Your workflows, credentials, and settings in the
            echo    .n8n data folder will be preserved
            echo  • Only the n8n program files will be replaced
            echo.
            echo  ════════════════════════════════════════
            echo   CONFIRMATION REQUIRED
            echo  ════════════════════════════════════════
            echo.
            echo  To proceed with overwriting the existing installation,
            echo  you must type: DELETE
            echo.
            echo  Type DELETE in CAPITAL LETTERS to confirm, or
            echo  type anything else to cancel and go back.
            echo.
            set /p "FOLDER_OVERWRITE_CONFIRM=  Type DELETE to confirm: "
            if not "!FOLDER_OVERWRITE_CONFIRM!"=="DELETE" (
                echo.
                echo  Installation cancelled. Returning to selection...
                timeout /t 2 /nobreak >nul
                cls
                echo.
                echo  ════════════════════════════════════════
                echo      n8n Installation Wizard
                echo  ════════════════════════════════════════
                echo.
                echo  Step 2 of 4: Installation Setup
                echo  ────────────────────────────────────────
                echo.
                goto ASK_N8N_TYPE
            )
            echo.
            echo  Confirmation accepted. Proceeding...
            timeout /t 2 /nobreak >nul
        )
    )
    echo.
    echo  [✓] Selected: Folder installation
    echo      Location: !N8N_INSTALL_PATH!
) else if "%N8N_TYPE%"=="3" (
    if not "%DOCKER_AVAILABLE%"=="YES" (
        echo.
        echo  [✗] Docker is not available. Please choose option 1 or 2.
        timeout /t 2 /nobreak >nul
        cls
        echo.
        echo  ════════════════════════════════════════
        echo      n8n Installation Wizard
        echo  ════════════════════════════════════════
        echo.
        echo  Step 2 of 4: Installation Setup
        echo  ────────────────────────────────────────
        echo.
        goto ASK_N8N_TYPE
    )
    set "N8N_INSTALL_TYPE=DOCKER"
    set "N8N_INSTALL_PATH=Docker Container"
    echo.
    echo  [✓] Selected: Docker installation
) else (
    echo.
    if "%DOCKER_AVAILABLE%"=="YES" (
        echo  [✗] Invalid choice. Please enter 1, 2, or 3.
    ) else (
        echo  [✗] Invalid choice. Please enter 1 or 2.
    )
    timeout /t 2 /nobreak >nul
    cls
    echo.
    echo  ════════════════════════════════════════
    echo      n8n Installation Wizard
    echo  ════════════════════════════════════════
    echo.
    echo  Step 2 of 4: Installation Setup
    echo  ────────────────────────────────────────
    echo.
    goto ASK_N8N_TYPE
)

REM Set data path based on installation type
if "!N8N_INSTALL_TYPE!"=="GLOBAL" (
    set "N8N_DATA_PATH=%USERPROFILE%\.n8n"
    set "TARGET_DRIVE=%SYSTEMDRIVE%"
) else if "!N8N_INSTALL_TYPE!"=="DOCKER" (
    set "N8N_DATA_PATH=Docker Volume"
    set "TARGET_DRIVE="
) else (
    set "N8N_DATA_PATH=!N8N_INSTALL_PATH!"
    set "TARGET_DRIVE=!N8N_INSTALL_PATH:~0,2!"
)

REM Check disk space on target drive (need at least 1.2GB) - skip for Docker
if not "!N8N_INSTALL_TYPE!"=="DOCKER" (
echo.
echo  Checking disk space on !TARGET_DRIVE!...
for /f "tokens=3" %%a in ('dir !TARGET_DRIVE!\ 2^>nul ^| findstr /C:"bytes free"') do set "FREE_SPACE_STR=%%a"
set "FREE_SPACE_STR=!FREE_SPACE_STR:,=!"
set /a "FREE_SPACE_MB=!FREE_SPACE_STR:~0,-6!" 2>nul
if !FREE_SPACE_MB! GEQ 1200 (
    echo  [✓] Disk space on !TARGET_DRIVE!: !FREE_SPACE_MB! MB available
) else if !FREE_SPACE_MB! GEQ 1 (
    echo  [!] Warning: Low disk space on !TARGET_DRIVE! ^(!FREE_SPACE_MB! MB^)
    echo      n8n installation requires approximately 1.2 GB
    echo.
    set /p "CONTINUE_LOW_SPACE=  Continue anyway? (Y/N): "
    if /i not "!CONTINUE_LOW_SPACE!"=="Y" (
        echo.
        echo  Returning to installation setup...
        timeout /t 2 /nobreak >nul
        cls
        echo.
        echo  ════════════════════════════════════════
        echo      n8n Installation Wizard
        echo  ════════════════════════════════════════
        echo.
        echo  Step 2 of 4: Installation Setup
        echo  ────────────────────────────────────────
        echo.
        goto ASK_N8N_TYPE
    )
) else (
    REM Fallback if calculation failed - just note we couldn't check
    echo  [i] Disk space: Could not determine ^(ensure 1.2+ GB free on !TARGET_DRIVE!^)
)
)

echo.
if "!N8N_INSTALL_TYPE!"=="DOCKER" (
    echo  [i] n8n data will be stored in Docker volume
) else (
    echo  [i] n8n will store data at: !N8N_DATA_PATH!\.n8n\
    echo      ^(n8n automatically creates the .n8n subfolder^)
)
echo.
set /p "CONFIRM_N8N=  Confirm choice? (Y/N): "
if /i not "%CONFIRM_N8N%"=="Y" (
    cls
    echo.
    echo  ════════════════════════════════════════
    echo      n8n Installation Wizard
    echo  ════════════════════════════════════════
    echo.
    echo  Step 2 of 4: Installation Setup
    echo  ────────────────────────────────────────
    echo.
    goto ASK_N8N_TYPE
)

REM Sub-step: Docker Configuration (if Docker installation selected)
if not "%N8N_INSTALL_TYPE%"=="DOCKER" goto SKIP_DOCKER_CONFIG

:ASK_DOCKER_CONFIG
echo.
echo.
echo  Docker Configuration
echo  ────────────────────────────────────────
echo.
echo  Configure Docker container settings.
echo.

REM Container name
echo  Container Name:
echo  • Press Enter for default: n8n
echo  • Or enter a custom name (no spaces)
echo.
set /p "DOCKER_CONTAINER_INPUT=  Container name (default: n8n): "
if "!DOCKER_CONTAINER_INPUT!"=="" set "DOCKER_CONTAINER=n8n"
if defined DOCKER_CONTAINER_INPUT set "DOCKER_CONTAINER=!DOCKER_CONTAINER_INPUT!"

REM Check if container with this name already exists
docker ps -a --format "{{.Names}}" 2>nul | findstr /X /C:"!DOCKER_CONTAINER!" >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo.
    echo  ════════════════════════════════════════
    echo   WARNING: Container Already Exists
    echo  ════════════════════════════════════════
    echo.
    echo  A Docker container named "!DOCKER_CONTAINER!" already exists.
    echo.
    echo  Options:
    echo  1. Remove the existing container and create new
    echo  2. Choose a different container name
    echo.
    set /p "CONTAINER_ACTION=  Your choice (1 or 2): "
    if "!CONTAINER_ACTION!"=="1" (
        echo.
        echo  Stopping and removing existing container...
        docker stop !DOCKER_CONTAINER! >nul 2>&1
        docker rm !DOCKER_CONTAINER! >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            echo  [✓] Existing container removed
        ) else (
            echo  [✗] Failed to remove container. Please remove manually:
            echo      docker rm -f !DOCKER_CONTAINER!
            pause
            goto ASK_DOCKER_CONFIG
        )
    ) else (
        echo.
        echo  Please enter a different container name.
        timeout /t 2 /nobreak >nul
        cls
        echo.
        echo  ════════════════════════════════════════
        echo      n8n Installation Wizard
        echo  ════════════════════════════════════════
        echo.
        echo  Step 2 of 4: Installation Setup
        echo  ────────────────────────────────────────
        echo.
        goto ASK_DOCKER_CONFIG
    )
)

echo.
REM Volume name
echo  Data Volume Name:
echo  • Press Enter for default: n8n_data
echo  • Or enter a custom volume name
echo.
set /p "DOCKER_VOLUME_INPUT=  Volume name (default: n8n_data): "
if "!DOCKER_VOLUME_INPUT!"=="" set "DOCKER_VOLUME=n8n_data"
if defined DOCKER_VOLUME_INPUT set "DOCKER_VOLUME=!DOCKER_VOLUME_INPUT!"

REM Auto-detect timezone from Windows and convert to IANA format
for /f "tokens=*" %%t in ('powershell -Command "[System.TimeZoneInfo]::Local.Id"') do set "WIN_TZ=%%t"
set "DOCKER_TIMEZONE=UTC"
REM Map common Windows timezones to IANA format
if "!WIN_TZ!"=="Pacific Standard Time" set "DOCKER_TIMEZONE=America/Los_Angeles"
if "!WIN_TZ!"=="Mountain Standard Time" set "DOCKER_TIMEZONE=America/Denver"
if "!WIN_TZ!"=="Central Standard Time" set "DOCKER_TIMEZONE=America/Chicago"
if "!WIN_TZ!"=="Eastern Standard Time" set "DOCKER_TIMEZONE=America/New_York"
if "!WIN_TZ!"=="Atlantic Standard Time" set "DOCKER_TIMEZONE=America/Halifax"
if "!WIN_TZ!"=="GMT Standard Time" set "DOCKER_TIMEZONE=Europe/London"
if "!WIN_TZ!"=="W. Europe Standard Time" set "DOCKER_TIMEZONE=Europe/Amsterdam"
if "!WIN_TZ!"=="Central Europe Standard Time" set "DOCKER_TIMEZONE=Europe/Budapest"
if "!WIN_TZ!"=="Central European Standard Time" set "DOCKER_TIMEZONE=Europe/Warsaw"
if "!WIN_TZ!"=="Romance Standard Time" set "DOCKER_TIMEZONE=Europe/Paris"
if "!WIN_TZ!"=="FLE Standard Time" set "DOCKER_TIMEZONE=Europe/Kiev"
if "!WIN_TZ!"=="Russian Standard Time" set "DOCKER_TIMEZONE=Europe/Moscow"
if "!WIN_TZ!"=="India Standard Time" set "DOCKER_TIMEZONE=Asia/Kolkata"
if "!WIN_TZ!"=="China Standard Time" set "DOCKER_TIMEZONE=Asia/Shanghai"
if "!WIN_TZ!"=="Tokyo Standard Time" set "DOCKER_TIMEZONE=Asia/Tokyo"
if "!WIN_TZ!"=="Singapore Standard Time" set "DOCKER_TIMEZONE=Asia/Singapore"
if "!WIN_TZ!"=="AUS Eastern Standard Time" set "DOCKER_TIMEZONE=Australia/Sydney"
if "!WIN_TZ!"=="New Zealand Standard Time" set "DOCKER_TIMEZONE=Pacific/Auckland"

echo.
echo  [✓] Docker Configuration:
echo      Container: !DOCKER_CONTAINER!
echo      Volume:    !DOCKER_VOLUME!
echo      Timezone:  !DOCKER_TIMEZONE! (auto-detected)
echo.
set /p "CONFIRM_DOCKER=  Confirm Docker settings? (Y/N): "
if /i not "!CONFIRM_DOCKER!"=="Y" (
    cls
    echo.
    echo  ════════════════════════════════════════
    echo      n8n Installation Wizard
    echo  ════════════════════════════════════════
    echo.
    echo  Step 2 of 4: Installation Setup
    echo  ────────────────────────────────────────
    echo.
    goto ASK_DOCKER_CONFIG
)

:SKIP_DOCKER_CONFIG
REM Sub-step: Network Configuration
echo.
echo.
:ASK_NETWORK_CONFIG
echo  n8n Network Configuration
echo  ────────────────────────────────────────
echo.
if "!DEFAULT_PORT_IN_USE!"=="YES" (
    echo  [!] Note: Port 5678 is in use - please choose a different port
    echo.
)
if "%N8N_INSTALL_TYPE%"=="DOCKER" (
    echo  Configure the port for n8n to run on.
    echo  Docker will map this port to the container.
    echo.
    echo  Port Number:
    echo  • Press Enter for default: 5678
    echo  • Or enter a custom port (1024-65535)
    echo    Examples: 8080, 3000, 5000
    echo.
    set /p "N8N_PORT_INPUT=  Port (default: 5678): "
    if "!N8N_PORT_INPUT!"=="" set "N8N_PORT=5678"
    if defined N8N_PORT_INPUT set "N8N_PORT=!N8N_PORT_INPUT!"
    
    set "N8N_HOST=localhost"
    
    echo.
    echo  [✓] Network Configuration:
    echo      Port: !N8N_PORT!
    echo      URL:  http://localhost:!N8N_PORT!
    goto CONFIRM_NETWORK
)

echo  Configure the host and port for n8n to run on.
    echo.
    echo  Host/IP Address:
    echo  • Press Enter for default: 127.0.0.1 (localhost only)
    echo  • Or enter a custom IP address
    echo    Examples: 0.0.0.0 (all interfaces), 192.168.1.100 (specific local IP)
    echo.
    set /p "N8N_HOST_INPUT=  Host (default: 127.0.0.1): "
    if "!N8N_HOST_INPUT!"=="" set "N8N_HOST=127.0.0.1"
    if defined N8N_HOST_INPUT (
        if not "!N8N_HOST_INPUT!"=="" set "N8N_HOST=!N8N_HOST_INPUT!"
    )

    echo.
    echo  Port Number:
    echo  • Press Enter for default: 5678
    echo  • Or enter a custom port (1024-65535)
    echo    Examples: 8080, 3000, 5000
    echo.
    set /p "N8N_PORT_INPUT=  Port (default: 5678): "
    if "!N8N_PORT_INPUT!"=="" set "N8N_PORT=5678"
    if defined N8N_PORT_INPUT (
        if not "!N8N_PORT_INPUT!"=="" set "N8N_PORT=!N8N_PORT_INPUT!"
    )

    echo.
    echo  [✓] Network Configuration:
    echo      Host: !N8N_HOST!
    echo      Port: !N8N_PORT!
    echo      URL:  http://!N8N_HOST!:!N8N_PORT!

:CONFIRM_NETWORK
echo.
set /p "CONFIRM_NETWORK=  Confirm network settings? (Y/N): "
if /i not "!CONFIRM_NETWORK!"=="Y" (
    cls
    echo.
    echo  ════════════════════════════════════════
    echo      n8n Installation Wizard
    echo  ════════════════════════════════════════
    echo.
    echo  Step 2 of 4: Installation Setup
    echo  ────────────────────────────────────────
    echo.
    goto ASK_NETWORK_CONFIG
)

REM Auto-update option (not for Docker - Docker has its own update mechanism)
if not "!N8N_INSTALL_TYPE!"=="DOCKER" (
    echo.
    echo.
    echo  Auto-Update Configuration
    echo  ────────────────────────────────────────
    echo.
    echo  Would you like start_n8n.bat to check for updates?
    echo  • Each time you start n8n, it will check for newer versions
    echo  • You will be prompted before any update is installed
    echo.
    set /p "ENABLE_AUTO_UPDATE=  Enable auto-update check? (Y/N, default: N): "
    if /i "!ENABLE_AUTO_UPDATE!"=="Y" (
        set "AUTO_UPDATE=YES"
        echo.
        echo  [✓] Auto-update check enabled
    ) else (
        set "AUTO_UPDATE=NO"
        echo.
        echo  [✓] Auto-update check disabled
    )
)

REM Desktop shortcut option (not for Docker)
set "CREATE_SHORTCUT=NO"
set "SHORTCUT_PATH="
if not "!N8N_INSTALL_TYPE!"=="DOCKER" (
    echo.
    echo.
    echo  Desktop Shortcut
    echo  ────────────────────────────────────────
    echo.
    echo  Create a desktop shortcut for start_n8n.bat?
    echo.
    echo    [1] Current user only ^(%USERNAME%^)
    echo    [2] All users ^(Public Desktop^)
    echo    [N] No shortcut
    echo.
    set /p "SHORTCUT_CHOICE=  Your choice (1/2/N, default: N): "
    if "!SHORTCUT_CHOICE!"=="1" (
        set "CREATE_SHORTCUT=YES"
        set "SHORTCUT_PATH=%USERPROFILE%\Desktop"
        echo.
        echo  [✓] Shortcut will be created for %USERNAME%
    ) else if "!SHORTCUT_CHOICE!"=="2" (
        set "CREATE_SHORTCUT=YES"
        set "SHORTCUT_PATH=%PUBLIC%\Desktop"
        echo.
        echo  [✓] Shortcut will be created for all users
    ) else (
        echo.
        echo  [✓] No shortcut will be created
    )
)

REM Final confirmation
cls
echo.
echo  ════════════════════════════════════════
echo      n8n Installation Wizard
echo  ════════════════════════════════════════
echo.
echo  Step 2 of 4: Installation Summary
echo  ────────────────────────────────────────
echo.
echo  n8n Installation: !N8N_INSTALL_TYPE!
echo  Installation Path: !N8N_INSTALL_PATH!
echo  Data Directory: !N8N_DATA_PATH!
echo  Host: !N8N_HOST!
echo  Port: !N8N_PORT!
echo  Access URL: http://!N8N_HOST!:!N8N_PORT!
if not "!N8N_INSTALL_TYPE!"=="DOCKER" (
    echo  Auto-Update Check: !AUTO_UPDATE!
    echo  Desktop Shortcut: !CREATE_SHORTCUT!
)
echo.
set /p "FINAL_CONFIRM=  Proceed with installation? (Y/N): "
if /i not "!FINAL_CONFIRM!"=="Y" (
    echo.
    echo Returning to Installation Setup...
    timeout /t 2 /nobreak >nul
    goto CUSTOM_INSTALL
)
goto EXECUTE_INSTALL

:EXECUTE_INSTALL
REM Execute installation
cls
echo.
echo  ════════════════════════════════════════
echo      n8n Installation Wizard
echo  ════════════════════════════════════════
echo.
echo  Step 3 of 4: Installing n8n
echo  ────────────────────────────────────────
echo.

REM Ensure data directory exists (not needed for Docker)
if not "!N8N_INSTALL_TYPE!"=="DOCKER" (
    if not exist "!N8N_DATA_PATH!" (
        echo  Creating data directory...
        mkdir "!N8N_DATA_PATH!" 2>nul
        if !ERRORLEVEL! NEQ 0 (
            echo  [✗] Could not create data directory: !N8N_DATA_PATH!
            pause
            exit /b 1
        )
        echo  [✓] Data directory created
        echo.
    )
)

if "!N8N_INSTALL_TYPE!"=="GLOBAL" goto INSTALL_GLOBAL
if "!N8N_INSTALL_TYPE!"=="FOLDER" goto INSTALL_FOLDER
if "!N8N_INSTALL_TYPE!"=="DOCKER" goto INSTALL_DOCKER

REM If we get here, something went wrong
echo.
echo  [✗] Error: Installation type not recognized
echo  Type: [!N8N_INSTALL_TYPE!]
echo.
pause
exit /b 1

:INSTALL_GLOBAL
echo  Running: npm install -g n8n
echo  This may take a few minutes...
echo.
call npm install -g n8n
echo.
echo  Verifying installation...
where n8n >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo  [✗] Installation failed! n8n command not found.
    echo  Please check the error messages above.
    pause
    exit /b 1
)
echo  [✓] n8n installed globally
goto CREATE_START_SCRIPT

:INSTALL_FOLDER
echo  Running: npm install n8n in !N8N_INSTALL_PATH!
echo  This may take a few minutes...
echo.
cd /d "!N8N_INSTALL_PATH!"
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo  [✗] Could not change to directory: !N8N_INSTALL_PATH!
    pause
    exit /b 1
)
call npm install n8n
echo.
echo  Verifying installation...
if not exist "!N8N_INSTALL_PATH!\node_modules\n8n" (
    echo.
    echo  [✗] Installation failed! n8n not found in node_modules.
    echo  Please check the error messages above or review: !LOG_FILE!
    pause
    exit /b 1
)
echo  [✓] n8n installed to folder

REM Add to PATH if folder installation
set "N8N_BIN=!N8N_INSTALL_PATH!\node_modules\.bin"
echo.
echo  Adding !N8N_BIN! to PATH...

echo %PATH% | find /i "!N8N_BIN!" >nul
if !ERRORLEVEL! EQU 0 (
    echo  [✓] Already in PATH
) else (
    for /f "skip=2 tokens=3*" %%a in ('reg query HKCU\Environment /v PATH 2^>nul') do set "CURRENT_PATH=%%b"
    if "!CURRENT_PATH!"=="" (
        setx PATH "!N8N_BIN!"
    ) else (
        setx PATH "!N8N_BIN!;!CURRENT_PATH!"
    )
    echo  [✓] Added to PATH (restart terminal to use)
)
goto CREATE_START_SCRIPT

:INSTALL_DOCKER
echo  Creating Docker volume: !DOCKER_VOLUME!
echo.
docker volume create !DOCKER_VOLUME! 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo  [✗] Failed to create Docker volume
    pause
    exit /b 1
)
echo  [✓] Docker volume created
echo.

echo  Pulling n8n Docker image...
echo  This may take a few minutes...
echo.
docker pull docker.n8n.io/n8nio/n8n 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo  [✗] Failed to pull n8n Docker image
    pause
    exit /b 1
)
echo  [✓] n8n Docker image downloaded
echo.

echo  Starting n8n container: !DOCKER_CONTAINER!
echo.
docker run -d --name !DOCKER_CONTAINER! -p !N8N_PORT!:5678 -e GENERIC_TIMEZONE="!DOCKER_TIMEZONE!" -e TZ="!DOCKER_TIMEZONE!" -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true -e N8N_RUNNERS_ENABLED=true -v !DOCKER_VOLUME!:/home/node/.n8n docker.n8n.io/n8nio/n8n 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo  [✗] Failed to start n8n container
    echo  Note: If container already exists, run: docker rm !DOCKER_CONTAINER!
    pause
    exit /b 1
)
echo  [✓] n8n container started successfully
echo.

REM Wait a moment for container to start
echo  Waiting for container to initialize...
timeout /t 5 /nobreak >nul

REM Verify container is running
docker ps --filter name=!DOCKER_CONTAINER! --filter status=running | find "!DOCKER_CONTAINER!" >nul
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo  [!] Warning: Container may not be running properly
    echo  Check logs with: docker logs !DOCKER_CONTAINER!
)
goto CREATE_START_SCRIPT

:CREATE_START_SCRIPT
REM Create start script and README
echo.
echo  Creating start script and documentation...

if "!N8N_INSTALL_TYPE!"=="DOCKER" (
    REM Docker installation - no scripts needed, use Docker Desktop
    set "N8N_INSTALL_PATH=%SCRIPTDIR%"
) else (
    REM Set start script location based on install type
    if "!N8N_INSTALL_TYPE!"=="GLOBAL" (
        REM Global install - save start script to user profile n8n folder
        if not exist "%USERPROFILE%\n8n" mkdir "%USERPROFILE%\n8n"
        set "START_SCRIPT=%USERPROFILE%\n8n\start_n8n.bat"
        set "N8N_INSTALL_PATH=%USERPROFILE%\n8n"
    ) else (
        set "START_SCRIPT=!N8N_INSTALL_PATH!\start_n8n.bat"
    )

    if "!N8N_INSTALL_TYPE!"=="FOLDER" (
        REM Folder installation - use npx
        (
            echo @echo off
            echo setlocal enabledelayedexpansion
            echo set N8N_USER_FOLDER=!N8N_DATA_PATH!
            echo set N8N_PORT=!N8N_PORT!
            echo set N8N_PROTOCOL=http
            echo set N8N_HOST=!N8N_HOST!
            echo.
            echo cd /d "!N8N_INSTALL_PATH!"
            if "!AUTO_UPDATE!"=="YES" (
                echo.
                echo echo Checking for n8n updates...
                echo for /f "tokens=*" %%%%i in ^('npm view n8n version 2^^^>nul'^) do set LATEST=%%%%i
                echo for /f "tokens=*" %%%%i in ^('npx n8n --version 2^^^>nul'^) do set CURRENT=%%%%i
                echo if not "^^!CURRENT^^!"=="^^!LATEST^^!" ^(
                echo     echo.
                echo     echo   Update available: ^^!CURRENT^^! -^^^> ^^!LATEST^^!
                echo     echo.
                echo     set /p "DO_UPDATE=  Update now? [Y/N]: "
                echo     if /i "^^!DO_UPDATE^^!"=="Y" ^(
                echo         echo.
                echo         echo   Updating n8n...
                echo         npm update n8n
                echo         echo.
                echo         echo   [OK] Update complete
                echo         echo.
                echo     ^)
                echo ^) else ^(
                echo     echo   [OK] n8n is up to date [v^^!CURRENT^^!]
                echo ^)
                echo echo.
            )
            echo echo Starting n8n...
            echo echo Access n8n at: http://!N8N_HOST!:!N8N_PORT!
            echo echo.
            echo npx n8n start
        ) > "!START_SCRIPT!"
    ) else (
        REM Global installation - direct command
        (
            echo @echo off
            echo setlocal enabledelayedexpansion
            echo set N8N_USER_FOLDER=!N8N_DATA_PATH!
            echo set N8N_PORT=!N8N_PORT!
            echo set N8N_PROTOCOL=http
            echo set N8N_HOST=!N8N_HOST!
            echo.
            if "!AUTO_UPDATE!"=="YES" (
                echo echo Checking for n8n updates...
                echo for /f "tokens=*" %%%%i in ^('npm view n8n version 2^^^>nul'^) do set LATEST=%%%%i
                echo for /f "tokens=*" %%%%i in ^('n8n --version 2^^^>nul'^) do set CURRENT=%%%%i
                echo if not "^^!CURRENT^^!"=="^^!LATEST^^!" ^(
                echo     echo.
                echo     echo   Update available: ^^!CURRENT^^! -^^^> ^^!LATEST^^!
                echo     echo.
                echo     set /p "DO_UPDATE=  Update now? [Y/N]: "
                echo     if /i "^^!DO_UPDATE^^!"=="Y" ^(
                echo         echo.
                echo         echo   Updating n8n globally...
                echo         npm update -g n8n
                echo         echo.
                echo         echo   [OK] Update complete
                echo         echo.
                echo     ^)
                echo ^) else ^(
                echo     echo   [OK] n8n is up to date [v^^!CURRENT^^!]
                echo ^)
                echo echo.
            )
            echo echo Starting n8n...
            echo echo Access n8n at: http://!N8N_HOST!:!N8N_PORT!
            echo echo.
            echo n8n start
        ) > "!START_SCRIPT!"
    )

    echo  [OK] Start script created: !START_SCRIPT!
)

REM Create desktop shortcut if requested
if "!CREATE_SHORTCUT!"=="YES" (
    echo.
    echo  Creating desktop shortcut...
    set "SHORTCUT_FILE=!SHORTCUT_PATH!\Start n8n.lnk"
    
    REM Use PowerShell to create the shortcut
    powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('!SHORTCUT_FILE!'); $s.TargetPath = '!START_SCRIPT!'; $s.WorkingDirectory = '!N8N_INSTALL_PATH!'; $s.Description = 'Start n8n Workflow Automation'; $s.Save()" 2>nul
    
    if exist "!SHORTCUT_FILE!" (
        echo  [OK] Desktop shortcut created: !SHORTCUT_FILE!
    ) else (
        echo  [!] Could not create desktop shortcut
    )
)

REM Create README file
echo.
echo  Creating README file...
set "README_FILE=!N8N_INSTALL_PATH!\README.txt"
echo  README path: !README_FILE!

echo ════════════════════════════════════════════════════════════════ > "!README_FILE!"
echo  n8n - Workflow Automation Platform >> "!README_FILE!"
echo  Windows Installation - Community Edition >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo. >> "!README_FILE!"
echo IMPORTANT NOTICE: >> "!README_FILE!"
echo ───────────────── >> "!README_FILE!"
echo  This is an UNOFFICIAL community-made installer for n8n on Windows. >> "!README_FILE!"
echo  This installer is NOT affiliated with, endorsed by, or connected to >> "!README_FILE!"
echo  n8n.io or n8n GmbH in any way. >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  For official n8n support, please visit: >> "!README_FILE!"
echo  • https://community.n8n.io >> "!README_FILE!"
echo  • https://docs.n8n.io >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  For installer issues or contributions: >> "!README_FILE!"
echo  • GitHub: https://github.com/web3Leander >> "!README_FILE!"
echo. >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo. >> "!README_FILE!"
echo Installation Details: >> "!README_FILE!"
echo ───────────────────── >> "!README_FILE!"
echo  Installation Type: !N8N_INSTALL_TYPE! >> "!README_FILE!"
if "!N8N_INSTALL_TYPE!"=="DOCKER" (
    echo  Container Name:    !DOCKER_CONTAINER! >> "!README_FILE!"
    echo  Docker Volume:     !DOCKER_VOLUME! >> "!README_FILE!"
    echo  Timezone:          !DOCKER_TIMEZONE! >> "!README_FILE!"
    echo  Network Port:      !N8N_PORT! >> "!README_FILE!"
) else (
    echo  Installation Path: !N8N_INSTALL_PATH! >> "!README_FILE!"
    echo  Data Directory:    !N8N_DATA_PATH!\.n8n (created on first run) >> "!README_FILE!"
    echo  Start Script:      !START_SCRIPT! >> "!README_FILE!"
    echo  Network Host:      !N8N_HOST! >> "!README_FILE!"
    echo  Network Port:      !N8N_PORT! >> "!README_FILE!"
)
echo  Installation Date: %DATE% %TIME% >> "!README_FILE!"
echo. >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo  QUICK START GUIDE >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo. >> "!README_FILE!"
if "!N8N_INSTALL_TYPE!"=="DOCKER" (
    echo  Managing Your n8n Docker Container: >> "!README_FILE!"
    echo  ───────────────────────────────── >> "!README_FILE!"
    echo  • Start:   docker start !DOCKER_CONTAINER! >> "!README_FILE!"
    echo  • Stop:    docker stop !DOCKER_CONTAINER! >> "!README_FILE!"
    echo  • Restart: docker restart !DOCKER_CONTAINER! >> "!README_FILE!"
    echo  • Or use Docker Desktop to manage the container >> "!README_FILE!"
    echo. >> "!README_FILE!"
    echo  Accessing n8n: >> "!README_FILE!"
    echo  ───────────── >> "!README_FILE!"
    echo  1. Make sure the container is running >> "!README_FILE!"
    echo  2. Open your browser to: http://localhost:!N8N_PORT! >> "!README_FILE!"
    echo  3. Follow the setup wizard to create your account >> "!README_FILE!"
    echo  4. Start building your first workflow! >> "!README_FILE!"
    echo. >> "!README_FILE!"
    echo  Useful Docker Commands: >> "!README_FILE!"
    echo  ────────────────────── >> "!README_FILE!"
    echo  • View container status: docker ps -a >> "!README_FILE!"
    echo  • View logs:             docker logs -f !DOCKER_CONTAINER! >> "!README_FILE!"
    echo  • Access container:      docker exec -it !DOCKER_CONTAINER! sh >> "!README_FILE!"
    echo  • Remove container:      docker rm -f !DOCKER_CONTAINER! >> "!README_FILE!"
    echo  • Backup data volume:    docker volume inspect !DOCKER_VOLUME! >> "!README_FILE!"
) else (
    echo  1. Double-click or run: !START_SCRIPT! >> "!README_FILE!"
    echo  2. Wait for n8n to start (you'll see "Editor is now accessible") >> "!README_FILE!"
    echo  3. Open your browser to: http://!N8N_HOST!:!N8N_PORT! >> "!README_FILE!"
    echo  4. Follow the setup wizard to create your account >> "!README_FILE!"
    echo  5. Start building your first workflow! >> "!README_FILE!"
)
echo. >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo  USEFUL COMMANDS >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  Start n8n:     Double-click start_n8n.bat or run from terminal >> "!README_FILE!"
echo  Stop n8n:      Press Ctrl+C in the terminal window running n8n >> "!README_FILE!"
echo  Access UI:     http://!N8N_HOST!:!N8N_PORT! >> "!README_FILE!"
echo  View logs:     Check terminal window where n8n is running >> "!README_FILE!"
echo. >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo  ENVIRONMENT VARIABLES >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  The following environment variables are configured in your >> "!README_FILE!"
echo  start_n8n.bat script: >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  N8N_USER_FOLDER:  !N8N_DATA_PATH! >> "!README_FILE!"
echo  N8N_HOST:         !N8N_HOST! >> "!README_FILE!"
echo  N8N_PORT:         !N8N_PORT! >> "!README_FILE!"
echo  N8N_PROTOCOL:     http >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  IMPORTANT: n8n automatically creates a .n8n subfolder inside >> "!README_FILE!"
echo  N8N_USER_FOLDER for storing all data. Your actual data will be at: >> "!README_FILE!"
echo  !N8N_DATA_PATH!\.n8n\ >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  This folder contains your workflows, credentials, settings, and >> "!README_FILE!"
echo  database. It will be created automatically when you first run n8n. >> "!README_FILE!"
echo. >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo  OFFICIAL n8n RESOURCES >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  Official Website:     https://n8n.io >> "!README_FILE!"
echo  Documentation:        https://docs.n8n.io >> "!README_FILE!"
echo  Community Forum:      https://community.n8n.io >> "!README_FILE!"
echo  GitHub Repository:    https://github.com/n8n-io/n8n >> "!README_FILE!"
echo  Workflow Templates:   https://n8n.io/workflows >> "!README_FILE!"
echo  YouTube Channel:      https://www.youtube.com/@n8n-io >> "!README_FILE!"
echo. >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo  TROUBLESHOOTING >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  n8n won't start: >> "!README_FILE!"
echo  • Check that port !N8N_PORT! is not already in use >> "!README_FILE!"
echo  • Try running: netstat -ano ^| findstr :!N8N_PORT! >> "!README_FILE!"
echo  • Make sure Node.js is properly installed >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  Can't access the web interface: >> "!README_FILE!"
echo  • Verify n8n is running (check the terminal window) >> "!README_FILE!"
echo  • Try accessing: http://localhost:!N8N_PORT! >> "!README_FILE!"
echo  • Check Windows Firewall settings if using non-localhost IP >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  Port already in use: >> "!README_FILE!"
echo  • Edit start_n8n.bat and change N8N_PORT to a different port >> "!README_FILE!"
echo  • Common alternatives: 3000, 5000, 8080 >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  Need to move your data: >> "!README_FILE!"
echo  • Your data is stored in: !N8N_DATA_PATH!\.n8n\ >> "!README_FILE!"
echo  • To move to a new location, copy the entire .n8n folder >> "!README_FILE!"
echo  • Update N8N_USER_FOLDER in start_n8n.bat to the new base path >> "!README_FILE!"
echo  • Do NOT include .n8n in the path - n8n adds it automatically >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  For more help: >> "!README_FILE!"
echo  • Visit the n8n community: https://community.n8n.io >> "!README_FILE!"
echo  • Check the docs: https://docs.n8n.io >> "!README_FILE!"
echo. >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo  SYSTEM INFORMATION >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  Installation Date: %DATE% %TIME% >> "!README_FILE!"
echo  Installer Version: 0.1.5 >> "!README_FILE!"
echo  Node.js Version:   Run 'node --version' to check >> "!README_FILE!"
echo  npm Version:       Run 'npm --version' to check >> "!README_FILE!"
echo. >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo  CREDITS >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  This community installer was created by: >> "!README_FILE!"
echo  • GitHub: https://github.com/web3Leander >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  n8n is developed and maintained by n8n GmbH: >> "!README_FILE!"
echo  • GitHub: https://github.com/n8n-io/n8n >> "!README_FILE!"
echo  • Website: https://n8n.io >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  DISCLAIMER: This installer is an unofficial, community-created >> "!README_FILE!"
echo  tool and is not affiliated with n8n.io or n8n GmbH. For official >> "!README_FILE!"
echo  support, please use the official n8n channels listed above. >> "!README_FILE!"
echo. >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"

echo  [✓] README created: !README_FILE!

goto INSTALLATION_COMPLETE

:INSTALLATION_COMPLETE
cls
echo.
echo  ════════════════════════════════════════════════════════
echo      n8n Installation Wizard
echo      Installation Complete!
echo  ════════════════════════════════════════════════════════
echo.
echo  Step 4 of 4: Installation Complete
echo  ────────────────────────────────────────
echo.
if "!N8N_INSTALL_TYPE!"=="DOCKER" (
    echo  [✓] n8n installed to: Docker Container
    echo  [✓] Container name: !DOCKER_CONTAINER!
    echo  [✓] Data volume: !DOCKER_VOLUME!
    echo  [✓] README file: !N8N_INSTALL_PATH!\README.txt
) else if "!N8N_INSTALL_TYPE!"=="GLOBAL" (
    for /f "tokens=*" %%i in ('n8n --version 2^>nul') do set N8N_VERSION=%%i
    if defined N8N_VERSION (
        echo  [✓] n8n !N8N_VERSION! installed globally
    ) else (
        echo  [✓] n8n installed globally
    )
    echo  [✓] n8n command available system-wide
) else (
    echo  [✓] n8n installed to: !N8N_INSTALL_PATH!
    echo  [✓] Restart terminal for PATH changes
)
if not "!N8N_INSTALL_TYPE!"=="DOCKER" (
    echo  [✓] Data directory: !N8N_DATA_PATH!
    echo  [✓] Start script: !START_SCRIPT!
    echo  [✓] README file: !N8N_INSTALL_PATH!\README.txt
)
echo.
echo  ────────────────────────────────────────
echo.
echo  Thank you for using this community installer!
echo.
echo  Installer by: https://github.com/web3Leander
echo  n8n by n8n GmbH: https://n8n.io
echo.
echo  REMINDER: This is an unofficial community tool.
echo  For n8n support, visit: https://community.n8n.io
echo.
echo  ────────────────────────────────────────
echo.
echo  Next Steps:
if "!N8N_INSTALL_TYPE!"=="DOCKER" (
    echo  1. Container is running - manage via Docker Desktop
    echo  2. Open http://localhost:!N8N_PORT! in your browser
    echo  3. Create your first workflow
) else if "!N8N_INSTALL_TYPE!"=="FOLDER" (
    echo  1. Close and reopen your terminal
    echo  2. Run: !START_SCRIPT!
    echo  3. Open http://!N8N_HOST!:!N8N_PORT! in your browser
    echo  4. Create your first workflow
) else (
    echo  1. Run: !START_SCRIPT!
    echo  2. Open http://!N8N_HOST!:!N8N_PORT! in your browser
    echo  3. Create your first workflow
)
echo.
echo  For more information, see README.txt in the installation folder
echo.
pause
exit /b 0

REM Helper function to clear ERRORLEVEL
:CLEAR_ERROR
exit /b 0
