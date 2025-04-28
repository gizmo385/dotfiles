{ config, pkgs, lib, ... }:

let
  inherit (lib.lists) optionals;
  inherit (config.gizmo.languages) nix;
in
{
  config = {
    home = {
      packages = builtins.concatLists [
        # Install the interpreter if desired
        (optionals nix.formatter [ pkgs.nixfmt-rfc-style ])
      ];
    };

    programs = {
      nixvim.plugins = {
        # Setup the nix LSP
        lsp.servers.nil_ls = {
          enable = nix.lsp;
          settings.formatting.command = [ "nixfmt" ];
        };
      };
    };
  };
}
