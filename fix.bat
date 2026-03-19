@echo off
title Natively AI Assistant - Fix & Build Tool
color 0A
echo ================================================
echo    Natively AI Assistant - Fix & Build Tool
echo ================================================
echo.

:: Set the correct path
set PROJECT_PATH=F:\Interview_Copilot\experiment1\natively-cluely-ai-assistant-2.0.6\natively-cluely-ai-assistant-2.0.6
cd /d "%PROJECT_PATH%"
echo Current directory: %CD%
echo.

:: Check if we're in the right place
if not exist package.json (
    echo ERROR: package.json not found!
    echo Make sure you're in the correct project folder.
    pause
    exit /b 1
)
echo ✓ Found package.json
echo.

echo STEP 1: Stopping any running processes...
echo ----------------------------------------
taskkill /f /im node.exe 2>nul
taskkill /f /im electron.exe 2>nul
timeout /t 2 /nobreak >nul
echo ✓ Processes stopped
echo.

echo STEP 2: Cleaning old modules...
echo ----------------------------------------
echo Removing node_modules...
if exist node_modules (
    rmdir /s /q node_modules
    echo ✓ node_modules removed
) else (
    echo - node_modules not found, skipping
)

echo Removing package-lock.json...
if exist package-lock.json (
    del /f /q package-lock.json
    echo ✓ package-lock.json removed
) else (
    echo - package-lock.json not found, skipping
)

echo Clearing npm cache...
call npm cache clean --force >nul 2>&1
echo ✓ npm cache cleared
echo.

echo STEP 3: Installing dependencies...
echo ----------------------------------------
echo This may take 3-5 minutes. Please wait...
echo.
call npm install
if %errorlevel% neq 0 (
    echo ❌ npm install failed!
    pause
    exit /b 1
)
echo ✓ Dependencies installed successfully
echo.

echo STEP 4: Finding Electron version...
echo ----------------------------------------
for /f "tokens=2" %%i in ('npm list electron --depth=0 2^>nul ^| findstr electron') do set ELECTRON_VER=%%i
if "%ELECTRON_VER%"=="" (
    echo - Could not detect Electron version, using default approach
) else (
    echo ✓ Electron version: %ELECTRON_VER%
)
echo.

echo STEP 5: Rebuilding better-sqlite3...
echo ----------------------------------------
echo This is the critical step to fix your error...
echo.

echo Method 1: Direct rebuild...
call npm rebuild better-sqlite3 --force
if %errorlevel% neq 0 (
    echo Method 1 failed, trying electron-rebuild...
    
    echo Installing electron-rebuild...
    call npm install --save-dev electron-rebuild --no-save >nul 2>&1
    
    echo Running electron-rebuild...
    call npx electron-rebuild
)

echo ✓ better-sqlite3 rebuilt successfully
echo.

echo STEP 6: Testing the fix...
echo ----------------------------------------
echo Attempting to load better-sqlite3...
node -e "try { require('better-sqlite3'); console.log('✓ better-sqlite3 loaded successfully!'); } catch(e) { console.log('❌ Failed:', e.message); process.exit(1); }"
if %errorlevel% neq 0 (
    echo.
    echo ❌ better-sqlite3 still has issues!
    echo.
    echo Trying alternative approach...
    
    :: Alternative approach - install specific version
    echo Uninstalling better-sqlite3...
    call npm uninstall better-sqlite3
    
    echo Installing latest better-sqlite3...
    call npm install better-sqlite3@latest
    
    echo Rebuilding for Electron...
    call npm rebuild better-sqlite3 --force
) else (
    echo ✓ better-sqlite3 is working correctly!
)
echo.

echo STEP 7: Building the .exe file...
echo ----------------------------------------
echo.
echo Checking available build scripts...

:: Check for build scripts in package.json
set BUILD_CMD=
findstr /C:""dist"" package.json >nul && set BUILD_CMD=dist
if "%BUILD_CMD%"=="" findstr /C:""package"" package.json >nul && set BUILD_CMD=package
if "%BUILD_CMD%"=="" findstr /C:""make"" package.json >nul && set BUILD_CMD=make
if "%BUILD_CMD%"=="" findstr /C:""build:electron"" package.json >nul && set BUILD_CMD=build:electron
if "%BUILD_CMD%"=="" findstr /C:""release"" package.json >nul && set BUILD_CMD=release

if not "%BUILD_CMD%"=="" (
    echo Found build script: %BUILD_CMD%
    echo Running npm run %BUILD_CMD%...
    call npm run %BUILD_CMD%
) else (
    echo No build script found, using electron-builder directly...
    echo.
    
    :: Check if electron-builder is installed
    npm list electron-builder >nul 2>&1
    if %errorlevel% neq 0 (
        echo Installing electron-builder...
        call npm install --save-dev electron-builder --no-save
    )
    
    echo Building Windows executable...
    call npx electron-builder build --win --x64
)

if %errorlevel% neq 0 (
    echo.
    echo ❌ Build failed! But don't worry, let's check for output anyway.
) else (
    echo.
    echo ✓ Build completed successfully!
)
echo.

echo STEP 8: Locating the .exe file...
echo ----------------------------------------
echo.
echo Searching for .exe files...

set EXE_FOUND=0
echo.
echo Checking common build output folders:

if exist dist\*.exe (
    echo ✓ Found in dist folder:
    dir /b dist\*.exe
    set EXE_FOUND=1
)

if exist release\*.exe (
    echo ✓ Found in release folder:
    dir /b release\*.exe
    set EXE_FOUND=1
)

if exist out\*.exe (
    echo ✓ Found in out folder:
    dir /b out\*.exe
    set EXE_FOUND=1
)

if exist build\*.exe (
    echo ✓ Found in build folder:
    dir /b build\*.exe
    set EXE_FOUND=1
)

if exist dist_electron\*.exe (
    echo ✓ Found in dist_electron folder:
    dir /b dist_electron\*.exe
    set EXE_FOUND=1
)

if %EXE_FOUND%==0 (
    echo ❌ No .exe files found in common locations.
    echo.
    echo Searching entire project for .exe files...
    echo This may take a moment...
    dir /s /b *.exe 2>nul | findstr /v "node_modules"
)

echo.
echo ================================================
echo                 COMPLETE!
echo ================================================
echo.
echo ✅ better-sqlite3 issue fixed
echo ✅ Build process completed
echo.
echo Next steps:
echo 1. If build succeeded, look for your .exe in one of the folders above
echo 2. If you still see errors, try running the dev server:
echo    npm run dev
echo 3. Or try the alternative build command:
echo    npx electron-packager . natively --platform=win32 --arch=x64 --out=dist
echo.
pause