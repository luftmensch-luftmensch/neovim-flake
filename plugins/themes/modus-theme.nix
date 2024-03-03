{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.colorschemes.modus-theme = {
    enable = mkEnableOption "A Neovim port of the original Modus Themes built for GNU Emacs.";
  };

  config = let
    cfg = config.colorschemes.modus-theme;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [modus-themes-nvim];

      extraConfigLua = ''
        -- Theme customization
        require("modus-themes").setup({
          style = "modus_vivendi",
          variant = "default",
          transparent = true,
          dim_inactive = true,
          styles = {
            -- Style to be applied to different syntax groups
            -- Value is any valid attr-list value for `:help nvim_set_hl`
            comments = { italic = true },
            keywords = { italic = true },
          },
        })
        -- Load theme
        vim.cmd([[colorscheme modus]]) 
      '';
    };
}
