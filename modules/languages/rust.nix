{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib.lists) optionals;
  inherit (config.gizmo.languages) rust;
in
{
  config = {
    home = {
      packages = builtins.concatLists [
        # Install the cargo toolchain
        (optionals rust.toolchain [
          pkgs.cargo
          pkgs.rustc
          pkgs.rust-analyzer
        ])
        # Install ra-multiplex, used for the LSP setup
        (optionals rust.toolchain [ pkgs.ra-multiplex ])
      ];
      file = {
        ra-multiplex-config = {
          target = ".config/ra-multiplex/config.toml";
          text = "instance_timeout = false";
        };
      };
    };
    # Setup nix tooling for rust
    programs = {
      nixvim.plugins = {
        lsp.servers = {
          rust_analyzer = {
            enable = rust.lsp;
            cmd = [ "ra-multiplex.sh" ];
            installRustc = false;
            installCargo = false;
            onAttach.function = ''
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              if vim.g.lsp_on_attach ~= nil then
                vim.g.lsp_on_attach(client, bufnr)
              end
            '';
          };
        };
      };
    };
  };
}
