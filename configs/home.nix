{ config, pkgs, ... }:

let
  packages = import ./nix/packages.nix;
  username = "gizmo";
  homeDirectory = "/home/${username}";

  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    # ref = "nixos-23.05";
  });
in
{

  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";

    # packages = packages.packagesToInstall;

    file = {
      # Shell configs
      ".tmux.conf".source = ./tmux/tmux.conf;

      # Editor configs
      # ".vimrc".source = ./vim/vimrc;
      # "bindings.vim".source = ./vim/bindings.vim;
      # "plugin_settings.vim".source = ./vim/plugin_settings.vim;
      # "plugins.vim".source = ./vim/plugins.vim;
      # "settings.vim".source = ./vim/settings.vim;

      # Git configs
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

    # neovim = {
    #   enable = true;
    #   vimAlias = true;
    #   defaultEditor = true;

    #   extraConfig = (builtins.readFile ./nvim/init.vim);
    # };

    zsh = import ./nix/zsh.nix { inherit homeDirectory pkgs; };

    nixvim = import ./nix/neovim;

    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    bat.enable = true;

    git = {
      enable = true;
      userName = "gizmo385";
      userEmail = "gizmo385@users.noreply.github.com";
    };
  };
}