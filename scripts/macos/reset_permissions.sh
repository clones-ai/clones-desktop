#!/bin/bash

# Script to reset TCC permissions for clones-desktop
# This forces macOS to ask for permissions again

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Resetting TCC permissions for clones-desktop...${NC}"
echo ""

BUNDLE_ID="ai.clones.desktop"

echo -e "${YELLOW}This will:${NC}"
echo "1. Remove all TCC database entries for clones-desktop"
echo "2. Force macOS to ask for permissions again on next launch"
echo ""
echo -e "${YELLOW}You will need to:${NC}"
echo "1. Quit clones-desktop if it's running"
echo "2. Remove it from System Settings (Privacy & Security)"
echo "3. Relaunch the app to get fresh permission prompts"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo -e "${BLUE}Resetting Accessibility permission...${NC}"
tccutil reset Accessibility "$BUNDLE_ID" 2>/dev/null || echo "Already reset or not found"

echo -e "${BLUE}Resetting Screen Recording permission...${NC}"
tccutil reset ScreenCapture "$BUNDLE_ID" 2>/dev/null || echo "Already reset or not found"

echo -e "${BLUE}Resetting Input Monitoring permission...${NC}"
tccutil reset ListenEvent "$BUNDLE_ID" 2>/dev/null || echo "Already reset or not found"

echo ""
echo -e "${GREEN}✅ Permissions reset complete!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Open System Settings > Privacy & Security"
echo "2. Check Accessibility, Screen Recording, and Input Monitoring"
echo "3. Remove 'clones-desktop' from all lists if present"
echo "4. Relaunch clones-desktop"
echo "5. The app should now show system permission dialogs"
echo ""
echo -e "${BLUE}Tip: If the app doesn't show permission dialogs:${NC}"
echo "Run: killall Dock    (to refresh System Settings)"

