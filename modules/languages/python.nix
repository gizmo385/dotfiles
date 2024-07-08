{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (lib.lists) optionals;
  inherit (config.gizmo.languages) python;
in
  {
    options.gizmo.languages.python = {
      tooling = mkOption {
        type = types.bool;
        default = true;
        description = "Enable python language tooling and plugins";
      };
      interpreter = mkOption {
        type = types.bool;
        default = true;
        description = "Install the Python interpreter (some machines have this preinstalled)";
      };
      linters = {
        ruff = mkOption {
          type = types.bool;
          default = true;
          description = "Enable ruff LSP";
        };
        pylsp = mkOption {
          type = types.bool;
          default = true;
          description = "Enable pylsp LSP";
        };
        pyright = mkOption {
          type = types.bool;
          default = true;
          description = "Enable pyright LSP";
        };
      };
    };

    config =  {
      home.packages = builtins.concatLists [
        # Install the tooling if desired
        (optionals python.tooling [pkgs.uv pkgs.ruff])
        # Install the interpreter if desired
        (optionals python.interpreter [pkgs.python3])
      ];

      # Setup the language tooling
      programs.nixvim = mkIf python.tooling {
        autoCmd = [
          {
            event = ["BufEnter"];
            pattern = [ "*.py" ];
            command = ":setlocal textwidth=120";
          }
        ];

        plugins = {
          treesitter.ensureInstalled = ["python"];
          lsp.servers = {
            ruff-lsp.enable = python.linters.ruff;
            pyright.enable = python.linters.pyright;
            pylsp = {
              enable = python.linters.pylsp;
              settings.plugins = {
                ruff = {
                  enabled = python.linters.ruff;
                  lineLength = 120;
                  format = ["I"];
                };
              };
            };
          };
        };
      };
    };
  }
