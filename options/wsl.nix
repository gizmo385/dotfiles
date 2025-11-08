{ ... }:

{
  config.gizmo = {
    username = "gizmo";
    toad = true;
    
    languages = {
      rust = {
        toolchain = true;
        lsp = true;
      };
    };
  };
}
