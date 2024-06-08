{
  programs.git = {
      enable = true;
      userName = "gizmo385";
      userEmail = "gizmo385@users.noreply.github.com";

      # Install delta, a better diff tool
      delta.enable = true;

      ignores = [
        # macOS files
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"
      ];

      # Git aliases
      aliases = {
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        addp = "add --patch";
        tatus = "status";
        stats = "status";
        barnch = "branch";
      };

      extraConfig = {
        pull.rebase = false;
        rerere.enabled = true;
        commit.verbose = true;
      };
  };
}
