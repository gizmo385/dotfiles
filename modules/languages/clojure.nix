{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (config.gizmo.languages) clojure;
in
  {
    options.gizmo.languages.clojure = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Clojure language tooling and plugins";
    };

    config = mkIf clojure {
      # TODO: Add autocmds for rainbow parenthesis
      home.packages = [ pkgs.leiningen ];
      programs.nixvim = {
        plugins = {
          lsp.servers.clojure-lsp.enable = true;
          treesitter.ensureInstalled = ["clojure"];
        };

        extraPlugins = with pkgs.vimPlugins; [
          vim-clojure-highlight
          vim-clojure-static
          vim-fireplace
          rainbow_parentheses-vim
        ];
      };
    };
  }
