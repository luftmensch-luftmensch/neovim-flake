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

  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["toggleterm"];

    vim.nnoremap = {
      "<leader>s" = ":ToggleTerm<CR>";
    };

    vim.luaConfigRC.nvimtoogletre = nvim.dag.entryAnywhere ''
      require("toggleterm").setup{
        direction = ${"'" + cfg.position + "'"}
      }
    '';
  };
}
