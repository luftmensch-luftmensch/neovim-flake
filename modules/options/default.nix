{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./config.nix
    ./options.nix
  ];
}
