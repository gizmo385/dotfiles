FROM ubuntu:24.04

# Install some base system dependencies
RUN apt-get update && \
    apt-get install curl git python3 xz-utils sudo --yes && \
    rm -rf /var/lib/apt/lists/*

# Create the gizmo user
RUN useradd -ms /bin/bash gizmo
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Setup the nix mount and make gizmo the owner
RUN mkdir -m 0755 /nix && chown gizmo /nix
RUN mkdir /home/gizmo/.vim && chown gizmo /home/gizmo/.vim

# Switch to gizmo
USER gizmo
ENV USER=gizmo
ENV BUILDING_DOTFILES_CONTAINER=1

# Install nix and home-manager
RUN curl -L https://nixos.org/nix/install | sh
RUN . $HOME/.nix-profile/etc/profile.d/nix.sh && nix upgrade-nix
RUN $HOME/.nix-profile/bin/nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
RUN $HOME/.nix-profile/bin/nix-channel --update
RUN . $HOME/.nix-profile/etc/profile.d/nix.sh && nix-shell '<home-manager>' -A install

# Make some directories
RUN mkdir -p $HOME/.config/home-manager
RUN mkdir -p $HOME/.config/nix

# Copy the dotfiles and install them
WORKDIR /home/gizmo/workspaces/dotfiles
COPY --chown=gizmo . .
RUN ln -sf ./modules/home.nix $HOME/.config/home-manager/home.nix
RUN ln -sf ./configs/nix.conf $HOME/.config/nix/nix.conf

# Install the flake
RUN . $HOME/.nix-profile/etc/profile.d/nix.sh && home-manager switch --impure --flake .#docker

# Swap back to the home directory and setup the entrypoint command
WORKDIR /home/gizmo
CMD ["/home/gizmo/.nix-profile/bin/zsh"]
