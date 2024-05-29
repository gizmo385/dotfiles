{ config, pkgs, ... }:

let
  packages = import ./nix/packages.nix;
  username = builtins.getEnv "USER";
  homeDirectory = "/home/${username}";

  # I use nixvim to manage my neovim configs within nix
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "main";
  });
in
{

  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";

    file = {
      # Shell configs
      ".tmux.conf".source = ./tmux/tmux.conf;

      # Git configs (these should probably be pulled into nix)
      ".gitconfig".source = ./git/gitconfig;
      ".global_gitignore".source = ./git/global_gitignore;
      "scripts".source = ./scripts;
    };

    sessionVariables = {
      EDITOR = "nvim";
      LC_ALL = "C.UTF-8";
      LANG = "C.UTF-8";
      DEBIAN_FRONTEND = "noninteractive";
    };
  };

  programs = {
    home-manager.enable = true;

    zsh = import ./nix/zsh.nix { inherit homeDirectory pkgs; };

    # Import my neovim configuration
    nixvim = import ./nix/neovim;

    # Better shell tooling
    bat.enable = true; # cat alternative
    fzf.enable = true; # Fuzzy file finder
    ripgrep.enable = true; # grep alternative
    fd.enable = true; # find alternative
    eza = {
      # ls alternative
      enable = true;
      enableZshIntegration = true;
    };
    

    git = {
      enable = true;
      userName = "gizmo385";
      userEmail = "gizmo385@users.noreply.github.com";

      # Install delta, a better diff tool
      delta.enable = true;
    };
  };
}
