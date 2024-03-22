{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.cloak.enable = mkEnableOption "Enable cloak";

  config = let
    cfg = config.plugins.cloak;
  in
    mkIf cfg.enable {
      extraPlugins = [pkgs.vimPlugins.cloak-nvim];
      extraConfigLua = ''
        -- [cloak setup] --
        require('cloak').setup({
          enabled = true,
          cloak_character = '*',
          highlight_group = 'Comment',
          cloak_telescope = true,
          patterns = {
            {
              file_pattern = {
                ".env*",
                ".dev.vars",
              },
              cloak_pattern = '=.+',
            },
          },
        })
      '';
    };
}
