Gizmo385's Dotfiles
=======

All of my configurations for vim/nix/bash/zsh/etc.

### Installation

To quickly install these run the following command:

```bash
curl https://raw.githubusercontent.com/gizmo385/dotfiles/main/install.sh | sh
```

After you have the files installed, you can run the `update_dotfiles` alias to pull the latest
changes from git. If you need to relink dotfiles, you can run `reinstall_dotfiles` and it will
reinstall/relink everything.


### Forking the Project
If you wish to fork these dotfiles for yourself, there are a few areas you might wish to change:

* In the `install.sh` script, change the variable to point the script towards your fork and
  branch
