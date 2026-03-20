@echo off
title Build Akhil Copilot EXE
color 0A
echo ================================================
echo    Building Akhil Copilot Windows EXE
echo ================================================
echo.

cd /d "F:\Interview_Copilot\experiment1\natively-cluely-ai-assistant-2.0.6\natively-cluely-ai-assistant-2.0.6"

echo Checking for build scripts...
echo.

if exist package.json (
    echo Found package.json
    echo.
    
    echo Trying: npm run dist
    call npm run dist
    if %errorlevel% equ 0 goto :success
    
    echo Trying: npm run build
    call npm run build
    if %errorlevel% equ 0 goto :success
    
    echo Trying: npm run package
    call npm run package
    if %errorlevel% equ 0 goto :success
)

echo Trying electron-builder directly...
call npx electron-builder build --win --x64
if %errorlevel% equ 0 goto :success

echo Trying electron-packager...
call npx electron-packager . akhil-copilot --platform=win32 --arch=x64 --out=dist --overwrite
if %errorlevel% equ 0 goto :success

echo ❌ Build failed!
pause
exit /b 1

:success
echo.
echo ================================================
echo    BUILD SUCCESSFUL!
echo ================================================
echo.
echo Your .exe file is in one of these folders:
echo.
if exist dist\*.exe (
    echo   📁 dist folder:
    dir /b dist\*.exe
)
if exist release\*.exe (
    echo   📁 release folder:
    dir /b release\*.exe
)
if exist dist_electron\*.exe (
    echo   📁 dist_electron folder:
    dir /b dist_electron\*.exe
)
echo.
echo You can now distribute this file!
echo.
pause    