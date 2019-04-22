# Use GPG as SSH agent for YubiKey usage
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# Source secrets like MPD password
. ~/.secret
if [ -e /home/sochan/.nix-profile/etc/profile.d/nix.sh ]; then . /home/sochan/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
