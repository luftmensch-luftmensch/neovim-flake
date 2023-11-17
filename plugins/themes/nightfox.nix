{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.colorscheme.nightfox = {
    enable = mkEnableOption "A highly customizable theme for vim";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.nightfox-nvim;
      description = "Package to use for nightfox theme";
    };
  };

  config = let
    cfg = config.plugins.colorscheme.nightfox;

  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
      require('nightfox').setup({
        options = {
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          }
        }
      })

      -- setup must be called before loading
      vim.cmd("colorscheme carbonfox")
      '';
    };
}
