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
        local root_files = {'clint.config.ts'}
        local paths = vim.fs.find(root_files, {stop = vim.env.HOME})
        local root_dir = vim.fs.dirname(paths[1])
        if root_dir then
          vim.lsp.start({
             name = 'clint',
             cmd = {'clint', 'lsp'},
             root_dir = root_dir,
             autostart =  true,
          })
        end
      '';
    };
  };
}
