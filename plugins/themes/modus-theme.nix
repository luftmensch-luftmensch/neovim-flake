{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
with lib;
let
  # cfg = config.plugins.colorscheme.modus-theme;
  flavours = [
    "modus_vivendi"
    "modus_operandi"
  ];
in

{
  options.plugins.colorscheme.modus-theme = {
    enable = mkEnableOption "A highly customizable theme for vim";
    flavour = helpers.defaultNullOpts.mkEnumFirstDefault flavours "Theme flavour";
  };

  config = let
    cfg = config.plugins.colorscheme.modus-theme;

  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [modus-theme];
      extraConfigLua = ''
      require("modus-themes").setup({
        -- Theme comes in two styles `modus_operandi` and `modus_vivendi`
        -- `auto` will automatically set style based on background set with vim.o.background
        style = "${cfg.flavour}",
        variant = "default", -- Theme comes in four variants `default`, `tinted`, `deuteranopia`, and `tritanopia`
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          functions = { italic = true },
          variables = {},
                                                                                                  },

        --- You can override specific color groups to use other groups or a hex color
        --- function will be called with a ColorScheme table
        ---@param colors ColorScheme
        on_colors = function(colors)
          colors.error = colors.red_faint -- Change error color to the "faint" variant
        end,

        --- You can override specific highlights to use other groups or a hex color
        --- function will be called with a Highlights and ColorScheme table
        ---@param highlights Highlights
        ---@param colors ColorScheme
        on_highlights = function(highlights, colors) end,
      })

      vim.cmd("colorscheme ${cfg.flavour}")
      '';
    };
}
