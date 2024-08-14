{ ... }:

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
      plugins = [ ];

      sessionVariables = {
        PATH = "$PATH:$HOME/.scripts:$HOME/.nix-profile/bin";
      };

      shellAliases = {
        # Fix my typos
        celar = "clear";
        gits = "git";

        # Handle cd aliases
        groot = "cd $(git rev-parse --show-toplevel)";

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
    };

    # Enable some zsh integrations in other tools
    eza.enableZshIntegration = true;
    fzf.enableZshIntegration = true;
  };
}
