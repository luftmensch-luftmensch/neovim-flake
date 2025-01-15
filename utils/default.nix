{ lib, ... }:
rec {
  modeKeys = mode: lib.attrsets.mapAttrsToList (key: action: { inherit key action mode; });
  nkmap = modeKeys [ "n" ];
  vkmap = modeKeys [ "v" ];
  ikmap = modeKeys [ "i" ];
  tkmap = modeKeys [ "t" ];
}
