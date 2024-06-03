{ config
, pkgs
, lib
, ... }:

let
  isDarwin = pkgs.stdenvNoCC.hostPlatform.isDarwin;
  #homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
  username = "gizmo385";
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
  # I use nixvim to manage my neovim configs within nix
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "main";
  });

  zsh = import ./zsh.nix { inherit pkgs homeDirectory; };
in
{

  imports = [
    nixvim.homeManagerModules.nixvim
    zsh
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";

    file = {
      scripts = {
        source = ../scripts;
        target = ".scripts";
        recursive = true;
      };
    };

    sessionVariables = {
      EDITOR = "nvim";
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

    git = import ./git.nix { inherit pkgs; };
    nixvim = import ./neovim;

    # Tool for parsing JSON output
    jq.enable = true;

    # Better shell tooling
    bat.enable = true; # Alternative to cat
    ripgrep.enable = true; # Alternative to grep
    fd.enable = true; # Alternative to find
    eza.enable = true; # Alternative to ls
    fzf.enable = true; # Fuzzy file finder
  };
}
