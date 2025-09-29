@echo off
setlocal

echo 🚀 Clones Desktop - Complete Build ^& Deploy
echo ===========================================

echo ℹ️ Step 1/2: Building release...
call scripts\windows\build_release_local.ps1

if errorlevel 1 (
    echo ❌ Build failed, aborting deployment
    exit /b 1
)

echo ✅ Build completed successfully!

echo ℹ️ Step 2/2: Uploading to Tigris...
call scripts\windows\upload_to_tigris_windows.bat

if errorlevel 1 (
    echo ❌ Upload failed
    exit /b 1
)

echo ✅ Complete deployment finished!
echo ℹ️ Your app is now available for download at:
echo   🌐 https://releases-test.clones-ai.com/latest/