{ pkgs, ... }:

let 
  vimPlugins = pkgs.vimPlugins;
in
{
  imports = [
    ./plugins/nvim-tree.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
  ];

  enable = true;

  colorscheme = "everforest";

  globals.mapleader = ",";
  keymaps = [
    # Use ; for starting commands
    { key = ";"; action = ":"; }
    # Use regex searches
    { key = "/"; action ="/\\v"; mode = ["n" "v"]; }
    { key = "\\"; action =":%s/\\v"; mode = ["n" "v"]; }
    # Clear the current selection with ,<space>
    { key = "<leader><space>"; action = ":noh<CR>"; mode = "n"; }
    # Disable the arrow keys
    { key = "<up>"; action = "<nop>";  mode = "n"; }
    { key = "<down>"; action = "<nop>"; mode = "n"; }
    { key = "<left>"; action = "<nop>"; mode = "n"; }
    { key = "<right>"; action = "<nop>"; mode = "n"; }
    # Use editor lines, not global lines
    { key = "j"; action = "gj"; mode = "n"; }
    { key = "k"; action = "gk"; mode = "n"; }
    # Use jj to exit from insert mode
    { key = "jj"; action = "<ESC>"; mode = "i"; }
    { key = "JJ"; action = "<ESC>"; mode = "i"; }
  ];

  opts = {
    # Show relative line numbers on all lines, but show the current line number on the current line
    relativenumber = true;
    number = true;
    ruler = true;
    scrolloff = 5;

    # Show what mode I'm in
    showmode = true;
    hidden = true;

    # Make my undos persistent
    undofile = true;
    swapfile = false;

    # Ignore case when searching, unless I mix case
    ignorecase  =  true;
    smartcase  =  true;

    # Search incrementally
    incsearch = true;

    # Highlight search matches
    hlsearch = true;
    
    # Jump to matching brackets
    showmatch = true;

    # Highlight current column and 101st column as a marker
    cursorcolumn = true;
    textwidth = 100;
    colorcolumn="+1";

    # Use 4 spaces instead of tabs, round to the nearest 4 spaces
    tabstop = 4;
    shiftwidth = 4;
    softtabstop = 4;

    # Automatically indent
    autoindent = true;
    smartindent = true;

    # Misc settings
    ttyfast = true;
    lazyredraw = true;
    wildmenu = true;
    mouse = "a";
  };

  # TODO: Extract these out into modules
  plugins = {
    # nvim-tree.enable = true;
    nix.enable = true;
    airline.enable = true;
    multicursors.enable = true;

    treesitter.enable = true;

    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;

    rust-tools.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    # Tools for building other plugins
    everforest
    async-vim

    # rainbow parenthesis -- Coloring of nested parenthesis
    rainbow_parentheses-vim

    # NERDcommenter -- Auto comment out lines
    nerdcommenter

    # Clojure REPL and auto-execute
    vim-fireplace

    # Syntax highlighting
    vim-devicons

    # Language syntax highlighting
    vim-clojure-highlight
    vim-jsonnet
    vim-clojure-static
    vim-javascript
    vim-terraform

    # Knowledge management
    vimwiki

    # Telescope, a file-finder plugin
    

    # Language Server Protocol Plugins
    nvim-lspconfig

    # Auto-complete
    cmp-buffer
    cmp-path
    cmp-cmdline
    nvim-cmp
    nvim-snippy

    # Formatting
    neoformat

    # File Explorer
    nvim-web-devicons
  ];
}
