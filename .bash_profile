# Use GPG as SSH agent for YubiKey usage
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# Source secrets like MPD password
. ~/.secret
