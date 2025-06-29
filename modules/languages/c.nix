{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (config.gizmo.languages) c;
in
{
  config = mkIf c {
    home.packages = [ pkgs.gcc ];
  };
}
