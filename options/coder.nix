{ ... }:

{
  config.gizmo = {
    username = "discord";
    work = true;

    languages = {
      clojure = false;
      rust = true;
      python.interpreter = false;
    };
  };
}
