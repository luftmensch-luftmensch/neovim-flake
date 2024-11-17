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
        "<leader>gd" = "<cmd>Trouble lsp_definitions<CR>";
        "<leader>gr" = "<cmd>Trouble lsp_references<CR>";
        "<leader>gI" = "<cmd>Trouble lsp_implementations<CR>";
        "<leader>gW" = "<cmd>Telescope lsp_workspace_symbols<CR>";
        "<leader>gF" = "<cmd>Telescope lsp_document_symbols<CR>";
        "<leader>ge" = "<cmd>Telescope diagnostics bufnr=0<CR>";
        "<leader>gE" = "<cmd>Telescope diagnostics<CR>";
        "<leader>rn" = "<cmd>lua vim.lsp.buf.rename()<CR>";

        "[d" = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        "]d" = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        "<leader>e" = "<cmd>lua vim.diagnostic.open_float()<CR>"; # Show diagnostic error messages
        "<leader>q" = "<cmd>lua vim.diagnostic.setloclist()<CR>"; # Open diagnostic quickfix list
        "<leader>ca" = "<cmd>lua vim.lsp.buf.code_action()<CR>"; # Open diagnostic quickfix list
      });

    plugins = {
      lsp = {
        enable = true;
        keymaps = {
          silent = true;
          lspBuf = {
            gd = "definition";
            gD = "declaration";
            ca = "code_action";
            ff = "format";
            K = "hover";
          };
        };

        capabilities = ''
          capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
        '';

        servers = {
          clangd.enable = true;
          bashls.enable = true;
          gopls.enable = true;
          dartls.enable = true;
          efm = {
            enable = true;
            extraOptions.init_options.documentFormatting = true;
            settings.logLevel = 1;
          };
          pylsp = {
            enable = true;
            settings = {
              configurationSources = "flake8";
              plugins = {
                flake8.enabled = true;
                pylint.enabled = true;
              };
            };
          };
          nixd = {
            enable = true;
            settings = {
              formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
            };
          };
        };
      };

      efmls-configs = {
        enable = true;
        setup = rec {
          sh = {
            formatter = "shfmt";
            linter = "shellcheck";
          };
          bash = sh;
          c = {
            formatter = "clang_format";
            linter = "cppcheck";
          };
          "c++" = c;
          go = {
            formatter = "gofmt";
            linter = "golint";
          };
          markdown.formatter = "cbfmt";
          python.formatter = "black";

          nix.linter = "statix";
          lua.formatter = "stylua";
          json.formatter = "prettier";
          css.formatter = "prettier";
          gitcommit.linter = "gitlint";
        };
      };

      clangd-extensions = {
        enable = true;
        ast = {
          roleIcons = {
            type = "";
            declaration = "";
            expression = "";
            specifier = "";
            statement = "";
            templateArgument = "";
          };
          kindIcons = {
            compound = "";
            recovery = "";
            translationUnit = "";
            packExpansion = "";
            templateTypeParm = "";
            templateTemplateParm = "";
            templateParamObject = "";
          };
        };

        inlayHints = {
          highlight = "Comment";
          priority = 100;
          parameterHintsPrefix = "<- ";
          otherHintsPrefix = "=> ";
        };
      };

      # VSCode-like pictograms for neovim lsp completion items
      lspkind = {
        enable = true;
        cmp.enable = true;
        symbolMap = {
          Text = "󰉿";
          Method = "󰆧";
          Function = "󰊕";
          Constructor = "";
          Field = "󰜢";
          Variable = "󰀫";
          Class = "󰠱";
          Interface = "";
          Module = "";
          Property = "󰜢";
          Unit = "󰑭";
          Value = "󰎠";
          Enum = "";
          Keyword = "󰌋";
          Snippet = "";
          Color = "󰏘";
          File = "󰈙";
          Reference = "󰈇";
          Folder = "󰉋";
          EnumMember = "";
          Constant = "󰏿";
          Struct = "󰙅";
          Event = "";
          Operator = "󰆕";
          TypeParameter = "";
        };
      };

      # Diagnostics, references, telescope results, quickfix and location list
      trouble = {
        enable = true;
        settings = {
          icons = {
            folder_closed = " ";
            folder_open = " ";
            indent = {
              fold_closed = " ";
              fold_open = " ";
              last = "└╴";
              middle = "├╴";
              top = "│ ";
              ws = "  ";
            };
            kinds = {
              Array = " ";
              Boolean = "󰨙 ";
              Class = " ";
              Constant = "󰏿 ";
              Constructor = " ";
              Enum = " ";
              EnumMember = " ";
              Event = " ";
              Field = " ";
              File = " ";
              Function = "󰊕 ";
              Interface = " ";
              Key = " ";
              Method = "󰊕 ";
              Module = " ";
              Namespace = "󰦮 ";
              Null = " ";
              Number = "󰎠 ";
              Object = " ";
              Operator = " ";
              Package = " ";
              Property = " ";
              String = " ";
              Struct = "󰆼 ";
              TypeParameter = " ";
              Variable = "󰀫 ";
            };
          };
          # position = "bottom";
          # signs = {
          #   error = "";
          #   warning = "";
          #   hint = "";
          #   information = "";
          #   other = "";
          # };
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = false;
          format_on_save = {
            timeoutMs = 500;
            lspFallback = true;
          };

          # Map of filetype to formatters
          formatters_by_ft = {
            lua = [ "stylua" ];
            tex = [ "latexindent" ];
            c = [ "clang-format" ]; # "astyle"
            # Conform will run multiple formatters sequentially
            python = [
              "isort"
              "black"
            ];
            # Use a sub-list to run only the first available formatter
            javascript = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            # Use the "*" filetype to run formatters on all filetypes.
            "*" = [ "codespell" ];
            "nix" = [ "nixfmt" ];
            # Use the "_" filetype to run formatters on filetypes that don't
            # have other formatters configured.
            "_" = [ "trim_whitespace" ];
          };
        };
      };
    };
  };
}
