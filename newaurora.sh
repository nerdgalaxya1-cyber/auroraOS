#!/bin/bash
SENHA_CORRETA="2026"
VERSAO="2.2.0"

# --- LOGIN ---
senha=$(dialog --title "auroraOS Hub" --passwordbox "Chave de Acesso:" 8 40 --stdout)
[ "$senha" != "$SENHA_CORRETA" ] && exit 1

# --- FUNÇÃO FETCH (Comando via Terminal) ---
mostrar_specs() {
    clear
    echo -e "\e[1;36m"
    figlet -f small "  AURORA"
    echo -e "\e[0m------------------------------------------"
    echo -e "SISTEMA:    auroraOS V$VERSAO"
    echo -e "USUÁRIO:    $(whoami)"
    echo -e "MODELO:     $(getprop ro.product.model)"
    echo -e "CPU:        $(getprop ro.product.cpu.abi)"
    echo -e "ANDROID:    $(getprop ro.build.version.release)"
    echo -e "MEMÓRIA:    $(free -h | grep Mem | awk '{print $3 "/" $2}')"
    echo -e "BATERIA:    $(termux-battery-status | grep percentage | awk '{print $2}' | tr -d ',')%"
    echo -e "UPTIME:     $(uptime -p)"
    echo -e "------------------------------------------"
}
export -f mostrar_specs

# --- AURORA STORE (15 APPS) ---
aurora_store() {
    while true; do
        app=$(dialog --title "auroraStore" --menu "Selecione o pacote:" 18 55 15             1 "Python" 2 "NodeJS" 3 "Clang" 4 "Git" 5 "Wget"             6 "Curl" 7 "CMatrix" 8 "HTOP" 9 "Neofetch" 10 "Nano"             11 "Vim" 12 "Zip" 13 "PHP" 14 "Ruby" 15 "Nmap" 0 "<< VOLTAR" --stdout)
        
        case $app in
            1) clear; pkg install python -y ;; 2) clear; pkg install nodejs -y ;;
            3) clear; pkg install clang -y ;; 4) clear; pkg install git -y ;;
            5) clear; pkg install wget -y ;; 6) clear; pkg install curl -y ;;
            7) clear; pkg install cmatrix -y ;; 8) clear; pkg install htop -y ;;
            9) clear; pkg install neofetch -y ;; 10) clear; pkg install nano -y ;;
            11) clear; pkg install vim -y ;; 12) clear; pkg install zip -y ;;
            13) clear; pkg install php -y ;; 14) clear; pkg install ruby -y ;;
            15) clear; pkg install nmap -y ;;
            0 | "") break ;;
        esac
        [ "$app" != "0" ] && dialog --msgbox "Tarefa concluída com sucesso!" 6 35
    done
}

# --- PÁGINA 3 (SOCIAL & MEMBERS) ---
menu_pagina_3() {
    while true; do
        p3=$(dialog --title "Página 3 (Comunidade)" --menu "Recursos VIP:" 15 45 4             1 "aurora members (Perfil)"             2 "Bloco de Notas"             3 "Status de Rede (IP)"             0 "<< VOLTAR PÁGINA 2" --stdout)
        case $p3 in
            1) dialog --title "aurora members" --msgbox "💎 STATUS: ADMINISTRADOR PLATINUM\nID: #0001\nACESSO: ILIMITADO\n\nBem-vindo ao Clube Aurora!" 10 45 ;;
            2) nota=$(dialog --inputbox "Sua nota:" 8 40 --stdout)
               [ ! -z "$nota" ] && echo "$nota" >> notas.txt ;;
            3) ip=$(ifconfig | grep "inet "); dialog --msgbox "$ip" 10 50 ;;
            0 | "") break ;;
        esac
    done
}

# --- PÁGINA 2 (SISTEMA) ---
menu_pagina_2() {
    while true; do
        p2=$(dialog --title "Página 2 (Sistema)" --menu "Ferramentas:" 15 45 5             1 "auroraStore (15 Apps)"             2 "Gerenciador de Arquivos"             3 "Status da Bateria"             4 "PRÓXIMA PÁGINA (3) >>"             0 "<< VOLTAR INÍCIO" --stdout)
        case $p2 in
            1) aurora_store ;;
            2) list=$(ls -F); dialog --title "Arquivos" --msgbox "$list" 12 45 ;;
            3) bat=$(termux-battery-status); dialog --msgbox "$bat" 10 45 ;;
            4) menu_pagina_3 ;;
            0 | "") break ;;
        esac
    done
}

# --- MENU PRINCIPAL (1/3) ---
while true; do
    escolha=$(dialog --title "auroraOS V$VERSAO" --menu "Menu Principal:" 15 45 5         1 "Abrir Terminal Aurora"         2 "Calculadora (Segredo: 99)"         3 "Configurações"         7 "PRÓXIMA PÁGINA (2) >>"         0 "Sair" --stdout)

    case $escolha in
        1)
           clear
           echo "alias fetch='mostrar_specs'" > .aurora_bashrc
           echo "export PS1='auroraOS ~$ '" >> .aurora_bashrc
           echo -e "\e[1;36m"; figlet -f small "  AURORA"; echo -e "\e[0m"
           echo "Digite 'fetch' para as 8 especificações."
           bash --rcfile .aurora_bashrc -i
           rm .aurora_bashrc ;;
        2) 
           n=$(dialog --inputbox "Conta ou Segredo:" 8 40 --stdout)
           if [ "$n" == "99" ]; then
               clear; echo -e "\e[1;32m"; figlet "MATRIX"
               for i in {1..30}; do echo -n "$RANDOM "; sleep 0.05; done; read
           elif [ ! -z "$n" ]; then
               res=$(echo "scale=2; $n" | bc 2>/dev/null)
               dialog --msgbox "Resultado: $res" 6 30
           fi ;;
        3) 
           conf=$(dialog --menu "Ajustes:" 10 40 3 1 "Update System" 2 "Limpar Cache" 0 "Voltar" --stdout)
           [ "$conf" == "1" ] && { clear; git pull; sleep 1; }
           [ "$conf" == "2" ] && { pkg clean; dialog --msgbox "Limpo!" 5 20; } ;;
        7) menu_pagina_2 ;;
        0 | "") clear; exit ;;
    esac
done
