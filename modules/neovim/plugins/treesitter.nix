{ pkgs, ... }:

{
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      dockerfile
      json
      jsonnet
      nix
      typescript
      vim
      yaml
    ];
  };

  extraPlugins = with pkgs.vimPlugins; [ playground ];
}
