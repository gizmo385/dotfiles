{ ... }:

{
  config = {
    plugins = {
      lsp-format.enable = true;
      cmp-nvim-lsp.enable = true;

      lsp = {
        enable = true;
        servers = {
          nil-ls.enable = true;
          bashls.enable = true;
        };

        keymaps = {
          silent = true;
          lspBuf = {
            gD = { action = "declaration"; };
            gd = { action = "definition"; };
            gi = { action = "implementation"; };
            gt = { action = "type_definition"; };
            gT = { action = "type_definition"; };
            K = { action = "hover"; };
            "<leader>lr" = { action = "rename"; };
          };

          diagnostic = {
            "<leader>le" = { action = "open_float"; };
            "[d" = { action = "goto_prev"; };
            "]d" = { action = "goto_next"; };
          };
        };
      };
    };
  };
}
