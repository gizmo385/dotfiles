{ ... }:

{
  config = {
    plugins = {
      lsp-format.enable = true;
      cmp-nvim-lsp.enable = true;

      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
        };

        keymaps = {
          silent = true;
          lspBuf = {
            gD = { action = "declaration"; };
            gd = { action = "definition"; };
            gi = { action = "implementation"; };
            gt = { action = "type_definition"; };
            gr = { action = "references"; };
            gT = { action = "type_definition"; };
            K = { action = "hover"; };
            "<leader>lr" = { action = "rename"; };
            "<leader>la" = { action = "code_action"; };
            "<leader>ca" = { action = "code_action"; };
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
