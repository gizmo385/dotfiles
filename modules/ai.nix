{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) mkIf;
  inherit (config.gizmo) ai;
in
{
  config = mkIf ai.enable {
    home = {
      packages = [ pkgs.claude-code ];

      file = {
        claude_md = {
          source = ../configs/CLAUDE.md;
          target = "CLAUDE.md";
        };
      };
    };

    programs = {
      # Add an environment variable for the Anthropic API key
      zsh = {
        initContent = ''
          if [ -e $HOME/.anthropic_api_key ]
          then
              export ANTHROPIC_API_KEY="$(cat $HOME/.anthropic_api_key)"
          fi
        '';
      };

      nixvim = {
        # Enable some LSPs for I only care about at work
        plugins = {
          avante = {
            enable = ai.avantePlugin;
            settings = {
              model = "claude-3-7-sonnet-20250219";
              behaviour = {
                enable_cursor_planning_mode = true;
              };
            };
          };
          lualine.settings.extensions = [ "avante" ];
        };

        extraPlugins = mkIf ai.claudeCodePlugin [
          (pkgs.vimUtils.buildVimPlugin {
            name = "claude-code.nvim";
            src = pkgs.fetchFromGitHub {
              owner = "greggh";
              repo = "claude-code.nvim";
              rev = "main";
              sha256 = "sha256-jKWm3lN5nyZ1BsIKMFt4EQhb0n+iyEyOw79Rj/A3yZI=";
            };
          })
        ];

        keymaps = mkIf ai.claudeCodePlugin [
          {
            key = "<leader>aa";
            action = ":ClaudeCode<CR>";
            mode = "n";
            options.silent = true;
          }
        ];

        extraConfigLua = mkIf ai.claudeCodePlugin ''
          require("claude-code").setup({
            window = {
              position = "rightbelow vsplit"
            }
          })
        '';
      };
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "claude-code"
      ];

  };
}
