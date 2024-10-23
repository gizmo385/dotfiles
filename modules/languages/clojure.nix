{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (config.gizmo.languages) clojure;

  paredit = pkgs.vimUtils.buildVimPlugin {
    name = "paredit.vim";
    src = pkgs.fetchFromGitHub {
      owner = "vim-scripts";
      repo = "paredit.vim";
      rev = "791c3a0cc3155f424fba9409a9520eec241c189c";
      hash = "sha256-6b8UpQ65gGAggxifesdd5OHaVcxW4WBnlE6d/dYYj5Y";
    };
  };
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
          lsp.servers.clojure_lsp.enable = true;
          treesitter = {
            settings.ensure_installed = ["clojure"];
          };
        };

        extraPlugins = with pkgs.vimPlugins; [
          vim-clojure-highlight
          vim-clojure-static
          vim-fireplace
          rainbow_parentheses-vim
          paredit
        ];
      };
    };
  }
