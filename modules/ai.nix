{ config
, inputs
, lib
, pkgs
, ...
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

  # OpenTelemetry export to SigNoz on alpenglow (monitoring.acbc.house).
  # otlp.acbc.house is Caddy in front of SigNoz's Alloy agent (OTLP/HTTP) and
  # only answers on the tailnet/LAN; off it, exports fail quietly. The
  # OTEL_LOG_* gates send prompt/response text and tool details (commands,
  # paths), but not tool output.
  claudeTelemetryEnv = {
    CLAUDE_CODE_ENABLE_TELEMETRY = "1";
    CLAUDE_CODE_ENHANCED_TELEMETRY_BETA = "1";
    OTEL_METRICS_EXPORTER = "otlp";
    OTEL_LOGS_EXPORTER = "otlp";
    OTEL_TRACES_EXPORTER = "otlp";
    OTEL_EXPORTER_OTLP_PROTOCOL = "http/protobuf";
    OTEL_EXPORTER_OTLP_ENDPOINT = "https://otlp.acbc.house";
    OTEL_LOG_USER_PROMPTS = "1";
    OTEL_LOG_TOOL_DETAILS = "1";
    OTEL_METRICS_INCLUDE_REPOSITORY = "true";
  };

  claudeSettingsPatch = {
    statusLine = {
      type = "command";
      command = "bash ${statuslineScript}";
    };
    spinnerVerbs = {
      mode = "replace";
      verbs = spinnerVerbs;
    };
  }
  # The merge only adds keys, so turning this off later leaves the env block
  # in ~/.claude/settings.json; remove it by hand.
  // lib.optionalAttrs ai.telemetry {
    env = claudeTelemetryEnv;
  };

  soundsSrc = ../assets/sounds;
  soundFiles = lib.attrNames (
    lib.filterAttrs (_: t: t == "regular") (builtins.readDir soundsSrc)
  );
  # basename-without-extension -> filename, e.g. "airplane-chime" -> "airplane-chime.mp3"
  soundsByName = lib.listToAttrs (
    map
      (f: {
        name = lib.removeSuffix ".wav" (lib.removeSuffix ".mp3" f);
        value = f;
      })
      soundFiles
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
    map
      (f: {
        name = "agent_mux_sound_${lib.replaceStrings [ "-" "." ] [ "_" "_" ] f}";
        value = {
          source = soundsSrc + "/${f}";
          target = ".local/share/sounds/${f}";
        };
      })
      soundFiles
  );
in
{
  config = {
    home = {
      packages = [ ]
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
          # The agent-mux binary path rotates every rebuild (new /nix/store
          # hash), so re-run `install-hooks` on each activation to refresh
          # the Notification hook entry in ~/.claude/settings.json. The
          # subcommand is idempotent and updates a stale entry in place.
          installAgentMuxClaudeHook = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            ${agent-mux}/bin/agent-mux install-hooks
          '';
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
        ''
        # Tell machines apart in SigNoz. Claude Code doesn't report the host
        # itself, and settings.json can't compute it.
        + lib.optionalString ai.telemetry ''
          export OTEL_RESOURCE_ATTRIBUTES="host.name=''${HOST%%.*}"
        '';

        shellAliases = mkIf ai.mux {
          am = "agent-mux";
        };
      };
    };
  };
}
