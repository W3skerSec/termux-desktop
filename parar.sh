#!/data/data/com.termux/files/usr/bin/bash
# Para o Termux Desktop: encerra XFCE, servidor X11, PulseAudio e dbus,
# e limpa sockets/locks/sessao. Espelha o que o iniciar.sh sobe.

echo "[*] Parando o Termux Desktop..."

# 1. Encerra a sessao grafica e o servidor X
killall -9 xfce4-session xfwm4 xfce4-panel xfdesktop xfsettingsd startxfce4 termux-x11 2>/dev/null || true

# 2. Encerra o PulseAudio
pulseaudio -k 2>/dev/null || true
killall -9 pulseaudio 2>/dev/null || true

# 3. Encerra o dbus
killall -9 dbus-daemon dbus-launch 2>/dev/null || true

# 4. Limpa sockets, locks e sessao
TMP="${TMPDIR:-/data/data/com.termux/files/usr/tmp}"
rm -rf "$TMP/.X11-unix" "$TMP/.X0-lock" "$TMP/pulse-"* 2>/dev/null || true
rm -rf ~/.cache/sessions/* 2>/dev/null || true
rm -f ~/.dbus_session_env 2>/dev/null || true
unset PULSE_SERVER DBUS_SESSION_BUS_ADDRESS 2>/dev/null || true

echo "[OK] Desktop encerrado. Pode fechar o app Termux-X11."
