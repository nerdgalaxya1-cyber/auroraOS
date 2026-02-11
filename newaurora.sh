#!/bin/bash

# --- VARIÁVEIS DE SISTEMA ---
SENHA_CORRETA="2026"
VERSAO="2.0"

# --- TELA DE LOGIN ---
senha=$(dialog --title "Segurança Aurora" --passwordbox "Digite a Chave Mestra:" 8 45 --stdout)
[ "$senha" != "$SENHA_CORRETA" ] && { clear; exit 1; }

# --- FUNÇÃO DE CONFIGURAÇÕES (CORRIGIDA) ---
configuracoes() {
    while true; do
        conf=$(dialog --title "Painel de Controle" --menu "Ajustes do Sistema:" 12 45 4 \
            1 "Alterar Senha Mestra" \
            2 "Informações da Versão" \
            3 "Ativar Núcleo [α]" \
            0 "Voltar" --stdout)

        case $conf in
            1) 
                nova=$(dialog --title "Segurança" --inputbox "Nova senha:" 8 40 --stdout)
                if [ ! -z "$nova" ]; then
                    SENHA_CORRETA="$nova"
                    dialog --msgbox "Senha alterada com sucesso!" 6 35
                fi ;;
            2) dialog --title "Sobre" --msgbox "auroraOS V$VERSAO\nDev: nerdgalaxya1-cyber" 8 40 ;;
            3) dialog --title "NÚCLEO ALPHA" --msgbox "Segredo [α] Ativado!\nAcesso ao Kernel Aurora liberado." 7 45 ;;
            0) break ;;
        esac
    done
}

# --- OUTRAS PÁGINAS E FUNÇÕES ---
menu_pagina_2() {
    while true; do
        p2=$(dialog --title "auroraOS - Página 2" --menu "Mais Funções:" 15 45 5 \
            1 "Aurora Store" \
            2 "Status da Bateria" \
            3 "Reportar Bugs (WhatsApp)" \
            0 "Voltar" --stdout)
        case $p2 in
            1) dialog --msgbox "Loja em manutenção." 6 35 ;;
            2) status=$(termux-battery-status); dialog --msgbox "$status" 10 45 ;;
            3) dialog --title "SUPORTE" --msgbox "Reporte bugs no WhatsApp:\n+55 64 9341-5513" 8 45 ;;
            0) break ;;
        esac
    done
}

# --- MENU PRINCIPAL ---
while true; do
    escolha=$(dialog --title "auroraOS V$VERSAO [α]" --menu "Menu Principal:" 16 45 8 \
        1 "Terminal Pop-up" \
        2 "Calculadora" \
        3 "Calendário" \
        4 "Bloco de Notas" \
        5 "Gerenciador de Arquivos" \
        6 "Configurações" \
        7 "VER MAIS >>" \
        0 "Sair" --stdout)

    case $escolha in
        1) clear; figlet "Aurora"; bash --rcfile <(echo "export PS1='auroraOS ~\$ '") ;;
        2) n=$(dialog --inputbox "Conta:" 8 40 --stdout); [ ! -z "$n" ] && dialog --msgbox "Resultado: $(echo "scale=2; $n" | bc)" 6 30 ;;
        3) dialog --calendar "Data:" 0 0 ;;
        4) f=$(dialog --inputbox "Arquivo:" 8 40 --stdout); [ ! -z "$f" ] && { touch "$f"; dialog --editbox "$f" 20 60 2> "$f"; } ;;
        5) # Coloque aqui sua função de gerenciador se tiver
           dialog --msgbox "Abrindo Gerenciador..." 5 30 ;;
        6) configuracoes ;;
        7) menu_pagina_2 ;;
        0) clear; break ;;
    esac
done
