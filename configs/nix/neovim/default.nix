{ pkgs, ... }:

let 
  vimPlugins = pkgs.vimPlugins;
in
{
  enable = true;

  colorscheme = "everforest";

  extraPlugins = with pkgs.vimPlugins; [
  #     # Tools for building other plugins
    everforest
    async-vim

  #     # Colorschemes
  #     gruvbox
  # everforest.enable = true;

  #     # rainbow parenthesis -- Coloring of nested parenthesis
  #     rainbow_parentheses-vim

  #     # NERDcommenter -- Auto comment out lines
  #     nerdcommenter

  #     # Multiple cursors
  #     multicursors-nvim

  #     # Bottom bar line in vim
  #     vim-airline

  #     # Clojure REPL and auto-execute
  #     vim-fireplace

  #     # Syntax highlighting
  #     vim-devicons

  #     # Language syntax highlighting
  #     vim-nix
  #     vim-clojure-highlight
  #     vim-jsonnet
  #     vim-clojure-static
  #     vim-javascript
  #     rust-tools-nvim
  #     vim-terraform

  #     # Knowledge management
  #     vimwiki

  #     # Telescope, a file-finder plugin
  #     popup-nvim
  #     plenary-nvim
  #     telescope-nvim
  #     telescope-fzf-native-nvim

  #     # Tree-sitter is a parser tool
  #     nvim-treesitter
  #     playground

  #     # Language Server Protocol Plugins
  #     nvim-lspconfig

  #     # Auto-complete
  #     cmp-nvim-lsp
  #     cmp-buffer
  #     cmp-path
  #     cmp-cmdline
  #     nvim-cmp
  #     nvim-snippy

  #     # Formatting
  #     neoformat

  #     # File Explorer
  #     nvim-web-devicons
  #     nvim-tree-lua
  ];
}
