{ pkgs, ... }:

{
  keymaps = [
    {
      key = "<leader>d";
      action = ":VimwikiDiaryIndex<cr>:VimwikiDiaryGenerateLinks<cr>";
      mode = "n";
    }
    {
      key = "<leader>du";
      action = ":VimwikiDiaryGenerateLinks<cr>";
      mode = "n";
    }
    {
      key = "<leader>dn";
      action = ":VimwikiMakeDiaryNote<cr>";
      mode = "n";
    }
  ];

  autoCmd = [
    {
      event = ["BufNewFile"];
      pattern = [ "*/diary/*.wiki" ];
      command = ":0r !$HOME/.scripts/new_diary_entry.py '%'";
    }
  ];

  extraPlugins = [ pkgs.vimPlugins.vimwiki ];
}
