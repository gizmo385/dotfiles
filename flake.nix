{
  description = "Gizmo's developer environment configurations";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nuschtosSearch = {
      url = "github:NuschtOS/search";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Nixvim, used for building neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nuschtosSearch.follows = "nuschtosSearch";
      inputs.flake-parts.follows = "flake-parts";
    };

    # Custom Github terminal UI that I've built
    gh-lazy = {
      url = "github:gizmo385/gh-lazy";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # A terminal multiplexer
    tuios = {
      url = "github:Gaurav-Gosain/tuios";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      home-manager,
      flake-utils,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      defaultConfiguration = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./modules/home.nix ];
      };

      macbookConfiguration = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          ./options/gizmo-macbook.nix
          ./modules/home.nix
        ];
      };

      coderConfiguration = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          ./options/coder.nix
          ./modules/home.nix
        ];
      };

      workMacbook = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          ./options/work-macbook.nix
          ./modules/home.nix
        ];
      };
    in
    {
      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-hostname'
      homeConfigurations = {
        # Docker, WSL, and default all use the defaultConfiguration
        "default" = defaultConfiguration;
        "docker" = defaultConfiguration;

        # WSL
        "gizmo-desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./options/wsl.nix
            ./modules/home.nix
          ];
        };

        # Linux desktop
        "gizmonix" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./options/gizmonix.nix
            ./modules/home.nix
          ];
        };

        # Home Server
        "alpenglow" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./options/alpenglow.nix
            ./modules/home.nix
          ];
        };

        # Remote development environments
        "gizmo-coder" = coderConfiguration;
        "gizmo" = coderConfiguration;

        # Personal macbook
        "gizmo-macbook" = macbookConfiguration;

        # Work laptop
        "M4M-CChapline" = workMacbook;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        switchCommand = "${pkgs.home-manager}/bin/home-manager switch --flake .#";
        setupPackages = [
          home-manager.packages.${system}.default
          pkgs.nixVersions.nix_2_31
          pkgs.git
        ];
        # This is, admittedly pretty gross. The current way that I'm configuring nixvim for home-manager
        # means that the dev shell definition gets mad because we have the config.enable option. I
        # haven't found a clean way to hook this up without conditionally removing the config.enable
        # option in the nixvim module :(
        nixvimConfig = import ./modules/neovim { inherit pkgs; };
        nixvimConfig' = nixvimConfig // {
          config = (builtins.removeAttrs nixvimConfig.config [ "enable" ]);
        };
        nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
          module = nixvimConfig';
        };
      in
      {
        packages = {
          neovim = nvim;
          
          setupDotfiles = pkgs.writeShellApplication {
            name = "setup-dotfiles";
            runtimeInputs = setupPackages;
            text = ''
              ${switchCommand}"$(hostname -s)" -b .backup
            '';
          };
        };

        apps = {
          neovim = {
            type = "app";
            program = "${nvim}/bin/nvim";
          };

          setupDotfiles = {
            type = "app";
            program = "${self.packages.${system}.setupDotfiles}/bin/setup-dotfiles";
          };
        };
      }
    );
}
