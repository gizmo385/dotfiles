{ ... }:

{
  config.gizmo = {
    username = "gizmo";
    graphical = true;
    ai.telemetry = true;

    languages.rust = {
      toolchain = true;
      lsp = true;
    };
  };
}
