{ config, ... }:

let
  inherit (config.gizmo.languages) nix;
in
{
  config = {
    # Setup the nix LSP
    programs = {
      nixvim.plugins = {
        lsp.servers.nil_ls.enable = nix.lsp;
      };
    };
  };
}
