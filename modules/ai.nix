{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.lists) optionals;
  inherit (config.gizmo) ai;
in
{
  config = mkIf ai.enable {
    home = {
      packages = [
        pkgs.claude-code
      ];

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
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "claude-code"
      ];

  };
}
