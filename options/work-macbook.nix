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
      c = false;
      setupClint = true;
      python.interpreter = false;
      nix.formatter = false;
      rust.lsp = true;
      clojure = false;
    };
  };
}
