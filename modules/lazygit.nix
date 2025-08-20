{ ... }:

{
  programs = {
    lazygit = {
      enable = true;
      settings = {
        fetchAll = false;
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          };
        };
        customCommands = [
          {
            key = "e";
            context = "files";
            command = "floaterm {{.SelectedFile.Name | quote}}";
          }
          {
            key = "F";
            context = "files";
            command = "floaterm {{.SelectedFile.Name | quote}}";
          }
        ];
      };
    };
    nixvim.keymaps = [{
      key = "<leader>g";
      action = ":FloatermNew --title=LazyGit --width=0.9 --height=0.95 lazygit<CR>";
      mode = "n";
      options.silent = true;
    }];
  };
}
