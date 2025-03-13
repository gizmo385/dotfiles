{ lib, config, ... }:

let
  inherit (lib) mkIf;
  inherit (config.gizmo.languages) setupClint;
in
{
  config = {
    # Setup the clint LSP
    programs = {
      nixvim.extraConfigLuaPost = mkIf setupClint ''
        vim.lsp.start({
           name = 'clint',
           cmd = {'clint', 'lsp'},
           filetypes = { "*" },
           autostart =  true,
        })
      '';
    };
  };
}
