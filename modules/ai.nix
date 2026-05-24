{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf optionals;
  inherit (config.gizmo) ai;
  agent-mux = inputs.agent-mux.packages.${pkgs.stdenv.hostPlatform.system}.default;

  jsonMerge = import ./lib/json-merge.nix { inherit lib pkgs; };
  tomlMerge = import ./lib/toml-merge.nix { inherit lib pkgs; };

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

  soundsSrc = ../assets/sounds;
  soundFiles = lib.attrNames (
    lib.filterAttrs (_: t: t == "regular") (builtins.readDir soundsSrc)
  );
  # basename-without-extension -> filename, e.g. "airplane-chime" -> "airplane-chime.mp3"
  soundsByName = lib.listToAttrs (
    map (f: {
      name = lib.removeSuffix ".wav" (lib.removeSuffix ".mp3" f);
      value = f;
    }) soundFiles
  );
  selectedChimeFile = soundsByName.${ai.muxChime};
  agentMuxChimePath = "${config.xdg.dataHome}/sounds/${selectedChimeFile}";

  agentMuxSettingsPatch = {
    notifications = {
      enabled = true;
      sound = true;
      sound_file = agentMuxChimePath;
    };
  };

  soundHomeFiles = lib.listToAttrs (
    map (f: {
      name = "agent_mux_sound_${lib.replaceStrings [ "-" "." ] [ "_" "_" ] f}";
      value = {
        source = soundsSrc + "/${f}";
        target = ".local/share/sounds/${f}";
      };
    }) soundFiles
  );
in
{
  config = {
    home = {
      packages = [
        pkgs.pi-coding-agent
      ]
      ++ optionals ai.tools [
        pkgs.claude-code
        pkgs.claude-agent-acp
      ]
      ++ optionals ai.mux [
        agent-mux
      ];

      file = lib.mkMerge [
        (mkIf ai.configs {
          claude_md = {
            source = ../configs/CLAUDE.md;
            target = "CLAUDE.md";
          };
          claude_statusline = {
            source = ../configs/claude-statusline.sh;
            target = ".claude/statusline-command.sh";
            executable = true;
          };
        })
        (mkIf ai.mux soundHomeFiles)
      ];

      activation = lib.mkMerge [
        (mkIf ai.configs {
          mergeClaudeSettings = jsonMerge {
            targetPath = "${config.home.homeDirectory}/.claude/settings.json";
            patch = claudeSettingsPatch;
          };
        })
        (mkIf ai.mux {
          mergeAgentMuxSettings = tomlMerge {
            targetPath = "${config.home.homeDirectory}/.config/agent-mux/config.toml";
            patch = agentMuxSettingsPatch;
          };
        })
      ];
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

        shellAliases = mkIf ai.mux {
          am = "agent-mux";
        };
      };
    };
  };
}
