# Termux Desktop Pack

XFCE4 desktop environment configuration for Termux on Android, optimized for mobile screens with audio support, icon theme, and lightweight panel setup.

## Requirements

- Android device with Termux installed
- [Termux-X11](https://github.com/termux/termux-x11) app installed

## Fresh Install (from zero)

### 1. Install Termux and update packages

```bash
pkg update -y && pkg upgrade -y
```

### 2. Clone this repository

```bash
pkg install git -y
git clone https://github.com/W3skerSec/termux-desktop-pack.git
cd termux-desktop-pack
```

### 3. Download and extract icon theme

Download the icon pack from the [latest release](https://github.com/W3skerSec/termux-desktop-pack/releases/latest) and place it inside the `icons/` folder:

```bash
mkdir -p icons
wget -O icons.zip https://github.com/W3skerSec/termux-desktop-pack/releases/latest/download/icons.zip
unzip icons.zip -d icons/
rm icons.zip
```

### 4. Run the installer

```bash
bash install.sh
```

### 5. Start the desktop

Open the Termux-X11 app, then run:

```bash
bash ~/iniciar_athena.sh
```

## What gets installed

- XFCE4 desktop environment
- LXTerminal with dark theme and transparency
- XFCE4 panel with shortcuts for Terminal, Files, Browser and Editor
- PulseAudio with Android audio backend (AAudio/OpenSL ES)
- Material Black Cherry Suru icon theme
- GTK2/GTK3 dark theme configuration
- Plank dock launcher

## Structure

```
termux-desktop-pack/
  install.sh          # automated installer
  iniciar_athena.sh   # desktop launcher script
  config/             # dotfiles (XFCE4, GTK, LXTerminal, Plank)
  bin/                # helper scripts
  icons/              # icon theme (downloaded separately from Releases)
```

## Notes

- The icons folder is distributed as a separate zip in Releases to keep the repository lightweight
- Compositor is disabled by default for better performance on mobile hardware
- Audio is configured to run on port 4713 via PulseAudio daemon
