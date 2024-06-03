{
  description = "Gizmo's developer environment configurations";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nixvim, used for building neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs:
  let
    inherit (self) outputs;
    defaultConfiguration = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = {inherit inputs outputs;};
      # > Our main home-manager configuration file <
      modules = [./modules/home.nix];
    };
  in {
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-hostname'
    homeConfigurations = {
      "docker" = defaultConfiguration;
      "gizmo-coder" = defaultConfiguration;

      "gizmo-macbook" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./options/gizmo-macbook.nix ./modules/home.nix];
    };
  };
};
}
