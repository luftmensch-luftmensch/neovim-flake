{
  lib,
  config,
  helpers,
  pkgs,
  utils,
  ...
}:
{
  config = {
    keymaps = helpers.keymaps.mkKeymaps { options.silent = true; } (
      utils.nkmap (
        lib.optionalAttrs config.plugins.neo-tree.enable {
          "<leader>d" = "<cmd>Neotree toggle<CR>";
        }
        // lib.optionalAttrs config.plugins.telescope.enable {
          "<leader><leader>" = "<cmd>Telescope buffers<CR>";
          "<leader>." = "<cmd>Telescope find_files<CR>";
          "<leader>/" = "<cmd>Telescope live_grep<CR>";
          "<leader>:" = "<cmd>Telescope command_history<CR>";
          "<C-s>" = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
          "<leader>fk" = "<cmd> Telescope keymaps<CR>";
          # "<leader>fh" = "<cmd> Telescope help_tags<CR>";
          # "<leader>ft" = "<cmd> Telescope<CR>";
          # "<leader>fs" = "<cmd> Telescope treesitter<CR>";

          # # Telescope w/ git
          # "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
          # "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
          # "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
          # "<leader>fvs" = "<cmd> Telescope git_status<CR>";
          # "<leader>fvx" = "<cmd> Telescope git_stash<CR>";
          # # Lsp
          # "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
          # "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";

          # "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
          # "<leader>fli" = "<cmd> Telescope lsp_implementations<CR>";
          # "<leader>flD" = "<cmd> Telescope lsp_definitions<CR>";
          # "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
          # "<leader>fld" = "<cmd> Telescope diagnostics<CR>";
        }
      )
    );

    plugins = {
      neo-tree = {
        enable = true;
        sources = [
          "filesystem"
          "buffers"
          "git_status"
          "document_symbols"
        ];
        addBlankLineAtTop = false;

        filesystem = {
          bindToCwd = false;
          followCurrentFile.enabled = true;
        };

        defaultComponentConfigs = {
          indent = {
            withExpanders = true;
            expanderCollapsed = "󰅂";
            expanderExpanded = "󰅀";
            expanderHighlight = "NeoTreeExpander";
          };

          gitStatus = {
            symbols = {
              added = " ";
              conflict = "󰩌 ";
              deleted = "󱂥";
              ignored = " ";
              modified = " ";
              renamed = "󰑕";
              staged = "󰩍";
              unstaged = "";
              untracked = " ";
            };
          };
        };
      };

      telescope = {
        enable = true;
        extensions = {
          file-browser.enable = true;
          fzf-native.enable = true;
          live-grep-args.enable = true;
        };
        settings = {
          defaults = {
            layout_config = {
              prompt_position = "bottom";
              horizontal = {
                width_padding = 0.9;
                height_padding = 0.1;
                preview_width = 0.6;
              };

              vertical = {
                width_padding = 5.0e-2;
                height_padding = 1;
                preview_height = 0.5;
              };
            };

            mappings = {
              i = {
                "<Esc>" = "close";
                "<C-j>" = "move_selection_next";
                "<C-k>" = "move_selection_previous";
                "<C-Up>" = "preview_scrolling_up";
                "<C-Down>" = "preview_scrolling_down";
                "<C-v>" = "select_vertical";
                "<C-x>" = "select_horizontal";
                "<C-h>" = "which_key";
              };
            };

            prompt_prefix = "🔍 ";
            selection_caret = " ";
            vimgrep_arguments = [
              "${lib.getExe pkgs.ripgrep}"
              "--color=never"
              "--no-heading"
              "--with-filename"
              "--line-number"
              "--column"
              "--smart-case"
            ];
          };

          pickers = {
            colorscheme.enable_preview = true;
            find_command = "${lib.getExe pkgs.fd}";
          };
        };
      };
    };

    extraPlugins = [ pkgs.vimPlugins.telescope-ui-select-nvim ];
  };
}
