{ pkgs, ... }:

{
  plugins.treesitter = {
    enable = true;
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      markdown
      markdown_inline
      html
    ];
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
    folding.enable = false;
  };
}
