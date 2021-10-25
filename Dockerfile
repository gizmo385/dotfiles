from ubuntu:20.04

# Install some base system dependencies
RUN apt-get update
RUN apt-get install curl git python3 xz-utils sudo --yes

# Create the gizmo user
RUN useradd -ms /bin/bash gizmo

# Setup the nix mount and make gizmo the owner
RUN mkdir -m 0755 /nix && chown gizmo /nix
RUN mkdir /home/gizmo/.vim && chown gizmo /home/gizmo/.vim

# Switch to gizmo
USER gizmo
ENV USER=gizmo
ENV BUILDING_DOTFILES_CONTAINER=1

# Copy the dotfiles and install them
WORKDIR /home/gizmo/workspaces/dotfiles
COPY . .
RUN ./install.sh

# Swap back to the home directory and setup the entrypoint command
WORKDIR /home/gizmo
CMD ["/home/gizmo/.nix-profile/bin/fish"]
