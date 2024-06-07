
let
  mkButton = shortcut: cmd: val: {
    type = "button";
    inherit val;
    opts = {
      inherit shortcut;
      keymap = [
        "n"
        shortcut
        cmd
        {}
      ];
      position = "center";
      cursor = 0;
      width = 40;
      align_shortcut = "right";
      hl_shortcut = "Keyword";
    };
  };
in
  {
    config = {
      keymaps = [
        {
          key = "<leader>a";
          action = ":Alpha<CR>";
          mode = "n";
        }
        {
          key = "<C-a>";
          action = ":Alpha<CR>";
          mode = "n";
        }
      ];
      plugins = {
        alpha = {
          enable = true;
          layout = [
            {
              type = "padding";
              val = 2;
            }
            {
              opts = {
                hl = "Define";
                position = "center";
              };
              type = "text";
              val = [
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⣶⣶⠿⠿⠿⠿⠿⠿⠿⢷⣶⣶⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⡾⠿⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠻⠿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢦⡀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⠏⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣄⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣦⡀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣶⣶⣶⣶⣶⡿⠟⠋⠚⢋⣭⣭⣽⠿⠷⠶⢶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣦⡀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⣠⣴⡾⠟⠋⠉⠀⠀⠀⠀⠀⠁⠀⠀⠀⣀⣀⡉⠻⣄⠀⠀⠀⠀⠀⠉⠙⠻⠶⣦⣤⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣷⡀⠀⠀"
                "⢀⣀⣠⣤⣶⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⢿⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⢻⣷⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣷⡀⠀"
                "⠻⣿⡉⠁⢀⣠⣤⣀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣠⡴⠋⠉⠉⢀⣼⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣧⠀"
                "⠀⠸⣿⣆⠀⠀⠀⠈⠙⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠄⠀⠀⠀⠀⠀⠹⣿⠁⠀⠀⠀⣠⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⡆"
                "⠀⠀⠈⠻⣦⣀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠁⠀⠀⠀⠀⠀⠀⠀⠹⣇⣀⣴⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣗"
                "⠀⠀⠀⠀⠈⠛⠷⣶⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿"
                "⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠠⣶⠾⠶⠶⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡶⠟⠻⠷⣦⠀⢹⡆⠀⠀⠀⠀⠀⠀⠐⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⢸⣿"
                "⠀⠀⠀⠀⠀⠀⠀⢰⡟⠀⠀⠀⠀⠀⠀⠀⠙⣷⠀⠀⢀⣀⣀⡀⠀⢠⡿⠁⠀⠀⠀⠀⠀⠀⠸⣧⠀⠀⠀⠀⠀⠀⠀⠸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⠁⠀⠀⠀⠀⠀⠀⢸⣿"
                "⠀⠀⠀⠀⠀⠀⢰⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠘⠀⠀⠀⢀⣀⣀⣄⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⣻⡧⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⢀⣤⠾⠋⠀⠀⠀⠀⠀⠀⠀⠀⣼⡇"
                "⠀⠀⠀⠀⠀⠀⠈⢿⣗⠀⠀⠀⠀⠀⠀⣀⣀⣾⣀⠸⣯⣍⣉⣉⡿⠀⣘⣦⣀⣀⣀⡀⠀⢠⣾⠏⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⢀⣠⣴⠾⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠀"
                "⠀⠀⠀⠀⠀⠀⠀⢀⣽⠿⣦⣤⣐⠊⡩⠟⣻⣿⣎⣀⠀⣉⣿⡉⠀⢀⣴⢿⣙⠒⢦⣤⣴⠟⠁⠀⠀⠀⠀⠀⣀⣀⣠⣼⣿⠶⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠁⠀"
                "⠀⠀⠀⠀⠀⢀⣼⠟⡽⠀⣠⣭⡿⠿⠟⠛⠛⠛⠛⠛⠛⣿⠛⠛⠿⠿⠷⠶⠿⠿⠿⠿⠷⠶⠶⠶⠾⠟⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀"
                "⠀⠀⠀⠀⠀⣾⣟⢸⣧⣾⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⡾⠟⠁⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠙⠿⢾⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣴⡶⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣦⣤⣤⣤⣶⡶⠶⠶⠿⠿⠿⠿⠿⠿⠿⠷⠶⠶⠶⢶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⡶⠶⠿⠿⠛⠛⠋⠉⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "                                                                 "
              ];
            }
            {
              opts = {
                hl = "Identifier";
                position = "center";
              };
              type = "text";
              val = [
                " ██████╗ ██╗███████╗███╗   ███╗ ██████╗ ██████╗  █████╗ ███████╗"
                "██╔════╝ ██║╚══███╔╝████╗ ████║██╔═══██╗╚════██╗██╔══██╗██╔════╝"
                "██║  ███╗██║  ███╔╝ ██╔████╔██║██║   ██║ █████╔╝╚█████╔╝███████╗"
                "██║   ██║██║ ███╔╝  ██║╚██╔╝██║██║   ██║ ╚═══██╗██╔══██╗╚════██║"
                "╚██████╔╝██║███████╗██║ ╚═╝ ██║╚██████╔╝██████╔╝╚█████╔╝███████║"
                " ╚═════╝ ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚════╝ ╚══════╝"
              ];
            }
            {
              type = "padding";
              val = 2;
            }
            {
              type = "group";
              val = [
                {
                  opts = {
                    hl = "Keyword";
                    position = "center";
                  };
                  type = "text";
                  val = "Wiki";
                }
                (mkButton "w" ":VimwikiIndex<CR>" " > Open Wiki")
                (mkButton "d" ":VimwikiDiaryIndex<cr>:VimwikiDiaryGenerateLinks<cr>" " > Open Diary")
                (mkButton "n" ":VimwikiMakeDiaryNote<cr>" "✎ > New Diary Entry")
                (mkButton "s" "<CMD>lua require('telescope').extensions.vimwiki.live_grep()<cr>" " > Search Wiki")
              ];
            }
            {
              type = "padding";
              val = 2;
            }
            {
              type = "group";
              val = [
                {
                  opts = {
                    hl = "Keyword";
                    position = "center";
                  };
                  type = "text";
                  val = "Commands";
                }
              (mkButton "e" ":ene<CR>" " > New file")
              (mkButton "f" "<CMD>lua require('telescope.builtin').find_files()<CR>" " > Find File")
              (mkButton "/" "<CMD>lua require('telescope.builtin').live_grep()<CR>" " > Search")
              (mkButton "r" "<CMD>lua require('telescope.builtin').oldfiles()<CR>" " > Recent")
              (mkButton "q" ":qa<CR>" " > Quit")
            ];
          }
          {
            type = "padding";
            val = 2;
          }
          {
            opts = {
              hl = "Keyword";
              position = "center";
            };
            type = "text";
            val = "git@github.com:gizmo385";
          }
        ];
      };
    };
  };
}
