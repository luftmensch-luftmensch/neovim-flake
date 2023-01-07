{pkgs, config, lib, ...}:
with lib; {
  config = {
    vim.lsp = {
      enable = mkDefault false;
      capabilities = mkDefault false;
      luaLocals = mkDefault "";
      onAttach = mkDefault "";
      
      lightbulb = mkDefault false;
      signatures = mkDefault false;
      uiProgressInfo.enable = mkDefault false;
      lspLoading = mkDefault false;
      diagnosticsPopup = mkDefault false;
      diagnosticSignCustomization = mkDefault false;
      null-ls = {
        enable = mkDefault false;
        sources = mkDefault [];
      };

      lang = {
        c = {
          enable = mkDefault false;
        };

        nix = {
          enable = mkDefault false;
          server = mkDefault "nil";
          pkg    = mkDefault pkgs.nil;
        };

        bash = {
          enable = mkDefault false;
        };
      };
    };
  };
}
