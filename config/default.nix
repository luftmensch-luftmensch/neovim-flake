{ lib, ... }:
{
  # Automatically import nix files in this current directory
  imports =
    with builtins;
    with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && hasSuffix "nix" "${fn}")) (attrNames (readDir ./.))
    )
    ++ [ ./plugins ];
}
