{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.org;
in {
  options.vim.org = {
    enable = mkEnableOption "Enable org mode support for neovim";
    
  };
  config = mkIf cfg.enable (
    let writeIf = cond: msg: if cond then msg else "";
    in {
      vim.startPlugins = ["nvim-org"];

      vim.luaConfigRC.orgmode = nvim.dag.entryAnywhere ''
        -- [orgmode setup] --

        -- Load custom treesitter grammar for org filetype
        require('orgmode').setup_ts_grammar()

        require('orgmode').setup({
          org_agenda_files = {'~/Dropbox/org/*'},
          --org_default_notes_file = '~/Dropbox/org/refile.org',
        })
      '';

    }
  );
}
