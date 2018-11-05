# Use GPG as SSH agent for YubiKey usage
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# Fix for SSH hanging while prompting for pass
#gpg-connect-agent updatestartuptty /bye
