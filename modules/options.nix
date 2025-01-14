{ lib
, ...
}:

let
  inherit (lib) mkOption types;
in
{
  options.gizmo = {
    username = mkOption {
      type = types.str;
      default = "gizmo";
      description = "The username for the system";
    };

    work = mkOption {
      type = types.bool;
      default = false;
      description = "Enable work configs";
    };

    graphical = mkOption {
      type = types.bool;
      default = false;
      description = "Install UI packages";
    };

    fonts = mkOption {
      type = types.bool;
      default = true;
      description = "Setup fonts";
    };

    languages = {
      setupClint = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Discord clint LSP tooling";
      };

      clojure = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Clojure language tooling and plugins";
      };

      javascript = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Javascript language tooling and plugins";
      };

      nix.lsp = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the nix LSP tooling";
      };

      python = {
        interpreter = mkOption {
          type = types.bool;
          default = true;
          description = "Install the Python interpreter (some machines have this preinstalled)";
        };

        linters = {
          ruff = mkOption {
            type = types.bool;
            default = true;
            description = "Enable ruff LSP";
          };

          pylsp = mkOption {
            type = types.bool;
            default = true;
            description = "Enable pylsp";
          };

          pyright = mkOption {
            type = types.bool;
            default = true;
            description = "Enable pyright LSP";
          };
        };
      };

      rust = {
        toolchain = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the cargo build tool for Rust";
        };

        lsp = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the rust LSP tooling (like ra-multiplexer)";
        };
      };
    };
  };
}
