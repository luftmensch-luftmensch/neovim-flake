{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.nvimTreeLua;
in {
  options.vim.nvimTreeLua = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable nvim-tree-lua";
    };

    autoReloadOnWrite = mkEnableOption "Auto reload on write";

    treeSide = mkOption {
      default = "left";
      description = "Side the tree will appear on left or right";
      type = types.enum ["left" "right"];
    };

    treeWidth = mkOption {
      default = 25;
      description = "Width of the tree in charecters";
      type = types.int;
    };

    hideFiles = mkOption {
      default = [".git" "node_modules" ".cache"];
      description = "Files to hide in the file view by default.";
      type = with types; listOf str;
    };

    hideIgnoredGitFiles = mkOption {
      default = false;
      description = "Hide files ignored by git";
      type = types.bool;
    };

    openOnSetup = mkOption {
      default = false;
      description = "Open when vim is started on a directory";
      type = types.bool;
    };

    closeOnLastWindow = mkOption {
      default = true;
      description = "Close when tree is last window open";
      type = types.bool;
    };

    ignoreFileTypes = mkOption {
      default = [];
      description = "Ignore file types";
      type = with types; listOf str;
    };

    closeOnFileOpen = mkOption {
      default = false;
      description = "Closes the tree when a file is opened.";
      type = types.bool;
    };

    resizeOnFileOpen = mkOption {
      default = false;
      description = "Resizes the tree when opening a file.";
      type = types.bool;
    };

    followBufferFile = mkOption {
      default = true;
      description = "Follow file that is in current buffer on tree";
      type = types.bool;
    };

    indentMarkers = mkOption {
      default = true;
      description = "Show indent markers";
      type = types.bool;
    };

    hideDotFiles = mkOption {
      default = false;
      description = "Hide dotfiles";
      type = types.bool;
    };

    openOnNewTab = mkOption {
      default = false;
      description = "Opens the tree view when opening a new tab";
      type = types.bool;
    };

    disableNetRW = mkOption {
      default = false;
      description = "Disables netrw and replaces it with tree";
      type = types.bool;
    };

    hijackNetRW = mkOption {
      default = true;
      description = "Prevents netrw from automatically opening when opening directories";
      type = types.bool;
    };

    trailingSlash = mkOption {
      default = true;
      description = "Add a trailing slash to all folders";
      type = types.bool;
    };

    groupEmptyFolders = mkOption {
      default = true;
      description = "Compact empty folders trees into a single item";
      type = types.bool;
    };

    lspDiagnostics = mkOption {
      default = true;
      description = "Shows lsp diagnostics in the tree";
      type = types.bool;
    };

    systemOpenCmd = mkOption {
      default = "${pkgs.xdg-utils}/bin/xdg-open";
      description = "The command used to open a file with the associated default program";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["nvim-tree-lua"];

    vim.nnoremap = {
      "<leader>e" = ":NvimTreeToggle<CR>";
      "<leader>tr" = ":NvimTreeRefresh<CR>";
      "<leader>tf" = ":NvimTreeFocus<CR>";
    };

    vim.luaConfigRC.nvimtreelua = nvim.dag.entryAnywhere ''
      -- [nvim-tree setup] --

      vim.g.nvim_tree_disable_default_keybindings = 1
      require("nvim-tree").setup({
        auto_reload_on_write = ${boolToString cfg.autoReloadOnWrite},
        disable_netrw = ${boolToString cfg.disableNetRW},
        hijack_netrw = ${boolToString cfg.hijackNetRW},
        open_on_tab = ${boolToString cfg.openOnNewTab},
        open_on_setup = ${boolToString cfg.openOnSetup},
        open_on_setup_file = ${boolToString cfg.openOnSetup},
        system_open = {
          cmd = ${"'" + cfg.systemOpenCmd + "'"},
        },
        diagnostics = {
          enable = ${boolToString cfg.lspDiagnostics},
        },
        view  = {
          width = ${toString cfg.treeWidth},
          side = ${"'" + cfg.treeSide + "'"},

          mappings = {

            -- Unset default keybindings
            custom_only = true,

            list = {
              { key = "h", action = "dir_up" },
              { key = "l", action = "cd" },
              { key = "q", action = "close" },
              { key = "g?", action = "toggle_help" },
              { key = "<S-Tab>", action = "collapse_all" },
              { key = "<C-k>", action = "toggle_file_info" },
              { key = "y", action = "copy_name" },
              { key = "Y", action = "copy_path" },
              { key = "gy", action = "copy_absolute_path" },
              { key = "s", action = "system_open" },
              { key = "R", action = "refresh" },
              { key = "a", action = "create" },
              { key = "d", action = "remove" },
              { key = "D", action = "trash" },
              { key = "r", action = "rename" },
              { key = "<C-r>", action = "full_rename" },
              { key = "c", action = "copy" },
              { key = "p", action = "paste" },
              { key = "<Tab>", action = "preview" },
            },
        },
        },
        renderer = {
          indent_markers = {
            enable = ${boolToString cfg.indentMarkers},
          },
          add_trailing = ${boolToString cfg.trailingSlash},
          group_empty = ${boolToString cfg.groupEmptyFolders},
        },
        actions = {
          open_file = {
            quit_on_open = ${boolToString cfg.closeOnFileOpen},
            resize_window = ${boolToString cfg.resizeOnFileOpen},
          },
        },
        git = {
          enable = true,
          ignore = ${boolToString cfg.hideIgnoredGitFiles},
        },
        filters = {
          dotfiles = ${boolToString cfg.hideDotFiles},
          custom = {
            ${builtins.concatStringsSep "\n" (builtins.map (s: "\"" + s + "\",") cfg.hideFiles)}
          },
        },
      })
    '';
  };
}
