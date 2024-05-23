{ config, pkgs, ... }:

let
  packages = import ./nix/packages.nix;
in
{
  home = {
    username = "gizmo";
    homeDirectory = "/home/gizmo";
    stateVersion = "23.11";

    packages = packages.packagesToInstall;

    file = {
      # Shell configs
      # ".zshrc".source = ./shells/zsh/zshrc;
      "shell_aliases".source = ./shells/common/aliases;
      ".config/fish/config.fish".source = ./shells/fish/config.fish;
      ".tmux.conf".source = ./tmux/tmux.conf;

      # Editor configs
      ".config/nvim/init.vim".source = ./nvim/init.vim;
      ".vimrc".source = ./vim/vimrc;
      "bindings.vim".source = ./vim/bindings.vim;
      "plugin_settings.vim".source = ./vim/plugin_settings.vim;
      "plugins.vim".source = ./vim/plugins.vim;
      "settings.vim".source = ./vim/settings.vim;

      # Git configs
      ".gitconfig".source = ./git/gitconfig;
      ".global_gitignore".source = ./git/global_gitignore;
      "scripts".source = ./scripts;

    };

    sessionVariables = {
      EDITOR = "nvim";
      LC_ALL = "C.UTF-8";
      LANG = "C.UTF-8";
      DEBIAN_FRONTEND = "noninteractive";
    };
  };

  programs = {
    home-manager.enable = true;

    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;

      extraConfig = (builtins.readFile ./nvim/init.vim);
    };

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [];
        theme = "crcandy";
      };

      initExtra = (builtins.readFile ./shells/zsh/zshrc);
    };

    git = {
      enable = true;
      userName = "gizmo385";
      userEmail = "gizmo385@users.noreply.github.com";
    };
  };
}