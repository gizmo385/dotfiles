{ ... }:

{
  config.gizmo = {
    username = "discord";
    work = true;

    languages = {
      all.clint = true;
      clojure = false;

      # We manage our Python interpreters through Clyde tooling
      python.interpreter = false;

      # This doesn't properly resolve types in the monorepo, drop it for now
      python.linters.pyright = false;

      # I want to use the Rust LSP, but the cargo tooling is managed via Clyde
      rust.lsp = true;
    };
  };
}
