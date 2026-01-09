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
      packages = [
        pkgs.claude-code
        pkgs.claude-code-acp
      ];

      file = {
        claude_md = {
          source = ../configs/CLAUDE.md;
          target = "CLAUDE.md";
        };
        toad_json = {
          source = ../configs/toad.json;
          target = ".config/toad/toad.json";
          force = true;
        };
      };
    };

    programs = {
      nixvim = {
        plugins = mkIf ai.copilot {
          lsp.servers.copilot.enable = true;
          sidekick.enable = true;
        };
        keymaps = mkIf ai.copilot [
          {
            key = "<tab>";
            action.__raw = ''
              function()
                if not require("sidekick").nes_jump_or_apply() then
                  return "<Tab>"
                end
              end
            '';
            mode = [ "n" "i" ];
            options = {
              expr = true;
              desc = "Goto/Apply Next Edit Suggestion";
            };
          }
        ];
      };


      zsh = {
        shellAliases = {
          toad = "uvx --from batrachian-toad toad acp ${pkgs.claude-code-acp}/bin/claude-code-acp";
        };
        # Add an environment variable for the Anthropic API key
        initContent = ''
          if [ -e $HOME/.anthropic_api_key ]
          then
              export ANTHROPIC_API_KEY="$(cat $HOME/.anthropic_api_key)"
          fi
        '';
      };
    };
  };
}

