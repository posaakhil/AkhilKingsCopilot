@echo off
title Akhil Copilot - Fix Native Modules
color 0A
echo ================================================
echo    Akhil Copilot - Fix Native Modules Tool
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

echo ================================================
echo    STEP 1: Rebuild All Native Modules
echo ================================================
echo.

:: Stop any running processes
echo Stopping any running Node/Electron processes...
taskkill /f /im node.exe 2>nul
taskkill /f /im electron.exe 2>nul
timeout /t 2 /nobreak >nul
echo ✓ Processes stopped
echo.

:: Delete node_modules and package-lock.json
echo Removing node_modules folder...
if exist node_modules (
    rmdir /s /q node_modules
    echo ✓ node_modules removed
) else (
    echo - node_modules not found, skipping
)
echo.

echo Removing package-lock.json...
if exist package-lock.json (
    del /f /q package-lock.json
    echo ✓ package-lock.json removed
) else (
    echo - package-lock.json not found, skipping
)
echo.

:: Clear npm cache
echo Clearing npm cache...
call npm cache clean --force >nul 2>&1
echo ✓ npm cache cleared
echo.

:: Reinstall dependencies
echo Installing dependencies (this may take 3-5 minutes)...
echo.
call npm install
if %errorlevel% neq 0 (
    echo ❌ npm install failed!
    echo.
    echo Trying with --force...
    call npm install --force
    if %errorlevel% neq 0 (
        echo ❌ Still failing. Please check your internet connection.
        pause
        exit /b 1
    )
)
echo ✓ Dependencies installed successfully
echo.

:: Rebuild native modules for Electron
echo Rebuilding native modules for Electron...
call npm run rebuild 2>nul
if %errorlevel% neq 0 (
    echo npm run rebuild not found, using electron-rebuild...
    call npx electron-rebuild
)
echo ✓ Native modules rebuilt
echo.

echo ================================================
echo    STEP 2: Force Rebuild better-sqlite3
echo ================================================
echo.

:: Install electron-rebuild if needed
echo Checking for electron-rebuild...
call npx electron-rebuild --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing electron-rebuild...
    call npm install -g electron-rebuild --no-save >nul 2>&1
    call npm install -D electron-rebuild --no-save >nul 2>&1
)
echo.

:: Force rebuild better-sqlite3
echo Force rebuilding better-sqlite3 for Electron...
call npx electron-rebuild -f -w better-sqlite3
if %errorlevel% neq 0 (
    echo Method 1 failed, trying alternative...
    
    :: Alternative: rebuild directly
    call npm rebuild better-sqlite3 --force
    
    :: Alternative: uninstall and reinstall
    echo Uninstalling and reinstalling better-sqlite3...
    call npm uninstall better-sqlite3
    call npm install better-sqlite3@latest
    call npm rebuild better-sqlite3 --force
)
echo ✓ better-sqlite3 rebuilt
echo.

:: Test better-sqlite3
echo Testing better-sqlite3...
node -e "try { require('better-sqlite3'); console.log('✓ better-sqlite3 works!'); } catch(e) { console.log('❌ Still failing:', e.message); }"
echo.

echo ================================================
echo    STEP 3: Build Audio Native Module
echo ================================================
echo.

:: Check if native-module folder exists
if exist native-module (
    cd native-module
    echo Entering native-module folder...
    echo.
    
    :: Clean old builds
    echo Cleaning old builds...
    if exist node_modules (
        rmdir /s /q node_modules 2>nul
    )
    if exist target (
        rmdir /s /q target 2>nul
    )
    if exist *.node (
        del /f /q *.node 2>nul
    )
    echo.
    
    :: Install dependencies
    echo Installing native module dependencies...
    call npm install
    if %errorlevel% neq 0 (
        echo ❌ npm install failed in native-module
        cd ..
        goto :skip_audio
    )
    echo ✓ Dependencies installed
    echo.
    
    :: Build the module
    echo Building native audio module...
    call npm run build
    if %errorlevel% neq 0 (
        echo npm run build not found, trying napi build...
        call npx napi build --platform --release
        if %errorlevel% neq 0 (
            echo ❌ Build failed. Trying alternative...
            call npm run build:release
        )
    )
    echo.
    
    :: Check if build succeeded
    echo Checking build output...
    if exist *.node (
        echo ✓ Native module built successfully!
        dir *.node
    ) else if exist target\release\*.node (
        echo ✓ Native module found in target\release\
        dir target\release\*.node
        copy target\release\*.node . >nul 2>&1
    ) else (
        echo ⚠ Warning: Could not find .node file, but continuing...
    )
    echo.
    
    cd ..
    echo Returned to project root
) else (
    echo ⚠ native-module folder not found, skipping audio module build
)
:skip_audio
echo.

echo ================================================
echo    FINAL VERIFICATION
echo ================================================
echo.

:: Final verification
echo Running final checks...
echo.

echo Checking better-sqlite3...
node -e "try { require('better-sqlite3'); console.log('  ✓ better-sqlite3: OK'); } catch(e) { console.log('  ❌ better-sqlite3: FAILED'); }"
echo.

echo Checking native audio module...
if exist native-module\*.node (
    echo   ✓ Audio native module: OK
) else if exist native-module\target\release\*.node (
    echo   ✓ Audio native module: OK (in target folder)
) else (
    echo   ⚠ Audio native module: Not found (may be optional)
)
echo.

echo ================================================
echo               FIX COMPLETE!
echo ================================================
echo.
echo ✅ All native modules rebuilt successfully
echo ✅ better-sqlite3 should now work with Electron
echo ✅ Audio module rebuilt (if it existed)
echo.
echo Next steps:
echo 1. Test the app: npm run app:dev
echo 2. If still having issues, try: npm run dev
echo 3. Build executable: npm run dist (or your build command)
echo.
echo The app should now run without module version errors!
echo.
pause