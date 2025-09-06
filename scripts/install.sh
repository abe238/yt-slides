#!/bin/bash

# YT-Slides Installation Script
# Installs required dependencies for video screenshot extraction

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

echo "🚀 YT-Slides Installation Script"
echo ""

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
fi

log_info "Detected OS: $OS"

# Install dependencies based on OS
case $OS in
    "macos")
        log_info "Installing dependencies on macOS..."
        
        # Check if Homebrew is installed
        if ! command -v brew &> /dev/null; then
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            log_success "Homebrew already installed"
        fi
        
        # Install yt-dlp
        if ! command -v yt-dlp &> /dev/null; then
            log_info "Installing yt-dlp..."
            brew install yt-dlp
        else
            log_success "yt-dlp already installed"
        fi
        
        # Install ffmpeg
        if ! command -v ffmpeg &> /dev/null; then
            log_info "Installing ffmpeg..."
            brew install ffmpeg
        else
            log_success "ffmpeg already installed"
        fi
        ;;
        
    "linux")
        log_info "Installing dependencies on Linux..."
        
        # Update package manager
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            # Install yt-dlp
            if ! command -v yt-dlp &> /dev/null; then
                log_info "Installing yt-dlp..."
                sudo apt-get install -y python3-pip
                pip3 install yt-dlp
            else
                log_success "yt-dlp already installed"
            fi
            
            # Install ffmpeg
            if ! command -v ffmpeg &> /dev/null; then
                log_info "Installing ffmpeg..."
                sudo apt-get install -y ffmpeg
            else
                log_success "ffmpeg already installed"
            fi
            
        elif command -v yum &> /dev/null; then
            # RedHat/CentOS
            sudo yum update
            if ! command -v yt-dlp &> /dev/null; then
                log_info "Installing yt-dlp..."
                sudo yum install -y python3-pip
                pip3 install yt-dlp
            else
                log_success "yt-dlp already installed"
            fi
            
            if ! command -v ffmpeg &> /dev/null; then
                log_info "Installing ffmpeg..."
                sudo yum install -y ffmpeg
            else
                log_success "ffmpeg already installed"
            fi
        else
            log_error "Unsupported Linux distribution. Please install yt-dlp and ffmpeg manually."
            exit 1
        fi
        ;;
        
    "windows")
        log_error "Windows installation not automated. Please install manually:"
        echo "1. Install yt-dlp: https://github.com/yt-dlp/yt-dlp/releases"
        echo "2. Install ffmpeg: https://ffmpeg.org/download.html"
        echo "3. Ensure both are in your PATH"
        exit 1
        ;;
        
    *)
        log_error "Unknown OS. Please install yt-dlp and ffmpeg manually."
        exit 1
        ;;
esac

# Create necessary directories
mkdir -p "$HOME/.yt-slides/temp"
mkdir -p "$HOME/.yt-slides/output"

# Add bin to PATH if not already there
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../bin" && pwd)"
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    log_info "Adding yt-slides to PATH..."
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.bashrc"
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.zshrc" 2>/dev/null || true
    log_warning "Please run: source ~/.bashrc (or restart your terminal)"
fi

echo ""
log_success "🎉 Installation completed!"
echo ""
echo "✅ Dependencies installed:"
echo "  - yt-dlp: $(yt-dlp --version 2>/dev/null || echo 'not found')"
echo "  - ffmpeg: $(ffmpeg -version 2>/dev/null | head -1 | cut -d' ' -f3 || echo 'not found')"
echo ""
echo "🚀 You can now run: yt-slides --help"