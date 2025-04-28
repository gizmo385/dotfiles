{ ... }:

{
  config.gizmo = {
    username = "chrischapline";
    work = true;

    languages = {
      setupClint = true;
      python.interpreter = false;
      python.linters.pyright = false;
      nix.formatter = false;
      rust.lsp = true;
      clojure = false;
    };
  };
}
