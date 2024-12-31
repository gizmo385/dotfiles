{ pkgs, ... }:

let 
  npx-bin = "${pkgs.nodejs}/bin/npx";
  joplin-command = "TERM=xterm-256color ${npx-bin} joplin";
in
  {

  config = {
    programs.zsh.shellAliases =  {
      joplin = joplin-command;
    };
    programs.nixvim.keymaps =  [{
      key = "<leader>J";
      action = ":FloatermNew --width=0.9 --height=0.95 ${joplin-command}<CR>";
      mode = "n";
      options.silent = true;
    }];
  };
}
