{ lib, config, ... }:
{
  config = {
    # Current favourite colorscheme
    colorschemes.modus.enable = true;

    plugins = {
      alpha = {
        enable = true;
        layout = [
          {
            type = "padding";
            val = 10;
          }
          {
            opts = {
              hl = "Type";
              position = "center";
            };
            type = "text";
            val = [
              "                                                                       "
              "                                                                     "
              "       ████ ██████           █████      ██                     "
              "      ███████████             █████                             "
              "      █████████ ███████████████████ ███   ███████████   "
              "     █████████  ███    █████████████ █████ ██████████████   "
              "    █████████ ██████████ █████████ █████ █████ ████ █████   "
              "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
              " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
              "                                                                       "
              "                                                                       "
              "                                                                       "
            ];
          }
        ];
      };
      lualine = {
        enable = true;
        settings = {
          iconsEnabled = true;
          globalstatus = true;
          extensions = lib.optionals config.plugins.nvim-tree.enable [ "nvim-tree" ];
          ignoreFocus = lib.optionals config.plugins.nvim-tree.enable [ "NvimTree" ];
          theme = if config.colorschemes.modus.enable then "modus-vivendi" else "auto";
        };
      };

      web-devicons.enable = true;

      # Ui replacement for messages, cmdline and the popupmenu
      noice = {
        enable = true;
        settings = {
          messages = rec {
            view = "notify";
            viewError = view;
            viewWarn = view;
            viewHistory = "messages";
            viewSearch = "virtualtext";
          };

          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };

          presets = {
            command_palette = true;
            long_message_to_split = true;
            lsp_doc_border = false;
          };

          notify = {
            enabled = true;
            view = "notify";
          };
        };
      };
    };
  };
}
