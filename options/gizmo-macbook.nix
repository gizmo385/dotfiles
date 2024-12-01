{ ... }:

{
  config.gizmo = {
    username = "gizmo385";
    languages = {
      rust = {
        toolchain = true;  
        lsp = true;  
      };
      python.linters.pylsp = false;
    };

  };
}
