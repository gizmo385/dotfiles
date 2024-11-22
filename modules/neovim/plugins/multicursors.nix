{ ... }:

{
  config = {
    keymaps = [
      # Multicursor bindings
      { key = "<C-n>"; action = "<cmd>MCstart<cr>"; mode = "n"; }
    ];

    plugins = {
      multicursors.enable = true;
    };
  };
}
