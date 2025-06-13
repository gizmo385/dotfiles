{ pkgs, ... }:

let
  python-bin = "${pkgs.python311}/bin/python";
  uvx-bin = "${pkgs.uv}/bin/uvx";
  lazy-github-command = "TERM=xterm-256color ${uvx-bin} --quiet --python ${python-bin} lazy-github";
in
{

  # TODO: I'd like to set up an actual derivation for this and pull this out as a separate script,
  # but this'll do for now
  config = {
    programs.zsh.shellAliases = {
      lh = lazy-github-command;
      lazy-github = lazy-github-command;
    };
    programs.nixvim.keymaps = [{
      key = "<leader>G";
      action = ":FloatermNew --title=LazyGithub --width=0.9 --height=0.95 ${lazy-github-command}<CR>";
      mode = "n";
      options.silent = true;
    }];
  };
}
