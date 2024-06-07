{
  plugins.lazygit.enable = true;
  keymaps = [
    {
      key = "<leader>g";
      action = ":LazyGit<CR>";
      mode = "n";
    }
    {
      key = "<C-g>";
      action = ":LazyGit<CR>";
      mode = "n";
    }
  ];
}
