{
  description = "Gizmo's developer environment configurations";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

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
    };

    # Custom Github terminal UI that I've built
    gh-lazy = {
      url = "github:gizmo385/gh-lazy";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
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
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
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
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          ./options/coder.nix
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
        "M1M-CChapline" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./options/work-macbook.nix
            ./modules/home.nix
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        switchCommand = "${pkgs.home-manager}/bin/home-manager switch --flake .#";
        setupPackages = [
          home-manager.packages.${system}.default
          pkgs.nixVersions.nix_2_28
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
        devShells = {
          neovim = pkgs.mkShell {
            buildInputs = [ nvim ];
            packages = [ home-manager.packages.${system}.default ];
            shellHook = "nvim";
          };
        };

        packages = {
          setupDotfiles = pkgs.writeShellApplication {
            name = "setup-dotfiles";
            runtimeInputs = setupPackages;
            text = ''
              ${switchCommand}"$(hostname -s)" -b .backup
            '';
          };
        };

        apps = {
          setupDotfiles = {
            type = "app";
            program = "${self.packages.${system}.setupDotfiles}/bin/setup-dotfiles";
          };
        };
      }
    );
}
