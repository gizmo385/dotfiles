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
      ./git.nix
      ./graphical.nix
      ./languages
      ./work.nix
      ./zsh.nix
    ];

    options.gizmo.username = mkOption {
      type = types.str;
      default = "gizmo";
      description = "The username for the system";
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

          rgignore = {
            target = ".rgignore"; 
            text =  ''
            .git
            '';
          };
        };

        sessionVariables = {
          EDITOR = "nvim";
        };

        packages = [
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

      news.display = "silent";
  };
}
