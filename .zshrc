# Source: https://github.com/PonderingGrower/dotfiles

# allow of sourcing from ~/.zfunctions
fpath=(
    ~/.zfunctions
    "${fpath[@]}"
)

[[ -f ~/.secret ]] && source ~/.secret
#[[ -f ~/.ssh-agent.env ]] && source ~/.ssh-agent.env
#[[ -f ~/.gnupg/gpg-agent-info-lilim ]] && source ~/.gnupg/gpg-agent-info-lilim
#export GPG_AGENT_INFO

# Preamble {{{
autoload colors         # enable colors
autoload -U compinit    # enable auto completion
autoload -U promptinit  # advanced prompts support
autoload -U do-reboot   # cloud reboot scripts

prompt off              # disable system settings
colors                  # initialize
compinit                # longest wait
promptinit

zmodload zsh/parameter  # load to use $history[$HISTCMD] variable

# }}}
# Imports {{{

for file in ~/.zsh.conf.d/*; do
    source "$file"
done

# }}}
# Display settings {{{
case $HOST in           # change prompt depending on host
    caspair*|lilim*)
        COLOR="green" ;;
    melchior*)
        COLOR="cyan" ;;
    leliel*)
        COLOR="magenta" ;;
    arael*)
        COLOR="red" ;;
    *)
        COLOR="yellow" ;;
esac

export PURE_PROMPT_SYMBOL="%B%{$fg[$COLOR]%} >%{$reset_color%}%b"
prompt pure

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

# fix for inputting gpg pass in console
export GPG_TTY=$(tty)

# improve output format of 'time'
export TIMEFMT=$'\nreal\t%*Es\nuser\t%*Us\nsys\t%*Ss'

# }}}
# Exports {{{

if _exists nvim; then
    EDITOR="nvim"
    alias vim='nvim'
else
    EDITOR="vim"
fi

export PATH="${PATH}:${HOME}/go/bin:${HOME}/bin"
export EDITOR
export VISION="$EDITOR"
export PAGER="less"
export BROWSER="thunar"
export TERMINAL="urxvtc"
export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man nomod nolist' -\""
export FZF_DEFAULT_OPTS="--extended-exact --height=100% --layout=default"
export SOPS_GPG_KEYSERVER="https://keys.openpgp.org"
export ANSIBLE_REMOTE_USER="admin"
export RESTIC_REPOSITORY="sftp:u288137@u288137.your-storagebox.de:/home/$(hostname)"
export RESTIC_PASSWORD_FILE='/home/jakubgs/.usb_backup_pass'
export PASSWORD_STORE_DIR="$HOME/work/infra-pass"
export DIRENV_LOG_FORMAT=''
export QEMU_OPTS='-m 4096 -smp 4 -display gtk,zoom-to-fit=on'

# Magically link PYTHONPATH to the ZSH array pythonpath
typeset -T PYTHONPATH pythonpath
# Hacky way to provide python packages to Ansible for local tasks.
if [[ -d /etc/profiles/per-user ]]; then
    for SITE_PACKAGES in /etc/profiles/per-user/$USER/lib/python3.*/site-packages; do
        export PYTHONPATH="${PYTHONPATH}:${SITE_PACKAGES}"
    done
fi
# Remove duplicates
typeset -U pythonpath
export PYTHONPATH

# }}}
# General settings {{{

export DIRSTACKSIZE=1000          # number of folder paths to remember
export HISTSIZE=4000              # number of lines kept in history
export SAVEHIST=4000              # number of lines saved in the history after logout
export HISTFILE="$HOME/.zhistory" # location of history
export HISTCONTROL=ignoreboth     # ignore commands starting with space, dedupe
setopt INC_APPEND_HISTORY         # append command to history file once executed
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
setopt INTERACTIVE_COMMENTS       # Allow for comments in interactive command line
setopt completealiases


# }}}
# Completion {{{

# history of changing directories (cd)
setopt AUTO_PUSHD                 # pushes the old directory onto the stack
setopt PUSHD_MINUS                # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                # expand the expression (allows 'cd -2/tmp')
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

# process autocompletion
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# hostname expansion from known_hosts
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null|sort -u)"}%%[# ]*}//,/ })'

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


# cd not select parent dir
# zstyle ':completion:*:cd:*' ignore-parents parent pwd

# }}}
# Key Bindings {{{
typeset -A key
# Vim mode
bindkey -v
# 10ms for key sequences
KEYTIMEOUT=1

# Use ESC to edit the current command line:
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line

# fix backspace in append mode
bindkey "^?" backward-delete-char

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
bindkey "^[."   insert-last-word   # Alt + .
bindkey -s '\e.' insert-last-word  # Alt + .
bindkey "^L"    clear-screen                                # ctrl + l
bindkey "^Q"    kill-word                                   # ctrl + q
bindkey "^W"    backward-kill-word                          # ctrl + w
bindkey "^R"    history-incremental-pattern-search-backward # ctrl + r
bindkey "\e[2~" quoted-insert

# }}}
# FZF {{{

if [ -n "${commands[fzf-share]}" ]; then
    # This is available on NixOS
    source $(fzf-share)/completion.zsh
    source $(fzf-share)/key-bindings.zsh
elif [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
fi
bindkey '^F' fzf-cd-widget

# }}}
# Direnv {{{

# Sources configs in infra repos.
if [ -n "${commands[direnv]}" ]; then
    eval "$(direnv hook zsh)"
fi

# }}}
