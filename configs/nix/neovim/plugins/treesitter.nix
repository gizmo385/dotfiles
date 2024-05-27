{ pkgs, ... }:

{
    plugins.treesitter = {
        enable = true;
        indent = true;

        ensureInstalled = ["python" "bash" "terraform"];
    };

    extraPlugins = with pkgs.vimPlugins; [
        playground
    ];
}