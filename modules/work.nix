{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (config.gizmo) work;

  # Custom codeownership plugin
  codeowners = pkgs.vimUtils.buildVimPlugin {
    name = "vim-codeowners";
    src = builtins.fetchGit {
      url = "git@github.com:discord/vim-codeowners.git";
      rev = "ff6d2ad447d17f5c7eaf64fb99a77d1afaa02eda";
    };
  };
  
  claude-code = pkgs.vimUtils.buildVimPlugin {
    name = "greggh/claude-code.nvim";
    src = builtins.fetchGit {
      url = "git@github.com:greggh/claude-code.nvim.git";
      rev = "d1dbc6b7025c4f034e14cc0dda6d29d5a6a5c4e8";
    };
  };
in
{
  config = mkIf work {
    home = {
      packages = [
        # Tool for managing k8s contexts and namespaces
        pkgs.kubectx
        pkgs.docker-compose
        pkgs.claude-code
      ];
      sessionVariables = {
        # Used by Clyde to install the updated nix version
        USE_NEW_NIX = "1";
      };
    };

    programs = {
      lazygit.settings = {
        git.branchPrefix = "gizmo/";
      };
    };


    # Disable oh-my-zsh git prompt statuses because they're slow on the monorepo
    programs.git.extraConfig = {
      oh-my-zsh = {
        hide-status = 1;
        hide-dirty = 1;
      };
    };

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "claude-code"
    ];

    programs.nixvim = {
      # Enable some LSPs for I only care about at work
      plugins = {
        lsp.servers = {
          bashls.enable = true;
          terraformls.enable = true;
          dockerls.enable = true;
          docker_compose_language_service.enable = true;
          elixirls.enable = true;
        };
      };

      extraConfigLuaPost = ''
      require('claude-code').setup()
      '';

      extraPlugins = [ codeowners claude-code ];

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
        {
          key = "<leader>C";
          action = ":FloatermNew --width=0.9 --height=0.9 clyde tui<CR>";
          mode = "n";
        }
        
        {
          key = "<leader>aa";
          action = ":ClaudeCode<CR>";
          mode = "n";
        }

      ];
    };
  };
}
