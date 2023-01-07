{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./dashboard.nix
    ./config.nix
  ];
}
