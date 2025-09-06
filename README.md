# YT-Slides

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue.svg)](#installation)

**Universal Video Screenshot Extractor** - Extract high-quality screenshots from videos at specified timestamps with robust download fallbacks and flexible timestamp parsing.

Perfect for creating slide decks from conference talks, extracting key frames from tutorials, or building visual documentation from video content.

## ✨ Features

- 🎯 **Precise Screenshot Extraction** - Extract frames at exact timestamps
- 📺 **Multi-Platform Video Support** - YouTube, Vimeo, and 1000+ sites via yt-dlp
- 🔄 **Robust Download Fallbacks** - 4 different download methods with automatic failover
- ⏱️ **Flexible Timestamp Formats** - `[HH:MM:SS]`, `MM:SS`, or seconds
- 🎨 **Configurable Quality** - Adjustable screenshot quality (1-10 scale)
- ⚡ **Batch Processing** - Process hundreds of timestamps efficiently
- 🛡️ **Error Recovery** - Graceful handling of network issues and invalid timestamps
- 📊 **Progress Tracking** - Real-time progress updates and detailed statistics
- 🎭 **Smart Timing** - Apply global offset to fine-tune timestamp accuracy

## 📦 Quick Start

### Installation

1. **Clone or download the project:**
```bash
git clone https://github.com/your-username/yt-slides.git
cd yt-slides
```

2. **Run the installation script:**
```bash
./scripts/install.sh
```

This will automatically install:
- `yt-dlp` (video downloader)
- `ffmpeg` (video processing)
- Set up necessary directories

3. **Test the installation:**
```bash
./scripts/test.sh
```

### Basic Usage

```bash
# Extract screenshots from a video
./bin/yt-slides "https://youtube.com/watch?v=VIDEO_ID" examples/timestamps.txt

# Custom output directory and higher quality
./bin/yt-slides "https://youtube.com/watch?v=VIDEO_ID" timestamps.txt --output-dir "MySlides" --quality 8

# Apply timing offset (useful when timestamps are slightly off)
./bin/yt-slides "https://youtube.com/watch?v=VIDEO_ID" timestamps.txt --offset -2
```

## 📋 Timestamp Format Guide

YT-Slides supports multiple timestamp formats in your text file:

```
# Conference Talk Timestamps
# Lines starting with # are comments

# Bracketed format (YouTube-style)
[00:01:30]
[00:05:45]

# Plain HH:MM:SS format  
00:10:15
00:15:30

# MM:SS format (auto-converts to 00:MM:SS)
02:30
08:45

# Seconds only (auto-converts to HH:MM:SS)
150
485
```

### Creating Your Timestamps File

1. **From YouTube video descriptions** - Many creators include timestamps
2. **Manual identification** - Watch video and note key moments
3. **Browser extension** - Use timestamp-capturing extensions
4. **Automated tools** - Scene detection or subtitle analysis

**💡 Pro Tip:** Start with approximate timestamps and use the `--offset` option to fine-tune timing.

## ⚙️ Configuration Options

### Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--output-dir <name>` | Custom output directory name | Auto-generated from video title |
| `--quality <1-10>` | Screenshot quality (higher = better) | `2` |
| `--offset <seconds>` | Global timing adjustment | `0` |
| `--keep-video` | Keep source video file | `true` |
| `--delete-video` | Delete source video after processing | `false` |
| `--format <format>` | Video format preference | `best[height<=720]` |
| `--help` | Show detailed help | - |

### Examples

```bash
# High quality screenshots with custom naming
yt-slides "VIDEO_URL" timestamps.txt \
  --output-dir "Conference_2024_Slides" \
  --quality 8

# Timing adjustment (slides appear 3 seconds after audio cues)
yt-slides "VIDEO_URL" timestamps.txt --offset 3

# Minimal storage usage (delete video after processing)
yt-slides "VIDEO_URL" timestamps.txt \
  --delete-video \
  --quality 3
```

## 🏗️ Project Structure

```
yt-slides/
├── bin/
│   └── yt-slides              # Main executable script
├── scripts/
│   ├── install.sh             # Dependency installation
│   └── test.sh                # Installation verification
├── examples/
│   ├── timestamps.txt         # Basic timestamp examples
│   └── conference-talk.txt    # Real-world example
└── README.md                  # This documentation
```

## 🔧 Installation Details

### Prerequisites

- **Operating System:** macOS or Linux
- **Shell:** Bash 4.0+ (pre-installed on most systems)
- **Internet connection** for downloading dependencies and videos

### Dependencies (Auto-installed)

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** - Video downloader supporting 1000+ sites
- **[FFmpeg](https://ffmpeg.org/)** - Video processing and screenshot extraction

### Manual Installation

If automatic installation fails:

**macOS (Homebrew):**
```bash
brew install yt-dlp ffmpeg
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install python3-pip ffmpeg
pip3 install yt-dlp
```

**RedHat/CentOS:**
```bash
sudo yum install python3-pip ffmpeg
pip3 install yt-dlp
```

## 🛠️ Troubleshooting

### Common Issues and Solutions

#### "yt-dlp not found" Error
```bash
# Verify installation
which yt-dlp
yt-dlp --version

# Reinstall if missing
./scripts/install.sh
```

#### Video Download Failures
The script includes 4 fallback download methods:

1. **Standard download** - Direct yt-dlp with specified format
2. **User agent spoofing** - Bypasses some bot detection
3. **Browser cookies** - Uses Safari cookies for authentication
4. **youtube-dl fallback** - Alternative downloader

**Manual workaround:**
```bash
# Download manually and place in temp directory
yt-dlp "VIDEO_URL" -o "video.%(ext)s"
# Then run yt-slides pointing to local file
```

#### "Invalid timestamp format" Warnings
- Check for extra spaces or special characters
- Ensure format matches: `[HH:MM:SS]`, `MM:SS`, or `123` (seconds)
- Use `#` for comments in timestamp files

#### Screenshots at Wrong Timing
```bash
# Apply global offset to all timestamps
yt-slides "VIDEO_URL" timestamps.txt --offset -3  # 3 seconds earlier
yt-slides "VIDEO_URL" timestamps.txt --offset 2   # 2 seconds later
```

#### Permission Denied Errors
```bash
# Make scripts executable
chmod +x bin/yt-slides scripts/*.sh

# Check directory permissions
ls -la ~/.yt-slides/
```

### Debug Mode

For detailed troubleshooting, run with verbose output:
```bash
bash -x bin/yt-slides "VIDEO_URL" timestamps.txt
```

### Getting Help

1. **Check installation:** `./scripts/test.sh`
2. **View help:** `./bin/yt-slides --help`
3. **Test with examples:** Use provided example files first
4. **Check logs:** Screenshots include progress updates and error details

## 📊 Performance & Limits

### Typical Performance
- **Download:** 2-10 MB/s (depends on video quality and connection)
- **Screenshot extraction:** 5-20 screenshots/second
- **Memory usage:** ~100-500 MB (depends on video resolution)

### Recommended Limits
- **Timestamps:** Up to 500 per video (tested with 116 successfully)
- **Video length:** Up to 4 hours (longer videos work but take more time)
- **Concurrent runs:** 1-2 instances (avoid overloading video servers)

### Storage Requirements
- **Temp storage:** 2x video file size during processing
- **Output:** ~50-500 KB per screenshot (depends on quality setting)
- **Video file:** Preserved by default unless `--delete-video` specified

## 🎯 Use Cases

### Conference Presentations
Extract clean slides from conference talks without speaker overlays:
```bash
yt-slides "https://youtube.com/watch?v=conference_talk" conference-slides.txt --offset -1
```

### Tutorial Documentation
Create step-by-step visual guides from video tutorials:
```bash
yt-slides "https://youtube.com/watch?v=tutorial" tutorial-steps.txt --quality 6
```

### Research & Analysis
Extract frames for video content analysis:
```bash
yt-slides "VIDEO_URL" analysis-points.txt --output-dir "Research_Data"
```

### Educational Content
Build slide decks from educational videos:
```bash
yt-slides "https://youtube.com/watch?v=lecture" lecture-slides.txt --keep-video
```

## 📝 Advanced Usage

### Batch Processing Multiple Videos
```bash
#!/bin/bash
for url in $(cat video_urls.txt); do
  yt-slides "$url" "timestamps_${url##*=}.txt" --output-dir "Batch_$(date +%Y%m%d)"
done
```

### Integration with Other Tools
```bash
# Convert screenshots to PDF
yt-slides "VIDEO_URL" timestamps.txt --output-dir "temp_slides"
convert temp_slides/*.jpg presentation.pdf

# Create contact sheet
montage temp_slides/*.jpg -tile 4x6 -geometry +2+2 contact_sheet.jpg
```

### Custom Quality Settings

| Quality | Use Case | File Size |
|---------|----------|-----------|
| 1-2 | Quick previews, small files | ~25KB |
| 3-4 | Standard web usage | ~75KB |
| 5-6 | High quality slides | ~150KB |
| 7-8 | Print quality | ~300KB |
| 9-10 | Archive/professional | ~500KB+ |

## 🤝 Contributing

This project was created to solve real-world video processing challenges. Contributions welcome!

### Development Setup
```bash
git clone https://github.com/your-username/yt-slides.git
cd yt-slides
./scripts/install.sh
./scripts/test.sh
```

### Bug Reports
Please include:
- Operating system and version
- Video URL (if public) or video platform
- Timestamp file content
- Error output from script
- Output from `./scripts/test.sh`

## 📄 License

MIT License - see LICENSE file for details.

## ⚖️ Legal Notice

**User Responsibility:** Users are responsible for complying with applicable laws and the terms of service of video platforms. This tool is provided for legitimate use cases such as:
- Educational content creation
- Research and analysis  
- Personal archival of public content
- Accessibility improvements

**Platform Compliance:** Respect copyright, fair use guidelines, and platform terms of service. Do not use this tool for:
- Redistributing copyrighted content without permission
- Bypassing paywalls or access restrictions
- Commercial use without proper licensing
- Violating creators' rights

The developers of YT-Slides are not responsible for how users choose to use this software.

## 🙏 Acknowledgments

Built with:
- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - Incredible video downloader
- [FFmpeg](https://ffmpeg.org/) - Swiss army knife of video processing
- Community feedback and real-world testing

---

**Made for content creators, researchers, and anyone who needs to extract frames from videos efficiently.**