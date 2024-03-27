Gizmo's Dotfiles
=======

All of my configurations for vim/nix/bash/zsh/fish/etc.

## Try them out!

[![Dev Env Dockerfile](https://github.com/gizmo385/dotfiles/actions/workflows/docker-image.yml/badge.svg?branch=main)](https://github.com/gizmo385/dotfiles/actions/workflows/docker-image.yml)

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

Once the install has been completed, you can interact with the dotfile installation via the `dfs`
CLI tool that is added to the path. Any required Vim plugins will install on first launch.

## Updating Installed Packages

I primarily use [nix](https://github.com/NixOS/nix) to manage my system dependencies. The list of packages installed system-wide via `nix-env` is found in [`packages.nix`](https://github.com/gizmo385/dotfiles/blob/main/dotfiles/nix/packages.nix).
