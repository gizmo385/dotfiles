{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib.lists) optionals;
  inherit (config.gizmo.languages) python;
in
{

  config = {
    home.packages = builtins.concatLists [
      # Install some basic python tooling
      [
        pkgs.uv
        pkgs.ruff
      ]
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
        {
          event = [ "BufWritePre" ];
          pattern = [ "*.py" ];
          callback = {
            __raw = ''
              function()
                vim.lsp.buf.code_action({
                  context = { only = { "source.organizeImports" } },
                  apply = true,
                })
              end
            '';
          };
        }
      ];

      plugins = {
        treesitter = {
          grammarPackages = [
            pkgs.vimPlugins.nvim-treesitter.builtGrammars.python
          ];
        };
        lsp.servers = {
          ruff = {
            enable = python.linters.ruff;
            extraOptions = {
              init_options.settings.args = [ "--select=I" ];
            };
          };
          ty.enable = python.linters.ty;
          pyright = {
            enable = python.linters.pyright;
            extraOptions = {
              disableOrganizeImports = !python.linters.ruff;
            };
          };
        };
      };
    };
  };
}
