{
  lib,
  config,
  pkgs,
  helpers,
  utils,
  ...
}:
{
  config = {
    keymaps = helpers.keymaps.mkKeymaps { options.silent = true; } (
      utils.nkmap (
        lib.optionalAttrs config.plugins.markdown-preview.enable {
          "<leader>mp" = "<cmd>MarkdownPreview<cr>";
        }
        // lib.optionalAttrs config.plugins.toggleterm.enable {
          "<leader>s" = ":ToggleTerm<CR>";
          "<leader>tf" = "<cmd>ToggleTerm direction=float<cr>";
        }
        // lib.optionalAttrs config.plugins.mini.enable { "<leader>M" = "<cmd>lua MiniMap.toggle()<CR>"; }
      )
    );

    plugins = {
      markview = {
        enable = true;
        settings = {
          modes = [
            "n"
            "i"
            "no"
            "c"
          ];
          hybrid_modes = [ "i" ];
          callback.on_enable = ''
            function (_, win)
              vim.wo[win].conceallevel = 2;
              vim.wo[win].concealcursor = "nc";
            end
          '';
        };
      };
      markdown-preview = {
        enable = true;
        settings = {
          preview_options = {
            disable_filename = 1;
            disable_sync_scroll = 1;
            sync_scroll_type = "middle";
          };
          theme = "dark";
        };
      };

      mini = {
        enable = true;

        modules = {
          # Visual enhancement (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md)
          ai = { };
          # Interactive alignment (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md)
          align = { };
          # Enhanced surrounding (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md)
          surround = { };
          # Minimap
          map = { };
          # Enhanced commenting - Alternative to https://github.com/numToStr/Comment.nvim
          comment = { };
        };
      };
      web-devicons.enable = true;

      toggleterm = {
        enable = true;
        settings = {
          direction = "horizontal";
          float_opts = {
            border = "curved";
            winblend = 3;
          };
        };
      };

      which-key = {
        enable = true;
        settings.win.border = "rounded";
      };

      silicon = {
        enable = true;
        flavour = "Monokai Extended Origin";
      };

      cloak = {
        enable = true;
        settings = {
          cloak_character = "*";
          highlight_group = "Comment";
          cloak_telescope = true;
          patterns = [
            {
              cloak_pattern = "=.+";
              file_pattern = [
                ".env*"
                ".dev.vars"
              ];
            }
          ];
        };
      };
    };


    extraPackages =
      with lib;
      with config.plugins;
      (optionals lsp.enable (
        with pkgs;
        [
          fswatch
          cppcheck
          nodePackages.bash-language-server
        ]
      ))
      ++ (optionals conform-nvim.enable (
        with pkgs;
        [
          codespell
          isort
          prettierd
        ]
      ))
      ++ (optionals luasnip.enable (with pkgs.luajitPackages; [ jsregexp ]))
      ++ [ pkgs.nixfmt-rfc-style ];

  };
}
