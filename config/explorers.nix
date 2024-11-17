{
  lib,
  pkgs,
  helpers,
  ...
}:
{
  config = {
    keymaps =
      let
        modeKeys = mode: lib.attrsets.mapAttrsToList (key: action: { inherit key action mode; });
        nm = modeKeys [ "n" ];
      in
      helpers.keymaps.mkKeymaps { options.silent = true; } (nm {
        # File Tree
        "<leader>d" = "<cmd>NvimTreeToggle<CR>";
        "<leader>tr" = ":NvimTreeRefresh<CR>";
        "<leader>tf" = ":NvimTreeFocus<CR>";

        # Telescope
        "<leader><leader>" = "<cmd>Telescope buffers<CR>";
        "<leader>." = "<cmd> Telescope find_files<CR>";
        "<leader>fg" = "<cmd> Telescope live_grep<CR>";
        "<leader>fh" = "<cmd> Telescope help_tags<CR>";
        "<leader>ft" = "<cmd> Telescope<CR>";
        "<leader>fs" = "<cmd> Telescope treesitter<CR>";
        "<leader>fk" = "<cmd> Telescope keymaps<CR>";
        "<C-s>" = "<cmd>Telescope current_buffer_fuzzy_find<CR>";

        # Telescope w/ git
        "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
        "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
        "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
        "<leader>fvs" = "<cmd> Telescope git_status<CR>";
        "<leader>fvx" = "<cmd> Telescope git_stash<CR>";

        # Lsp
        "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
        "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";

        "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
        "<leader>fli" = "<cmd> Telescope lsp_implementations<CR>";
        "<leader>flD" = "<cmd> Telescope lsp_definitions<CR>";
        "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
        "<leader>fld" = "<cmd> Telescope diagnostics<CR>";
      });

    plugins = {

      # File Explorer Tree
      nvim-tree = {
        enable = true;
        autoReloadOnWrite = true;
        hijackNetrw = true;
        actions = {
          openFile.quitOnOpen = true;
          changeDir = {
            enable = true;
            global = true;
          };
        };

        git = {
          enable = true;
          ignore = false;
        };

        liveFilter = {
          prefix = " ";
          alwaysShowFolders = true;
        };

        renderer = {
          addTrailing = true;
          highlightOpenedFiles = "name";
          indentWidth = 2;
          groupEmpty = true;
          indentMarkers.enable = true;
          icons = {
            webdevColors = false;
            gitPlacement = "after";
            padding = "  ";
            glyphs = {
              git = {
                staged = "";
                unstaged = "δ";
                untracked = "α";
                deleted = "D";
                renamed = "R";
              };
              folder = {
                arrowOpen = "»";
                arrowClosed = "›";
                default = "'";
                open = " ";
              };
            };
          };
        };

        onAttach = {
          __raw = ''
            function(bufnr)
              local api = require("nvim-tree.api")

              local function opts(desc)
                return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
              end

              -- Mappings migrated from view.mappings.list
              vim.keymap.set('n', 'h', api.tree.change_root_to_parent, opts('Up'))
              vim.keymap.set('n', 'l', api.tree.change_root_to_node, opts('Down'))
              vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
              vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
              vim.keymap.set('n', '<S-Tab>', api.tree.collapse_all, opts('Collapse'))
              vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
              vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
              vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
              vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
              vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
              vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
              vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
              vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
              vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
              vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
              vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
              vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
              vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
              vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
            end
          '';
        };

        view = {
          width = 25;
          side = "left";
          signcolumn = "yes";
        };

        filters = {
          dotfiles = false;
          custom = [
            "^.git$"
            "node_modules"
            ".cache"
          ];
        };

        systemOpen.cmd = "${pkgs.xdg-utils}/bin/xdg-open";

        diagnostics = {
          enable = true;
          showOnDirs = true;
          debounceDelay = 100;
          severity.min = "warn";
        };
        selectPrompts = true;
      };

      telescope = {
        enable = true;
        settings.defaults = {
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
            "${lib.getExe pkgs.ripgrep}/"
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
          ];
          pickers.find_command = "${lib.getExe pkgs.fd}";
        };
      };
    };

    extraPlugins = [ pkgs.vimPlugins.telescope-ui-select-nvim ];
  };
}
