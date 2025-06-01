{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (config.gizmo) ai;
in
{
  config = mkIf ai {
    home = {
      packages = [ pkgs.claude-code ];
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
            enable = true;
            settings = {
              model = "claude-3-5-sonnet-20240620";
            };
          };
        };
      };
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "claude-code"
      ];

  };
}
