#!/data/data/com.termux/files/usr/bin/bash

################################################
echo "[✓] Limpeza agressiva de processos zumbis"
################################################

killall -9 xfce4-session xfwm4 xfce4-panel termux-x11 pulseaudio 2>/dev/null || true
kill -9 $(cat /data/data/com.termux/files/usr/tmp/pulse-*/pid 2>/dev/null) 2>/dev/null || true
rm -rf /data/data/com.termux/files/usr/tmp/.X11-unix
rm -rf /data/data/com.termux/files/usr/tmp/pulse-*
rm -f /data/data/com.termux/files/usr/tmp/.X0-lock
rm -rf ~/.cache/sessions/*
unset PULSE_SERVER


########################################
echo "[✓] Configurando áudio e ambiente"
########################################


export DISPLAY=:0
export XDG_RUNTIME_DIR=${TMPDIR}
ulimit -n 10240

###############################################
# PERFORMANCE: Variáveis para GPU/MESA/V-SYNC #
###############################################


export GALLIUM_DRIVER=llvmpipe
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLES_VERSION_OVERRIDE=3.2
export virgl_debug=no_vtest
export vblank_mode=0



#################################################
# Inicializa PulseAudio para Android (AAUDIO/SLES)#
#################################################

pulseaudio -k 2>/dev/null || true
sleep 1
pulseaudio --daemonize=yes --exit-idle-time=-1 --disallow-exit 2>/dev/null || true
sleep 2

export PULSE_SERVER=127.0.0.1:4713
pactl set-sink-mute AAudio_sink 0 2>/dev/null || true
pactl set-sink-volume AAudio_sink 100% 2>/dev/null || true
pactl set-sink-mute OpenSL_ES_sink 0 2>/dev/null || true
pactl set-sink-volume OpenSL_ES_sink 100% 2>/dev/null || true

mkdir -p ~/.config/pulse
cat > ~/.config/pulse/client.conf << EOF
default-server = 127.0.0.1:4713
autospawn = no
daemon-binary = /data/data/com.termux/files/usr/bin/pulseaudio
EOF
echo "[✓] PulseAudio iniciado com volume em 100% (127.0.0.1:4713)"



#############################
echo "[✓] Iniciando Servidor"
#############################


##########################################
# Inicializa o servidor gráfico Termux-X11#
##########################################

termux-x11 :0 -ac -dpi 96 > ~/.termux_x11.log 2>&1 &

# Aguarda até o servidor X11 estar pronto para conexões
echo "[✓] Aguardando inicialização do servidor gráfico X11..."
for i in $(seq 1 12); do
    if [ -S /data/data/com.termux/files/usr/tmp/.X11-unix/X0 ] || DISPLAY=:0 xset q >/dev/null 2>&1; then
        echo "[✓] Servidor X11 pronto na porta :0"
        break
    fi
    sleep 1
done

#######################################
# Iniciando Desktop Otimizada          #
#######################################

# Usamos dbus-run-session para estabilidade total
dbus-run-session startxfce4 > ~/.athena_desktop.log 2>&1 &

sleep 3
export DISPLAY=:0

##############################################
# Salva DBUS address em formato simples      #
##############################################
# Lê DBUS diretamente do ambiente do processo xfce4-session
sleep 1
XFCE_PID=$(pgrep -x xfce4-session | head -1)
if [ -n "$XFCE_PID" ]; then
  DBUS_ADDR=$(cat /proc/$XFCE_PID/environ 2>/dev/null | tr '\0' '\n' | grep '^DBUS_SESSION_BUS_ADDRESS=' | head -1 | cut -d= -f2-)
  if [ -n "$DBUS_ADDR" ]; then
    echo "export DBUS_SESSION_BUS_ADDRESS=$DBUS_ADDR" > ~/.dbus_session_env
    echo "[✓] DBUS capturado: $DBUS_ADDR"
  fi
fi

##############################################
# Desativa compositor do XFWM4 e encerra picom#
##############################################
DISPLAY=:0 xfconf-query -c xfwm4 -p /general/use_compositing -s false 2>/dev/null || true
pkill -9 picom 2>/dev/null || true
echo "[✓] Compositor e Picom desativados (modo ultra-leve)"

##############################################
# Configura Painel do XFCE para Modo Retrato  #
##############################################
DISPLAY=:0 xfconf-query -c xfce4-panel -p /panels/panel-0/size -s 32 2>/dev/null || true
DISPLAY=:0 xfconf-query -c xfce4-panel -p /panels/panel-0/length -s 100 2>/dev/null || true
DISPLAY=:0 xfconf-query -c xfce4-panel -p /panels/panel-0/length-type -s 0 2>/dev/null || true
DISPLAY=:0 xfconf-query -c xfce4-panel -p /panels/panel-0/position-locked -s true 2>/dev/null || true

