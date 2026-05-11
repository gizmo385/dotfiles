{ ... }:

{
  config = {
    gizmo.username = "chris";
    programs.git.settings.safe.directory = [ "/services" ];
  };
}
