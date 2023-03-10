{pkgs, config, lib, ...}:
with lib; {
  config = {
    vim.dashboard = {
      enable         = mkDefault false;
      autoSaveOnExit = mkDefault false;
      customHeader   = mkDefault false;
      customFooter   = mkDefault false;
      hideStatusline = mkDefault false;
      hideTabline    = mkDefault false;
      hideWinbar     = mkDefault false;
      verboseSession = mkDefault false;
    };
  };
}
