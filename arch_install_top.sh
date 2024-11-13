#!/bin/bash

echo "
                   ▄
                  ▟█▙
                 ▟███▙
                ▟█████▙
               ▟███████▙
              ▂▔▀▜██████▙
             ▟██▅▂▝▜█████▙               ==================================
            ▟█████████████▙                KDE Plasma Installation Script
           ▟███████████████▙             ==================================
          ▟█████████████████▙
         ▟███████████████████▙
        ▟█████████▛▀▀▜████████▙
       ▟████████▛      ▜███████▙
      ▟█████████        ████████▙
     ▟██████████        █████▆▅▄▃▂
    ▟██████████▛        ▜█████████▙thallesb
   ▟██████▀▀▀              ▀▀██████▙
  ▟███▀▘                       ▝▀███▙
 ▟▛▀                               ▀▜▙

Bem-vindo ao script de instalação do KDE Plasma!
Este script irá configurar o ambiente KDE no seu sistema Arch Linux.

"
# Função para verificar se o script está sendo executado como root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Por favor, execute como root: sudo ./install_kde_setup.sh"
        exit 1
    fi
}

# Função para confirmação do usuário
confirm_installation() {
    read -p "Deseja iniciar a instalação? (s/n): " confirm
    case "$confirm" in
        [Ss]) echo "Iniciando a instalação...";;
        [Nn]) echo "Instalação cancelada."; exit 0;;
        *) echo "Opção inválida."; confirm_installation;;
    esac
}

# Função para atualizar o sistema e sincronizar a mirrorlist com o país escolhido
setup_mirrors() {
    read -p "Digite o nome do seu país para configurar os mirrors (ex: Brazil): " country
    echo "Configurando mirrors para o país: $country"
    pacman -Sy reflector --noconfirm
    if reflector --country "$country" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist; then
        echo "Mirrors configurados com sucesso."
    else
        echo "Erro ao configurar mirrors. Verifique o nome do país e a conexão com a internet."
        exit 1
    fi
    pacman -Syy
}

# Função para instalar pacotes principais do KDE Plasma
install_kde_core() {
    echo "Instalando KDE Plasma e gerenciador de login SDDM..."
    pacman -S --noconfirm bluedevil breeze-gtk discover drkonqi kde-gtk-config kdeplasma-addons kgamma kinfocenter krdp kscreen ksshaskpass kwallet-pam kwrited ocean-sound-theme oxygen oxygen-sounds plasma-browser-integration plasma-desktop plasma-disks plasma-firewall plasma-nm plasma-pa plasma-systemmonitor plasma-thunderbolt plasma-vault plasma-welcome plasma-workspace-wallpapers powerdevil print-manager sddm-kcm xdg-desktop-portal-kde breeze-grub 
    systemctl enable sddm
    echo "KDE Plasma instalado com sucesso."
}

# Função para instalar ferramentas de sistema e produtividade
install_utilities() {
    echo "Instalando ferramentas essenciais do KDE..."
    pacman -S --noconfirm konsole dolphin kdeconnect partitionmanager ark
}

# Função para configurar e instalar o gerenciamento de rede e firewall
setup_network() {
    echo "Instalando applet de rede e NetworkManager..."
    pacman -S --noconfirm networkmanager firewalld 
    systemctl enable NetworkManager
    systemctl start NetworkManager
    systemctl enable firewalld
    systemctl start firewalld
}

# Função para instalar suporte a impressão e digitalização
install_print_scan_support() {
    echo "Instalando suporte para impressão e digitalização..."
    pacman -S --noconfirm sane simple-scan system-config-printer
}

# Função para instalar plugins e suporte multimídia
install_multimedia_integration() {
    echo "Instalando suporte multimídia e integração de navegador..."
    pacman -S --noconfirm ffmpeg vlc ffmpegthumbs kdegraphics-thumbnailers audiocd-kio gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
}

# Função para instalar ferramentas de personalização e aparência adicionais
install_customization_tools() {
    echo "Instalando ferramentas de personalização e widgets adicionais..."
    pacman -S --noconfirm  kvantum-qt5 plasma-sdk breeze-icons
}

# Função para instalar ferramentas de produtividade
install_productivity_tools() {
    echo "Instalando ferramentas de produtividade do KDE..."
    pacman -S --noconfirm spectacle gwenview okular kate
}

# Função para instalar ferramentas adicionais
install_additional_tools() {
    echo "Instalando navegador e ferramentas adicionais..."
    pacman -S --noconfirm firefox yakuake filelight nano
}


# Execução das funções
check_root
confirm_installation
# Execução das funções
setup_mirrors
install_kde_core
install_utilities
setup_network
install_print_scan_support
install_multimedia_integration
install_customization_tools
install_productivity_tools
install_additional_tools


# Instalao do yay (AUR HELPER)
# Função para verificar se o comando foi bem-sucedido
check_success() {
    if [ $? -ne 0 ]; then
        echo "Erro: $1"
        exit 1
    fi
}

# Verificar se o git está instalado
if ! command -v git &> /dev/null; then
    echo "Git não está instalado. Instalando git..."
    sudo pacman -S --noconfirm git
    check_success "Falha ao instalar git."
else
    echo "Git já está instalado."
fi

# Clonar o repositório do yay
echo "Clonando o repositório do yay..."
git clone https://aur.archlinux.org/yay.git
check_success "Falha ao clonar o repositório do yay."

# Acessar o diretório do yay
cd yay || exit

# Construir e instalar o yay como usuário normal (sem sudo)
echo "Instalando o yay..."
makepkg -si --noconfirm
check_success "Falha ao instalar o yay."

# Limpar o diretório após a instalação
cd ..
rm -rf yay

echo "Instalação completa! Reinicie o sistema para aplicar as mudanças."
