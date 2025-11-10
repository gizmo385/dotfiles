{
  config,
  pkgs,
  inputs,
  ...
}:

let
  # I use nixvim to manage my neovim configs within nix
  nixvim = inputs.nixvim;

  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;
  inherit (config.gizmo) username;
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  imports = [
    nixvim.homeModules.nixvim
    ./ai.nix
    ./fonts.nix
    ./git.nix
    ./graphical.nix
    ./languages
    ./lazy_github.nix
    ./lazygit.nix
    ./options.nix
    ./toad.nix
    ./work.nix
    ./zsh.nix
  ];

  config = {
    home = {
      inherit username homeDirectory;
      stateVersion = "23.11";

      file = {
        scripts = {
          source = ../scripts;
          target = ".scripts";
          recursive = true;
        };

        pr_template = {
          target = "pr_template.md";
          text = ''
            # What's changing?

            # Why is it changing?

          '';
        };

        rgignore = {
          target = ".rgignore";
          text = ''
            .git
          '';
        };
      };

      sessionVariables = {
        EDITOR = "nvim";
        PATH = "$HOME/.nix-profile/bin:$PATH";
      };

      packages = [
        # Alternative to man pages that provides examples
        pkgs.tldr
        # Tool for parsing YAML output (jq but for YAML)
        pkgs.yq
        # TUI for interacting with Docker
        pkgs.lazydocker
        # CLI recording tool
        pkgs.asciinema_3
        # Syntax-aware grep tool
        pkgs.ast-grep
      ];
    };

    programs = {
      home-manager.enable = true;

      nixvim = import ./neovim;

      # Tool for parsing JSON output
      jq.enable = true;

      # Better shell tooling
      bat.enable = true; # Alternative to cat
      ripgrep.enable = true; # Alternative to grep
      fd.enable = true; # Alternative to find
      eza.enable = true; # Alternative to ls
      fzf.enable = true; # Fuzzy file finder

      # A better diff tool
      delta = {
        enable = true;
        enableGitIntegration = true;
      };

      # Better top
      btop = {
        enable = true;
        settings = {
          color_theme = "gruvbox_dark";
        };
      };
    };

    news.display = "silent";
  };
}
