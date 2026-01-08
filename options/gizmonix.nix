{ ... }:

{
  config.gizmo = {
    username = "gizmo";
    graphical = true;

    languages.rust = {
      toolchain = true;
      lsp = true;
    };
  };
}
