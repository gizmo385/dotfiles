{
  plugins = {
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-cmdline.enable = true;
    cmp = {
      enable = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "buffer"; }
          { name = "path"; }
        ];

        mapping = {
          "<up>" = "cmp.mapping.select_prev_item()";
          "<down>" = "cmp.mapping.select_next_item()";
          "<C-Space>" = "cmp.mapping(cmp.mapping.complete(), { 'i', 'c' })";
          "<TAB>" = "cmp.mapping.confirm({ select = true })";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };
  };
}
