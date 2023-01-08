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
    restoreCursorOnExit = mkEnableOption "Restore cursor shape on Exit/Suspend/Resume";

  };

  config = mkIf cfg.enable (
    let writeIf = cond: msg: if cond then msg else "";

    in {
        vim.luaConfigRC.options = nvim.dag.entryAnywhere ''
          -- [options setup] --
          vim.opt.laststatus = ${toString cfg.lastStatus};
          vim.opt.showmode = ${boolToString cfg.showMode};

          ${writeIf cfg.restoreCursorOnExit ''
          local au = vim.api.nvim_create_augroup('restore_on_exit.augroup', { clear = true })
          vim.api.nvim_create_autocmd({ 'VimLeave'}, {
             group = au,
             command = "set guicursor=a:ver25-Cursor"
          })
          ''}
        '';
    }
    
  );

}
