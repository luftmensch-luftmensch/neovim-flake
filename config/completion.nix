{ lib, pkgs, ... }:
{
  config = {
    plugins = {
      cmp-emoji.enable = true;
      cmp = {
        enable = true;
        cmdline = {
          # Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
          "/".sources = [ { name = "buffer"; } ];
          "?".sources = [ { name = "buffer"; } ];
          # Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
          ":".sources = [
            { name = "path"; }
            { name = "cmdline"; }
          ];
        };
        filetype.gitcommit.sources = [
          { name = "cmp_git"; }
          { name = "buffer"; }
        ];
        settings = {
          autoEnableSources = true;
          experimental.ghost_text = false;
          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 30;
          };

          snippet.expand = "luasnip";
          formatting.fields = [
            "kind"
            "abbr"
            "menu"
          ];
          sources = [
            { name = "git"; }
            { name = "nvim_lsp"; }
            { name = "emoji"; }
            {
              name = "buffer"; # text within current buffer
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
            {
              name = "path"; # file system paths
              keywordLength = 3;
            }
            {
              name = "luasnip"; # snippets
              keywordLength = 3;
            }
          ];

          window = {
            completion.border = "solid";
            documentation.border = "solid";
          };

          mapping = {
            "<C-Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
        };
      };

      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;
      cmp-cmdline.enable = lib.mkForce false;

      # VSCode-like pictograms for neovim lsp completion items
      lspkind = {
        enable = true;
        cmp.enable = true;
        extraOptions = {
          maxwidth = 50;
          ellipsis_char = "...";
        };

        symbolMap = {
          Text = "󰉿";
          Module = "";
          Method = " ";
          Function = "󰡱 ";
          Constructor = " ";
          Field = " ";
          Variable = "󱀍 ";
          Class = " ";
          Interface = " ";
          Property = " ";
          Unit = " ";
          Value = " ";
          Enum = " ";
          Keyword = " ";
          Snippet = " ";
          Color = " ";
          File = "";
          Reference = " ";
          Folder = " ";
          EnumMember = " ";
          Constant = " ";
          Struct = " ";
          Event = " ";
          Operator = " ";
          TypeParameter = " ";
        };
      };

      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
          store_selection_keys = "<Tab>";
        };
        fromVscode = [
          {
            lazyLoad = true;
            paths = "${pkgs.vimPlugins.friendly-snippets}";
          }
        ];
      };

      nvim-autopairs = {
        enable = true;
        settings.disable_filetype = [
          "TelescopePrompt"
          "vim"
        ];
      };
      schemastore = {
        enable = true;
        json.enable = true;
        yaml.enable = true;
      };
    };
  };
}
