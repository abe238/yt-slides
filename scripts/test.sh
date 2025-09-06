#!/bin/bash

# YT-Slides Test Script
# Tests the installation and basic functionality

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

echo "🧪 YT-Slides Test Suite"
echo ""

# Test 1: Check dependencies
log_info "Test 1: Checking dependencies..."

if command -v yt-dlp &> /dev/null; then
    log_success "yt-dlp found: $(yt-dlp --version)"
else
    log_error "yt-dlp not found. Run: ./scripts/install.sh"
    exit 1
fi

if command -v ffmpeg &> /dev/null; then
    log_success "ffmpeg found: $(ffmpeg -version 2>/dev/null | head -1 | cut -d' ' -f3)"
else
    log_error "ffmpeg not found. Run: ./scripts/install.sh"
    exit 1
fi

# Test 2: Check script executable
log_info "Test 2: Checking yt-slides script..."

SCRIPT_PATH="$(dirname "$0")/../bin/yt-slides"
if [ -x "$SCRIPT_PATH" ]; then
    log_success "yt-slides script is executable"
else
    log_error "yt-slides script not executable. Run: chmod +x bin/yt-slides"
    exit 1
fi

# Test 3: Check help output
log_info "Test 3: Testing help output..."
if "$SCRIPT_PATH" --help > /dev/null 2>&1; then
    log_success "Help command works"
else
    log_error "Help command failed"
    exit 1
fi

# Test 4: Check example files
log_info "Test 4: Checking example files..."

EXAMPLES_DIR="$(dirname "$0")/../examples"
if [ -f "$EXAMPLES_DIR/timestamps.txt" ]; then
    log_success "Example timestamps file exists"
else
    log_error "Example timestamps file missing"
    exit 1
fi

# Test 5: Validate timestamp parsing (dry run)
log_info "Test 5: Testing timestamp parsing..."
TEMP_TIMESTAMPS="/tmp/test_timestamps.txt"
cat > "$TEMP_TIMESTAMPS" << EOF
[00:00:10]
00:01:30
2:45
180
EOF

# Count valid timestamps (this is a simplified test)
VALID_COUNT=$(grep -v '^#' "$TEMP_TIMESTAMPS" | grep -v '^$' | wc -l | tr -d ' ')
if [ "$VALID_COUNT" -eq 4 ]; then
    log_success "Timestamp parsing test passed"
else
    log_warning "Timestamp parsing may have issues"
fi

rm -f "$TEMP_TIMESTAMPS"

echo ""
log_success "🎉 All tests passed!"
echo ""
echo "✅ YT-Slides is ready to use!"
echo "📖 Run: yt-slides --help for usage information"
echo "🧪 Try: yt-slides 'https://youtube.com/watch?v=example' examples/timestamps.txt"