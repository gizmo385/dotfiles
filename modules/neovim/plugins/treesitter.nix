{ pkgs, ... }:

{
  plugins.treesitter = {
    enable = true;
    settings = {
      ensure_installed = [ "markdown" "markdown_inline" "html" ];
      highlight.enable = true;
      indent.enable = true;
    };
    folding = false;
  };

  extraPlugins = with pkgs.vimPlugins; [ playground ];
}
