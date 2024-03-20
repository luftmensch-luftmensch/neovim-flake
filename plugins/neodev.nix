{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.neodev.enable = mkEnableOption "Enable neodev";

  config = let
    cfg = config.plugins.neodev;
  in
    mkIf cfg.enable {
      extraPlugins = [pkgs.vimPlugins.neodev-nvim];
      extraConfigLua = ''
        -- [Neodev setup] --
        require("neodev").setup({})
      '';
    };
}
