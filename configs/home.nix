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

  home.packages = [
    # Tool for managing k8s contexts and namespaces
    pkgs.kubectx
    # Alternative to man pages that provides examples
    pkgs.tldr
    # Tool for parsing YAML output (jq but for YAML)
    pkgs.yq
  ];

  programs = {
    home-manager.enable = true;

    zsh = import ./nix/zsh.nix { inherit homeDirectory pkgs; };
    git = import ./nix/git.nix { inherit pkgs; };
    nixvim = import ./nix/neovim;

    # Tool for parsing JSON output
    jq.enable = true;

    # Better shell tooling
    bat.enable = true; # Alternative to cat
    ripgrep.enable = true; # Alternative to grep
    fd.enable = true; # Alternative to find
    eza = {
      # Alternative to ls
      enable = true;
      enableZshIntegration = true;
    };

    # Fuzzy file finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
