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
echo      Community Edition - Version 0.1
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
if %ERRORLEVEL% NEQ 0 (
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
if %ERRORLEVEL% NEQ 0 (
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
set /p "N8N_TYPE=  Your choice (1 or 2): "

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
    )
    echo.
    echo  [✓] Selected: Folder installation
    echo      Location: !N8N_INSTALL_PATH!
) else (
    echo.
    echo  [✗] Invalid choice. Please enter 1 or 2.
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
) else (
    set "N8N_DATA_PATH=!N8N_INSTALL_PATH!"
)

echo.
echo  [i] n8n will store data at: !N8N_DATA_PATH!\.n8n\
echo      (n8n automatically creates the .n8n subfolder)
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

REM Sub-step: Network Configuration
echo.
echo.
:ASK_NETWORK_CONFIG
echo  n8n Network Configuration
echo  ────────────────────────────────────────
echo.
echo  Configure the host and port for n8n to run on.
echo.
echo  Host/IP Address:
echo  • Press Enter for default: 127.0.0.1 (localhost only)
echo  • Or enter a custom IP address
echo    Examples: 0.0.0.0 (all interfaces), 192.168.1.100 (specific local IP)
echo.
set /p "N8N_HOST_INPUT=  Host (default: 127.0.0.1): "
if "!N8N_HOST_INPUT!"==" " set "N8N_HOST=127.0.0.1"
if not defined N8N_HOST_INPUT set "N8N_HOST=127.0.0.1"
if defined N8N_HOST_INPUT (
    if not "!N8N_HOST_INPUT!"==" " set "N8N_HOST=!N8N_HOST_INPUT!"
)

echo.
echo  Port Number:
echo  • Press Enter for default: 5678
echo  • Or enter a custom port (1024-65535)
echo    Examples: 8080, 3000, 5000
echo.
set /p "N8N_PORT_INPUT=  Port (default: 5678): "
if "!N8N_PORT_INPUT!"==" " set "N8N_PORT=5678"
if not defined N8N_PORT_INPUT set "N8N_PORT=5678"
if defined N8N_PORT_INPUT (
    if not "!N8N_PORT_INPUT!"==" " set "N8N_PORT=!N8N_PORT_INPUT!"
)

echo.
echo  [✓] Network Configuration:
echo      Host: !N8N_HOST!
echo      Port: !N8N_PORT!
echo      URL:  http://!N8N_HOST!:!N8N_PORT!
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

REM Ensure data directory exists
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

if "!N8N_INSTALL_TYPE!"=="GLOBAL" goto INSTALL_GLOBAL
if "!N8N_INSTALL_TYPE!"=="FOLDER" goto INSTALL_FOLDER

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
call npm install -g n8n 2>&1
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
call npm install n8n 2>&1
echo.
echo  Verifying installation...
if not exist "!N8N_INSTALL_PATH!\node_modules\n8n" (
    echo.
    echo  [✗] Installation failed! n8n not found in node_modules.
    echo  Please check the error messages above.
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

:CREATE_START_SCRIPT
REM Create start script and README
echo.
echo  Creating start script and documentation...
set "START_SCRIPT=!N8N_INSTALL_PATH!\start_n8n.bat"

if "!N8N_INSTALL_TYPE!"=="FOLDER" (
    REM Folder installation - use npx
    (
        echo @echo off
        echo set N8N_USER_FOLDER=!N8N_DATA_PATH!
        echo set N8N_PORT=!N8N_PORT!
        echo set N8N_PROTOCOL=http
        echo set N8N_HOST=!N8N_HOST!
        echo.
        echo echo Starting n8n...
        echo echo Access n8n at: http://!N8N_HOST!:!N8N_PORT!
        echo echo.
        echo cd /d "!N8N_INSTALL_PATH!"
        echo npx n8n start
    ) > "!START_SCRIPT!"
) else (
    REM Global installation - direct command
    (
        echo @echo off
        echo set N8N_USER_FOLDER=!N8N_DATA_PATH!
        echo set N8N_PORT=!N8N_PORT!
        echo set N8N_PROTOCOL=http
        echo set N8N_HOST=!N8N_HOST!
        echo.
        echo echo Starting n8n...
        echo echo Access n8n at: http://!N8N_HOST!:!N8N_PORT!
        echo echo.
        echo n8n start
    ) > "!START_SCRIPT!"
)

echo  [✓] Start script created: !START_SCRIPT!

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
echo  Installation Path: !N8N_INSTALL_PATH! >> "!README_FILE!"
echo  Data Directory:    !N8N_DATA_PATH!\.n8n (created on first run) >> "!README_FILE!"
echo  Start Script:      !START_SCRIPT! >> "!README_FILE!"
echo  Network Host:      !N8N_HOST! >> "!README_FILE!"
echo  Network Port:      !N8N_PORT! >> "!README_FILE!"
echo  Installation Date: %DATE% %TIME% >> "!README_FILE!"
echo. >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo  QUICK START GUIDE >> "!README_FILE!"
echo ════════════════════════════════════════════════════════════════ >> "!README_FILE!"
echo. >> "!README_FILE!"
echo  1. Double-click or run: !START_SCRIPT! >> "!README_FILE!"
echo  2. Wait for n8n to start (you'll see "Editor is now accessible") >> "!README_FILE!"
echo  3. Open your browser to: http://!N8N_HOST!:!N8N_PORT! >> "!README_FILE!"
echo  4. Follow the setup wizard to create your account >> "!README_FILE!"
echo  5. Start building your first workflow! >> "!README_FILE!"
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
echo  Installer Version: 0.1.1 >> "!README_FILE!"
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
if "!N8N_INSTALL_TYPE!"=="GLOBAL" (
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
echo  [✓] Data directory: !N8N_DATA_PATH!
echo  [✓] Start script: !START_SCRIPT!
echo  [✓] README file: !N8N_INSTALL_PATH!\README.txt
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
if "!N8N_INSTALL_TYPE!"=="FOLDER" (
    echo  1. Close and reopen your terminal
    echo  2. Run: !START_SCRIPT!
) else (
    echo  1. Run: !START_SCRIPT!
)
echo  3. Open http://!N8N_HOST!:!N8N_PORT! in your browser
echo  4. Create your first workflow
echo.
echo  For more information, see README.txt in the installation folder
echo.
pause
exit /b 0
