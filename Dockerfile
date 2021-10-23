from ubuntu:20.04

# Install some base system dependencies
RUN apt-get update
RUN apt-get install curl git python3 xz-utils sudo --yes

# Create the gizmo user
RUN useradd -ms /bin/bash gizmo

# Setup the nix mount and make gizmo the owner
RUN mkdir -m 0755 /nix && chown gizmo /nix

# Switch to gizmo
USER gizmo
ENV USER=gizmo
WORKDIR /home/gizmo

# Copy the dotfiles and install them
RUN mkdir -p workspaces/dotfiles
COPY . workspaces/dotfiles
WORKDIR /home/gizmo/workspaces/dotfiles
RUN ls

RUN ./install.sh

CMD ["/home/gizmo/.nix-profile/bin/zsh"]
