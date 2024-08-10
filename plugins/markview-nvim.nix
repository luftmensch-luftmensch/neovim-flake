{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.plugins.markview-nvim.enable = mkEnableOption "Enhanced markdown previewer";

  config =
    let
      cfg = config.plugins.markview-nvim;
    in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [ markview-nvim ];

      extraConfigLua = ''
        require("markview").setup({
            modes = { "n", "i", "no", "c" },
            hybrid_modes = { "i" },

            -- This is nice to have
            callbacks = {
                on_enable = function (_, win)
                    vim.wo[win].conceallevel = 2;
                    vim.wo[win].concealcursor = "nc";
                end
            }
        })
      '';
    };
}
