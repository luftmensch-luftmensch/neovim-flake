{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.git = {
      enable             = mkDefault false;
      git-messenger      = mkDefault false;
      neogit = {
        enable = mkDefault false;
        disableCommitConfirmation = mkDefault false;
      };
    };
  };
}
