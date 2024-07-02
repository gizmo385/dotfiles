{ ... }:

{
  config.gizmo = {
    username = "chrischapline";
    work = true;

    languages = {
      python.interpreter = false;
      python.linters.pyright = false;
      rust.lsp = true;
      clojure = false;
    };
  };
}
