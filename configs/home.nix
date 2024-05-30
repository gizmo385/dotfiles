{ config, pkgs, ... }:

let
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
      scripts = {
        source = ./scripts;
        target = ".scripts";
        recursive = true;
      };
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
    git = import ./nix/git.nix { inherit pkgs; };
    nixvim = import ./nix/neovim;

    # Better shell tooling
    bat.enable = true; # Alternative to cat
    fzf.enable = true; # Fuzzy file finder
    ripgrep.enable = true; # Alternative to grep
    fd.enable = true; # Alternative to find
    eza = {
      # Alternative to ls
      enable = true;
      enableZshIntegration = true;
    };
  };
}
