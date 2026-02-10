#!/bin/bash

# --- SETUP INICIAL DO SISTEMA ---
# Cria a pasta do sistema se ela não existir
SYS_DIR="aurora_sys"
mkdir -p "$SYS_DIR"

# Redireciona arquivos temporários para dentro da pasta do sistema
RES="$SYS_DIR/res.txt"
LOG="$SYS_DIR/install.log"
INFO="$SYS_DIR/info.txt"

SENHA="2026"

# --- LOGIN ---
pass=$(dialog --stdout --backtitle "auroraOS V1.1" --title " LOGIN " --passwordbox "CHAVE MESTRA:" 10 40)
[ "$pass" != "$SENHA" ] && clear && exit 1

# --- LOOP PRINCIPAL ---
while true; do
    app=$(dialog --stdout --backtitle "auroraOS V1.1 - Sistema Organizado" \
    --title " DASHBOARD " --menu "Apps e Ferramentas:" 18 55 8 \
    "1" "SISTEMA CORE" \
    "2" "SECURITY & NET" \
    "3" "AURORA STORE (Loja)" \
    "4" "EXPLORADOR DE ARQUIVOS" \
    "5" "CONFIGURAÇÕES" \
    "T" ">> TERMINAL POP-UP" \
    "0" "DESLIGAR")

    [ $? -ne 0 ] || [ "$app" == "0" ] && clear && break

    case $app in
        4) # --- EXPLORADOR COM CRIAÇÃO ---
            DIR=$(pwd)
            while true; do
                file=$(dialog --stdout --title " Local: $DIR " --menu "Ações:" 18 60 10 \
                ".." "[ Voltar ]" "+" "[ NOVA PASTA ]" "*" "[ NOVO ARQUIVO ]" \
                $(ls -F $DIR | head -n 12) "V" "SAIR")
                
                [ "$file" == "V" ] || [ -z "$file" ] && break
                
                if [ "$file" == ".." ]; then cd .. && DIR=$(pwd)
                elif [ "$file" == "+" ]; then
                    nome=$(dialog --stdout --inputbox "Nome da pasta:" 8 40)
                    [ ! -z "$nome" ] && mkdir -p "$nome"
                elif [ "$file" == "*" ]; then
                    nome=$(dialog --stdout --inputbox "Nome do arquivo:" 8 40)
                    if [ ! -z "$nome" ]; then
                        cont=$(dialog --stdout --inputbox "Conteúdo:" 10 50)
                        echo "$cont" > "$nome"
                    fi
                elif [[ "$file" == */ ]]; then cd "$file" && DIR=$(pwd)
                else dialog --textbox "$file" 15 50; fi
            done ;;

        3) # --- LOJA (SALVANDO LOGS NA PASTA SISTEMA) ---
            pkg=$(dialog --stdout --title " STORE " --menu "Apps:" 15 45 5 "python" "Python" "git" "Git" "V" "VOLTAR")
            if [ "$pkg" != "V" ] && [ ! -z "$pkg" ]; then
                dialog --infobox "Instalando $pkg..." 5 30
                pkg install "$pkg" -y > "$LOG" 2>&1
                dialog --title "Log em: $LOG" --textbox "$LOG" 15 55
            fi ;;

        5) # --- CONFIGS COM INFO REAL ---
            conf=$(dialog --stdout --title " Configurações " --menu "Ajustes:" 15 45 5 "Sobre" "Info" "Egg" " [α] " "V" "VOLTAR")
            if [ "$conf" == "Sobre" ]; then
                echo "auroraOS V1.1 - Build 54" > "$INFO"
                echo "Kernel: $(uname -r)" >> "$INFO"
                echo "Pasta Raiz: $SYS_DIR" >> "$INFO"
                dialog --title " Informações " --textbox "$INFO" 12 45
            elif [ "$conf" == "Egg" ]; then
                dialog --title " [α] " --msgbox "Núcleo Aurora Ativo!" 8 35
            fi ;;

        1) neofetch --stdout > "$RES" && dialog --textbox "$RES" 20 50 ;;
        2) curl -s ipinfo.io > "$RES" && dialog --textbox "$RES" 18 50 ;;
        "T") cmd=$(dialog --stdout --inputbox "Comando:" 10 50)
             [ ! -z "$cmd" ] && eval "$cmd" > "$RES" 2>&1 && dialog --textbox "$RES" 18 60 ;;
    esac
done
clear

