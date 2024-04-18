{
  lib,
  pkgs,
  config,
  helpers,
  ...
}: {
  config = {
    autoGroups.nvim-highlight-yank.clear = true;
    autoCmd = [
      {
        event = "VimLeave";
        command = "set guicursor=a:ver25-Cursor";
      }

      # Stolen from kickstarter.nvim
      {
        event = "TextYankPost";
        desc = "Highlight when yanking text";
        callback.__raw = "function() vim.highlight.on_yank() end";
        group = "nvim-highlight-yank";
      }
    ];

    # Global values
    globals = {
      mapleader = " ";
      maplocalleader = " ";
      nvim_tree_disable_default_keybindings = 1;
    };

    # Custom option
    opts = {
      # True color support
      termguicolors = true;

      number = true;
      relativenumber = true;
      showmode = false;
      title = true;
      breakindent = true;

      # tabstop = 2;
      # shiftwidth = 2;
      # softtabstop = 2;
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
      hlsearch = true;
      # When and how to draw the signcolumn. (yes to set to always)
      signcolumn = "yes";

      # Number of screen lines to use for the command-line. (Disabled as we are going to use Noice folke plugin)
      cmdheight = 1;

      cot = ["menu" "menuone" "noselect"];
      updatetime = 500;
      spell = true;
      colorcolumn = "100";
      list = true;
      listchars = {
        tab = "» ";
        trail = "·";
        nbsp = "␣";
      };
      timeout = true;
      timeoutlen = 300;
      clipboard = "unnamedplus";
      mouse = "a";

      swapfile = false;
      backup = false;
      writebackup = false;
      splitright = true;
      splitbelow = true;
      laststatus = 3;
      winbar = "%=%m\ %f"; # " %m %=%l:%v ";
      fsync = true;
    };

    ### MAPPINGS ###
    keymaps = let
      modeKeys = mode: lib.attrsets.mapAttrsToList (key: action: {inherit key action mode;});
      nm = modeKeys ["n"];
      # vs = modeKeys ["v"];
    in
      helpers.keymaps.mkKeymaps {options.silent = true;} (nm {
        "<Esc>" = "<cmd>nohlsearch<CR>";
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

        # Git
        "<leader>gg" = ":Neogit cwd=~/config/<CR>";
        "<leader>gG" = ":Neogit cwd=~/nix-config/<CR>";
        "<leader>g." = ":Neogit cwd=./<CR>";

        # Terminal
        "<leader>s" = ":ToggleTerm<CR>";

        # Lsp
        "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
        "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";

        "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
        "<leader>fli" = "<cmd> Telescope lsp_implementations<CR>";
        "<leader>flD" = "<cmd> Telescope lsp_definitions<CR>";
        "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
        "<leader>fld" = "<cmd> Telescope diagnostics<CR>";

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

        # Buffers
        "<M-[>" = "<cmd>bprevious<CR>";
        "<M-]>" = "<cmd>bnext<CR>";

        # Splitting & Window managment
        "<leader>v" = "<cmd>vsplit<CR>";
        "<leader>h" = "<cmd>split<CR>";
        "<leader>x" = "<cmd>only<CR>"; # close all but current window (in a single tab, aka close all other splits)
        "<C-M-k>" = "<cmd>bufdo bwipeout<CR>"; # close all buffers opened
        "<leader>z" = "<cmd>bdelete<CR>"; # close focused window/buffer
        # Keybinds to make split navigation easier
        "<C-h>" = "<C-w><C-h>";
        "<C-j>" = "<C-w><C-j>";
        "<C-k>" = "<C-w><C-k>";
        "<C-l>" = "<C-w><C-l>";

        # mini-nvim
        "<leader>M" = "<cmd>lua MiniMap.toggle()<CR>";
      });

    editorconfig.enable = true;

    extraConfigLuaPre = ''
      -- [nvim-cmp extra setup] --
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- [Lsp logging setup] --
      -- Disable logging
      -- vim.lsp.set_log_level("off") -- change to debug only for testing
    '';

    colorschemes.moonfly.enable = true;

    # Plugins setup
    plugins = {
      lualine = {
        enable = true;
        iconsEnabled = true;
        globalstatus = true;
        extensions = lib.optionals config.plugins.nvim-tree.enable ["nvim-tree"];
        ignoreFocus = lib.optionals config.plugins.nvim-tree.enable ["NvimTree"];
      };

      # Ui replacement for messages, cmdline and the popupmenu
      noice = {
        enable = true;
        messages = rec {
          view = "notify";
          viewError = view;
          viewWarn = view;
          viewHistory = "messages";
          viewSearch = "virtualtext";
        };

        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        presets = {
          command_palette = true;
          long_message_to_split = true;
          lsp_doc_border = false;
        };

        notify = {
          enabled = true;
          view = "notify";
        };
      };

      notify = {
        enable = true;
        timeout = 1000;
        stages = "static";
      };

      mini = {
        enable = true;
        modules = {
          # Visual enhancment (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md)
          ai = {};
          # Interactive alignment (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md)
          align = {};
          # Enhanced surrounding (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md)
          surround = {};
          # Minimap
          map = {};
          # Enhanced commenting - Alternative to https://github.com/numToStr/Comment.nvim
          comment = {};
        };
      };

      silicon = {
        enable = true;
        flavour = "Monokai Extended Origin";
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

          prompt_prefix = "🔍 ";
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
          pickers.find_command = "${pkgs.fd}/bin/fd";
        };
      };

      which-key = {
        enable = true;
        window = {
          border = "rounded";
          margin = {
            top = 1;
            bottom = 1;
            left = 1;
            right = 1;
          };
        };
      };

      ### Code support ###
      neodev.enable = true;
      cloak.enable = true;

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

        servers = {
          clangd.enable = true;
          bashls.enable = true;
          gopls.enable = true;
          dartls.enable = true;
          efm = {
            enable = true;
            extraOptions.init_options.documentFormatting = true;
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
          nil_ls = {
            enable = true;
            settings.formatting.command = ["alejandra" "--quiet"];
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

      # Treesitter
      treesitter = {
        enable = true;
        indent = true;
        nixvimInjections = true;

        grammarPackages = with config.plugins.treesitter.package.passthru.builtGrammars;
          [c cpp dart lua nix python sql]
          ++ [vim vimdoc]
          ++ [gitattributes gitcommit gitignore git_rebase]
          ++ [bash regex dockerfile diff latex]
          ++ [make meson ninja]
          ++ [markdown markdown_inline rst]
          ++ [ini json toml yaml]
          ++ [html javascript css];
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

      # Disabled it as I found it pretty annoying
      treesitter-context.enable = false;

      # Diagnostics, references, telescope results, quickfix and location list
      trouble = {
        enable = true;
        settings = {
          icons = true;
          position = "bottom";
          signs = {
            error = "";
            warning = "";
            hint = "";
            information = "";
            other = "";
          };
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
        treesitterIntegration = {
          enable = true;
          includeMatchWords = true;
        };
      };

      # Autopairs
      nvim-autopairs.enable = true;

      # Comments on steroid
      todo-comments.enable = true;

      conform-nvim = {
        enable = true;
        notifyOnError = false;
        formatOnSave = {
          timeoutMs = 500;
          lspFallback = true;
        };

        # Map of filetype to formatters
        formattersByFt = {
          lua = ["stylua"];
          # Conform will run multiple formatters sequentially
          python = ["isort" "black"];
          # Use a sub-list to run only the first available formatter
          javascript = [["prettierd" "prettier"]];
          # Use the "*" filetype to run formatters on all filetypes.
          "*" = ["codespell"];
          # Use the "_" filetype to run formatters on filetypes that don't
          # have other formatters configured.
          "_" = ["trim_whitespace"];
        };
      };

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

      ### Completion ###
      cmp = {
        enable = true;

        settings = {
          mapping = {
            "<CR>" = "cmp.mapping.confirm({select = true })";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
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
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "path";}
            {name = "buffer";}
          ];
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
      };

      # Git integration for buffers
      gitsigns = {
        enable = true;
        settings = {
          trouble = config.plugins.trouble.enable;
          current_line_blame = false;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 200;
            ignoreWhitespace = false;
          };
          current_line_blame_formatter_nc = "   <author> | <author_time:%h %d, %Y> | <summary>";
        };
      };

      # Reveal the commit messages under the cursor
      gitmessenger.enable = true;

      # Magit port for neovim
      neogit = {
        enable = true;
        settings = {
          auto_refresh = true;
          disable_commit_confirmation = true;
          use_magit_keybindings = true;
          commit_popup.kind = "split";
        };
      };

      ### Snippets ###
      luasnip.enable = true;

      alpha = {
        enable = true;
        layout = [
          {
            type = "padding";
            val = 10;
          }
          {
            opts = {
              hl = "Type";
              position = "center";
            };
            type = "text";
            val = [
              "                                                                       "
              "                                                                     "
              "       ████ ██████           █████      ██                     "
              "      ███████████             █████                             "
              "      █████████ ███████████████████ ███   ███████████   "
              "     █████████  ███    █████████████ █████ ██████████████   "
              "    █████████ ██████████ █████████ █████ █████ ████ █████   "
              "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
              " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
              "                                                                       "
              "                                                                       "
              "                                                                       "
            ];
          }
        ];
      };
    };

    extraConfigLuaPost = ''
      require("luasnip.loaders.from_snipmate").lazy_load()
    '';

    extraPlugins = with pkgs.vimPlugins; [telescope-ui-select-nvim markdown-preview-nvim];
    extraPackages = with lib;
    with config.plugins;
      (optionals lsp.enable (with pkgs; [fswatch cppcheck nodePackages.bash-language-server]))
      ++ (optionals conform-nvim.enable (with pkgs; [codespell isort prettierd]));
    # extraPackages = with pkgs;
    #   []
    #   ++ lib.optionals config.plugins.conform-nvim.enable (with pkgs; [codespell isort prettierd]);
  };
}
