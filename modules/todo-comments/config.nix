{pkgs, config, lib, ...}:
with lib; {
  config = {
    vim.todo-comments = {
      enable         = mkDefault false;
      customKeywords = mkDefault false;
      mergeKeyworks  = mkDefault false;
    };
  };
}
