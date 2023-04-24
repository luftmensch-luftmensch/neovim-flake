{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.nvim-cursorline = {
    enable = mkEnableOption "Enable highlighting cursor words and lines with nvim-cursorline";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.nvim-cursorline;
      description = "Package to use for nvim-cursorline";
    };
  };

  config = let
    cfg = config.plugins.nvim-cursorline;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
      -- [nvim-cursorline setup] --
      require('nvim-cursorline').setup {
        cursorword = {
          enable      = 3,
          min_length  = 3,
          hl = {
            underline = true 
          }
        }
      }
      '';
    };
}

