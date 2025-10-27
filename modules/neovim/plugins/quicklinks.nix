{ pkgs, ... }:

{
  extraConfigLua = ''
    -- Add nvim-quicklinks to runtime path if it exists locally
    local quicklinks_path = vim.fn.expand('~/workspace/nvim-quicklinks')
    if vim.fn.isdirectory(quicklinks_path) == 1 then
      vim.opt.runtimepath:append(quicklinks_path)

      -- Setup quicklinks if successfully loaded
      local ok, quicklinks = pcall(require, 'quicklinks')
      if ok then
        quicklinks.setup({
          debug = false,
          enable_project_config = true,
        })
      end
    end
  '';

  keymaps = [
    {
      key = "<leader>q";
      action = "<cmd>Quicklinks<cr>";
      mode = "n";
      options = {
        desc = "Show quicklinks";
        silent = true;
      };
    }
  ];
}
