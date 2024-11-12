#!/bin/bash

# Função para verificar se o script está sendo executado como root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Por favor, execute como root: sudo ./install_kde_setup.sh"
        exit 1
    fi
}

# Função para atualizar o sistema e sincronizar a mirrorlist com o país escolhido
setup_mirrors() {
    read -p "Digite o nome do seu país para configurar os mirrors (ex: Brazil): " country
    echo "Configurando mirrors para o país: $country"
    pacman -Sy reflector --noconfirm
    reflector --country "$country" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    pacman -Syy
}

# Função para instalar pacotes principais do KDE Plasma
install_kde_core() {
    echo "Instalando KDE Plasma e gerenciador de login SDDM..."
    pacman -S --noconfirm plasma-meta sddm
    systemctl enable sddm
}

# Função para instalar ferramentas de sistema e produtividade
install_utilities() {
    echo "Instalando ferramentas essenciais do KDE..."
    pacman -S --noconfirm konsole dolphin kdeconnect plasma-systemmonitor partitionmanager ark
}

# Função para configurar e instalar o gerenciamento de rede
setup_network() {
    echo "Instalando applet de rede e NetworkManager..."
    pacman -S --noconfirm plasma-nm networkmanager
    systemctl enable NetworkManager
    systemctl start NetworkManager
}

# Função para instalar aparência e personalização
install_appearance() {
    echo "Instalando temas e personalização do KDE..."
    pacman -S --noconfirm breeze-gtk breeze-icons kde-gtk-config plasma-disks
}

# Função para instalar ferramentas de produtividade
install_productivity_tools() {
    echo "Instalando ferramentas de produtividade do KDE..."
    pacman -S --noconfirm spectacle gwenview okular kate
}

# Função para instalar suporte multimídia
install_multimedia_support() {
    echo "Instalando suporte multimídia..."
    pacman -S --noconfirm ffmpeg pulseaudio plasma-pa vlc
}

# Função para instalar ferramentas de acesso remoto
install_remote_tools() {
    echo "Instalando ferramentas de acesso remoto..."
    pacman -S --noconfirm krdc krfb
}

# Função para instalar ferramentas adicionais
install_additional_tools() {
    echo "Instalando navegador e ferramentas adicionais..."
    pacman -S --noconfirm firefox yakuake filelight
}

# Função para instalar pacotes de integração de hardware e configurações
install_hardware_support() {
    echo "Instalando suporte adicional para hardware e configurações avançadas..."
    pacman -S --noconfirm kinfocenter kcm-wacomtablet powerdevil bluedevil plasma-wayland-session
}

# Função para instalar plugins e suporte multimídia
install_multimedia_integration() {
    echo "Instalando suporte multimídia e integração de navegador..."
    pacman -S --noconfirm plasma-browser-integration ffmpegthumbs kdegraphics-thumbnailers audiocd-kio gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
}

# Função para instalar suporte a impressão e digitalização
install_print_scan_support() {
    echo "Instalando suporte para impressão e digitalização..."
    pacman -S --noconfirm print-manager sane simple-scan
}

# Função para instalar ferramentas de personalização e aparência adicionais
install_customization_tools() {
    echo "Instalando ferramentas de personalização e widgets adicionais..."
    pacman -S --noconfirm kdeplasma-addons kvantum-qt5 plasma-sdk
}




# Execução das funções
check_root
setup_mirrors
install_kde_core
install_utilities
setup_network
install_appearance
install_productivity_tools
install_multimedia_support
install_remote_tools
install_additional_tools
install_hardware_support
install_multimedia_integration
install_print_scan_support
install_customization_tools


echo "Instalação completa! Reinicie o sistema para aplicar as mudanças."
