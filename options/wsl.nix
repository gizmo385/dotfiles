{ ... }:

{
  config = {
    gizmo = {
      username = "gizmo";

      languages = {
        rust = {
          toolchain = true;
          lsp = true;
        };
      };
    };

    # wslu (which provides wslview) isn't packaged in nixpkgs, so point xdg-open
    # consumers at Windows' explorer.exe to handle URL launches from WSL.
    home.sessionVariables.BROWSER = "/mnt/c/Windows/explorer.exe";
  };
}
