{
  plugins.floaterm = {
    enable = true;
  };
  keymaps = [
    {
      key = "<C-t>";
      action = ":FloatermToggle<CR>";
      mode = "n";
    }
  ];
}
