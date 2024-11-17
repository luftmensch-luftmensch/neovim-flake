{
  config,
  helpers,
  ...
}:
{
  config = {
    autoGroups = {
      nvim-highlight-yank.clear = true;
      BigFileOptimizer = { };
    };
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
        group = "BigFileOptimizer";
        callback = helpers.mkRaw ''
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
      }

    ];

    viAlias = true;
    vimAlias = true;

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

      cot = [
        "menu"
        "menuone"
        "noselect"
      ];
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

    editorconfig.enable = true;

    performance = {
      byteCompileLua = {
        enable = true;
        nvimRuntime = true;
        configs = true;
        plugins = true;
      };
      combinePlugins.standalonePlugins = [ "nvim-cmp" ];
    };
  };
}
