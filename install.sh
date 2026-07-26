#!/data/data/com.termux/files/usr/bin/bash
set -e

REPO="https://github.com/W3skerSec/termux-desktop-pack"
ICONS_URL="$REPO/releases/latest/download/icons.zip"
INSTALL_DIR="$HOME/termux-desktop-pack"

echo ""
echo "Termux Desktop Pack - Instalador"
echo "================================="
echo ""

# Se rodando via curl (sem o repo clonado), clona primeiro
if [ ! -f "$(dirname "$0")/config/xfce4/terminal/terminalrc" ]; then
    echo "[1/5] Instalando dependencias..."
    pkg update -y -q
    pkg install -y git wget unzip curl 2>/dev/null

    echo "[2/5] Clonando repositorio..."
    if [ -d "$INSTALL_DIR" ]; then
        echo "Diretorio ja existe, atualizando..."
        git -C "$INSTALL_DIR" pull -q
    else
        git clone -q "$REPO.git" "$INSTALL_DIR"
    fi
    SCRIPT_DIR="$INSTALL_DIR"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "[1/5] Instalando dependencias..."
    pkg update -y -q
    pkg install -y wget unzip 2>/dev/null
fi

echo "[2/5] Instalando pacotes graficos..."
pkg install -y termux-x11-nightly xfce4 lxterminal pulseaudio dbus xfce4-panel xfwm4 2>/dev/null

echo "[3/5] Preparando diretorios..."
mkdir -p ~/.config ~/.local/bin ~/.icons

echo "[4/5] Aplicando configuracoes de interface..."
cp -rf "$SCRIPT_DIR/config/xfce4" ~/.config/
cp -rf "$SCRIPT_DIR/config/lxterminal" ~/.config/
[ -d "$SCRIPT_DIR/config/plank" ]   && cp -rf "$SCRIPT_DIR/config/plank" ~/.config/
[ -d "$SCRIPT_DIR/config/gtk-3.0" ] && cp -rf "$SCRIPT_DIR/config/gtk-3.0" ~/.config/
[ -f "$SCRIPT_DIR/config/.gtkrc-2.0" ] && cp -f "$SCRIPT_DIR/config/.gtkrc-2.0" ~/.gtkrc-2.0

cp -f "$SCRIPT_DIR/bin/launch-terminal" ~/.local/bin/
chmod +x ~/.local/bin/launch-terminal

cp -f "$SCRIPT_DIR/iniciar.sh" ~/iniciar.sh
chmod +x ~/iniciar.sh

# Baixar e instalar icones se nao existirem localmente
if [ -d "$SCRIPT_DIR/icons" ] && [ "$(ls -A "$SCRIPT_DIR/icons" 2>/dev/null)" ]; then
    cp -rf "$SCRIPT_DIR/icons/"* ~/.icons/
else
    echo "[4/5] Baixando tema de icones (pode demorar)..."
    wget -q --show-progress -O /tmp/icons.zip "$ICONS_URL"
    unzip -q /tmp/icons.zip -d /tmp/icons_tmp/
    cp -rf /tmp/icons_tmp/*/icons/* ~/.icons/ 2>/dev/null || cp -rf /tmp/icons_tmp/ ~/.icons/
    rm -rf /tmp/icons.zip /tmp/icons_tmp
fi

echo "[5/5] Instalacao concluida!"
echo ""
echo "Para iniciar o desktop:"
echo "  1. Abra o app Termux-X11"
echo "  2. No Termux, rode:"
echo "     bash ~/iniciar.sh"
echo ""
