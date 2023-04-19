{
  config,
  lib,
  pkgs,
  helpers,
  ...
}:
with lib; {
  options.plugins.dash = {
    enable = mkEnableOption "A highly customizable dashboard for neovim";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.dashboard-nvim;
      description = "Package to use for dashboard";
    };
  };

  config = let
    cfg = config.plugins.dash;

  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        -- [dashboard setup] --
        -- local dash = require('dashboard')

        -- local ifmt  = "%-5s"
        -- local fmt    = "» %-35s"
        -- local sfmt  = "» %15s"

        require('dashboard').setup({
          config = {


            -- packages = { enable = false }, -- No need to show it as we inject directly into neovim (the counter is 0)
            -- project = {
            --   enable = true,
            --   limit = 8,
            --   label = 'Recent code sessions',
            -- },

            -- mru = { -- Don't show recent opened files
            --   limit = 3,
            -- },

            header = {

            "⢠⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⡄⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⡄⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤   ",
            "⠀⢸⡇⠀⠀⣶⠀⠀⣶⡆⠰⢾⡷⠶⠆⠰⢾⡷⠆⠀⣶⢶⡶⣦⡄⣴⠶⠶⣦⡄⣶⠶⠶⣦⡄⣰⠶⠶⠶⠆⣴⠶⠶⣆⡀⣿⣰⠶⣦⡄⣀⣀⣀⣀⡀⠀⢸⡇⠀⠀⣶⠀⠀⣶⡆⠰⢾⡷⠶⠆⠰⢾⡷⠆⠀⣶⢶⡶⣦⡄⣴⠶⠶⣦⡄⣶⠶⠶⣦⡄⣰⠶⠶⠶⠆⣴⠶⠶⣆⡀⣿⣰⠶⣦",
            "⠀⢸⡇⠀⠀⣿⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀⢸⡇⠀⠀⣿⠸⠇⣿⡇⣿⠛⠛⠛⠃⣿⠀⠀⣿⡇⠙⠛⠻⣧⡄⣿⠀⠀⣭⡅⣿⠉⠀⣿⡇⠉⠉⠉⠉⠁⠀⢸⡇⠀⠀⣿⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀⢸⡇⠀⠀⣿⠸⠇⣿⡇⣿⠛⠛⠛⠃⣿⠀⠀⣿⡇⠙⠛⠻⣧⡄⣿⠀⠀⣭⡅⣿⠉⠀⣿",
            "⠀⠈⠛⠛⠃⠙⠛⠛⠛⠃⠀⠘⠃⠀⠀⠀⠈⠛⠛⠃⠛⠀⠀⠛⠃⠙⠛⠛⠛⠃⠛⠀⠀⠛⠃⠛⠛⠛⠋⠁⠙⠛⠛⠋⠁⠛⠀⠀⠛⠃⠀⠀⠀⠀⠀⠀⠈⠛⠛⠃⠙⠛⠛⠛⠃⠀⠘⠃⠀⠀⠀⠈⠛⠛⠃⠛⠀⠀⠛⠃⠙⠛⠛⠛⠃⠛⠀⠀⠛⠃⠛⠛⠛⠋⠁⠙⠛⠛⠋⠁⠛⠀⠀⠛",

            },

            center = {
              -- Find files with telescope
              {
                icon = " ",
                desc = "Find file",
                key = 'o',
                keymap = 'SPC .',
                action = 'Telescope find_files',
              }
            },

            footer = {
              [[ . ,-"-.   ,-"-. ,-"-.   ,-"-. ,-"-.   ,-"-. ,-"-.   ,-"-. ,-"-.   ,-"-. ,-"-.   ,]],
              [[  X | | \ / | | X | | \ / | | X | | \ / | | X | | \ / | | X | | \ / | | X | | \ / ]],
              [[ / \| | |X| | |/ \| | |X| | |/ \| | |X| | |/ \| | |X| | |/ \| | |X| | |/ \| | |X| ]],
              [[    `-!-' `-!-"   `-!-' `-!-"   `-!-' `-!-"   `-!-' `-!-"   `-!-' `-!-"   `-!-' `-]],
            },
            -- week_header = {
            --   enable = true,
            -- },
          },


          theme = 'doom',
          hide = {
            statusline = false,
          },
        })




        ---- Spawn a terminal
        --{icon = ifmt:format(""),
        --  desc = fmt:format("Spawn terminal"),
        --  action = 'ToggleTerm', shortcut =
        --  sfmt:format('SPC s')},

        ---- Open ~/.config/nvim
        ----{ icon = ifmt:format(" "),
        ----  desc = fmt:format("Move to nvim configuration"),
        ----  action = ('cd %s'):format(vim.fn.stdpath('config')),
        ----  shortcut = sfmt:format('unbinded') }

        --}

      '';
    };
}
