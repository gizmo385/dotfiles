{ ... }:

{
  config.gizmo = {
    username = "discord";
    work = true;

    languages = {
      clojure = false;
      rust = true;
      python.interpreter = false;

      # This doesn't properly resolve types in the monorepo, drop it for now
      python.linters.pyright = false;
    };
  };
}
