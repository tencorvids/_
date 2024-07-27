#!/usr/bin/env bash

set -euo pipefail

# Colors
declare -A COLORS=(
    [NORMAL]=$(tput sgr0)
    [WHITE]=$(tput setaf 7)
    [BLACK]=$(tput setaf 0)
    [RED]=$(tput setaf 1)
    [GREEN]=$(tput setaf 2)
    [YELLOW]=$(tput setaf 3)
    [BLUE]=$(tput setaf 4)
    [MAGENTA]=$(tput setaf 5)
    [CYAN]=$(tput setaf 6)
    [BRIGHT]=$(tput bold)
    [UNDERLINE]=$(tput smul)
)

CURRENT_USERNAME='rew'

print_colored() {
    local color="${COLORS[$1]}"
    local text="$2"
    echo -e "${color}${text}${COLORS[NORMAL]}"
}

confirm() {
    echo -en "[${COLORS[GREEN]}y${COLORS[NORMAL]}/${COLORS[RED]}n${COLORS[NORMAL]}]: "
    read -r -n 1
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

print_header() {
    print_colored CYAN "
     _   _ _       ___        ___           _        _ _           
    | \ | (_)_  __/ _ \ ___  |_ _|_ __  ___| |_ __ _| | | ___ _ __ 
    |  \| | \ \/ / | | / __|  | || '_ \/ __| __/ _' | | |/ _ \ '__|
    | |\  | |>  <| |_| \__ \  | || | | \__ \ || (_| | | |  __/ |   
    |_| \_|_/_/\_\\\\___/|___/ |___|_| |_|___/\__\__,_|_|_|\___|_| 

"
    print_colored BLUE "                  https://github.com/tencorvids"
    print_colored RED "      ! To make sure everything runs correctly DONT run as root !"
    print_colored GREEN "                        -> './install.sh'"
    echo
}

get_input() {
    local prompt="$1"
    local variable_name="$2"
    print_colored GREEN "$prompt"
    read -r "$variable_name"
    print_colored YELLOW "Use \"${!variable_name}\" as $prompt?"
    confirm || exit 0
}

set_username() {
    sed -i -e "s/${CURRENT_USERNAME}/${username}/g" ./flake.nix
}

get_host() {
    while true; do
        print_colored GREEN "Choose a host - [C]orvus or [B]ones: "
        read -r -n 1 choice
        echo
        case $choice in
            [Cc]) HOST='corvus'; break ;;
            [Bb]) HOST='bones'; break ;;
            *) print_colored RED "Invalid choice. Please select 'C' for Corvus or 'B' for Bones." ;;
        esac
    done
    print_colored YELLOW "Use the \"$HOST\" host?"
    confirm || exit 0
}

create_directories() {
    local dirs=("Documents" "Downloads" "Development" "Work")
    print_colored MAGENTA "Creating folders:"
    for dir in "${dirs[@]}"; do
        print_colored MAGENTA "    - ~/$dir"
        mkdir -p ~/"$dir"
    done
}

install() {
    print_colored RED "\nSTART INSTALL PHASE\n"
    
    create_directories
    
    print_colored MAGENTA "Copying all documents"
    cp -r documents/* ~/Documents
    
    print_colored MAGENTA "Copying /etc/nixos/hardware-configuration.nix to ./hosts/${HOST}/"
    cp /etc/nixos/hardware-configuration.nix "./hosts/${HOST}/hardware-configuration.nix"
    
    print_colored YELLOW "You are about to start the system build, do you want to proceed?"
    confirm || exit 0
    
    print_colored BLUE "\nBuilding the system...\n"
    sudo nixos-rebuild switch --flake ".#${HOST}"
}

main() {
    print_header
    get_input "username" username
    set_username
    get_host
    install
}

main
