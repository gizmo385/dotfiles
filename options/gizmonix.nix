{ ... }:

{
  config.gizmo = {
    username = "gizmo";
    graphical = true;
    toad = true;

    languages.rust = {
      toolchain = true;
      lsp = true;
    };
  };
}
