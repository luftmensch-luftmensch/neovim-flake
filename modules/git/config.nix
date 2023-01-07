{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.git = {
      enable        = mkDefault false;
      neogit        = mkDefault false;
      git-messenger = mkDefault false;
    };
  };
}
