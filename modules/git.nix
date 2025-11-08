{ pkgs, ... }:
{
  home.packages = [ pkgs.gh ];
  programs = {
    git = {
      enable = true;

      settings = {
        user = {
          name = "gizmo385";
          email = "gizmo385@users.noreply.github.com";
        };
        pull.rebase = false;
        rerere.enabled = true;
        commit.verbose = true;
        init.defaultBranch = "main";

        # Git aliases
        alias = {
          lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          addp = "add --patch";
          tatus = "status";
          stats = "status";
          barnch = "branch";
        };
      };

      ignores = [
        # macOS files
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"
      ];
    };
  };
}
