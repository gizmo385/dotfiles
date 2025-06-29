{ pkgs, inputs, ... }:

let
  gh-lazy = inputs.gh-lazy.packages.${pkgs.system}.default;
  lazy-github-command = "TERM=xterm-256color ${gh-lazy}/bin/lazy-github";
in
{
  config = {
    home.packages = [ gh-lazy ];

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
