{lib}:
with lib; let
  # Plugin must be same as input name
  availablePlugins = [
    # GIT
    "git-messenger"
    "neogit"

    "plenary-nvim"

    # LSP + TREESITTER
    "nvim-lspconfig"
    "lspsaga"
    "lspkind"
    "nvim-fidget"
    "nvim-lightbulb"
    "lsp-signature"
    "inc-rename"
    "nvim-treesitter"
    "nvim-treesitter-context"

    "clangd_extensions"

    # Comments
    "todo-comments"

    # BUFFERS + TREE
    "nvim-tree-lua"
    "bufferline"

    # STATUSLINE
    "lualine"

    # COMPLETION
    "nvim-compe"
    "nvim-autopairs"
    "nvim-ts-autotag"
    "nvim-web-devicons"
    "bufdelete-nvim"
    "nvim-cmp"
    "cmp-nvim-lsp"
    "cmp-buffer"
    "cmp-vsnip"
    "cmp-path"
    "cmp-treesitter"
    "crates-nvim"
    "vim-vsnip"

    # CODE ACTIONS
    "nvim-code-action-menu"
    "trouble"
    "null-ls"

    # SUGGESTION
    "which-key"
    "indent-blankline"
    "nvim-cursorline"

    # TELESCOPE
    "telescope"

    # THEMES
    "nightfox"
    #"onedark"
    #"moonfly"
    
    # Dashboard
    "dashboard-nvim"

    # TERMINAL
    "toggleterm"

  ];

  pluginsType = with types; listOf (nullOr (either (enum availablePlugins) package));
in {
  pluginsOpt = {
    description,
    default ? [],
  }:
    mkOption {
      inherit description default;
      type = pluginsType;
    };
}
