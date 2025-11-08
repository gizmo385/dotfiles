{ pkgs, inputs, ... }:

let
  tuios = inputs.tuios.packages.${pkgs.system}.tuios;
in
{
  config = {
    home = {
      packages = [ tuios ];
      file.tuios-config = {
        target = ".config/tuios-config.json";
        source = ../configs/tuios-config.toml;
      };
    };

    programs.zsh.shellAliases = {
      "t" = "tuios";
    };
  };
}
