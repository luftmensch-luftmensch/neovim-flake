{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.windline = {
    enable = mkEnableOption "Enable windline";

    useCppComment = mkEnableOption "Use c++-style comments instead of c-style";
  };

  config = let
    cfg = config.plugins.windline;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [windline-nvim];
      extraConfigLua = ''
      -- [windline setup] --
      require('wlsample.evil_line') -- Other pre-defined options to look into -> bubble, bubble2, airline
      '';

    };
}
