{
  lib,
  pkgs,
  config,
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

        # Terminal
        "<leader>s" = ":ToggleTerm<CR>";

        "<leader>M" = "<cmd>lua MiniMap.toggle()<CR>";
      });

    plugins = {
      notify = {
        enable = true;
        timeout = 1000;
        stages = "static";
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

      # extraPlugins -> 
      markview-nvim.enable = true;

      silicon = {
        enable = true;
        flavour = "Monokai Extended Origin";
      };

      which-key = {
        enable = true;
        settings.win.border = "rounded";
      };

      ### Code support ###
      neodev.enable = true;
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

      cursorline = {
        enable = true;
        cursorword = {
          enable = true;
          minLength = 3;
          hl.underline = true;
        };
      };

      # Boost neovim % (Modern matchit and matchparen)
      vim-matchup = {
        enable = true;
        treesitter = {
          enable = true;
          include_match_words = true;
        };
      };

      # Autopairs
      nvim-autopairs.enable = true;

      # Comments on steroid
      todo-comments.enable = true;

      # Indent guides for Neovim
      indent-blankline = {
        enable = true;
        settings = {
          scope = {
            enabled = true;
            show_start = true;
          };
        };
      };
    };

    extraPlugins = [
      pkgs.vimPlugins.markdown-preview-nvim
    ];

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
