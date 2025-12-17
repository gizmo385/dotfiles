{ ... }:

{
  config.gizmo = {
    username = "chrischapline";
    work = true;

    languages = {
      c = false;
      setupClint = true;
      python.interpreter = false;
      nix.formatter = false;
      rust.lsp = true;
      clojure = false;
    };
  };
}
