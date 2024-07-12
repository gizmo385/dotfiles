{ pkgs, ... }:

{
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
    folding = false;
  };

  extraPlugins = with pkgs.vimPlugins; [ playground ];
}
