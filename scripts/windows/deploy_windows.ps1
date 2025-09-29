# Clones Desktop - Complete Build & Deploy (Windows)
param(
    [switch]$Verbose
)

# Functions for colored output
function Write-Info($Message) {
    Write-Host "ℹ️  $Message" -ForegroundColor Blue
}

function Write-Success($Message) {
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Error($Message) {
    Write-Host "❌ $Message" -ForegroundColor Red
}

# Main execution
function Main {
    Write-Host "🚀 Clones Desktop - Complete Build & Deploy" -ForegroundColor Cyan
    Write-Host "===========================================" -ForegroundColor Cyan

    Write-Info "Step 1/2: Building release..."

    # Execute build script
    try {
        if ($Verbose) {
            & "scripts\windows\build_release_local.ps1" -Verbose
        } else {
            & "scripts\windows\build_release_local.ps1"
        }

        if ($LASTEXITCODE -ne 0) {
            Write-Error "Build failed, aborting deployment"
            exit 1
        }
    } catch {
        Write-Error "Build script execution failed: $_"
        exit 1
    }

    Write-Success "Build completed successfully!"

    Write-Info "Step 2/2: Uploading to Tigris..."

    # Execute upload script
    try {
        if ($Verbose) {
            & "scripts\windows\upload_to_tigris_windows.ps1" -Verbose
        } else {
            & "scripts\windows\upload_to_tigris_windows.ps1"
        }

        if ($LASTEXITCODE -ne 0) {
            Write-Error "Upload failed"
            exit 1
        }
    } catch {
        Write-Error "Upload script execution failed: $_"
        exit 1
    }

    Write-Success "🎉 Complete deployment finished!"
    Write-Info "Your app is now available for download at:"
    Write-Host "  🌐 https://releases-test.clones-ai.com/latest/windows/" -ForegroundColor Cyan
}

# Run if executed directly
if ($MyInvocation.InvocationName -ne '.') {
    Main
}