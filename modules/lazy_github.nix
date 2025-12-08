{ pkgs, ... }:

let
  python-bin = "${pkgs.python311}/bin/python";
  uvx-bin = "${pkgs.uv}/bin/uvx";
  lazy-github-command = "TERM=xterm-256color ${uvx-bin} --quiet --python ${python-bin} lazy-github";
in
{

  config = {
    programs.zsh.shellAliases = {
      lh = lazy-github-command;
      lazy-github = lazy-github-command;
    };
    programs.nixvim.keymaps = [
      {
        key = "<leader>G";
        action = ":FloatermNew --title=LazyGithub --width=0.9 --height=0.95 ${lazy-github-command}<CR>";
        mode = "n";
        options.silent = true;
      }
    ];
  };
}
