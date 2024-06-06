{
  description = "Gizmo's developer environment configurations";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

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
    flake-utils,
    ...
  } @ inputs:
  let
    inherit (self) outputs;
    defaultConfiguration = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [./modules/home.nix];
    };

    macbookConfiguration = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [./options/gizmo-macbook.nix ./modules/home.nix];
    };

    coderConfiguration = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [./options/coder.nix ./modules/home.nix];
    };
  in {
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-hostname'
    homeConfigurations = {
      # Docker is the environment installed in the Dockerfile
      "docker" = defaultConfiguration;

      # Remote development environments
      "gizmo-coder" = coderConfiguration;
      "gizmo2" = coderConfiguration;

      # Personal macbook
      "gizmo-macbook" = macbookConfiguration;

      # Work laptop
      "M1M-CChapline" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./options/work-macbook.nix ./modules/home.nix];
      };
    };
  } // flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
  in
  {
    devShells = {
      default = pkgs.mkShell {
        packages = [
          home-manager.packages.${system}.default
        ];
      };
    };
  });
}
