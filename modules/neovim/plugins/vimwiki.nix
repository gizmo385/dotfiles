{ pkgs, ... }:


let
  vimwikiTelescope = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-vimwiki.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "ElPiloto";
      repo = "telescope-vimwiki.nvim";
      rev = "13a83b6107da17af9eb8a1d8e0fe49e1004dfeb4";
      hash = "sha256-46N1vMSu1UuzPFFe6Yt39s3xlKPOTErhPJbfaBQgq7g";
    };
  };
in
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
    {
      key = "<leader>vw";
      action = ":VimwikiIndex<cr>";
      mode = "n";
    }
  ];

  autoCmd = [
    {
      event = [ "BufNewFile" ];
      pattern = [ "*/diary/*.wiki" ];
      command = ":0r !$HOME/.scripts/new_diary_entry.py '%'";
    }
    {
      event = [ "BufEnter" ];
      pattern = [ "*/diary/*.wiki" "*/vimwiki/*.wiki" ];
      command = "noremap <buffer> <C-p> <cmd>lua require('telescope').extensions.vimwiki.vimwiki()<cr>";
    }
    {
      event = [ "BufEnter" ];
      pattern = [ "*/diary/*.wiki" "*/vimwiki/*.wiki" ];
      command = "noremap <buffer> <C-f> <cmd>lua require('telescope').extensions.vimwiki.live_grep()<cr>";
    }
  ];

  extraPlugins = [ pkgs.vimPlugins.vimwiki vimwikiTelescope ];
}
