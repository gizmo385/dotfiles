{ ... }:

{
  config.gizmo = {
    username = "discord";
    work = true;

    languages = {
      clojure = false;
      rust = false;
      python.interpreter = false;
    };
  };
}
