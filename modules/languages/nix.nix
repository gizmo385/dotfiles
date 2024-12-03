{ lib, config, ... }:

let
  inherit (lib) mkOption types;
  inherit (config.gizmo.languages) nix;
in
  {
    options.gizmo.languages.nix = {
      lsp = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the nix LSP tooling";
      };
    };

    config = {
      # Setup the nix LSP
      programs = {
        nixvim.plugins = {
          lsp.servers.nil_ls.enable = nix.lsp;
        };
      };
    };
  }
