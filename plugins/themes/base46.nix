{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.colorschemes.base46 = {
    enable = mkEnableOption "A dark charcoal theme for modern Neovim & classic Vim";
		variant = types.nullOr (types.enum ["tomorrow_night" "rosepine"]);
  };

  config = let
    cfg = config.colorschemes.base46;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [base46];

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
