{ ... }:

{
  config = {
    gizmo.username = "chris";
    gizmo.ai.telemetry = true;
    programs.git.settings.safe.directory = [ "/services" ];
  };
}
