{ pkgs, ... }:

let
  quick-scope = pkgs.vimUtils.buildVimPlugin {
    name = "quick-scope";
    src = pkgs.fetchFromGitHub {
      owner = "unblevable";
      repo = "quick-scope";
      rev = "6cee1d9e0b9ac0fbffeb538d4a5ba9f5628fabbc";
      hash = "sha256-fOS+ia+sZAK5Ctzp0E7dgLSAVgcSZPLtXDsfZrmPaLA=";
    };
  };
in
{
  extraPlugins = [ quick-scope ];
}
