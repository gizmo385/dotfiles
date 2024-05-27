{ pkgs, ... }:

{
    plugins.telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
    };

    keymaps = [
        { 
            key = "<C-p>";
            action = ":Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>";
            mode="n";
        }
        { 
            key = "<C-f>";
            action = ":Telescope live_grep<cr>";
            mode = "n"; 
        }
    ];

    extraPlugins = with pkgs.vimPlugins; [
        popup-nvim
        plenary-nvim
    ];
}