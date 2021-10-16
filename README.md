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

## Updating MacOS Packages

I use [nix-darwin](https://github.com/LnL7/nix-darwin) to manage system packages. To update the nix
channels, you can run:

```bash
nix-channel --update
```

And then you can update installed packages with:

```bash
darwin-rebuild switch
```

## Additional Package Managers


#### OCaml

Per [Real World OCaml](https://dev.realworldocaml.org/install.html), the `opam` package manager is
included in the packages installed as a part of Nix on MacOS. If you intend to use OCaml, you can
follow the setup instructions at the provided link or go through these snippets:

```bash
# Initialize OCaml/Opam: For fish shell, the necessary source commands are already present in the
# config, so opam init does not need to add them.
opam init

# Setup the OCaml environment
opam switch create 4.13.1
eval (opam env)

# Install base packages
opam install base utop

# Packages for Real World OCaml
opam install core async yojson core_extended \
     core_bench cohttp-async async_graphics \
     cryptokit menhir

opam install merlin ocp-indent
opam install ocamlformat
```
