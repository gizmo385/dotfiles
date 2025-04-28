{ ... }:

{
  config.gizmo = {
    username = "discord";
    work = true;

    languages = {
      setupClint = true;
      clojure = false;

      # We manage our Python and JS interpreters through Clyde tooling
      python.interpreter = false;
      javascript = false;

      # We manage our nixfmt installation
      nix.formatter = false;

      # I want to use the Rust LSP, but the cargo tooling is managed via Clyde
      rust.lsp = true;
    };
  };
}
