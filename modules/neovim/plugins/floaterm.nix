{
  plugins.floaterm = {
    enable = true;
  };
  keymaps = [
    {
      key = "<leader>t";
      action = ":FloatermToggle<CR>";
      mode = "n";
    }
    {
      key = "<C-t>";
      action = ":FloatermToggle<CR>";
      mode = "n";
    }
  ];
}
