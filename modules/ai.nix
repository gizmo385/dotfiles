{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf optionals;
  inherit (config.gizmo) ai;

  jsonMerge = import ./lib/json-merge.nix { inherit lib pkgs; };

  statuslineScript = "${config.home.homeDirectory}/.claude/statusline-command.sh";

  spinnerVerbs = lib.filter (s: s != "") (
    lib.splitString "\n" (builtins.readFile ../configs/claude-spinner-verbs.txt)
  );

  claudeSettingsPatch = {
    statusLine = {
      type = "command";
      command = "bash ${statuslineScript}";
    };
    spinnerVerbs = {
      mode = "replace";
      verbs = spinnerVerbs;
    };
  };
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
        claude_statusline = {
          source = ../configs/claude-statusline.sh;
          target = ".claude/statusline-command.sh";
          executable = true;
        };
      };

      activation = mkIf ai.configs {
        mergeClaudeSettings = jsonMerge {
          targetPath = "${config.home.homeDirectory}/.claude/settings.json";
          patch = claudeSettingsPatch;
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
