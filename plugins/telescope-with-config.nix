{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.telescope-with-config = {
    enable = mkEnableOption "Enable Telescope";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.telescope-nvim;
      description = "Package to use for telescope";
    };
  };

  config = let
    cfg = config.plugins.telescope-with-config;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
      -- [telescope setup] --

      local actions = require("telescope.actions")
      require("telescope").setup {
        defaults = {

          layout_config = {
            prompt_position = "bottom",
            horizontal = {
              --width_padding = 0.04,
              width_padding = 0.9,
              height_padding = 0.1,
              preview_width = 0.6,
            },
            vertical = {
              width_padding = 0.05,
              height_padding = 1,
              preview_height = 0.5,
            },
          },

          mappings = {
            i = {
              ["<Esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-Up>"] = actions.preview_scrolling_up,
              ["<C-Down>"] = actions.preview_scrolling_down,

              ["<C-v>"] = actions.select_vertical,
              ["<C-x>"] = actions.select_horizontal,

              ["<C-h>"] = "which_key"
            }
          },
          prompt_prefix = "🔍 ", -- 

          --path_display = { "smart" },
          selection_caret = " ",
          vimgrep_arguments = {
            "${pkgs.ripgrep}/bin/rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
          },
          pickers = {
            find_command = {
              "${pkgs.fd}/bin/fd",
            },
          },
        }
      }
      '';

    };
}
