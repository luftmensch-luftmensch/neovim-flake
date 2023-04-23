{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.windline = {
    enable = mkEnableOption "Enable windline";
  };

  config = let
    cfg = config.plugins.windline;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [windline-nvim];
      extraConfigLua = ''
      -- [windline status line setup] --
      require('wlsample.evil_line') -- Other pre-defined options to look into -> bubble, bubble2, airline
      '';
    };
}
