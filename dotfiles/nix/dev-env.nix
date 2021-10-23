{ pkgs ? import <nixpkgs> {} }:

let
  packages = import ./packages.nix;
in
pkgs.buildEnv {
  name = "dev-env";
  paths = packages.packagesToInstall;
}
