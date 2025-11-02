{ pkgs, ... }:

let
  nvim-quicklinks = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-quicklinks";
    version = "latest";
    src = pkgs.fetchFromGitHub {
      owner = "gizmo385";
      repo = "nvim-quicklinks";
      rev = "103dccb9dcf608d24770f4029eb7b7fea2b876e3";
      hash = "sha256-Zo0ERf/HDnU5CvFpk7eO2DyKB8q7s4CybgtNyO+lv+s=";
    };
  };
in
{
  extraPlugins = [ nvim-quicklinks ];

  extraConfigLua = ''
    -- Setup quicklinks
    require('quicklinks').setup({
      debug = false,
      enable_project_config = true,
    })
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
