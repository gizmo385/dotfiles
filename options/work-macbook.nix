{ ... }:

{
  config.gizmo = {
    username = "chrischapline";
    work = true;

    ai = {
      configs = true;
      tools = false;
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
