# Termux Desktop Pack

Configuração completa de ambiente gráfico XFCE4 para Termux no Android, otimizada para telas mobile com suporte a áudio, tema de ícones e painel leve.

## Instalação em um comando

Cole no Termux e aguarde:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/W3skerSec/termux-desktop/main/install.sh)
```

## Instalação manual (passo a passo)

### 1. Atualizar o Termux

```bash
pkg update -y && pkg upgrade -y
```

### 2. Clonar o repositório

```bash
pkg install git -y
git clone https://github.com/W3skerSec/termux-desktop.git
cd termux-desktop-pack
```

### 3. Baixar o pacote de ícones

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

## Requisitos

- Android com Termux instalado
- App [Termux-X11](https://github.com/termux/termux-x11) instalado

## O que é instalado

- Ambiente gráfico XFCE4
- LXTerminal com tema escuro e transparência
- Painel XFCE4 com atalhos para Terminal, Arquivos, Navegador e Editor
- PulseAudio com backend de áudio Android (AAudio/OpenSL ES)
- Tema de ícones Material Black Cherry Suru
- Configuração GTK2/GTK3 tema escuro
- Dock Plank com launcher

## Estrutura do repositório

```
termux-desktop-pack/
  install.sh          # instalador automático
  iniciar.sh   # script de inicialização do desktop
  config/             # dotfiles (XFCE4, GTK, LXTerminal, Plank)
  bin/                # scripts auxiliares
  icons/              # tema de ícones (baixado separadamente via Releases)
```

## Notas

- Os ícones são distribuídos separadamente como zip na aba Releases para manter o repositório leve
- O compositor gráfico é desativado por padrão para melhor desempenho em hardware mobile
- O áudio é configurado via PulseAudio na porta 4713
