# Akhil Copilot FREE

# 🚀 Akhil Copilot — Build & Native Module Fix Guide

This guide helps you **fix native module issues** and **build a working `.exe`** without errors.

It is designed for Electron + Node.js apps using native modules like:

* `better-sqlite3`
* Audio `.node` modules
* N-API / Rust builds

---

# 📌 🔥 Problems This Guide Fixes

* ❌ `better-sqlite3` version mismatch
* ❌ `.node` file not loading
* ❌ Native module errors in Electron
* ❌ App works in dev but crashes in `.exe`
* ❌ Build (`npm run dist`) fails
* ❌ Audio module not compiling

---

# ⚙️ 🧰 Requirements

Make sure you have installed:

### ✅ Required

* Node.js (LTS recommended)
* npm
* Git

### ✅ For Native Modules

* Python (for node-gyp)
* Visual Studio Build Tools (C++)

---

# 📂 📁 Project Setup

Navigate to your project folder:

```bash
cd F:\Interview_Copilot\experiment1\natively-cluely-ai-assistant-2.0.6
```

---

# 🛠️ ⚡ QUICK FIX (RECOMMENDED)

Run your automation script:

```bash
.\mainmodule.bat
```

👉 This will:

* Clean project
* Reinstall dependencies
* Rebuild native modules
* Fix better-sqlite3
* Build audio module

---

# 🧱 🔧 MANUAL STEP-BY-STEP (If needed)

---

## 🔹 STEP 1: Stop Running Processes

```bash
taskkill /f /im node.exe
taskkill /f /im electron.exe
```

---

## 🔹 STEP 2: Clean Old Files

```bash
rmdir /s /q node_modules
del package-lock.json
```

---

## 🔹 STEP 3: Clear Cache

```bash
npm cache clean --force
```

---

## 🔹 STEP 4: Install Dependencies

```bash
npm install
```

If error:

```bash
npm install --force
```

---

## 🔹 STEP 5: Rebuild Native Modules

```bash
npm run rebuild
```

If not available:

```bash
npx electron-rebuild
```

---

## 🔹 STEP 6: Fix better-sqlite3 (IMPORTANT)

```bash
npx electron-rebuild -f -w better-sqlite3
```

If still failing:

```bash
npm rebuild better-sqlite3 --force
```

OR:

```bash
npm uninstall better-sqlite3
npm install better-sqlite3@latest
npm rebuild better-sqlite3 --force
```

---

## 🔹 STEP 7: Build Audio Native Module

```bash
cd native-module
npm install
npm run build
```

If error:

```bash
npx napi build --platform --release
```

---

## 🔹 STEP 8: Verify Modules

```bash
node -e "require('better-sqlite3')"
```

👉 If no error → ✅ OK

---

## 🔹 STEP 9: Run App

```bash
npm start
```

OR

```bash
npm run app:dev
```

---

## 🔹 STEP 10: Build `.exe`

```bash
npm run dist
```

---

# ⚡ 🧠 BEST PRACTICES

---

## ✅ Always before building:

* Delete `node_modules`
* Run `npm install`
* Run `electron-rebuild`

---

## ✅ Keep versions consistent:

```bash
node -v
npm -v
```

---

## ❌ Avoid these mistakes:

* Copying `node_modules` from another PC
* Skipping rebuild step
* Mixing Electron + Node versions
* Building `.exe` without fixing native modules

---

# 🧪 🧰 TROUBLESHOOTING

---

## ❌ Error: Module version mismatch

```bash
npx electron-rebuild
```

---

## ❌ Error: Cannot find `.node` file

```bash
npm rebuild
```

---

## ❌ Error: node-gyp build failed

👉 Install:

* Python
* Visual Studio Build Tools

---

## ❌ App works in dev but not in `.exe`

```bash
npm run rebuild
npm run dist
```

---

## ❌ Error: Expected 2 arguments, but got 3

👉 Fix function call to match definition (remove extra argument)

---

# 🚀 💡 PRO TIPS

---

## 🔥 Use automation script

```bash
.\mainmodule.bat
```

👉 Saves time and avoids mistakes

---

## 🔥 Rename script (recommended)

```bash
fix-build.bat
```

Run:

```bash
.\fix-build.bat
```

---

## 🔥 Always rebuild before release

```bash
npm run rebuild
npm run dist
```

---

F:\Interview_Copilot\experiment1\natively-cluely-ai-assistant-2.0.6\natively-cluely-ai-assistant-2.0.6>doskey /history
npm install 
npm start
./mainmodulebat
.\mainmodulebat
.\mainmodule.bat
./mainmodule.bat
.\mainmodule.bat
cd native-module
npm run
npx napi build --platform --release
cd ..
cd npm start
npm start
npm run dist
doskey /history

F:\Interview_Copilot\experiment1\natively-cluely-ai-assistant-2.0.6\natively-cluely-ai-assistant-2.0.6>

# 🎯 FINAL RESULT

After following this guide:

* ✅ Native modules working
* ✅ No Electron errors
* ✅ `.exe` builds successfully
* ✅ App runs smoothly

---

# 👨‍💻 Author

**Akhil Copilot**
