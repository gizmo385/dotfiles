{ pkgs, ... }:

let
  paredit = pkgs.vimUtils.buildVimPlugin {
    name = "paredit.vim";
    src = pkgs.fetchFromGitHub {
      owner = "vim-scripts";
      repo = "paredit.vim";
      rev = "791c3a0cc3155f424fba9409a9520eec241c189c";
      hash = "sha256-6b8UpQ65gGAggxifesdd5OHaVcxW4WBnlE6d/dYYj5Y";
    };
  };
in
{
  extraPlugins = [ paredit ];
}
