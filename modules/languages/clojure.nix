{ pkgs, lib, config, ... }:

let
  inherit (config.gizmo) work;
  inherit (lib) mkIf;
in
{
  config = mkIf (!work) {
    packages = [ pkgs.leiningen ];
    programs.nixvim.plugins.lsp.servers.enable = true;
  };
}
