{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.mason = {
    enable = mkEnableOption "Enable mason";
  };


  config = let
    cfg = config.plugins.mason;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [ mason-nvim mason-lspconfig-nvim ];
      extraConfigLua = ''
      -- [mason setup] --
      require("mason").setup({
          ui = {
              icons = {
                  package_installed = "✓",
                  package_pending = "➜",
                  package_uninstalled = "✗"
              }
          }
      })

      -- [mason-lspconfig setup] --
      require("mason-lspconfig").setup()
      '';
      
    };

}
