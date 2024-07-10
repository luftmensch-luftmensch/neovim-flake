{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.silicon;
  flavours = [
    "1337"
    "Coldark-Cold"
    "Coldark-Dark"
    "DarkNeon"
    "Dracula"
    "GitHub"
    "Monokai Extended"
    "Monokai Extended Bright"
    "Monokai Extended Light"
    "Monokai Extended Origin"
    "Nord"
    "OneHalfDark"
    "OneHalfLight"
    "Solarized (dark)"
    "Solarized (light)"
    "Sublime Snazzy"
    "TwoDark"
    "Visual Studio Dark+"
    "ansi"
    "base16"
    "base16-256"
    "gruvbox-dark"
    "gruvbox-light"
    "zenburn"
  ];
in
{
  options.plugins.silicon = {
    enable = mkEnableOption "Enable nvim-silicon";
    flavour = helpers.defaultNullOpts.mkEnumFirstDefault flavours "Theme flavour";
  };

  config = mkIf cfg.enable {
    extraPlugins = with pkgs.vimPlugins; [ nvim-silicon ];
    extraConfigLua = ''
      require('silicon').setup {
        font                = "VictorMono NF=34",
        theme               = '${cfg.flavour}',
        gobble              = true,
        background          = '#000000ff',
        pad_horiz           = 16,
        pad_vert            = 16,
        tab_width           = 2,
        shadow_offset_x     = 0,
        shadow_offset_y     = 0,
        shadow_blur_radius  = 0,
        output = function()
          return "~/" .. os.date("!%d-%m-%Y %H-%M-%S") .. ".png"
        end,
        command = "${lib.getExe pkgs.silicon}",
        window_title = function()
          local fn = vim.api.nvim_buf_get_name(0)
          if vim.fn.empty(fn) == 1 then return end
          return vim.fn.fnamemodify(fn, ':~:.')
        end,
      }
    '';
  };
}
