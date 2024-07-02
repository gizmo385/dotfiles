{ ... }:

{
  config.gizmo = {
    username = "gizmo";
    graphical = true;

    languages.rust = {
      cargo = true;  
      lsp = true;  
    };
    neovim.alpha.useNerdfontTileset = true;
  };
}
