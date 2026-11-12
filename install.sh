#!/data/data/com.termux/files/usr/bin/bash
set -e

REPO="https://github.com/W3skerSec/termux-desktop"
ICONS_URL="$REPO/releases/latest/download/athena_icons.zip"
INSTALL_DIR="$HOME/termux-desktop-pack"
TMP="${TMPDIR:-$PREFIX/tmp}"   # Termux usa $PREFIX/tmp, NUNCA /tmp (nao e gravavel)

echo ""
echo "Termux Desktop Pack - Instalador"
echo "================================="
echo ""

# Detecta: rodando dentro do repo clonado, ou standalone via curl?
if [ ! -f "$(dirname "$0")/config/xfce4/terminal/terminalrc" ]; then
    echo "[1/6] Instalando dependencias base..."
    pkg update -y
    pkg install -y git wget unzip curl

    echo "[2/6] Baixando o projeto..."
    if [ -d "$INSTALL_DIR/.git" ]; then
        echo "  Ja existe, atualizando..."
        git -C "$INSTALL_DIR" pull -q
    else
        rm -rf "$INSTALL_DIR"
        git clone -q "$REPO.git" "$INSTALL_DIR"
    fi
    SCRIPT_DIR="$INSTALL_DIR"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "[1/6] Instalando dependencias base..."
    pkg update -y
    pkg install -y wget unzip
    echo "[2/6] Usando arquivos locais ($SCRIPT_DIR)"
fi

echo "[3/6] Habilitando repositorio grafico (x11-repo)..."
pkg install -y x11-repo
pkg update -y

echo "[4/6] Instalando pacotes graficos..."
# OBS: o dock "plank" vive no Termux como 'plank-reloaded' (fork no x11-repo).
# Instalar 'plank' da o erro "Unable to locate package plank".
pkg install -y termux-x11-nightly xfce4 xfwm4 xfce4-panel lxterminal pulseaudio dbus plank-reloaded xfce4-whiskermenu-plugin papirus-icon-theme

echo "[5/6] Aplicando configuracoes..."
mkdir -p ~/.config ~/.local/bin ~/.icons

cp -rf "$SCRIPT_DIR/config/xfce4" ~/.config/
cp -rf "$SCRIPT_DIR/config/lxterminal" ~/.config/
[ -d "$SCRIPT_DIR/config/plank" ]   && cp -rf "$SCRIPT_DIR/config/plank" ~/.config/
[ -d "$SCRIPT_DIR/config/gtk-3.0" ] && cp -rf "$SCRIPT_DIR/config/gtk-3.0" ~/.config/
[ -f "$SCRIPT_DIR/config/.gtkrc-2.0" ] && cp -f "$SCRIPT_DIR/config/.gtkrc-2.0" ~/.gtkrc-2.0

cp -f "$SCRIPT_DIR/bin/launch-terminal" ~/.local/bin/
chmod +x ~/.local/bin/launch-terminal

cp -f "$SCRIPT_DIR/iniciar.sh" ~/iniciar.sh
chmod +x ~/iniciar.sh

cp -f "$SCRIPT_DIR/parar.sh" ~/parar.sh
chmod +x ~/parar.sh

echo "[6/6] Instalando tema de icones..."
if [ -d "$SCRIPT_DIR/icons" ] && [ "$(ls -A "$SCRIPT_DIR/icons" 2>/dev/null)" ]; then
    cp -rf "$SCRIPT_DIR/icons/"* ~/.icons/
else
    echo "  Baixando tema de icones (pode demorar, ~237MB)..."
    rm -rf "$TMP/icons_tmp"
    mkdir -p "$TMP/icons_tmp"
    # Icones sao cosmeticos: se falhar o download/extracao, apenas avisa (nao aborta)
    if wget -q --show-progress -O "$TMP/athena_icons.zip" "$ICONS_URL" \
       && unzip -q -o "$TMP/athena_icons.zip" -d "$TMP/icons_tmp/"; then
        cp -rf "$TMP/icons_tmp/"*/icons/* ~/.icons/ 2>/dev/null \
            || cp -rf "$TMP/icons_tmp/"* ~/.icons/ 2>/dev/null || true
        echo "  Tema de icones instalado."
    else
        echo "  (aviso: nao foi possivel baixar os icones; o desktop funciona sem eles)"
    fi
    rm -rf "$TMP/athena_icons.zip" "$TMP/icons_tmp"
fi

# Blindagem: garante que todo plugin referenciado no painel tem pacote instalado.
# (evita o erro "Plugin X could not be loaded" num Termux zerado.)
echo "[*] Verificando plugins do painel..."
PANEL_XML="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
# plugins que JA vem com o xfce4-panel (nao tem pacote proprio)
CORE_PLUGINS=" separator launcher tasklist systray systemtray showdesktop directorymenu clock actions applicationsmenu pager windowmenu windowck "
if [ -f "$PANEL_XML" ]; then
    for p in $(grep -oE 'type="string" value="[a-z][a-z-]*"' "$PANEL_XML" \
               | sed -E 's/.*value="([a-z-]+)".*/\1/' | sort -u); do
        case "$CORE_PLUGINS" in *" $p "*) continue ;; esac
        # ja instalado? (todo plugin registra um .desktop)
        [ -f "$PREFIX/share/xfce4/panel/plugins/$p.desktop" ] && continue
        echo "  plugin '$p' ausente -> instalando xfce4-$p-plugin"
        pkg install -y "xfce4-$p-plugin" 2>/dev/null \
            || echo "    (aviso: sem pacote 'xfce4-$p-plugin'; remova o plugin do painel se nao usar)"
    done
fi

# Blindagem 2: garante que todo app dos launchers do painel esta instalado.
echo "[*] Verificando apps dos launchers..."
LDIR="$HOME/.config/xfce4/panel"
if [ -d "$LDIR" ]; then
    for exe in $(grep -rhE '^Exec=' "$LDIR"/*/*.desktop 2>/dev/null \
                 | sed -E 's/^Exec=//; s/ .*//' | sort -u); do
        case "$exe" in /*) continue ;; esac     # caminho absoluto (launch-terminal) -> pula
        command -v "$exe" >/dev/null 2>&1 && continue
        echo "  app '$exe' ausente -> instalando"
        pkg install -y "$exe" 2>/dev/null \
            || echo "    (aviso: pacote '$exe' nao encontrado; ajuste/remova o launcher)"
    done
fi

echo ""
echo "[OK] Instalacao concluida!"
echo ""
echo "Para iniciar o desktop:"
echo "  1. Abra o app Termux-X11"
echo "  2. No Termux, rode:"
echo "     bash ~/iniciar.sh"
echo ""
