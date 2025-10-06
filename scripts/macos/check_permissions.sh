#!/bin/bash

# Script to check macOS permissions for clones-desktop app

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APP_PATH="${1:-}"

if [ -z "$APP_PATH" ]; then
    echo -e "${RED}Usage: $0 /path/to/clones-desktop.app${NC}"
    exit 1
fi

if [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}Error: App not found at $APP_PATH${NC}"
    exit 1
fi

echo -e "${BLUE}Checking permissions for: $APP_PATH${NC}"
echo ""

# Get bundle ID
BUNDLE_ID=$(defaults read "$APP_PATH/Contents/Info.plist" CFBundleIdentifier 2>/dev/null || echo "unknown")
echo -e "Bundle ID: ${YELLOW}$BUNDLE_ID${NC}"
echo ""

# Check Accessibility permission
echo -e "${BLUE}=== Accessibility Permission ===${NC}"
if [ -f "/Library/Application Support/com.apple.TCC/TCC.db" ]; then
    # Try to query the database (requires sudo or specific access)
    ACCESSIBILITY=$(sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
        "SELECT allowed FROM access WHERE service='kTCCServiceAccessibility' AND client='$BUNDLE_ID'" 2>/dev/null || echo "")
    
    if [ "$ACCESSIBILITY" = "1" ]; then
        echo -e "${GREEN}✅ Accessibility: GRANTED${NC}"
    elif [ "$ACCESSIBILITY" = "0" ]; then
        echo -e "${RED}❌ Accessibility: DENIED${NC}"
    else
        echo -e "${YELLOW}⚠️  Accessibility: NOT IN DATABASE (never requested or database not accessible)${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Cannot check database (requires sudo)${NC}"
fi

echo ""

# Check Screen Recording permission
echo -e "${BLUE}=== Screen Recording Permission ===${NC}"
if [ -f "/Library/Application Support/com.apple.TCC/TCC.db" ]; then
    SCREEN_RECORDING=$(sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
        "SELECT allowed FROM access WHERE service='kTCCServiceScreenCapture' AND client='$BUNDLE_ID'" 2>/dev/null || echo "")
    
    if [ "$SCREEN_RECORDING" = "1" ]; then
        echo -e "${GREEN}✅ Screen Recording: GRANTED${NC}"
    elif [ "$SCREEN_RECORDING" = "0" ]; then
        echo -e "${RED}❌ Screen Recording: DENIED${NC}"
    else
        echo -e "${YELLOW}⚠️  Screen Recording: NOT IN DATABASE (never requested)${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Cannot check database (requires sudo)${NC}"
fi

echo ""

# Check Input Monitoring permission  
echo -e "${BLUE}=== Input Monitoring Permission ===${NC}"
if [ -f "/Library/Application Support/com.apple.TCC/TCC.db" ]; then
    INPUT_MONITORING=$(sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" \
        "SELECT allowed FROM access WHERE service='kTCCServiceListenEvent' AND client='$BUNDLE_ID'" 2>/dev/null || echo "")
    
    if [ "$INPUT_MONITORING" = "1" ]; then
        echo -e "${GREEN}✅ Input Monitoring: GRANTED${NC}"
    elif [ "$INPUT_MONITORING" = "0" ]; then
        echo -e "${RED}❌ Input Monitoring: DENIED${NC}"
    else
        echo -e "${YELLOW}⚠️  Input Monitoring: NOT IN DATABASE (never requested)${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Cannot check database (requires sudo)${NC}"
fi

echo ""
echo -e "${BLUE}=== Entitlements ===${NC}"
codesign -d --entitlements :- "$APP_PATH" 2>&1 | grep -A 1 "accessibility\|ScreenCapture\|ListenEvent" || echo "No relevant entitlements found"

echo ""
echo -e "${YELLOW}Note: This script requires sudo to access the TCC database.${NC}"
echo -e "${YELLOW}If you see 'NOT IN DATABASE', it means the permission was never requested.${NC}"
echo ""
echo -e "${BLUE}To manually fix permissions:${NC}"
echo "1. Open System Settings > Privacy & Security"
echo "2. Add clones-desktop to:"
echo "   - Accessibility"
echo "   - Screen Recording"
echo "   - Input Monitoring"

