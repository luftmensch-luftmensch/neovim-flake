{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.terminal;
in {
  options.vim.terminal = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable terminal inside neovim with toggleterm";
    };

    position = mkOption {
      default = "horizontal";
      description = "Position of current terminal";
      type = types.enum ["vertical" "horizontal" "tab" "float"];
    };

    floatOptions = {
      border = mkOption {
        default = "curved";
        description = "Border type";
        type = types.enum ["curved" "single" "double" "shadow"];
      };
      
    };



  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["toggleterm"];

    vim.nnoremap = {
      "<leader>s" = ":ToggleTerm<CR>";
    };

    vim.luaConfigRC.nvimtoogletre = nvim.dag.entryAnywhere ''
      require("toggleterm").setup{
        direction = ${"'" + cfg.position + "'"},

        float_opts = {
          -- The border key is *almost* the same as 'nvim_open_win'
          -- see :h nvim_open_win for details on borders however
          -- the 'curved' border is a custom border type
          -- not natively supported but implemented in this plugin.
          border = "${cfg.floatOptions.border}", -- other options supported by win open
          --width = 80,
          --height = 20,
          winblend = 3,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      }
    '';
  };
}
