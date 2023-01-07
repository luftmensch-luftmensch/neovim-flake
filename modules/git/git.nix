{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.git;
in {
  options.vim.git = {
    enable = mkOption {
      type = types.bool;
      description = "Enable git plugins";
    };

    neogit        = mkEnableOption "Enable neogit";
    git-messenger = mkEnableOption "Enable git messenger";
  };

  config =
    mkIf cfg.enable
    (
      let
        writeIf = cond: msg: if cond then msg else "";
        mkVimBool = val:
          if val
          then "1"
          else "0";
      in {
        vim.startPlugins =
          [
            (if cfg.git-messenger then "git-messenger" else null)
            (if cfg.neogit then "neogit" else null)
          ];

        vim.nnoremap =  {
          "<leader>g?" = ":GitMessenger<CR>";
          "<leader>gg" = ":Neogit cwd=~/config/<CR>";
          "<leader>gG" = ":Neogit cwd=~/Nixos/<CR>";
        };

        vim.luaConfigRC.gitsigns = nvim.dag.entryAnywhere ''
            -- [neogit setup] --
            local neogit = require('neogit')
        '';
      }
    );
}
