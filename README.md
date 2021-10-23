Gizmo385's Dotfiles
=======

All of my configurations for vim/nix/bash/zsh/fish/etc.

## Try em out!

[![Create and publish a Docker image](https://github.com/gizmo385/dotfiles/actions/workflows/docker-image.yml/badge.svg?branch=main)](https://github.com/gizmo385/dotfiles/actions/workflows/docker-image.yml)

If you'd like to try out my dotfiles, you can run them in a docker container that is published on every commit to GHCR! There are 2 ways to do this:

##### Using the Prebuilt Image:

1. Clone the git repo locally
2. Run `./run-in-docker.sh`. This will pull the latest image from GHCR (`ghcr.io/gizmo385/dotfiles:main`) and launch a container.

##### Building the Image Locally

1. Clone the git repo
2. Build the docker image with `docker build .`
3. Run the image with `docker run <image-id>` where `<image-id` is the ID of the built image.
 
### Installation

1. Clone the git repo
2. Run `./install.sh`
3. Source whichever shell RC file matches your shell (`bash`, `zsh`, or `fish`) or restart your shell.

Vim plugins will install on first launch.

## Updating Installed Packages

I use [nix](https://github.com/NixOS/nix) to manage my system dependencies. For MacOS systems, I use [nix-darwin](https://github.com/LnL7/nix-darwin) and for Linux systems I use `nix-env`. The list of packages that are installed can be found in [`packages.nix`](https://github.com/gizmo385/dotfiles/blob/main/dotfiles/nix/packages.nix). To update the pacakges installed on your system:

1. Pull the latest verison of the nix channels: `nix-channel --update`

2. Update the installed packages:
- **Linux**: `nix-env -if <dotfiles-repo>/dotfiles/nix/dev-env.nix`

- **MacOS**: `darwin-rebuild switch`


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
