{
  config = {
    viAlias = true;
    vimAlias = true;

    extraConfigLuaPre = ''
      vim.fn.sign_define("diagnosticsignerror", { text = " ", texthl = "diagnosticerror", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignwarn", { text = " ", texthl = "diagnosticwarn", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignhint", { text = "󰌵", texthl = "diagnostichint", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsigninfo", { text = " ", texthl = "diagnosticinfo", linehl = "", numhl = "" })
    '';

    # clipboard.providers.wl-copy.enable = true;

    opts = {
      # Show line numbers
      number = true;

      # Show relative line numbers
      relativenumber = true;

      # Use the system clipboard
      clipboard = "unnamedplus";

      # Number of spaces that represent a <TAB>
      tabstop = 2;
      softtabstop = 2;

      # Show tabline always
      showtabline = 2;

      # Use spaces instead of tabs
      expandtab = false;

      # Adaptive (Tab or spaces)
      smarttab = false;

      # Enable smart indentation
      smartindent = true;

      # Number of spaces to use for each step of (auto)indent
      shiftwidth = 2;

      # Even number of shift
      shiftround = true;

      # Enable break indent
      breakindent = true;

      # Highlight the screen line of the cursor
      cursorline = true;

      # Minimum number of screen lines to keep above and below the cursor
      scrolloff = 7;

      # Enable mouse support
      mouse = "a";

      # Set folding method to manual
      foldmethod = "manual";

      # Disable folding by default
      foldenable = false;

      # Wrap long lines at a character in 'breakat'
      linebreak = true;

      # Disable spell checking
      spell = false;

      # Disable swap file creation
      swapfile = false;
      backup = false;
      writebackup = false;
      laststatus = 3;

      timeout = true;
      # Time in milliseconds to wait for a mapped sequence to complete
      timeoutlen = 300;

      # Enable 24-bit RGB color in the TUI
      termguicolors = true;

      # Don't show mode in the command line
      showmode = false;

      # Open new split below the current window
      splitbelow = true;

      # Keep the screen when splitting
      splitkeep = "screen";

      # Open new split to the right of the current window
      splitright = true;

      # Hide command line unless needed
      cmdheight = 0;

      # Remove EOB
      fillchars.eob = " ";

      list = true;

      listchars = {
        tab = "» ";
        trail = "·";
        nbsp = "␣";
      };
    };

    autoGroups = {
      highlight_yank = { };
      vim_enter = { };
      indentscope = { };
      restore_cursor = { };
      big_file_optimizer = { };
    };

    autoCmd = [

      {
        event = "VimLeave";
        command = "set guicursor=a:ver25-Cursor";
      }

      # Stolen from kickstarter.nvim
      {
        event = "TextYankPost";
        group = "highlight_yank";
        desc = "Highlight when yanking text";
        pattern = "*";
        callback.__raw = "function() vim.highlight.on_yank() end";
      }
      {
        group = "vim_enter";
        event = [ "VimEnter" ];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              vim.cmd('Startup')
            end
          '';
        };
      }
      {
        group = "indentscope";
        event = [ "FileType" ];
        pattern = [
          "help"
          "Startup"
          "startup"
          "neo-tree"
          "Trouble"
          "trouble"
          "notify"
        ];
        callback = {
          __raw = ''
            function()
              vim.b.miniindentscope_disable = true
            end
          '';
        };
      }

      # from NVChad https://nvchad.com/docs/recipes (this autocmd will restore the cursor position when opening a file)
      {
        group = "restore_cursor";
        event = [ "BufReadPost" ];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              if
                vim.fn.line "'\"" > 1
                and vim.fn.line "'\"" <= vim.fn.line "$"
                and vim.bo.filetype ~= "commit"
                and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
              then
                vim.cmd "normal! g`\""
              end
            end
          '';
        };
      }

      # Stolen from traxys
      {
        event = "BufReadPost";
        pattern = [
          "*.md"
          "*.rs"
          "*.lua"
          "*.sh"
          "*.bash"
          "*.zsh"
          "*.js"
          "*.jsx"
          "*.ts"
          "*.tsx"
          "*.c"
          ".h"
          "*.cc"
          ".hh"
          "*.cpp"
          "*.nix"
        ];

        group = "big_file_optimizer";
        callback = {
          __raw = ''
            function(auEvent)
              local bufferCurrentLinesCount = vim.api.nvim_buf_line_count(0)

              if bufferCurrentLinesCount > 2048 then
                vim.notify("bigfile: disabling features", vim.log.levels.WARN)

                vim.cmd("TSBufDisable refactor.highlight_definitions")
                vim.g.matchup_matchparen_enabled = 0
                require("nvim-treesitter.configs").setup({
                  matchup = {
                    enable = false
                  }
                })
              end
            end
          '';
        };
      }
    ];

    # performance = {
    #   byteCompileLua = {
    #     enable = true;
    #     nvimRuntime = true;
    #     configs = true;
    #     plugins = true;
    #   };
    #   combinePlugins.standalonePlugins = [ "nvim-cmp" ];
    # };

  };
}
