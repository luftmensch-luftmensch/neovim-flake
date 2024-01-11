{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.code.flutter-tools = {
    enable = mkEnableOption "Enable staline";
  };

  config = let
    cfg = config.plugins.code.flutter-tools;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [flutter-tools-nvim];
      extraConfigLua = ''
      -- [flutter-tools setup] --
			require("flutter-tools").setup {} -- use defaults
      '';
    };
}
