
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH=/bin:/usr/bin:/Library/Frameworks/Python.framework/Versions/3.3/bin:.scripts:$PATH

if [ -e /Users/gizmo385/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/gizmo385/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
