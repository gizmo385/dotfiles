{ ... }:

{
  config.gizmo = {
    username = "chrischapline";
    work = true;

    ai = {
      avantePlugin = true;
      claudeCodePlugin = false;
    };

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
