{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.colorschemes.moonfly.enable = mkEnableOption "A dark charcoal theme for modern Neovim & classic Vim";

  config =
    let
      cfg = config.colorschemes.moonfly;
    in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [ vim-moonfly-colors ];

      extraConfigLua = ''
        -- Enable transparency
        vim.g.moonflyTransparent = true
        -- Underline matching parentheses
        vim.g.moonflyUnderlineMatchParen = true
        -- Display diagnostic virtual text in color
        vim.g.moonflyVirtualTextColor = true
        -- Win separator (line)
        vim.g.moonflyWinSeparator = 2
        vim.opt.fillchars = { horiz = '━', horizup = '┻', horizdown = '┳', vert = '┃', vertleft = '┫', vertright = '┣', verthoriz = '╋', }
        vim.cmd([[colorscheme moonfly]])
      '';
    };
}
