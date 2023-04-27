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
      nvim_tree_disable_default_keybindings = 1;
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

      # Prevent swapfile, backupfile from being created
      swapfile    = false;
      backup      = false;
      writebackup = false;

      # Open new splits respectoveòu to the right & to the bottom
      splitright  = true;
      splitbelow  = true;
    };

    commands = {
      # "SpellFr" = "setlocal spelllang=fr";
    };

    ### MAPPINGS ###

    ## Normal mode ##
    maps.normal = helpers.mkModeMaps {silent = true;} {
      # File Tree
      "<leader>d"        = "<cmd>NvimTreeToggle<CR>";
      "<leader>tr"       = ":NvimTreeRefresh<CR>";
      "<leader>tf"       = ":NvimTreeFocus<CR>";

      # Telescope
      "<leader><leader>" = "<cmd>Telescope buffers<CR>";
      "<leader>."        = "<cmd> Telescope find_files<CR>";
      "<leader>fg"       = "<cmd> Telescope live_grep<CR>";
      "<leader>fh"       = "<cmd> Telescope help_tags<CR>";
      "<leader>ft"       = "<cmd> Telescope<CR>";
      "<leader>fs"       = "<cmd> Telescope treesitter<CR>";

      # Telescope w/ git
      "<leader>fvcw"     = "<cmd> Telescope git_commits<CR>";
      "<leader>fvcb"     = "<cmd> Telescope git_bcommits<CR>";
      "<leader>fvb"      = "<cmd> Telescope git_branches<CR>";
      "<leader>fvs"      = "<cmd> Telescope git_status<CR>";
      "<leader>fvx"      = "<cmd> Telescope git_stash<CR>";

      # Git
      "<leader>gg"       = ":Neogit cwd=~/config/<CR>";
      "<leader>gG"       = ":Neogit cwd=~/Nixos/<CR>";
      "<leader>g."       = ":Neogit cwd=./<CR>";

      # LSP
      "<leader>flsb"     = "<cmd> Telescope lsp_document_symbols<CR>";
      "<leader>flsw"     = "<cmd> Telescope lsp_workspace_symbols<CR>";

      "<leader>flr"      = "<cmd> Telescope lsp_references<CR>";
      "<leader>fli"      = "<cmd> Telescope lsp_implementations<CR>";
      "<leader>flD"      = "<cmd> Telescope lsp_definitions<CR>";
      "<leader>flt"      = "<cmd> Telescope lsp_type_definitions<CR>";
      "<leader>fld"      = "<cmd> Telescope diagnostics<CR>";

      "gr"               = "<cmd>Telescope lsp_references<CR>";
      "gI"               = "<cmd>Telescope lsp_implementations<CR>";
      "gW"               = "<cmd>Telescope lsp_workspace_symbols<CR>";
      "gF"               = "<cmd>Telescope lsp_document_symbols<CR>";
      "ge"               = "<cmd>Telescope diagnostics bufnr=0<CR>";
      "gE"               = "<cmd>Telescope diagnostics<CR>";

      # Terminal
      "<leader>s"        = ":ToggleTerm<CR>";


      "mk"               = "<cmd>Telescope keymaps<CR>";

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

    # Neovim Editor Config support
    editorconfig = {
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

      -- [Web Dev Icons setup] --
      require'nvim-web-devicons'.setup({})
    '';

    # Plugins setup
    plugins = {
      ### Theming ###

      # Current favourite theme
      nightfox = {
        enable = true;
      };

      # Current favourite status line
      staline = {
        enable = true;
      };

      # Ui replacement for messages, cmdline and the popupmenu
      noice = {
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

      # Fuzzy finder w/ custom config
      telescope-with-config = {
        enable = true;
      };

      ### Code support ###
      # Treesitter
      treesitter = {
        enable = true;
        indent = true;

        incrementalSelection = {
          enable = true;
          keymaps = {
            initSelection    = "gnn";
            nodeIncremental  = "grn";
            scopeIncremental = "grc";
            nodeDecremental  = "grm";
          };
        };

        grammarPackages = with config.plugins.treesitter.package.passthru.builtGrammars; [
          arduino c cpp tlaplus # Low level programming
          rust lalrpop # Rust
          bash regex # Scripting
          dart
          devicetree
          dockerfile
          gitattributes gitcommit gitignore git_rebase diff # Git related
          # File type specific
          ini json toml yaml

          latex
          lua
          markdown markdown_inline rst # Markup Langs
          make meson ninja # Building SW
          nix
          python
          slint
          sql
          
          vim vimdoc
          html javascript css

          ### Disabled
          # cuda
        ];
      };

      treesitter-refactor = {
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

      treesitter-context = {
        enable = true;
      };

      trouble = {
        enable = true;
      };

      fidget = {
        enable = true;
        # sources.null-ls.ignore = true;
      };

      toggleterm = {
        enable = true;
      };

      nvim-cursorline = {
        enable = true;
      };
      
      # Vim matchup support for treesitter
      vim-matchup = {
        enable = true;
        treesitterIntegration = {
          enable = true;
          includeMatchWords = true;
        };
      };

      # Autopairs
      nvim-autopairs = {
        enable = true;
      };

      # Highlight TODO keywords
      todo-comments = {
        enable = true;
      };

      # Comments on steroid
      comment-nvim = {
        enable  = true;
        # Add a space b/w comment and the line
        padding = true;
        # Whether the cursor should stay at its position
        sticky  = true;
      };

      # File Tree
      nvim-tree = {
        enable = true;
        autoReloadOnWrite = true;
        hijackNetrw = true;
        # diagnostics = {
        #   enable = true;
        # };
        actions = {
          openFile = {
            quitOnOpen = true;
          };
        };
        git = {
          enable = true;
        };
        renderer = {
          addTrailing = true;
          groupEmpty = true;
          indentMarkers.enable = true;
        };

        onAttach = ''
        local function on_attach(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- Mappings migrated from view.mappings.list
          vim.keymap.set('n', 'h', api.tree.change_root_to_parent, opts('Up'))
          vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
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

        view = {
          width = 25;
          side = "left";
        };

        filters = {
          dotfiles = false;
          custom = [
            "node_modules" ".cache"
          ];
        };

        systemOpen = {
          cmd = "${pkgs.xdg-utils}/bin/xdg-open";
        };
      };

      
      indent-blankline = {
        enable = true;
        useTreesitter = true;
        showCurrentContext = true;
        showCurrentContextStart = true;
      };

      ### Completion ###
      nvim-cmp = {
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
          { name = "luasnip"; }
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
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
      neogit = {
        enable = true;
        disableCommitConfirmation = true;
        useMagitKeybindings = true;
      };

      ### Snippets ###
      luasnip = {
        enable = true;
      };
      
    };


    filetype = {
      filename = {
        Jenkinsfile = "groovy";
      };
      extension = {
        lalrpop = "lalrpop";
      };
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


    # plugins.netman = {
    #   enable = true;
    #   package = pkgs.vimPlugins.netman-nvim;
    # };

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
