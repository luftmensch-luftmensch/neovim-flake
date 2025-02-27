{
  config = {
    globals = {
      # Disable useless providers
      loaded_ruby_provider = 0; # Ruby
      loaded_perl_provider = 0; # Perl
      loaded_python_provider = 0; # Python 2
    };

    viAlias = true;
    vimAlias = true;

    extraConfigLuaPre = ''
      vim.fn.sign_define("diagnosticsignerror", { text = " ", texthl = "diagnosticerror", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignwarn", { text = " ", texthl = "diagnosticwarn", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignhint", { text = "󰌵", texthl = "diagnostichint", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsigninfo", { text = " ", texthl = "diagnosticinfo", linehl = "", numhl = "" })
    '';

    # Use system clipboard
    clipboard.register = "unnamedplus";

    opts = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers

      tabstop = 2; # Number of spaces that represent a <TAB>
      softtabstop = 2;
      showtabline = 2; # Show tabline always

      expandtab = false; # Use spaces instead of tabs
      smarttab = false; # Adaptive (Tab or spaces)
      smartindent = true; # Enable smart indentation

      shiftwidth = 2; # Number of spaces to use for each step of (auto)indent
      shiftround = true; # Even number of shift

      breakindent = true; # Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)

      hlsearch = true;
      incsearch = true;
      ignorecase = true;
      smartcase = true; # Don't ignore case with capitals

      cursorline = true; # Highlight the screen line of the cursor

      scrolloff = 7; # Minimum number of screen lines to keep above and below the cursor
      mouse = "a"; # Enable mouse support

      # foldmethod = "manual"; # Set folding method to manual
      # foldenable = false; # Disable folding by default

      # These options were recommended by nvim-ufo
      # See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
      foldcolumn = "auto";
      foldenable = true;
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldminlines = 1;
      foldnestmax = 3;
      foldlevel = 99;

      linebreak = true; # Wrap long lines at a character in 'breakat'

      spell = false; # Disable spell checking

      swapfile = false;
      backup = false;
      writebackup = false;
      laststatus = 3;

      timeout = true;

      timeoutlen = 300; # Time in milliseconds to wait for a mapped sequence to complete

      termguicolors = true; # Enable 24-bit RGB color in the TUI
      showmode = false; # Don't show mode in the command line

      splitbelow = true; # Open new split below the current window
      splitright = true; # Open new split to the right of the current window
      splitkeep = "screen"; # Keep the screen when splitting

      cmdheight = 0; # Hide command line unless needed

      fillchars.eob = " "; # Remove EOB

      list = true;

      listchars = {
        tab = "» ";
        trail = "·";
        nbsp = "␣";
      };

      encoding = "utf-8";
      fileencoding = "utf-8";
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
