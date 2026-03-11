#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'

alias grep='grep --color=auto'
alias gpuusage='watch -n 1 nvidia-smi'
#alias discordbot='$HOME/builds/Chill-Bot/bin/python3 $HOME/builds/Chill-Bot/bot.py'

alias bashrc="nv ~/.bashrc"
alias sourcebash="source ~/.bashrc"
alias rd="rm -r"

alias vim="nv"
alias nvimconf="cd $HOME/.config/nvim"
alias nv="$HOME/appimages/nvim-nightly.appimage"

# Search options
alias wiki="ddgr --np \!w" #Wikipedia
alias aw="ddgr --np \!aw" #Arch Wiki
alias amazon="ddgr --np \!a" #Amazon
alias ug="ddgr --np \!ug" #Ulimate-Guitar
alias yt="ddgr --np \!yt" #YouTube

#PS1='[\u@\h \W]\$ '
# Prompt
. ~/.config/git-prompt.sh
PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)")'
#PS1='\[\e[91m\]\u\[\e[0m\]@\[\e[96m\]\h\[\e[0m\] \[\e[32m\]\W\[\e[33m\]${PS1_CMD1}\[\e[0m\] \$ '
PROMPT_DIRTRIM=3
PS1='\[\e[32m\]\w\[\e[33m\]${PS1_CMD1}\[\e[0m\] \$ '


# path stuff
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/zls:$PATH"
# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/chas/.lmstudio/bin"


# mkcd custom command
function mkcd(){
    mkdir $1 && cd $1
}
