# Source: https://github.com/PonderingGrower/dotfiles

# source ssh-agent variables
source ~/.secret
source ~/.ssh-agent.env
source ~/.gnupg/gpg-agent-info-lilim
export GPG_AGENT_INFO

# Preamble {{{
autoload colors         # enable colors
autoload -U compinit    # enable auto completion
autoload -U promptinit  # advanced prompts support

colors                  # initialize
compinit                # longest wait
promptinit

zmodload zsh/parameter  # load to use $history[$HISTCMD] variable

# }}}
# Display settings {{{
case $HOST in           # change prompt depending on host
    melchior)
        COLOR="cyan" ;;
    caspair)
        COLOR="blue" ;;
    arael)
        COLOR="red" ;;
    zeruel)
        COLOR="red" ;;
    *)
        COLOR="green" ;;
esac

export PROMPT="%B%{%(#.$fg[red].$fg[${COLOR}])%} %n@%m: %1~%#%{$reset_color%}%b "
export PS1=$PROMPT
export PROMPT=$PROMPT

# define colors for less to get colored manpages
# or wget nion.modprobe.de/mostlike.txt && mkdir ~/.terminfo && cp mostlike.txt ~/.terminfo && tic ~/.terminfo/mostlike.txt
export LESS_TERMCAP_mb=$'\E[0;34m'    # begin blinking
export LESS_TERMCAP_md=$'\E[0;34m'    # begin bold
export LESS_TERMCAP_us=$'\E[01;34m'    # begin underline
export LESS_TERMCAP_me=$'\E[0m'        # end mode
export LESS_TERMCAP_se=$'\E[0m'        # end standout-mode
export LESS_TERMCAP_so=$'\E[01;47;34m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'        # end underline
export GROFF_NO_SGR=1

# color stderr red
#exec 2>>(while read line; do
#  print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done &)

# }}}
# Exports {{{
#
export TERMINFO=/usr/share/terminfo
#export VIMRUNTIME="/usr/local/share/vim/vim74"
export NVIMRUNTIME=/usr/local/share/nvim/runtime
export EDITOR="vim"
export VISION="vim"
export BROWSER="thunar"
export TERMINAL="urxvtc"
export DEITY="fsm"
export PAGER="less"
export CUPS_SERVER="localhost"
export MANPAGER="/bin/sh -c \"col -b | view -c 'set ft=man nomod nolist' -\""
export USE_PYTHON="2.7"

export PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/usr/games/bin:/opt/bin:/usr/lib/distcc/bin:/opt/java/bin/:/opt/logstash-1.4.2/bin:~/bin:.

# prepare environment for chef usage
eval "$(chef shell-init zsh)"

fpath=(~/tools/zsh-completions/src $fpath)

# Export for java classpath
export CLASSPATH=./:/opt/java/lib:/opt/java:/opt/java/jre/lib:/usr/share/java/hibernate/hibernate3.jar:/usr/share/java/postgresql-jdbc/postgresql-jdbc4.jar

# }}}
# General settings {{{

export HISTSIZE=4000              # number of lines kept in history
export SAVEHIST=4000              # number of lines saved in the history after logout
export HISTFILE="$HOME/.zhistory" # location of history
setopt INC_APPEND_HISTORY         # append command to history file once executed
setopt APPEND_HISTORY             # Don't overwrite, append!
setopt SHARE_HISTORY              # for sharing history between zsh proce'ses
setopt HIST_IGNORE_ALL_DUPS       # Ignore duplicates in history
setopt HIST_IGNORE_SPACE          # don't record entry if a space is preceeding it
setopt NO_CASE_GLOB               # case insensitive globbing
setopt NOFLOWCONTROL              # Nobody needs flow control anymore. Troublesome feature.
setopt AUTO_PUSHD                 # auto directory pushd that you can get dirs list by cd -[tab]
setopt AUTOCD                     # change directory without using cd command
setopt EXTENDEDGLOB               # Regular expressions in files
setopt COMPLETE_IN_WORD           # allow tab completion in the middle of a word
setopt AUTO_RESUME                # Resume jobs after typing it's name
setopt CHECK_JOBS                 # Dont quit console if processes are running

# }}}
# Completion {{{

# process autocompletion
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# hostname expansion from known_hosts
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# :completion:<func>:<completer>:<command>:<argument>:<tag>
# Expansion options
zstyle ':completion:*' completer _complete _prefix _expand _approximate
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Separate matches into groups
zstyle ':completion:*:matches'    group 'yes'
zstyle ':completion:*'          group-name ''
zstyle ':completion:*:messages' format '%d'

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
# set format for warnings
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# colorful listings
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' special-dirs true
# activate color-completion(!)
#zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

# Nicer copletion
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# tab completion for PID
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'

# cache
zstyle ':completion:*' use-cache 1
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' accept-exact '*(N)'

# format on completion
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false
# activate menu
zstyle ':completion:*:history-words'   menu yes
# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# provide verbose completion information
zstyle ':completion:*'                 verbose true
# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'
# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# arrow driven menu
zstyle ':completion:*' menu select

# How to handle different filetypes
zstyle ':mime:.jpg:' handler feh -x %s

#
# # cd not select parent dir
# zstyle ':completion:*:cd:*' ignore-parents parent pwd
#
# }}}
# Key Bindings {{{
typeset -A key
# Vim mode
bindkey -v
# 10ms for key sequences
KEYTIMEOUT=1

# edit current command in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# bash like ctrl-w
autoload -U select-word-style
select-word-style bash

# fix backspace in append mode
bindkey "^?" backward-delete-char

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
bindkey "^[."   insert-last-word   # Alt + .
bindkey -s '\e.' insert-last-word  # Alt + .
bindkey "^L"    clear-screen                                # ctrl + l
bindkey "^E"    kill-word                                   # ctrl + e
bindkey "^W"    backward-kill-word                          # ctrl + w
bindkey "^R"    history-incremental-pattern-search-backward # ctrl + r
bindkey "\e[2~" quoted-insert

# stop using arrow keys
#bindkey "^[[A" beep # up arrow key
#bindkey "^[[B" beep # down arrow key

# }}}
# Aliases {{{

# Global
alias -g A='; alert'
alias -g G='| grep --color -iE'
alias -g V='| vim -'

alias gv='gvim --remote-silent'
alias S='sudo'
alias ll='ls -lh --color'
alias mm="make -j6"
alias tt="tree -CdL 2"
alias wq='du -sh'
alias kt='du -h --max-depth=1 | sort -h'
alias dy='df --sync -hTt ext4'
alias grep='grep --color -i'
alias ssh='TERM=xterm-256color ssh'
alias sshm='ssh melchior'
alias rsync='rsync --progress'
alias pr='enscript --no-job-header --pretty-print --color --landscape --borders --columns=2 --word-wrap --mark-wrapped=arrow '
alias flush='sync; sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"'
alias httpat='python2 -m SimpleHTTPServer'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias livestreamer='livestreamer -p "mpv --cache=524288 --fs -"'
alias ytdl-audio='youtube-dl -x --audio-format mp3 --output "%(autonumber)s-%(title)s.%(ext)s" --autonumber-size 2'
alias qapt='sudo aptitude --quiet'
alias qupdate='sudo aptitude update && sudo aptitude upgrade'
alias sctl='sudo systemctl'
alias uctl='systemctl --user'
alias restart='sudo rc-config restart '
alias current-frontend='ssh balancer-iris.codility.net ls -l /srv/codility/frontends | grep -E "(current|offline)"'

# }}}
# Functions {{{

# codility readonly db access
function codilitydb() {
    eval 'ssh -N -L 15432:127.0.0.1:5432 database-crimson.codility.net &'
    SSH_TUNNEL_PID=$!
    sleep 2
    psql -U readonly -h 127.0.0.1 -p 15432 codility
    kill $SSH_TUNNEL_PID
}

# codility testing container
function dcodility() {
    docker run -it --privileged \
               --name codility_testing_$(date +%H%M_%d%m%y) \
               -v ~/work/codility:/srv/codility/install \
               codility:testing \
               /bin/bash
}

function batchssh() {
    QUERY='*:*'
    if [[ $1 == '-q' ]]; then
        QUERY=$2
        shift 2
    fi
    CMD=$@
    OLD_PWD=$PWD
    cd ~/work/infrastructure
    knife ssh -a fqdn "$QUERY" "$CMD"
    cd $OLD_PWD
}

# locate in current directory
function spot() {
    ag --nocolor --nogroup -g "$*"
}

function sshl() {
    OLDTERM=$TERM
    TERM="vt100"

    ssh leliel

    TERM=$OLDTERM
}

# reload zshrc
function src() {
    autoload -U zrecompile
    [[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc
    [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
    [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
    [[ -f ~/.zshrc.zwc.old ]] && rm -f ~/.zshrc.zwc.old
    [[ -f ~/.zcompdump.zwc.old ]] && rm -f ~/.zcompdump.zwc.old
    source ~/.zshrc
}

# g as simple shortcut for git status or just git if any other arguments are given
function g {
    if [[ $# > 0 ]]; then
        git "$@"
    else
        git status
    fi
}
compdef g=git

function d {
    if [[ $1 == 'clean' ]]; then
        docker rm $(docker ps -a -q)
    elif [[ $1 == 'cleanimages' ]]; then
        docker rmi $(docker images -f dangling=true -q)
    elif [[ $# > 0 ]]; then
        docker "$@"
    else
        docker ps
    fi
}
compdef d=docker

# repeat last command with sudo
function fuck {
    LAST_CMD=`fc -nl -1`
    echo sudo $LAST_CMD
    sudo zsh -c $LAST_CMD
}

# send a notification when command completes
function alert {
    RVAL=$?                 # get return value of the last command
    DATE=`date +"%a %b %d/%m/%Y, %H:%M:%S"` # get time of completion
    LAST=$history[$HISTCMD] # get current command
    LAST=${LAST%[;&|]*}     # remove "; alert" from it
    echo -ne "\e]2;$LAST\a" # set window title so we can get back to it
    LAST=${LAST//\"/'\"'}   # replace " for \" to not break lua format

    # check if awesome is present
    (( $+commands[awesome-client] )) || return

    # check if the command was successful
    if [[ $RVAL == 0 ]]; then
        RVAL="SUCCESS"
        BG_COLOR="#535d9a"
    else
        RVAL="FAILURE"
        BG_COLOR="#ba3624"
    fi

    # compose the notification
    MESSAGE="naughty.notify({ \
            title = \"Command completed on: \t\t$DATE\", \
            text = \"$ $LAST\" .. newline .. \"-> $RVAL\", \
            timeout = 0, \
            screen = 2, \
            bg = \"$BG_COLOR\", \
            fg = \"#ffffff\", \
            margin = 8, \
            width = 380, \
            run = function () run_or_raise(nill, { name = \"$LAST\" }) end
            })"
    # send it to awesome
    echo $MESSAGE | awesome-client -
}

# change color based on vimode
zle-keymap-select () {
    if [ $KEYMAP = vicmd ]; then
        echo -ne "\033]12;Red\007"
    else
        echo -ne "\033]12;White\007"
    fi
}

zle-line-finish () {
    zle -K viins
    echo -ne "\033]12;White\007"
}

zle-line-init () {
    zle -K viins
    echo -ne "\033]12;White\007"
}

# use these only if terminal is graphical
if [[ $TERM != "linux" ]]; then
    zle -N zle-keymap-select
    zle -N zle-line-finish
    zle -N zle-line-init
fi

# }}}
