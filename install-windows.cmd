@echo off
echo Installing OSIM 50x50mm Resizer for Windows...

where magick >nul 2>nul
if %ERRORLEVEL% neq 0 (
    where convert >nul 2>nul
    if %ERRORLEVEL% neq 0 (
        echo Installing ImageMagick via Winget...
        winget install ImageMagick.ImageMagick --accept-package-agreements --accept-source-agreements
    )
)

set "INSTALL_DIR=%USERPROFILE%\.osim-resizer"
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

echo Downloading script...
curl -sSL https://raw.githubusercontent.com/alexia-consta/cli-osim-resizer/main/windowsresizer.ps1 -o "%INSTALL_DIR%\windowsresizer.ps1"

echo @echo off> "%INSTALL_DIR%\osim-resizer.cmd"
echo PowerShell -NoProfile -ExecutionPolicy Bypass -Command "%INSTALL_DIR%\windowsresizer.ps1" %%*>> "%INSTALL_DIR%\osim-resizer.cmd"

echo Adding to System PATH...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "if ($env:Path -notlike '*%INSTALL_DIR%*') { [Environment]::SetEnvironmentVariable('Path', $env:Path + ';%INSTALL_DIR%', 'User') }"

echo Installation complete! Restart your CMD terminal, then type: osim-resizer
