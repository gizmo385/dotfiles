{ ... }:

{
  config.gizmo = {
    username = "gizmo";
    languages = {
      rust = {
        toolchain = true;
        lsp = true;
      };
    };

  };
}
