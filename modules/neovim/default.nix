{ pkgs, ... }:

{
  imports = [./plugins];
  config = {
    enable = true;

    colorschemes.kanagawa.enable = true;

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
    # Better window movement
    { key = "<C-h>"; action = "<C-w>h"; mode = "n"; }
    { key = "<C-j>"; action = "<C-w>j"; mode = "n"; }
    { key = "<C-k>"; action = "<C-w>k"; mode = "n"; }
    { key = "<C-l>"; action = "<C-w>l"; mode = "n"; }
  ];

  plugins = {
    nix.enable = true;
    airline.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    # Tools for building other plugins
    async-vim

    # NERDcommenter -- Auto comment out lines
    nerdcommenter

    # Language syntax highlighting
    vim-jsonnet
    vim-javascript
    vim-terraform

    # Icons for plugins
    nvim-web-devicons
    vim-devicons
  ];

  opts = {
    # Show relative line numbers on all lines, but show the current line number on the current line
    relativenumber = true;
    number = true;
    ruler = true;
    scrolloff = 5;
    wrap = false;

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

    # Display settings
    background = "dark";
    termguicolors = true;

    # Misc settings
    ttyfast = true;
    lazyredraw = true;
    wildmenu = true;
    mouse = "a";
  };
};
}
