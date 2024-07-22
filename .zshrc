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

prompt off              # disable system settings
colors                  # initialize
compinit                # longest wait
promptinit

zmodload zsh/parameter  # load to use $history[$HISTCMD] variable

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

if which nvim >/dev/null; then
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

# bash like ctrl-w
#autoload -U select-word-style
#select-word-style bash

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

# stop using arrow keys
#bindkey "^[[A" beep # up arrow key
#bindkey "^[[B" beep # down arrow key

# }}}
# Aliases {{{

# Global
alias -g A='alert'
alias -g G='grep'
alias -g O='xdg-open'

alias bc='bc -q'
alias dd='dd status=progress'
alias gv='gvim --remote-silent'
alias fucking='sudo'
alias ll='ls -lh --color'
alias mm="make -j6"
alias tt="tree -CdL 2"
alias wq='du -sh'
alias kt='du -h --max-depth=1 | sort -h'
alias dy='df --sync -hTt ext4'
alias copy='xsel -i --primary'
alias grep='grep --color -i'
alias rsync='rsync --progress'
alias pr='enscript --no-job-header --pretty-print --color --landscape --borders --columns=2 --word-wrap --mark-wrapped=arrow '
alias flush='sync; sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"'
alias httpat='python2 -m SimpleHTTPServer'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias livestreamer='livestreamer -p "mpv --cache=524288 --fs -"'
alias ytdl-audio='yt-dlp --add-metadata --extract-audio --format m4a --audio-format vorbis -o "%(autonumber)02d %(uploader)s - %(title)s (%(id)s).%(ext)s"'
alias uctl='systemctl --user'
alias restart='sudo rc-config restart '
alias qupdate='sudo apt update && sudo apt upgrade'
alias qapt='sudo apt --quiet'
alias n='sudo ss -lpsntu'
alias c='curl -sSL --fail-with-body'
alias cm='clipmenu'
alias ap='ansible-playbook -D'

alias spot="fzf | tr '\n' '\0' | xargs -0 realpath | tee >(xclip -i -selection clipboard) >(xclip -i)"

# wake up caspair
alias wakecaspair='wakeonlan d8:cb:8a:31:9d:5e'
alias wakemelchior='wakeonlan 00:1b:21:06:f1:cc'
alias wakelilim='wakeonlan 8c:16:45:3c:7d:15'

# CapsLock hell escape
alias CAPSLOCKOFF='xkbset nullify lock'
alias CAPSOFF='xkbset nullify lock'

# }}}
# Functions {{{

# locate in current directory
function see() {
    ag --nocolor --nogroup -g "$*"
}

function now() {
    date --rfc-3339=seconds | sed 's/ /T/'
}

function do-reboot() {
    doctl compute d ls $@ --format ID,Name,PublicIPv4,Region,Tags,Status
    ID=$(doctl compute d ls $@ --format ID --no-header)
    if [[ -n "${ID}" ]]; then
        echo
        read -q REPLY\?"Do you really want to reboot this host? (y/n) "
        if [[ "${REPLY}" == "y" ]]; then
            doctl compute droplet-action reboot "${ID}"
        fi
    fi
}

function gc-reboot() {
    NAME=${@:gs/./-}
    gcloud compute instances list --filter="${NAME}"
    ID=$(gcloud compute instances describe "${NAME}" --zone "us-central1-a" --quiet |  grep -oP "^id: '\K(\d+)")
    if [[ -n "${ID}" ]]; then
        echo
        read -q REPLY\?"Do you really want to reboot this host? (y/n) "
        if [[ "${REPLY}" == "y" ]]; then
            gcloud compute instances reset "${NAME}"
        fi
    fi
}

function ac-reboot() {
    aliyun ecs DescribeInstances --InstanceName="${@}" \
        --output "cols=InstanceId,HostName,EipAddress.IpAddress,Status" "rows=Instances.Instance[]"
    ID=$(aliyun ecs DescribeInstances --InstanceName="${@}" | jq -r '.Instances.Instance[0].InstanceId')
    [[ -z "${ID}" ]] && { echo "Instance not found"; return 1 }
    read -q REPLY\?"Do you really want to reboot this host? (y/n) "
    if [[ "${REPLY}" == "y" ]]; then
        STATUS=$(aliyun ecs DescribeInstances --InstanceName="${@}" | jq -r '.Instances.Instance[0].Status')
        if [[ "${STATUS}" == "Stopped" ]]; then
            aliyun ecs StartInstance  --InstanceId="${ID}" | jq -c
        else
            aliyun ecs RebootInstance --InstanceId="${ID}" --ForceStop=true | jq -c
        fi
    fi
}

function aws-reboot() {
    aws --profile nimbus ec2 describe-instances --filters "Name=tag:Name,Values=${@}" --query 'Reservations[0].Instances[0].{Instance:InstanceId,AZ:Placement.AvailabilityZone,IP:PublicIpAddress,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name}' --output text
    ID=$(aws --profile nimbus ec2 describe-instances --filters "Name=tag:Name,Values=${@}" --query 'Reservations[0].Instances[0].InstanceId' --output text)
    if [[ -n "${ID}" ]]; then
        echo
        read -q REPLY\?"Do you really want to reboot this host? (y/n) "
        if [[ "${REPLY}" == "y" ]]; then
            aws --profile nimbus ec2 reboot-instances --instance-ids ${ID}
        fi
    fi
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

# Check if command exists.
function _exists() {
    type "${1}" &>/dev/null
}

# g as simple shortcut for git status or just git if any other arguments are given
function g {
    if [[ $# > 0 ]]; then
        git "$@"
    else
        git status -sb
    fi
}
_exists git && compdef g=git

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
_exists docker && compdef d=docker

function ghpr {
    PR=${1}
    git fetch origin "pull/${PR}/head:pr/${PR}" && \
        git checkout "pr/${PR}"
}

function s {
    if [[ $# == 0 ]]; then
        sudo systemctl list-units --type=service --state=running
    elif [[ $# == 1 ]]; then
        sudo systemctl status "$@"
    else
        sudo systemctl "$@"
    fi
}
_exists systemctl && compdef s=systemctl

function j {
    if [[ $# == 0 ]]; then
        sudo journalctl --lines=30 --follow
    elif [[ $# == 1 ]]; then
        sudo journalctl --lines=30 --follow --unit "$@"
    else
        sudo journalctl "$@"
    fi
}
_exists journalctl && compdef j=journalctl

function t {
    if [[ $# == 0 ]]; then
        terraform plan
    else
        terraform "$@"
    fi
}

function i {
    if [[ $# == 0 ]]; then
        sudo ip --brief addr
    elif [[ $# == 1 ]]; then
        sudo ip addr show  "$@"
    else
        sudo ip "$@"
    fi
}
_exists ip && compdef i=ip

function b {
    if [[ $# == 0 || $1 == "unlock" ]]; then
        if [[ -f "${HOME}/.bwsession" ]]; then
            source "${HOME}/.bwsession"
        fi
        if ! bw login --check; then
            echo "Log in:"
            bw login
        fi
        if ! bw unlock --check; then
            BW_SESSION=$(bw --response unlock | jq '.data.raw')
            export BW_SESSION
            echo "export BW_SESSION=${BW_SESSION}" > "${HOME}/.bwsession"
        fi
        bw sync
    else
        bw "$@"
    fi
}

function r {
    if [[ $# == 0 ]]; then
        sudo systemctl -a list-timers '*backup*'
        restic -q snapshots --latest 3
    elif [[ $# == 1 ]]; then
        restic -q "$@"
    else
        restic "$@"
    fi
}
_exists restic && compdef r=restic

if type zerotier-cli > /dev/null; then
    function z {
        if [[ $# == 0 ]]; then
            sudo zerotier-cli status
        else
            sudo zerotier-cli "$@"
        fi
    }
fi

function a {
    if [[ $# == 0 ]]; then
        ansible localhost -m debug -a 'var=groups'
    else
        ansible "$@"
    fi
}
_exists restic && compdef a=ansible

# repeat last command with sudo
function fuck {
    LAST_CMD=`fc -nl -1`
    echo sudo $LAST_CMD
    sudo zsh -c $LAST_CMD
}

# send a notification when command completes
function alert {
    RVAL=$?                 # get return value of the last command
    DATE=`date +"%Y/%m/%d %H:%M:%S"` # get time of completion
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
    MESSAGE="require(\"naughty\").notify({ \
            title = \"Command completed: \t$DATE\", \
            text = \"$ $LAST\" .. newline .. \"-> $RVAL\", \
            timeout = 0, \
            screen = 1, \
            bg = \"$BG_COLOR\", \
            fg = \"#ffffff\", \
            margin = 8, \
            width = 500, \
            run = function () run_or_raise(nill, { name = \"$LAST\" }) end
            })"
    # send it to awesome
    echo $MESSAGE | awesome-client
}

function select-work-dir() {
    echo "${HOME}"
    WORK_DIR="${HOME}/work"
    SELECTED=$(ls "${WORK_DIR}" | fzf)
    [[ -n "${SELECTED}" ]] && cd "${WORK_DIR}/${SELECTED}"
    echo
    zle reset-prompt
}
zle     -N   select-work-dir
bindkey '^a' select-work-dir

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

# auto completion for ssh hosts
function fzf-ssh () {
  local hosts=$(awk -F '[, ]' '{if ($1 ~ /[a-z]/) {print $1}}' ~/.ssh/known_hosts)
  local domains=$(grep CanonicalDomains ~/.ssh/config | cut -f 2- -d ' ' | tr ' ' '|')
  local selected_host=$(echo $hosts | sed -E "s/\.(${domains})//" | sort -u | fzf --query "$LBUFFER")

  if [ -n "${selected_host}" ]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N fzf-ssh
bindkey '^s' fzf-ssh

# auto completion for cd history
function fzf-cd-history () {
  local cd_history=$(dirs -lp | sort | uniq)
  local paths=$(echo $cd_history | fzf --query "$LBUFFER")

  if [ -n "$paths" ]; then
    cd $selected_host
    zle accept-line
  fi
  zle reset-prompt
}

zle -N fzf-cd-history
bindkey '^k' fzf-cd-history

# systemd service search
function fzf-systemctl () {
    local services=$(
        systemctl list-units --type=service --plain | grep '.service'
    )
    local selected=$(
        echo "${services}" | fzf \
            --query "$LBUFFER" \
            --preview='sudo SYSTEMD_COLORS=1 systemctl status ${1}' \
            --preview-window=bottom,22
    )
    if [[ -n "${selected}" ]]; then
        BUFFER="sudo systemctl --no-pager status ${selected%% *}"
        zle accept-line
    fi
    zle reset-prompt
}

zle -N fzf-systemctl
bindkey '^u' fzf-systemctl

# git log search
function git-log-search() {
  source $HOME/bin/git-log-search
  local selected=$(__fzf_git_log_search__)
  echo "${selected}" > /tmp/x.log
  if [[ -n "${selected%% *}" ]]; then
      BUFFER="git show ${selected%% *}"
      zle accept-line
  fi
  zle reset-prompt
}
zle -N git-log-search
bindkey '^g' git-log-search

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
