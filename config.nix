{
  lib,
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
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      # Tab as spaces
      expandtab = false;
      # Adaptive (Tab or spaces)
      smarttab = false;
      # Even number of shift
      shiftround = true;
      autoindent = true;
      # smartindent = false;

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
      swapfile = false;
      backup = false;
      writebackup = false;

      # Open new splits respectively to the right & to the bottom
      splitright = true;
      splitbelow = true;

      # Statusline & winbar customization
      # Global statusline at the bottom instead of one for each window
      laststatus = 3;
      winbar = "%=%m\ %f"; # " %m %=%l:%v ";
      fsync = true;
    };

    commands = {
      # "SpellFr" = "setlocal spelllang=fr";
    };

    ### MAPPINGS ###
    keymaps = let
      modeKeys = mode:
        lib.attrsets.mapAttrsToList (key: action: {
          inherit key action mode;
        });
      nm = modeKeys ["n"];
      vs = modeKeys ["v"];
    in
      helpers.keymaps.mkKeymaps {options.silent = true;} (nm {
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
        "<C-s>" = "<cmd>Telescope current_buffer_fuzzy_find<CR>";

        # Telescope w/ git
        "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
        "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
        "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
        "<leader>fvs" = "<cmd> Telescope git_status<CR>";
        "<leader>fvx" = "<cmd> Telescope git_stash<CR>";

        # Git
        "<leader>gg" = ":Neogit cwd=~/config/<CR>";
        "<leader>gG" = ":Neogit cwd=~/nix-config/<CR>";
        "<leader>g." = ":Neogit cwd=./<CR>";

        # LSP
        "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
        "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";

        "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
        "<leader>fli" = "<cmd> Telescope lsp_implementations<CR>";
        "<leader>flD" = "<cmd> Telescope lsp_definitions<CR>";
        "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
        "<leader>fld" = "<cmd> Telescope diagnostics<CR>";

        "gr" = "<cmd>Telescope lsp_references<CR>";
        "gI" = "<cmd>Telescope lsp_implementations<CR>";
        "gW" = "<cmd>Telescope lsp_workspace_symbols<CR>";
        "gF" = "<cmd>Telescope lsp_document_symbols<CR>";
        "ge" = "<cmd>Telescope diagnostics bufnr=0<CR>";
        "gE" = "<cmd>Telescope diagnostics<CR>";

        # Terminal
        "<leader>s" = ":ToggleTerm<CR>";

        "mk" = "<cmd>Telescope keymaps<CR>";

        # Lsp
        "<C-c>!l" = "<cmd>TroubleToggle<CR>";
        "<leader>gd" = "<cmd>Trouble lsp_definitions<CR>";
        "<leader>gr" = "<cmd>Trouble lsp_references<CR>";

        # Buffers
        "<M-[>" = "<cmd>bprevious<CR>";
        "<M-]>" = "<cmd>bnext<CR>";

        # Splitting & Window managment
        "<leader>v" = "<cmd>vsplit<CR>";
        "<leader>h" = "<cmd>split<CR>";
        "<leader>x" = "<cmd>only<CR>"; # close all but current window (in a single tab, aka close all other splits)
        "<C-M-k>" = "<cmd>bufdo bwipeout<CR>"; # close all buffers opened
        "<leader>z" = "<cmd>bdelete<CR>"; # close focused window/buffer
      })
      ++ (vs {
        "<leader>zf" = "'<,'>ZkMatch<CR>";
      })
      ++ [
        {
          key = "<leader>rn";
          mode = ["n"];
          action = ''
            function()
            	return ":IncRename " .. vim.fn.expand("<cword>")
            end
          '';
          lua = true;
          options.expr = true;
        }
      ];

    # Neovim Editor Config support
    editorconfig.enable = true;

    extraConfigLuaPre = ''
      -- [options setup] --
      local au = vim.api.nvim_create_augroup('restore_on_exit.augroup', { clear = true })
      vim.api.nvim_create_autocmd({ 'VimLeave'}, {
      		group = au,
      		command = "set guicursor=a:ver25-Cursor"
      })

      -- [nvim-cmp extra setup] --
      local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- [luasnip extra setup] --
      local luasnip = require("luasnip")

      require'neodev'.setup({})

      -- [Web Dev Icons setup] --
      require'nvim-web-devicons'.setup({})

      -- [Lsp logging setup] --
      -- Disable logging
      vim.lsp.set_log_level("off") -- change to debug only for testing
    '';

    # Plugins setup
    plugins = {
      ### Theming ###

      # Current favourite theme
      nightfox.enable = true;

      # Current favourite status line
      staline.enable = true;

      # Ui replacement for messages, cmdline and the popupmenu
      noice = {
        enable = true;

        messages = {
          view = "notify";
          viewError = "notify";
          viewWarn = "notify";
          viewHistory = "messages";
          viewSearch = "virtualtext";
        };

        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        presets = {
          # bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
          lsp_doc_border = false;
        };

        notify = {
          enabled = true;
          view = "notify";
        };
      };

      # Needed for noice
      notify = {
        enable = true;
        timeout = 1000;
        stages = "static"; # slide, fade, fade_in_slide_out (default)
      };

      # Fuzzy finder w/ custom config
      telescope = {
        enable = true;
        defaults = {
          layout_config = {
            prompt_position = "bottom";
            horizontal = {
              width_padding = 0.9;
              height_padding = 0.1;
              preview_width = 0.6;
            };
            vertical = {
              width_padding = 0.05;
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
          prompt_prefix = "🔍 "; # -- 
          selection_caret = " ";
          vimgrep_arguments = [
            "${pkgs.ripgrep}/bin/rg"
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
          ];
          pickers = {
            find_command = "${pkgs.fd}/bin/fd";
          };
        };
      };

      which-key.enable = true;

      ### Code support ###
      neodev.enable = true;
      lsp = {
        enable = true;
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
          clangd.enable = true;
          bashls.enable = true;
          gopls.enable = true;
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
          nil_ls = {
            enable = true;
            settings = {
              formatting.command = ["alejandra" "--quiet"];
            };
          };
        };
      };

      efmls-configs = {
        enable = true;

        setup = {
          # all.linter = "vale";
          sh.formatter = "shfmt";
          bash.formatter = "shfmt";
          c.linter = "cppcheck";
          go.formatter = "gofmt";
          go.linter = "golint";
          markdown.formatter = "cbfmt";
          python.formatter = "black";

          nix.linter = "statix";
          lua.formatter = "stylua";
          json.formatter = "prettier";
          css.formatter = "prettier";
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

      lspkind = {
        enable = true;
        cmp.enable = true;
      };

      # VSCode bulb for neovim's built-in LSP.
      # nvim-lightbulb = {
      #   enable = true;
      #   autocmd.enabled = true;
      # };

      inc-rename.enable = true;

      # Treesitter
      treesitter = {
        enable = true;
        indent = true;

        incrementalSelection = {
          enable = true;
          keymaps = {
            initSelection = "gnn";
            nodeIncremental = "grn";
            scopeIncremental = "grc";
            nodeDecremental = "grm";
          };
        };

        grammarPackages = with config.plugins.treesitter.package.passthru.builtGrammars; [
          arduino
          c
          cpp
          tlaplus # Low level programming
          rust
          lalrpop # Rust
          bash
          regex # Scripting
          dart
          devicetree
          dockerfile
          gitattributes
          gitcommit
          gitignore
          git_rebase
          diff # Git related
          # File type specific
          ini
          json
          toml
          yaml

          latex
          lua
          markdown
          markdown_inline
          rst # Markup Langs
          make
          meson
          ninja # Building SW
          nix
          python
          slint
          sql

          vim
          vimdoc
          html
          javascript
          css

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
        smartRename.enable = true;
        navigation.enable = true;
      };

      treesitter-context.enable = true;

      # Diagnostics, references, telescope results, quickfix and location list
      trouble = {
        enable = true;
        icons = true;
        position = "bottom";
        # icons / text used for a diagnostic
        signs = {
          error = "";
          warning = "";
          hint = "";
          information = "";
          other = "";
        };
      };

      fidget.enable = true;

      toggleterm = {
        enable = true;
        direction = "horizontal";
        floatOpts = {
          border = "curved"; # other options -> single, double, shadow
          winblend = 3;
        };
      };

      cursorline = {
        enable = true;
        cursorword = {
          enable = true;
          minLength = 3;
          hl = {
            underline = true;
          };
        };
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
      nvim-autopairs.enable = true;

      # Highlight TODO keywords
      todo-comments.enable = true;

      # Comments on steroid
      comment-nvim = {
        enable = true;
        # Add a space b/w comment and the line
        padding = true;
        # Whether the cursor should stay at its position
        sticky = true;
      };

      # File Tree
      nvim-tree = {
        enable = true;
        autoReloadOnWrite = true;
        hijackNetrw = true;
        actions = {
          openFile = {
            quitOnOpen = true;
          };
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

        systemOpen = {
          cmd = "${pkgs.xdg-utils}/bin/xdg-open";
        };

        diagnostics = {
          enable = true;
          showOnDirs = true;
          debounceDelay = 100;
          severity = {
            min = "warn";
          };
        };
        selectPrompts = true;
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
          {name = "luasnip";}
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
      };

      ### Git ###
      gitsigns.enable = true;
      gitmessenger.enable = true;

      # Magit port for neovim
      neogit = {
        enable = true;
        disableCommitConfirmation = true;
        useMagitKeybindings = true;
      };

      ### Snippets ###
      luasnip.enable = true;
    };

    filetype = {
      filename = {
        Jenkinsfile = "groovy";
      };
      extension = {
        lalrpop = "lalrpop";
      };
    };

    extraConfigLuaPost = ''
      require("luasnip.loaders.from_snipmate").lazy_load()
    '';

    extraPlugins = with pkgs.vimPlugins; [
      telescope-ui-select-nvim
      markdown-preview-nvim
    ];
  };
}
