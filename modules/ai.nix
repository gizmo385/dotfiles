{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf optionals;
  inherit (config.gizmo) ai;
in
{
  config = {
    home = {
      packages = [
        pkgs.pi-coding-agent
      ] ++ optionals ai.tools [
        pkgs.claude-code
        pkgs.claude-agent-acp
      ];

      file = mkIf ai.configs {
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

    programs = mkIf ai.configs {
      zsh = {
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
