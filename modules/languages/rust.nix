{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (config.gizmo.languages) rust;
in
  {
    options.gizmo.languages.rust = mkOption {
      type = types.bool;
      default = false;
      description = "Enable rust language tooling and plugins";
    };

    config = mkIf rust {
      # Install cargo
      home.packages = with pkgs; [ cargo ];
      # Setup nix tooling for rust
      programs = {
        nixvim.plugins = {
          rust-tools.enable = true;
          treesitter.ensureInstalled = ["rust"];
          lsp.servers = {
            rust-analyzer = {
              enable = true;
              installCargo = false;
              installRustc = false;
              settings = {
                cargo.features = "all";
                check = {
                  command = "clippy";
                  features = "all";
                };
              };
            };
          };
        };
      };
    };
  }
