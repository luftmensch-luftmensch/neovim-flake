{
  lib,
  config,
  helpers,
  utils,
  ...
}:
{
  config = {
    colorschemes.modus.enable = true;
    plugins = {
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

      notify = {
        enable = true;
        timeout = 1000;
        stages = "static";
      };

      lualine = {
        enable = true;
        settings = {
          options = {
            globalstatus = true;
            extensions =
              [ "fzf" ]
              ++ lib.optionals config.plugins.nvim-tree.enable [ "nvim-tree" ]
              ++ lib.optionals config.plugins.neo-tree.enable [ "neo-tree" ];
            ignoreFocus = lib.optionals config.plugins.nvim-tree.enable [ "NvimTree" ];

            disabledFiletypes = {
              statusline = [
                "startup"
                "alpha"
              ];
            };
            theme = if config.colorschemes.modus.enable then "modus-vivendi" else "auto";
          };
          sections = {
            lualine_a = [
              {
                __unkeyed-1 = "mode";
                icon = "";
              }

            ];
            lualine_b = [
              {
                __unkeyed-1 = "branch";
                icon = "";
              }
              {
                __unkeyed-1 = "diff";
                symbols = {
                  added = " ";
                  modified = " ";
                  removed = " ";
                };
              }
            ];
            lualine_c = [
              {
                __unkeyed-1 = "diagnostics";
                sources = [ "nvim_lsp" ];
                symbols = {
                  error = " ";
                  warn = " ";
                  info = " ";
                  hint = "󰝶 ";
                };
              }
              {
                __unkeyed-1 = "navic";
              }
            ];
            lualine_x = [
              {
                __unkeyed-1 = "filetype";
                icon_only = true;
                separator = "";
                padding = {
                  left = 1;
                  right = 0;
                };
              }
              {
                __unkeyed-1 = "filename";
                path = 1;
              }
            ];
            lualine_y = [
              {
                __unkeyed-1 = "progress";
              }
            ];
            lualine_z = [
              {
                __unkeyed-1 = "location";
              }
            ];
          };
        };
      };
      startup = {
        enable = true;

        colors = {
          background = "#ffffff";
          foldedSection = "#ffffff";
        };

        sections = {
          header = {
            type = "text";
            oldfilesDirectory = false;
            align = "center";
            foldSection = false;
            title = "Header";
            margin = 5;
            content = [
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
            highlight = "Statement";
            defaultColor = "";
            oldfilesAmount = 0;
          };

          body = {
            type = "mapping";
            oldfilesDirectory = false;
            align = "center";
            foldSection = false;
            title = "Menu";
            margin = 5;
            content = [
              [
                " Find File"
                "Telescope find_files"
                "ff"
              ]
              [
                "󰍉 Find Word"
                "Telescope live_grep"
                "fr"
              ]
              [
                " Recent Files"
                "Telescope oldfiles"
                "fg"
              ]
              [
                " File Browser"
                "Telescope file_browser"
                "fe"
              ]
            ];
            highlight = "string";
            defaultColor = "";
            oldfilesAmount = 0;
          };
        };

        options.paddings = [
          1
          3
        ];

        parts = [
          "header"
          "body"
        ];
      };

      bufferline = {
        enable = true;
        settings = {
          options = {
            diagnostics = "nvim_lsp";
            mode = "buffers";
            close_icon = " ";
            buffer_close_icon = "󰱝 ";
            modified_icon = "󰔯 ";

            offsets = [
              {
                filetype = "neo-tree";
                text = "Neo-tree";
                highlight = "Directory";
                text_align = "left";
              }
            ];
          };
        };
      };
    };

    keymaps = helpers.keymaps.mkKeymaps { options.silent = true; } (
      utils.nkmap (
        lib.optionalAttrs config.plugins.bufferline.enable {
          "[b" = "<cmd>BufferLineCyclePrev<cr>"; # Cycle to previous buffer
          "]b" = "<cmd>BufferLineCycleNext<cr>"; # Cycle to next buffer
          "<leader>bh" = "<cmd>BufferLineCyclePrev<cr>"; # Cycle to previous buffer
          "<leader>bl" = "<cmd>BufferLineCycleNext<cr>"; # Cycle to next buffer
          "<leader>bd" = "<cmd>bdelete<cr>"; # Delete buffer
          "<leader>bo" = "<cmd>BufferLineCloseOthers<cr>"; # Delete other buffers
          "<leader>bp" = "<cmd>BufferLineTogglePin<cr>"; # Toggle pin
          "<leader>bP" = "<Cmd>BufferLineGroupClose ungrouped<CR>"; # Delete non-pinned buffers
        }
      )
    );
  };
}
