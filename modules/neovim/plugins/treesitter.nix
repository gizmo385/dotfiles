{ pkgs, ... }:

{
  plugins.treesitter = {
    enable = true;
    settings = {
      indent = true;
    };
  };

  extraPlugins = with pkgs.vimPlugins; [ playground ];
}
