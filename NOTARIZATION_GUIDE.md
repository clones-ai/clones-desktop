# 🔐 Manual Notarization Guide

## Prerequisites

1. **Apple Developer Account** with valid certificates
2. **Xcode** installed with command line tools
3. **App-specific password** for your Apple ID
4. **Team ID** from your Apple Developer account

## Step 1: Setup Keychain Profile (One-time)

```bash
xcrun notarytool store-credentials "ClonesProd" \
  --apple-id "your@email.com" \
  --team-id "YOUR_TEAM_ID" \
  --password "your-app-specific-password"
```

**Get your Team ID**: Developer Portal → Membership → Team ID

**Create app-specific password**: Apple ID → Sign-In and Security → App-Specific Passwords

## Step 2: Build Locally

```bash
./scripts/macos/build_release_local.sh
```

This will create a timestamped build directory with:
- `macos_arm64/` - Apple Silicon .app bundle
- `macos_intel/` - Intel .app bundle  
- `dmg_arm64/` - Apple Silicon .dmg
- `dmg_intel/` - Intel .dmg

## Step 3: Notarize Applications

### Option A: Command Line (Recommended)

**For .app bundles:**
```bash
# ARM64
xcrun notarytool submit "build_output_*/macos_arm64/clones-desktop.app" \
  --keychain-profile "ClonesProd" --wait

# Intel
xcrun notarytool submit "build_output_*/macos_intel/clones-desktop.app" \
  --keychain-profile "ClonesProd" --wait
```

**For .dmg files:**
```bash
# ARM64
xcrun notarytool submit "build_output_*/dmg_arm64/clones-desktop_*_aarch64.dmg" \
  --keychain-profile "ClonesProd" --wait

# Intel  
xcrun notarytool submit "build_output_*/dmg_intel/clones-desktop_*_x64.dmg" \
  --keychain-profile "ClonesProd" --wait
```

### Option B: Xcode Organizer

1. Open **Xcode**
2. **Window** → **Organizer**  
3. **Distribute App** → **Developer ID** → **Upload**
4. Select your .app or .dmg file
5. Follow the wizard

## Step 4: Staple Notarization Ticket

After successful notarization:

```bash
# For .app bundles
xcrun stapler staple "build_output_*/macos_arm64/clones-desktop.app"
xcrun stapler staple "build_output_*/macos_intel/clones-desktop.app"

# For .dmg files  
xcrun stapler staple "build_output_*/dmg_arm64/clones-desktop_*_aarch64.dmg"
xcrun stapler staple "build_output_*/dmg_intel/clones-desktop_*_x64.dmg"
```

## Step 5: Verify Notarization

```bash
# Check app
spctl -a -vvv -t install "path/to/clones-desktop.app"

# Check dmg
spctl -a -vvv -t open --context context:primary-signature "path/to/file.dmg"
```

**Expected output:** `accepted` with no security violations.

## Troubleshooting

### Common Issues

**❌ "Invalid Developer ID"**
- Check your signing certificate in Keychain Access
- Ensure certificate is valid and not expired

**❌ "Notarization failed"**  
- Check detailed logs: `xcrun notarytool log <submission-id> --keychain-profile "ClonesProd"`
- Common issues: unsigned binaries, invalid entitlements

**❌ "App damaged and can't be opened"**
- Stapling step missing or failed
- Download may have been corrupted

### Check Notarization Status

```bash
# List recent submissions
xcrun notarytool history --keychain-profile "ClonesProd"

# Get detailed log
xcrun notarytool log <submission-id> --keychain-profile "ClonesProd"
```

## Production Notes

- **ARM64 DMG** = For M1/M2/M3 Macs (recommended)
- **Intel DMG** = For Intel Macs (legacy support)
- Both files will be Apple-signed and notarized
- Users can download and install without security warnings