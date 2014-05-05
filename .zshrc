# Author: Jakub Sokołowski <panswiata@gmail.com>
# Source: https://github.com/PonderingGrower/dotfiles

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

export EDITOR="vim"
export VISION="vim"
export BROWSER="thunar"
export TERMINAL="urxvtc"
export DEITY="fsm"
export PAGER="less"
export MPD_HOST="127.0.0.1"
export CUPS_SERVER="localhost"
export MANPAGER="/bin/sh -c \"col -b | view -c 'set ft=man nomod nolist' -\""
export USE_PYTHON="2.7"

export PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/usr/games/bin:/opt/bin:/usr/lib/distcc/bin:/opt/java/bin/:~/bin:.

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

# fix backspace in append mode
bindkey "^?" backward-delete-char

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
bindkey "${key[Insert]}"  overwrite-mode
bindkey "${key[Delete]}"  delete-char
bindkey "${key[Home]}"    beginning-of-line
bindkey "${key[End]}"     end-of-line
bindkey "^A"    beginning-of-line                           # ctrl + a
bindkey "^S"    end-of-line                                 # ctrl + s
bindkey "^L"    delete-char                                 # ctrl + l
bindkey "^H"    backward-delete-char                        # ctrl + h
bindkey "^E"    kill-word                                   # ctrl + e
bindkey "^W"    backward-kill-word                          # ctrl + w
bindkey "^K"    history-beginning-search-backward           # ctrl + k
bindkey "^J"    history-beginning-search-forward            # ctrl + j
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

alias x='startx'
alias v='vim --servername VIM'
alias S='sudo'
alias ll='ls -lh --color'
alias mm="make -j6"
alias tt="tree -CdL 2"
alias vv="vim --servername VIM --remote-silent"
alias gv="gvim --servername GVIM --remote-silent"
alias wq='du -sh'
alias kt='du -h --max-depth=1 | sort -h'
alias dy='df --sync -hTt ext4'
alias restart='sudo rc-config restart '
alias pjwstk='sudo sshfs s5134@sftp.pjwstk.edu.pl: /mnt/pjwstk -o uid=500,allow_other'
alias sshm='ssh melchior'
alias sshl='TERM=vt100; ssh leliel'
alias rsync='rsync --progress'
alias pr='enscript --no-job-header --pretty-print --color --landscape --borders --columns=2 --word-wrap --mark-wrapped=arrow '
alias flush='sync; sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"'
alias qemerge='sudo emerge --quiet y --quiet-build y --quiet-fail y -v'
alias qupdate='sudo emerge --quiet y --quiet-build y --quiet-fail y -avuD --with-bdeps=y --keep-going @world'
alias psync='ssh melchior "sudo emerge --sync > /tmp/portage_sync.log" && sudo eix-update'
alias httpat='python2 -m SimpleHTTPServer'
# clipboard in command line
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
# easier usage of etckeeper
alias etccommit='sudo etckeeper commit "Quick commit."'
alias sgit='sudo git'
alias gitc='git commit -a -m '
alias livestreamer='livestreamer -p "mpv --cache=524288 --cache-min=0.1 --fs -"'

# }}}
# Functions {{{

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
     git $@
   else
     git status
   fi
}

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

# }}}
