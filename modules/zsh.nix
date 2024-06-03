{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      syntaxHighlighting = {
        enable = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "gitfast" ];
        theme = "crcandy";
      };
      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
        {
          name = "you-should-use";
          src = pkgs.zsh-you-should-use;
        }
      ];

      sessionVariables = {
        PATH = "$PATH:$HOME/.scripts";
      };

      shellAliases = {
        # Fix my typos
        celar = "clear";
        gits = "git";

        # Aliases for ls
        ls = "eza";
        ll = "eza -alF";
        la = "eza -A";
        l = "eza -F";

        # Git aliases
        gs = "git status";
        gc = "git commit";
        ga = "git add";
        gap = "git add --patch";

        gco = "git checkout";
        gcob = "git checkout -b";
        gcb = "git checkout -b";
        gb = "git branch -vv";
        gbd = "git branch -D";

        gd = "git diff";
        gds = "git diff --staged";
        gdp = "git --no-pager diff --patch";

        gmb = "git merge-base --fork-point origin/main HEAD";

        # K8s aliases
        k = "kubectl";
        kx = "kubectx";
        kn = "kubens";

        # Home-manager aliases
        hm = "home-manager";
        hms = "home-manager switch";
        hmg = "home-manager generations";

        # Replace cat with bat
        cat = "bat";

        # Replace vim with neovim
        vim = "nvim";
      };

      initExtra = ''
      if [[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]]; then
        . $HOME/.nix-profile/etc/profile.d/nix.sh
      fi

      if [[ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]]; then
        . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      fi

      bindkey '^F' fzf-file-widget
      bindkey '^R' fzf-history-widget
      bindkey '^G' fzf-cd-widget
      '';
    };

    # Enable some zsh integrations in other tools
    eza.enableZshIntegration = true;
    fzf.enableZshIntegration = true;
  };
}
