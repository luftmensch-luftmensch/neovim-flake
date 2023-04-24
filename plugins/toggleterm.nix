{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.toggleterm = {
    enable = mkEnableOption "Enable terminal inside neovim with toggleterm";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.toggleterm-nvim;
      description = "Package to use for telescope";
    };
  };

  config = let
    cfg = config.plugins.toggleterm;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
      -- [toggleterm setup] --

      require("toggleterm").setup{
        direction = "horizontal",

        float_opts = {
          -- The border key is *almost* the same as 'nvim_open_win'
          -- see :h nvim_open_win for details on borders however
          -- the 'curved' border is a custom border type
          -- not natively supported but implemented in this plugin.
          border = "curved", -- other options -> single, double, shadow
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
