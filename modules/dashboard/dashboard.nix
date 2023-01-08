{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.dashboard;
in {

  options.vim.dashboard = {
    enable = mkEnableOption "Neovim dashboard";
    autoSaveOnExit = mkOption {
      type = types.bool;
      description = "Auto-save the current session on neovim exit if a session exists and more than one buffer is loaded";
    };
    customHeader = mkEnableOption "Enable custom header";
    customFooter = mkEnableOption "Enable custom footer";
    verboseSession = mkOption {
      type = types.bool;
      description = "Show the session file path on SessionSave and SessionLoad";
    };

    hideStatusline = mkOption {
      type = types.bool;
      description = "Don't show statusline";
    };

    hideTabline = mkOption {
      type = types.bool;
      description = "";
    };

    hideWinbar = mkOption {
      type = types.bool;
      description = "Don't show winbar";
    };

  };

  config =
    mkIf cfg.enable (
      let 

        writeIf = cond: msg: if cond then msg else "";
      in {
        vim.startPlugins = [
          "dashboard-nvim"
        ];

        vim.luaConfigRC.dashboard = nvim.dag.entryAnywhere ''
        -- [dashboard setup] --
        local dash = require('dashboard')

        local ifmt  = "%-5s"
        local fmt    = "» %-35s"
        local sfmt  = "» %15s"

        ${writeIf cfg.customHeader ''
        dash.custom_header ={
          --"⢠⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⡄⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤    ",
          --"⠀⢸⡇⠀⠀⣶⠀⠀⣶⡆⠰⢾⡷⠶⠆⠰⢾⡷⠆⠀⣶⢶⡶⣦⡄⣴⠶⠶⣦⡄⣶⠶⠶⣦⡄⣰⠶⠶⠶⠆⣴⠶⠶⣆⡀⣿⣰⠶⣦⡄",
          --"⠀⢸⡇⠀⠀⣿⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀⢸⡇⠀⠀⣿⠸⠇⣿⡇⣿⠛⠛⠛⠃⣿⠀⠀⣿⡇⠙⠛⠻⣧⡄⣿⠀⠀⣭⡅⣿⠉⠀⣿⡇",
          --"⠀⠈⠛⠛⠃⠙⠛⠛⠛⠃⠀⠘⠃⠀⠀⠀⠈⠛⠛⠃⠛⠀⠀⠛⠃⠙⠛⠛⠛⠃⠛⠀⠀⠛⠃⠛⠛⠛⠋⠁⠙⠛⠛⠋⠁⠛⠀⠀⠛⠃",

          "⢠⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⡄⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⡄⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤   ",
          "⠀⢸⡇⠀⠀⣶⠀⠀⣶⡆⠰⢾⡷⠶⠆⠰⢾⡷⠆⠀⣶⢶⡶⣦⡄⣴⠶⠶⣦⡄⣶⠶⠶⣦⡄⣰⠶⠶⠶⠆⣴⠶⠶⣆⡀⣿⣰⠶⣦⡄⣀⣀⣀⣀⡀⠀⢸⡇⠀⠀⣶⠀⠀⣶⡆⠰⢾⡷⠶⠆⠰⢾⡷⠆⠀⣶⢶⡶⣦⡄⣴⠶⠶⣦⡄⣶⠶⠶⣦⡄⣰⠶⠶⠶⠆⣴⠶⠶⣆⡀⣿⣰⠶⣦",
          "⠀⢸⡇⠀⠀⣿⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀⢸⡇⠀⠀⣿⠸⠇⣿⡇⣿⠛⠛⠛⠃⣿⠀⠀⣿⡇⠙⠛⠻⣧⡄⣿⠀⠀⣭⡅⣿⠉⠀⣿⡇⠉⠉⠉⠉⠁⠀⢸⡇⠀⠀⣿⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀⢸⡇⠀⠀⣿⠸⠇⣿⡇⣿⠛⠛⠛⠃⣿⠀⠀⣿⡇⠙⠛⠻⣧⡄⣿⠀⠀⣭⡅⣿⠉⠀⣿",
          "⠀⠈⠛⠛⠃⠙⠛⠛⠛⠃⠀⠘⠃⠀⠀⠀⠈⠛⠛⠃⠛⠀⠀⠛⠃⠙⠛⠛⠛⠃⠛⠀⠀⠛⠃⠛⠛⠛⠋⠁⠙⠛⠛⠋⠁⠛⠀⠀⠛⠃⠀⠀⠀⠀⠀⠀⠈⠛⠛⠃⠙⠛⠛⠛⠃⠀⠘⠃⠀⠀⠀⠈⠛⠛⠃⠛⠀⠀⠛⠃⠙⠛⠛⠛⠃⠛⠀⠀⠛⠃⠛⠛⠛⠋⠁⠙⠛⠛⠋⠁⠛⠀⠀⠛",

        }
        ''}

        --dash.custom_footer = {
        --  [[. ,-"-.   ,-"-. ,-"-.   ,-"-. ,-"-.   ,]],
        --  [[ X | | \ / | | X | | \ / | | X | | \ / ]],
        --  [[/ \| | |X| | |/ \| | |X| | |/ \| | |X| ]],
        --  [[   `-!-' `-!-"   `-!-' `-!-'   `-!-' `-]],
        --}

        ${writeIf cfg.customFooter ''
        dash.custom_footer = {
          [[ . ,-"-.   ,-"-. ,-"-.   ,-"-. ,-"-.   ,-"-. ,-"-.   ,-"-. ,-"-.   ,-"-. ,-"-.   ,]],
          [[  X | | \ / | | X | | \ / | | X | | \ / | | X | | \ / | | X | | \ / | | X | | \ / ]],
          [[ / \| | |X| | |/ \| | |X| | |/ \| | |X| | |/ \| | |X| | |/ \| | |X| | |/ \| | |X| ]],
          [[    `-!-' `-!-"   `-!-' `-!-"   `-!-' `-!-"   `-!-' `-!-"   `-!-' `-!-"   `-!-' `-]],
        }
        ''}
        dash.sessions_auto_save_on_exit = ${if cfg.autoSaveOnExit then "true" else "false"}
        dash.session_verbose = ${if cfg.verboseSession then "true" else "false"}
        dash.hide_statusline = ${if cfg.hideStatusline then "true" else "false"}
        dash.hide_tabline = ${if cfg.hideTabline then "true" else "false"}
        dash.hide_winbar = ${if cfg.hideWinbar then "true" else "false"}

        dash.custom_center = {
        -- Find files with telescope
        {icon = ifmt:format(" "),
          desc = fmt:format("Find file"),
          action = 'Telescope find_files', shortcut =
          sfmt:format('SPC .')},

        -- Spawn a terminal
        {icon = ifmt:format(""),
          desc = fmt:format("Spawn terminal"),
          action = 'ToggleTerm', shortcut =
          sfmt:format('SPC s')},

        -- Open ~/.config/nvim
        --{ icon = ifmt:format(" "),
        --  desc = fmt:format("Move to nvim configuration"),
        --  action = ('cd %s'):format(vim.fn.stdpath('config')),
        --  shortcut = sfmt:format('unbinded') }

        }

        '';
      }
    );
}
