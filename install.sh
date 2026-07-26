#!/data/data/com.termux/files/usr/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  AthenaOS Darkness UI — Instalação Automatizada no Termux   ║
# ╚══════════════════════════════════════════════════════════════╝

set -e

echo "🚀 Iniciando instalação do tema AthenaOS Darkness Desktop..."

# 1. Instalação de dependências essenciais
echo "[1/4] Atualizando pacotes e instalando dependências X11..."
pkg update -y
pkg install -y termux-x11-nightly xfce4 lxterminal pulseaudio dbus xfce4-panel xfwm4

# 2. Criação de diretórios do usuário
echo "[2/4] Preparando diretórios de configuração..."
mkdir -p ~/.config ~/.local/bin

# 3. Aplicando configurações da interface e ícones
echo "[3/4] Instalando dotfiles da UI (XFCE4, LXTerminal, Dock e Ícones)..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.icons
cp -rf "$SCRIPT_DIR/config/xfce4" ~/.config/
cp -rf "$SCRIPT_DIR/config/lxterminal" ~/.config/
[ -d "$SCRIPT_DIR/config/plank" ] && cp -rf "$SCRIPT_DIR/config/plank" ~/.config/
[ -d "$SCRIPT_DIR/config/gtk-3.0" ] && cp -rf "$SCRIPT_DIR/config/gtk-3.0" ~/.config/
[ -f "$SCRIPT_DIR/config/.gtkrc-2.0" ] && cp -f "$SCRIPT_DIR/config/.gtkrc-2.0" ~/.gtkrc-2.0

[ -d "$SCRIPT_DIR/icons" ] && cp -rf "$SCRIPT_DIR/icons/"* ~/.icons/

cp -f "$SCRIPT_DIR/bin/launch-terminal" ~/.local/bin/
chmod +x ~/.local/bin/launch-terminal

cp -f "$SCRIPT_DIR/iniciar_athena.sh" ~/iniciar_athena.sh
chmod +x ~/iniciar_athena.sh

# 4. Finalização
echo "[4/4] Instalação concluída com sucesso!"
echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  COMO INICIAR A INTERFACE:"
echo "  1. Abra o app Termux-X11"
echo "  2. No Termux, rode o comando:"
echo "     bash ~/iniciar_athena.sh"
echo "══════════════════════════════════════════════════════════════"
