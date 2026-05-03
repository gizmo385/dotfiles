{ lib, pkgs }:

# Returns a Home Manager activation script entry that deep-merges a JSON
# patch into a target file using `jq`. Creates the file (and parent dirs)
# if missing. The patch wins on conflicting keys; existing untouched keys
# are preserved so user edits to other parts of the file stick around.
{ targetPath, patch }:

lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  target=${lib.escapeShellArg targetPath}
  patch=${lib.escapeShellArg (builtins.toJSON patch)}

  mkdir -p "$(dirname "$target")"
  if [ ! -f "$target" ]; then
    echo '{}' > "$target"
  fi

  tmp=$(${pkgs.coreutils}/bin/mktemp)
  ${pkgs.jq}/bin/jq --argjson patch "$patch" '. * $patch' "$target" > "$tmp"
  mv "$tmp" "$target"
''
