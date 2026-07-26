# Termux Desktop

Ambiente gráfico XFCE4 completo para Termux no Android — tema escuro, ícones Material, áudio nativo e painel otimizado para mobile.

[![Platform](https://img.shields.io/badge/platform-Android%20%2F%20Termux-3DDC84?logo=android&logoColor=white)](https://termux.dev)
[![DE](https://img.shields.io/badge/DE-XFCE4-blue?logo=xfce&logoColor=white)](https://xfce.org)
[![Audio](https://img.shields.io/badge/audio-PulseAudio-orange)](https://www.freedesktop.org/wiki/Software/PulseAudio/)
[![Icons](https://img.shields.io/badge/icons-Material%20Black%20Cherry-black)](https://github.com/W3skerSec/termux-desktop/releases/latest)
[![License](https://img.shields.io/badge/license-free%20%2F%20open-brightgreen)](LICENSE)

---

## Instalacao em um comando

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/W3skerSec/termux-desktop/main/install.sh)
```

---

## Instalacao manual

### 1. Atualizar o Termux

```bash
pkg update -y && pkg upgrade -y
```

### 2. Clonar o repositorio

```bash
pkg install git -y
git clone https://github.com/W3skerSec/termux-desktop.git
cd termux-desktop
```

### 3. Baixar o tema de icones

```bash
mkdir -p icons
wget -O icons.zip https://github.com/W3skerSec/termux-desktop/releases/latest/download/icons.zip
unzip icons.zip -d icons/
rm icons.zip
```

### 4. Executar o instalador

```bash
bash install.sh
```

### 5. Iniciar o desktop

Abra o app Termux-X11, depois rode no Termux:

```bash
bash ~/iniciar.sh
```

---

## Requisitos

- Android com [Termux](https://termux.dev) instalado
- App [Termux-X11](https://github.com/termux/termux-x11) instalado

---

## O que e instalado

| Componente | Descricao |
|------------|-----------|
| XFCE4 | Ambiente grafico completo |
| LXTerminal | Terminal com tema escuro e transparencia |
| Painel XFCE4 | Atalhos para Terminal, Arquivos, Navegador e Editor |
| PulseAudio | Audio via AAudio/OpenSL ES |
| Material Black Cherry Suru | Tema de icones |
| GTK2/GTK3 | Tema escuro global |
| Plank | Dock com launcher |

---

## Android 12 e superior — Phantom Process

A partir do Android 12, o sistema encerra processos filhos do Termux automaticamente (phantom process killer). Isso derruba o servidor X11, o XFCE4 e o PulseAudio pouco apos iniciar.

### Opcoes do desenvolvedor (sem root, sem ADB)

Ative o modo desenvolvedor em:

```
Configuracoes > Sobre o telefone > toque 7x em "Numero da versao"
```

Depois va em `Configuracoes > Sistema > Opcoes do desenvolvedor` e ajuste:

| Opcao | Valor recomendado |
|-------|------------------|
| Limite de processos em segundo plano | Sem limite |
| Nao manter atividades | Desativado |

Essas opcoes reduzem mas nao eliminam completamente o problema.

### Solucao definitiva via ADB (recomendado)

> A porta do ADB wireless muda a cada conexao — use o par IP:porta exibido na tela do dispositivo em `Opcoes do desenvolvedor > Depuracao sem fio`.

**Parear o dispositivo:**

```bash
adb pair <ip>:<porta-de-pareamento>
```

**Conectar:**

```bash
adb connect <ip>:<porta-de-sessao>
```

**Desativar o phantom process killer:**

```bash
adb shell "/system/bin/device_config set_sync_disabled_for_tests persistent"
adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
```

**Verificar se aplicou:**

```bash
adb shell "/system/bin/device_config get activity_manager max_phantom_processes"
# Retorno esperado: 2147483647
```

**Reverter (opcional):**

```bash
adb shell "/system/bin/device_config set_sync_disabled_for_tests none"
adb shell "/system/bin/device_config delete activity_manager max_phantom_processes"
```

### Com root

```bash
su -c "device_config put activity_manager max_phantom_processes 2147483647"
```

### Sem root e sem PC — Shizuku

Instale o app **[Shizuku](https://shizuku.rikka.app)** para executar comandos privilegiados via ADB local, sem precisar de cabo ou PC.

---

## Estrutura do repositorio

```
termux-desktop/
  install.sh      — instalador automatico
  iniciar.sh      — inicializa o desktop
  config/         — dotfiles (XFCE4, GTK, LXTerminal, Plank)
  bin/            — scripts auxiliares
  icons/          — tema de icones (baixado via Releases)
```

---

## Notas

- Icones distribuidos separadamente como `icons.zip` na aba [Releases](https://github.com/W3skerSec/termux-desktop/releases) para manter o repositorio leve
- Compositor grafico desativado por padrao para melhor desempenho em hardware mobile
- Audio configurado via PulseAudio na porta `4713`

---

Feito no Termux · Android · XFCE4 · Material Black Cherry Suru
