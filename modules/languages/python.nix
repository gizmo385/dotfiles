{ lib, config, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (config.gizmo.languages) python;
in
  {
    options.gizmo.languages.python = mkOption {
      type = types.bool;
      default = true;
      description = "Enable python language tooling and plugins";
    };

    config = mkIf python {
      programs.nixvim.plugins = {
        treesitter.ensureInstalled = ["python"];
        lsp.servers = {
          ruff-lsp.enable = true;
          pylsp = {
            enable = true;
            settings.plugins = {
              ruff = {
                enabled = true;
                lineLength = 120;
              };
            };
          };
        };
      };
    };
  }
