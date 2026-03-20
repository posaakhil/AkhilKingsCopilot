:: Navigate to your project folder
cd F:\Interview_Copilot\experiment1\natively-cluely-ai-assistant-2.0.6\natively-cluely-ai-assistant-2.0.6

:: Kill any running Node/Electron processes
taskkill /f /im node.exe 2>nul
taskkill /f /im electron.exe 2>nul

:: Delete old build folders
rmdir /s /q dist 2>nul
rmdir /s /q dist-electron 2>nul
rmdir /s /q release 2>nul

:: Delete node_modules and lock file
rmdir /s /q node_modules 2>nul
del /f /q package-lock.json 2>nul

:: Clear npm cache
npm cache clean --force

:: Clear Electron cache (optional but recommended)
rmdir /s /q %USERPROFILE%\.electron 2>nul
rmdir /s /q %USERPROFILE%\.electron-builder 2>nul

echo ✓ Everything cleaned!