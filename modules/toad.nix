{ config, lib, pkgs, ... }:

let
  toadRepoPath = "$HOME/.local/share/toad";
  toadRepo = "git@github.com:Textualize/toad.git";

  toad-wrapper = pkgs.writeShellApplication {
    name = "toad";
    runtimeInputs = [
      pkgs.git
      pkgs.uv
      pkgs.nodejs
    ];
    text = ''
      TOAD_DIR="${toadRepoPath}"
      ORIGINAL_DIR="$(pwd)"

      # Clone repo if it doesn't exist
      if [ ! -d "$TOAD_DIR" ]; then
        echo "Cloning toad repository..."
        mkdir -p "$(dirname "$TOAD_DIR")"
        git clone "${toadRepo}" "$TOAD_DIR"
      fi

      # Update repo and install dependencies in toad directory
      cd "$TOAD_DIR"
      git fetch origin main --quiet 2>/dev/null || true

      # Install the claude code ACP locally if not already installed
      if [ ! -d "$TOAD_DIR/node_modules/@zed-industries/claude-code-acp" ]; then
        echo "Installing @zed-industries/claude-code-acp..."
        npm install @zed-industries/claude-code-acp
      fi

      # Return to original directory before running uv
      cd "$ORIGINAL_DIR"

      # Run toad with all arguments passed through, using the locally installed ACP
      uv run --project "$TOAD_DIR" toad acp "$TOAD_DIR/node_modules/.bin/claude-code-acp" -- "$@"
    '';
  };
in
{
  config = lib.mkIf config.gizmo.toad {
    home.packages = [ toad-wrapper ];

    programs.zsh.shellAliases = {
      toad = "${toad-wrapper}/bin/toad";
    };
  };
}
