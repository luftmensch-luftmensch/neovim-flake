{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.org = {
      enable = mkDefault false;
      
    };
  };
}
