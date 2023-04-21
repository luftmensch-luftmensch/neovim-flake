{
  pkgs,
  config,
  helpers,
  ...
}: {
  config = {

    # Global values
    globals = {
      mapleader = " ";
    };

    # Custom option
    options = {
      # True color support
      termguicolors = true;

      # Show numbers...
      number = true;
      # ...in a relative mode
      relativenumber = true;

      # Number of spaces that a <Tab> in the file counts for.
      tabstop = 4;
      shiftwidth = 4;

      # Minimal number of screen lines to keep above and below the cursor
      scrolloff = 7;
      # When and how to draw the signcolumn. (yes to set to always)
      signcolumn = "yes";

      # Number of screen lines to use for the command-line. (Disabled as we are going to use Noice folke plugin)
      cmdheight = 1;

      # A comma-separated list of options for Insert mode completion |ins-completion|.  The supported values are:
      # 
      # menu	-> Use a popup menu to show the possible completions.  The
      #         menu is only shown when there is more than one match and
      #         sufficient colors are available.  |ins-completion-menu|
      #
      # menuone ->  Use the popup menu also when there is only one match.
      #             Useful when there is additional information about the
      #             match, e.g., what file it comes from.
      #
      # noselect -> Do not select a match in the menu, force the user to
      #             select one from the menu. Only works in combination with
      #             "menu" or "menuone".
      cot = ["menu" "menuone" "noselect"];
      # If this many milliseconds nothing is typed the swap file will be written to disk
      updatetime = 500;
      # When on spell checking will be done. The languages are specified with 'spelllang'.
      spell = true;

      # Comma-separated list of screen columns that are highlighted with ColorColumn |hl-ColorColumn|.
      colorcolumn = "100";

      # statuscolumn = "%l     %r";

      # Strings to use in 'list' mode and for the |:list| command.  It is a comma-separated list of string settings.
      listchars = "tab:>-,lead:·,nbsp:␣,trail:•";

      # Determine the behavior when part of a mapped key sequence has been received.
      # For example, if <c-f> is pressed and 'timeout' is set, Nvim will wait 'timeoutlen' milliseconds
      # for any key that can follow <c-f> in a mapping.
      timeout = true;
      timeoutlen = 300;

      # Enable clipboard support
      clipboard = "unnamedplus";
    };

    commands = {
      # "SpellFr" = "setlocal spelllang=fr";
    };

    ### MAPPINGS ###

    ## Normal mode ##
    maps.normal = helpers.mkModeMaps {silent = true;} {
      "<leader>d" = "<cmd>NvimTreeToggle<CR>";

      "<leader><leader>" = "<cmd>Telescope buffers<CR>";
      "<leader>."        = "<cmd> Telescope find_files<CR>";
      "<leader>fg"       = "<cmd> Telescope live_grep<CR>";
      "<leader>fh"       = "<cmd> Telescope help_tags<CR>";
      "<leader>ft"       = "<cmd> Telescope<CR>";

      "<leader>fvcw"     = "<cmd> Telescope git_commits<CR>";
      "<leader>fvcb"     = "<cmd> Telescope git_bcommits<CR>";
      "<leader>fvb"      = "<cmd> Telescope git_branches<CR>";
      "<leader>fvs"      = "<cmd> Telescope git_status<CR>";
      "<leader>fvx"      = "<cmd> Telescope git_stash<CR>";

      "mk" = "<cmd>Telescope keymaps<CR>";
      # "fg" = "<cmd>Telescope git_files<CR>";

      "gr" = "<cmd>Telescope lsp_references<CR>";
      "gI" = "<cmd>Telescope lsp_implementations<CR>";
      "gW" = "<cmd>Telescope lsp_workspace_symbols<CR>";
      "gF" = "<cmd>Telescope lsp_document_symbols<CR>";
      "ge" = "<cmd>Telescope diagnostics bufnr=0<CR>";
      "gE" = "<cmd>Telescope diagnostics<CR>";

      "<leader>rn" = {
        action = ''
          function()
            return ":IncRename " .. vim.fn.expand("<cword>")
          end
        '';
        lua = true;
        expr = true;
      };

    };

    ## Visual mode ##
    maps.visual = helpers.mkModeMaps {silent = true;} {
      # "<leader>zf" = "'<,'>ZkMatch<CR>";
    };

    # colorschemes.tokyonight = {
    #   style = "night";
    #   enable = true;
    # };

    plugins = {

      # Current favourite theme
      nightfox = {
        enable = true;
      };

      # Neovim dashboard
      dash = {
        enable = true;
      };

      # Neovim as language server to inject LSP diagnostics, code actions
      null-ls = {
        enable = true;
        sources = {
          diagnostics = {
            shellcheck.enable = true;
            cppcheck.enable = true;
            gitlint.enable = true;
          };
          code_actions = {
            shellcheck.enable = true;
            gitsigns.enable = true;
          };
          formatting = {
            alejandra.enable = true;
            black.enable = true;
            stylua.enable = true;
            cbfmt.enable = true;
            shfmt.enable = true;
            taplo.enable = true;
            prettier.enable = true;
          };
        };
      };

      ### Git ###
      gitsigns.enable = true;
      gitmessenger.enable = true;
      
    };


    filetype = {
      filename = {
        Jenkinsfile = "groovy";
      };
      extension = {
        lalrpop = "lalrpop";
      };
    };



    plugins.luasnip = {
      enable = true;
    };

    extraConfigLuaPre = ''
      -- [options setup] --
      local au = vim.api.nvim_create_augroup('restore_on_exit.augroup', { clear = true })
      vim.api.nvim_create_autocmd({ 'VimLeave'}, {
         group = au,
         command = "set guicursor=a:ver25-Cursor"
      })

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local luasnip = require("luasnip")
    '';

    plugins.nvim-cmp = {
      enable = true;

      snippet.expand = "luasnip";

      mapping = {
        "<CR>" = "cmp.mapping.confirm({select = true })";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" })
        '';
        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';
        "<Down>" = "cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
        "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
      };

      sources = [
        {name = "luasnip";}
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
      ];
    };

    plugins.telescope = {
      enable = true;
      enabledExtensions = [ "ui-select" ];
      extensionConfig = {
        ui-select = {
          __raw = ''
              require("telescope.themes").get_dropdown {
              -- even more opts
              }
          '';
        };

      };
      
      extraOptions = {
        defaults = {
          layout_strategy = "horizontal";
          prompt_prefix = "🔍 ";
          selection_caret = " ";

          mappings = {
            i = {
              # "<Esc>" = "require('telescope.actions).close";

              # "K" = "actions.close";
            };
          };
        };
      };
    };

    plugins.treesitter = {
      enable = true;
      indent = true;

      grammarPackages = with config.plugins.treesitter.package.passthru.builtGrammars; [
        arduino
        bash
        c
        cpp
        cuda
        dart
        devicetree
        diff
        dockerfile
        gitattributes
        gitcommit
        gitignore
        git_rebase
        html
        ini
        json
        lalrpop
        latex
        lua
        make
        markdown
        markdown_inline
        meson
        ninja
        nix
        python
        regex
        rst
        rust
        slint
        sql
        tlaplus
        toml
        vim
        vimdoc
        yaml
      ];
    };

    plugins.treesitter-refactor = {
      enable = true;
      highlightDefinitions = {
        enable = true;
        clearOnCursorMove = true;
      };
      smartRename = {
        enable = true;
      };
      navigation = {
        enable = true;
      };
    };

    plugins.treesitter-context = {
      enable = true;
    };

    plugins.vim-matchup = {
      treesitterIntegration = {
        enable = true;
        includeMatchWords = true;
      };
      enable = true;
    };

    plugins.comment-nvim = {
      enable = true;
    };

    plugins.nvim-tree = {
      enable = true;
    };

    plugins.indent-blankline = {
      enable = true;

      useTreesitter = true;

      showCurrentContext = true;
      showCurrentContextStart = true;
    };

    plugins.lsp = {
      enable = true;

      enabledServers = [
        # {
        #   name = "lemminx";
        #   extraOptions = {
        #     cmd = ["${pkgs.lemminx-bin}/bin/lemminx-bin"];
        #   };
        # }
      ];

      keymaps = {
        silent = true;

        lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "ca" = "code_action";
          "ff" = "format";
          "K" = "hover";
        };
      };

      servers = {
        nil_ls = {
          enable = true;
          settings = {
            formatting.command = ["alejandra" "--quiet"];
          };
        };
        bashls.enable = true;
        dartls.enable = true;
      };
    };

    plugins.rust-tools = {
      enable = true;
      inlayHints = {
        maxLenAlign = true;
      };

      server = {
        cargo.features = "all";
        checkOnSave = true;
        check.command = "clippy";
      };
    };

    plugins.lspkind = {
      enable = true;
      cmp = {
        enable = true;
      };
    };

    plugins.nvim-lightbulb = {
      enable = true;
      autocmd.enabled = true;
    };

    plugins.lsp_signature = {
      enable = true;
    };

    plugins.inc-rename = {
      enable = true;
    };

    plugins.clangd-extensions = {
      enable = true;
      enableOffsetEncodingWorkaround = true;

      extensions.ast = {
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
    };

    plugins.fidget = {
      enable = true;
      # sources.null-ls.ignore = true;
    };

    plugins.lualine = {
      enable = true;
    };

    plugins.trouble = {
      enable = true;
    };

    plugins.noice = {
      enable = true;

      messages = {
        view = "mini";
        viewError = "mini";
        viewWarn = "mini";
      };

      lsp.override = {
        "vim.lsp.util.convert_input_to_markdown_lines" = true;
        "vim.lsp.util.stylize_markdown" = true;
        "cmp.entry.get_documentation" = true;
      };
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = true;
        lsp_doc_border = false;
      };
    };

    plugins.netman = {
      enable = true;
      package = pkgs.vimPlugins.netman-nvim;
    };

    plugins.which-key.enable = true;

    extraConfigLuaPost = ''
      require("luasnip.loaders.from_snipmate").lazy_load()

      local null_ls = require("null-ls")
      local helpers = require("null-ls.helpers")
    '';

    extraPlugins = with pkgs.vimPlugins; [
      telescope-ui-select-nvim
      markdown-preview-nvim
    ];
  };
}
