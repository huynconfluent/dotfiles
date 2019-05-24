#!/bin/bash
#  _           _        _ _
# (_)_ __  ___| |_ __ _| | |
# | | '_ \/ __| __/ _` | | |
# | | | | \__ \ || (_| | | |
# |_|_| |_|___/\__\__,_|_|_|

function createBackupDir () {

    local __bkdir="~/.bk/$(date +%Y-%m-%d-%H%M%S)"
    # create a backup directory if it doesn't exist
    mkdir -p "$__bkdir"

    # move files into backup directory
    for i in .bash_profile .bashrc .profile .vimrc .viminfo .alias; do
        # if not a symlink, backup the file
        if [ ! -h "~/$i" ]; then
            mv "$i" "$__bkdir"
        fi

    done
}

function setupBash () {

    # deploy symlinks to new files
    if [ -f "$(find ~/dotfiles/bash/bashrc -type f)" ]; then
        ln -fs ~/dotfiles/bash/bashrc ~/.bashrc
    else
        printf "~/dotfiles/bash/bashrc NOT FOUND\n"
    fi

    if [ -f "$(find ~/dotfiles/bash/bash_profile -type f)" ]; then
        ln -fs ~/dotfiles/bash/bash_profile ~/.bash_profile
    else
        printf "~/dotfiles/bash/bash_profile NOT FOUND\n"
    fi

    # reload .bash_profile
    source ~/.bash_profile

}

function setupVIM () {

    mkdir -p ~/dotfiles/vim/colors
    # symlink the vim color directory
    ln -fs ~/dotfiles/vim ~/.vim
    # symlink over vim stuff
    ln -fs ~/dotfiles/vim/vimrc ~/.vimrc

    # download vim themes
    curl -s -O https://raw.githubusercontent.com/Yggdroot/duoduo/master/colors/duoduo.vim
    mv duoduo.vim ~/dotfiles/vim/colors/

}

function installApps () {

    # utility apps
    local __apps=(vim tmux nmap jq tree openssl ansible awscli)
    # kafka tools
    local __kafka_apps=(kafkacat)
    # programming languages
    local __prg_lang=(python go node)
    # GUI apps
    local __ui_apps=(cyberduck)

    # check for homebrew
    source ~/dotfiles/bash/functions
    
    $(checkBrew)
    
    # install apps via homebrew
    if [ $(which brew) ]; then
        printf "...Installing apps (via HomeBrew)\n"

        # still need to write the proper install lines
    fi

}

# the loop
while true; do

    printf "dotfiles installation menu...\n\n"
    printf "0 - Automatic Install and Setup\n"
    printf "1 - Install Apps\n"
    printf "2 - Setup VIM\n"
    printf "Q - Quit\n"

    # get input
    read -p "Enter Choice: " choice

    # process choice
    case "$choice" in
        0 )
            # automatic install and setup
            installApps
            setupBash
            setupVIM
            exit 0
            ;;
        1 )
            # install apps
            installApps
            ;;
        2 )
            # setup VIM
            setupVIM
            ;;
        q|Q )
            # quit
            exit 0
            ;;
        * )
            printf "Choice not recognized, try again...\n"
            ;;
    esac
done
