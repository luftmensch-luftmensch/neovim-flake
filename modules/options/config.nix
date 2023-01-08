{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.options = {
      enable     = mkDefault false;
      lastStatus = mkDefault 2;
      showMode   = mkDefault true;
      restoreCursorOnExit = mkDefault false;
    };
  };
}
