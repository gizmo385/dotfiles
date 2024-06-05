{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (config.gizmo) work;

  # Custom codeownership plugin
  codeowners = pkgs.vimUtils.buildVimPlugin {
    name = "vim-codeowners";
    src = builtins.fetchGit {
      url = "git@github.com:discord/vim-codeowners.git";
      rev = "ff6d2ad447d17f5c7eaf64fb99a77d1afaa02eda";
    };
  };
in
  {
    options.gizmo.work = mkOption {
      type = types.bool;
      default = true;
      description = "Enable work configs";
    };

    config = mkIf work {
      home.packages = [
          # Tool for managing k8s contexts and namespaces
          pkgs.kubectx
          pkgs.docker-compose
        ];

        programs.nixvim = {
          # Enable some LSPs for I only care about at work
          plugins.lsp.servers = {
            terraformls.enable = true;
            docker.enable = true;
            elixirls.enable = true;
          };

          extraPlugins = [ codeowners ];

          keymaps = [
            {
              key = "<leader>co";
              action = ":CodeownersWhoOwns<CR>";
              mode = "n";
            }
            {
              key = "<leader>ct";
              action = ":CodeownersGotoTeamDefinition<CR>";
              mode = "n";
            }
            {
              key = "<leader>co";
              action = ":CodeownersGotoTeamHelpChannel<CR>";
              mode = "n";
            }
          ];
        };
      };
  }
