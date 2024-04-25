Gizmo's Dotfiles
=======

All of my configurations for vim/nix/bash/zsh/fish/etc.

# Try them out!

If you'd like to try out my dotfiles without installing them, there are a few different options:

### Using Github Codespaces:

There's a `devcontainer.json` defined in the `.devcontainers` folder in this repo! You're welcome to pull that into your own repos if you want to use my dotfiles in your own repo but you can also just click the button below to spin up a codespace and try them for yourself!

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/gizmo385/dotfiles?quickstart=1)

### Using the Prebuilt Image:

A dockerfile including all of my development configs is automatically built and pushed on every commit to this repo. There is a script in the root of this repo that'll pull the latest image from GHCR and run it:

[![Dev Env Dockerfile](https://github.com/gizmo385/dotfiles/actions/workflows/docker-image.yml/badge.svg?branch=main)](https://github.com/gizmo385/dotfiles/actions/workflows/docker-image.yml)

1. Clone the git repo locally
2. Run `./run-in-docker.sh`. This will pull the latest image from GHCR (`ghcr.io/gizmo385/dotfiles:main`) and launch a container.

### Building the Image Locally

1. Clone the git repo
2. Build the docker image with `docker build .`
3. Run the image with `docker run <image-id>` where `<image-id` is the ID of the built image.

# Installation

To fully install the dotfiles in your local environment:

1. Clone the git repo
2. Run `./install.sh`
3. Source whichever shell RC file matches your shell (`bash`, `zsh`, or `fish`) or restart your shell.

Once the install has been completed, you can interact with the dotfile installation via the `dfs`
CLI tool that is added to the path. Any required Vim plugins will install on first launch.

# Updating Installed Packages

I primarily use [nix](https://github.com/NixOS/nix) to manage my system dependencies. The list of packages installed system-wide via `nix-env` is found in [`packages.nix`](https://github.com/gizmo385/dotfiles/blob/main/configs/nix/packages.nix).
