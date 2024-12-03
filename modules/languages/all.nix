{ lib, config, ... }:

let
  inherit (lib) mkOption mkIf types;
  inherit (config.gizmo.languages) all;
in
  {
  options.gizmo.languages.all = {
    clint = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Discord clint LSP tooling";
    };
  };

  config = {
    # Setup the nix LSP
    programs = {
      nixvim.extraConfigLuaPost = mkIf all.clint ''
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
