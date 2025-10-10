{ pkgs, ... }:

{
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
      live-grep-args.enable = true;
    };
  };

  keymaps = [
    {
      key = "<C-p>";
      action = ":Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>";
      mode = "n";
      options.silent = true;
    }
    {
      key = "<C-f>";
      action = ":Telescope live_grep_args<cr>";
      mode = "n";
      options.silent = true;
    }
    {
      key = "<leader>r";
      action = ":Telescope resume<cr>";
      mode = "n";
      options.silent = true;
    }
    {
      key = "<leader>o";
      action = ":Telescope oldfiles<cr>";
      mode = "n";
      options.silent = true;
    }
  ];

  extraPlugins = with pkgs.vimPlugins; [
    popup-nvim
    plenary-nvim
  ];
}
