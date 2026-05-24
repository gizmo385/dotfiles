{ lib, pkgs }:

# Returns a Home Manager activation script entry that deep-merges a TOML
# patch into a target file by round-tripping through JSON
# (toml2json -> jq -> json2toml). Creates the file (and parent dirs) if
# missing. The patch wins on conflicting keys; arrays are replaced
# wholesale rather than concatenated. Comments and key ordering in the
# target file are not preserved.
{ targetPath, patch }:

lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  target=${lib.escapeShellArg targetPath}
  patch=${lib.escapeShellArg (builtins.toJSON patch)}

  mkdir -p "$(dirname "$target")"

  current=$(${pkgs.coreutils}/bin/mktemp)
  if [ ! -s "$target" ]; then
    echo '{}' > "$current"
  else
    ${pkgs.remarshal}/bin/toml2json "$target" > "$current"
  fi

  tmp=$(${pkgs.coreutils}/bin/mktemp)
  ${pkgs.jq}/bin/jq --argjson patch "$patch" '. * $patch' "$current" \
    | ${pkgs.remarshal}/bin/json2toml > "$tmp"
  mv "$tmp" "$target"
  rm -f "$current"
''
