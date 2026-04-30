{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (config.gizmo) work;
in
{
  config = mkIf work {
    home = {
      packages = [
        # Tool for managing k8s contexts and namespaces
        pkgs.kubectx
        pkgs.docker-compose
      ];
      sessionPath = [
        "$HOME/workspace/discord/.local/bin"
      ];
      sessionVariables = {
        # Used by Clyde to install the updated nix version
        USE_NEW_NIX = "1";
        LC_ALL = "en_US.UTF-8";
      };
    };

    programs = {
      lazygit.settings = {
        git.branchPrefix = "gizmo/";
      };

      zsh = {
        # We can defer to the work installation setup for fzf
        initContent = lib.mkOrder 1500 ''
          if [[ $options[zle] = on ]]; then
          . ~/.nix-profile/share/fzf/completion.zsh
          . ~/.nix-profile/share/fzf/key-bindings.zsh
          fi
        '';
      };
      # We can defer to the work installation setup for fzf
      fzf.enable = lib.mkForce false;

      # Disable oh-my-zsh git prompt statuses because they're slow on the monorepo
      git.settings = {
        oh-my-zsh = {
          hide-status = 1;
          hide-dirty = 1;
        };
      };

      nixvim = {
        # Enable some LSPs for I only care about at work
        plugins = {
          lsp.servers = {
            bashls.enable = true;
            dockerls.enable = true;
            docker_compose_language_service.enable = true;
            starpls.enable = true;
            elixirls.enable = true;
          };
        };

        autoCmd = [
          {
            command = ":setlocal expandtab tabstop=4 shiftwidth=4";
            event = [
              "BufEnter"
            ];
            pattern = [
              "*.bzl"
              "*.bazel"
              "BUILD"
            ];
          }
        ];

        keymaps = [
          {
            key = "<leader>C";
            action = ":FloatermNew --width=0.9 --height=0.9 clyde tui<CR>";
            mode = "n";
          }
        ];
      };
    };
  };
}
