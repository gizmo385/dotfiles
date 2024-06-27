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
      home = {
        packages = with pkgs; [ cargo ra-multiplex ];
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
            rust-analyzer = {
              enable = true;
              cmd = ["ra-multiplex.sh"];
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
