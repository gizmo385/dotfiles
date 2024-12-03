{ pkgs, config, lib, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (config.gizmo) fonts;
in 
  {
    options.gizmo.fonts = mkOption {
      type = types.bool;
      default = true;
      description = "Setup fonts";
    };
    config = mkIf fonts {
      home.packages = with pkgs; [
        # Fonts with better code support
        fira-code
        nerd-fonts.fira-code
      ];
    };
  }
