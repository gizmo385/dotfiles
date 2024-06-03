{ config
, pkgs
, lib
, ... }:

let
  # I use nixvim to manage my neovim configs within nix
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "main";
  });

  inherit (lib) mkOption types;
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;
  inherit (config.gizmo) username;
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
in
  {
    imports = [
      nixvim.homeManagerModules.nixvim
      ./zsh.nix
      ./git.nix
    ];

    options.gizmo = {
      username = mkOption {
        type = types.str;
        default = "gizmo";
        description = "The username for the system";
      };

      work = mkOption {
        type = types.bool;
        default = false;
        description = "Whether or not this is a work system";
      };
    };

    config = {
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

        packages = [
          # Tool for managing k8s contexts and namespaces
          pkgs.kubectx
          # Alternative to man pages that provides examples
          pkgs.tldr
          # Tool for parsing YAML output (jq but for YAML)
          pkgs.yq
        ];
      };

      programs = {
        home-manager.enable = true;

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
  };
}
