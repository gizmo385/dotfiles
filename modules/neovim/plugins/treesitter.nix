{ pkgs, ... }:

{
    plugins.treesitter = {
        enable = true;
        indent = true;
    };

    extraPlugins = with pkgs.vimPlugins; [ playground ];
}
