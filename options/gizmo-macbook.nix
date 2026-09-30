{ ... }:

{
  config.gizmo = {
    username = "chris";
    ai.telemetry = true;

    languages = {
      rust = {
        toolchain = true;
        lsp = true;
      };
    };
  };
}
