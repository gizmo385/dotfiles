{ config, pkgs, ... }:

{

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages =
    [
      pkgs.awscli
      pkgs.bat
      pkgs.clojure
      pkgs.docker
      pkgs.docker-compose
      pkgs.fira-code
      pkgs.fzf
      pkgs.gitAndTools.delta
      pkgs.htop
      pkgs.jq
      pkgs.kubectl
      pkgs.mosh
      pkgs.neovim
      pkgs.nodejs
      pkgs.ripgrep
      pkgs.skhd
      pkgs.tmux
      pkgs.vim
      pkgs.watch
      pkgs.yabai
      (pkgs.callPackage ../custom-nix-packages/coder.nix { })
    ];

    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
      }))
      (self: super: {
        neovim = super.neovim.override {
          viAlias = true;
          vimAlias = true;
        };
      })
    ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

 # Fonts
 fonts = {
   enableFontDir = true;
   fonts = [ pkgs.fira-code ];
 };

  # Shell
  programs.bash.enable = false;
  programs.zsh.enable = true;

  # Enable/Disable services
  services.skhd.enable = true;
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
  };

}
