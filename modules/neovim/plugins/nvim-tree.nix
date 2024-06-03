{
    plugins.nvim-tree = {
        enable = true;
    };

    keymaps = [
        { key = "<leader>n"; action = ":NvimTreeToggle<CR>"; mode = "n"; }
        { key = "<leader>N"; action = ":NvimTreeFindFile<CR>"; mode = "n"; }
    ];
}