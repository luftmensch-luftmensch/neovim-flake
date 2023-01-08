{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.options;
in {
  options.vim.options = {
    enable = mkEnableOption "Enable options customization";

    lastStatus = mkOption {
      type = types.int;
      description = "Current window status";
    };
    showMode = mkEnableOption "Enable show mode";

  };

  config = mkIf cfg.enable {
    vim.luaConfigRC.options = nvim.dag.entryAnywhere ''
    -- [options setup] --
    vim.opt.laststatus = ${toString cfg.lastStatus};
    vim.opt.showmode = ${boolToString cfg.showMode};
    '';

    
  };

}
