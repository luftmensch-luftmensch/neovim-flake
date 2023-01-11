{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.telescope;
in {
  options.vim.telescope = {
    enable = mkEnableOption "enable telescope";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      "telescope"
    ];

    vim.nnoremap =
      {
        "<leader>." = "<cmd> Telescope find_files<CR>";
        "<leader><leader>" = "<cmd> Telescope buffers<CR>";

        "<leader>fg" = "<cmd> Telescope live_grep<CR>";
        "<leader>fh" = "<cmd> Telescope help_tags<CR>";
        "<leader>ft" = "<cmd> Telescope<CR>";

        "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
        "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
        "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
        "<leader>fvs" = "<cmd> Telescope git_status<CR>";
        "<leader>fvx" = "<cmd> Telescope git_stash<CR>";
      }
      /* // (
        if config.vim.lsp.enable
        then {
          "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
          "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";

          "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
          "<leader>fli" = "<cmd> Telescope lsp_implementations<CR>";
          "<leader>flD" = "<cmd> Telescope lsp_definitions<CR>";
          "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
          "<leader>fld" = "<cmd> Telescope diagnostics<CR>";
        }
        else {}
      )
        */
      // (
        if config.vim.treesitter.enable
        then {
          "<leader>fs" = "<cmd> Telescope treesitter<CR>";
        }
        else {}
      );

    vim.luaConfigRC.telescope = nvim.dag.entryAnywhere ''
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
