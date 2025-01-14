{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf;
  inherit (config.gizmo.languages) javascript;
in
{
  config = mkIf javascript {
    home.packages = [ pkgs.nodejs ];
  };
}
