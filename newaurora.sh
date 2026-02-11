#!/bin/bash

# --- VARIÁVEIS DE SISTEMA ---
SENHA_CORRETA="2026"
VERSAO="2.1"

# --- AUTO-INSTALADOR DE DEPENDÊNCIAS ---
for pkg in dialog bc neofetch figlet git; do
    if ! command -v $pkg &> /dev/null; then
        echo "📦 Instalando $pkg..."
        pkg install $pkg -y
    fi
done

# --- TELA DE LOGIN ---
senha=$(dialog --title "Segurança Aurora" --passwordbox "Digite a Chave Mestra:" 8 45 --stdout)
[ "$senha" != "$SENHA_CORRETA" ] && { clear; exit 1; }

# --- FUNÇÃO DE ATUALIZAÇÃO (NOVIDADE V2.1) ---
atualizar_sistema() {
    dialog --title "Update Center" --yesno "Deseja verificar atualizações no GitHub?" 7 45
    if [ $? -eq 0 ]; then
        clear
        echo "🔄 Sincronizando com o repositório..."
        git pull origin main
        echo "✅ Atualização concluída! Reinicie o script."
        read -p "Pressione Enter para voltar..."
    fi
}

# --- PAINEL DE CONFIGURAÇÕES ---
configuracoes() {
    while true; do
        conf=$(dialog --title "Painel de Controle" --menu "Ajustes do Sistema:" 13 45 5 \
            1 "Alterar Senha Mestra" \
            2 "Informações da Versão" \
            3 "Ativar Núcleo [α]" \
            4 "ATUALIZAR SOFTWARE" \
            0 "Voltar" --stdout)

        case $conf in
            1) nova=$(dialog --inputbox "Nova senha:" 8 40 --stdout)
               [ ! -z "$nova" ] && SENHA_CORRETA="$nova" && dialog --msgbox "Senha alterada!" 6 30 ;;
            2) dialog --title "Sobre" --msgbox "auroraOS V$VERSAO\nDev: nerdgalaxya1-cyber" 8 40 ;;
            3) dialog --title "NÚCLEO ALPHA" --msgbox "Segredo [α] Ativado!" 6 35 ;;
            4) atualizar_sistema ;;
            0) break ;;
        esac
    done
}

# --- OUTRAS FUNÇÕES ---
gerenciador_arquivos() {
    item=$(dialog --title "Gerenciador" --menu "Opções:" 12 40 3 1 "Criar Pasta" 2 "Remover" 0 "Voltar" --stdout)
    case $item in
        1) n=$(dialog --inputbox "Nome da pasta:" 8 40 --stdout); mkdir "$n" ;;
        2) n=$(dialog --inputbox "Nome do arquivo:" 8 40 --stdout); rm -rf "$n" ;;
    esac
}

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
            3) dialog --title "SUPORTE" --msgbox "WhatsApp: +55 64 9341-5513" 8 45 ;;
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
        5) gerenciador_arquivos ;;
        6) configuracoes ;;
        7) menu_pagina_2 ;;
        0) clear; exit ;;
    esac
done
