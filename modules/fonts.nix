{ pkgs, config, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (config.gizmo) fonts;
in
{
  config = mkIf fonts {
    home.packages = with pkgs; [
      # Fonts with better code support
      fira-code
      nerd-fonts.fira-code
    ];
  };
}
