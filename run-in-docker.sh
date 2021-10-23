#/usr/bin/env bash
echo "Downloading latest dotfiles version..."
docker pull ghcr.io/gizmo385/dotfiles:main
echo "Launching docker container..."
docker run --rm -it ghcr.io/gizmo385/dotfiles:main
