{ pkgs, lib, config, ... }:

let
  inherit (lib.lists) optionals;
  inherit (config.gizmo.languages) python;
in
{

  config = {
    home.packages = builtins.concatLists [
      # Install some basic python tooling
      [ pkgs.uv pkgs.ruff ]
      # Install the interpreter if desired
      (optionals python.interpreter [ pkgs.python3 ])
    ];

    # Setup the language tooling
    programs.nixvim = {
      autoCmd = [
        {
          event = [ "BufEnter" ];
          pattern = [ "*.py" ];
          command = ":setlocal textwidth=120";
        }
      ];

      plugins = {
        treesitter = {
          settings.ensure_installed = [ "python" ];
        };
        lsp.servers = {
          ruff.enable = python.linters.ruff;
          pyright = {
            enable = python.linters.pyright;
            extraOptions = {
              disableOrganizeImports = !python.linters.ruff;
            };
          };
          pylsp = {
            enable = python.linters.pylsp;
            settings.plugins = {
              ruff = {
                enabled = python.linters.ruff;
                lineLength = 120;
                format = [ "I" ];
              };
            };
          };
        };
      };
    };
  };
}
