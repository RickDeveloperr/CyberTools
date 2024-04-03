#!/bin/bash

show_banner() {
    echo -e "\e[91m********************************************"
    echo "*                                                   *"
    echo "*                  CyberStorm                       *"
    echo "*           Instalador de Ferramentas               *"
    echo "*                   Linux                           *"
    echo "*                                                   *"
    echo "*****************************************************"
    echo
}

install_python_and_requirements() {
    if ! command -v python3 &> /dev/null; then
        echo "Instalando Python..."
        sudo apt-get update
        sudo apt-get install -y python3
        echo "Python instalado com sucesso."
    fi
    
    if [ -f "requirements.txt" ]; then
        echo "Instalando dependências Python do arquivo requirements.txt..."
        sudo apt-get install -y python3-pip
        sudo pip3 install -r requirements.txt
        echo "Dependências instaladas com sucesso."
    else
        echo "Arquivo requirements.txt não encontrado. Pulando instalação de dependências."
    fi
}

install_tool() {
    tool=$1
    echo "Instalando $tool..."
    sudo apt-get update
    sudo apt-get install -y $tool
    echo "$tool instalado com sucesso."
}

install_all_kali_tools() {
    echo "Instalando todas as ferramentas do Kali Linux..."
    sudo apt-get update
    sudo apt-get install -y kali-linux-tools
    echo "Todas as ferramentas do Kali Linux foram instaladas com sucesso."
}

show_banner

install_python_and_requirements

tools=(
    "Aircrack-ng" "Arkime" "BeEF" "bettercap" "burpsuite" "cewl" "dirb" "dnsenum"
    "dnsmap" "dnsrecon" "enum4linux" "fierce" "GRR" "gobuster" "hashcat" "hping3"
    "httrack" "Hydra" "InSpy" "john" "legion" "Maltego" "masscan" "metasploit-framework"
    "nbtscan" "Netcat" "Nikto" "nmap zenmap" "onesixtyone" "OpenSSH" "OpenVAS" "OSQuery"
    "OSSEC" "Recon-ng" "securityonion" "setoolkit" "smtp-scan" "smtp-user-enum" "Snort"
    "sqlmap" "sqlninja" "sqlsus" "SSLscan" "sslstrip" "THC-Hydra" "THC-SSL-DOS" "wpscan"
    "Wireshark" "Yara" "sslstrip"
)

show_tools() {
    col_width=25
    num_columns=3
    num_tools=${#tools[@]}
    num_per_col=$(( (num_tools + num_columns - 1) / num_columns ))

    for ((i = 0; i < num_per_col; i++)); do
        for ((j = i; j < num_tools; j += num_per_col)); do
            tool_index=$((j))
            printf "%2d. %-25s" "$(($tool_index+1))" "${tools[$tool_index]}"
        done
        echo
    done
}

show_navigation() {
    echo
    echo "Para navegar, use as opções abaixo:"
    echo "  p - Página anterior"
    echo "  n - Próxima página"
    echo "  q - Sair"
}

install_individual_tools() {
    echo "Selecione as ferramentas que deseja instalar (digite os números separados por espaço):"
    read -a selected_tools
    for tool_index in "${selected_tools[@]}"; do
        if [[ "$tool_index" =~ ^[0-9]+$ ]] && (( tool_index >= 1 )) && (( tool_index <= ${#tools[@]} )); then
            tool=${tools[$(($tool_index - 1))]}
            install_tool "$tool"
        else
            echo "Número de ferramenta inválido: $tool_index"
        fi
    done
}

echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
sudo ln -s /usr/local/bin/* /usr/local/bin

while true; do
    echo "Selecione uma opção:"
    echo "  1. Instalar todas as ferramentas do Kali Linux"
    echo "  2. Instalar várias ferramentas"
    echo "  3. Instalar uma ferramenta específica"
    echo "  q. Sair"
    read -p "Opção: " option
    case $option in
        1) install_all_kali_tools ;;
        2) clear
           show_banner
           show_tools
           show_navigation
           install_individual_tools ;;
        3) clear
           show_banner
           show_tools
           show_navigation
           install_individual_tools ;;
        q) echo "Saindo..."; exit ;;
        *) echo "Opção inválida." ;;
    esac
done
