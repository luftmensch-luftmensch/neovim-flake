{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in {
  
  options.vim.lsp = {

    enable = mkEnableOption "Neovim lsp support";

    capabilities = mkOption {
      type = types.lines;
      description = "LSP capabilities: A function that takes `capabilities` and returns that variable";
    };

    luaLocals = mkOption {
      type = types.lines;
      description = "Lua statements that have access to capabilities &amp; on_attach and are accessible in the servers";
    };

    onAttach = mkEnableOption "On attach function (takes arguments client,buffer)";

    lightbulb = mkEnableOption "Enable nvim-lightbulb: show a lightbulb when a code action is availaible";

    signatures = mkEnableOption "Enable signature popus [lsp_signature]";
    uiProgressInfo = mkEnableOption "Standalone UI for nvim-lsp progress";

    lspLoading = {
      enable = mkOption {
        type = types.bool;
        description = "Show lsp loading information as virtual text";
      };
    };

    diagnosticsPopup = mkOption {
      type = types.bool;
      description = "Enable a diagnostics popup";
    };

    diagnosticSignCustomization = mkEnableOption "Customize diagnostic signs";

    null-ls = {
      enable = mkOption {
        type = types.bool;
        description = "Enable null-ls";
      };

      sources = mkOption {
        type = with types; listOf str;
        default = [
          "builtins.formatting.alejandra"
          "builtins.formatting.black"
          "builtins.formatting.stylua"
          "builtins.formatting.trim_whitespace"
          "builtins.diagnostics.shellcheck"
          "builtins.diagnostics.cppcheck"
          "builtins.diagnostics.gitlint"
          "builtins.formatting.cbfmt"
          "builtins.formatting.shfmt"
          "builtins.formatting.taplo"
          "builtins.formatting.prettier"
          "builtins.code_actions.shellcheck"
        ];
        description = "Enabled sources";
      };

      
    };

    lang = {
      clang = {
        enable = mkEnableOption "C LSP language";
      };

      nix = {
        enable = mkOption {
          type = types.bool;
          description = "Enable Nix support";
        };

        server = mkOption {
          type = with types; enum ["rnix" "nil"];
          default = "nil";
          description = "Which LSP to use";
        };

        pkg = mkOption {
          type = types.package;
          default =
            if (cfg.lang.nix.server == "rnix")
            then pkgs.rnix-lsp
            else pkgs.nil;
          description = "The LSP package to use";
        };
      };

      bash = {
        enable = mkOption {
          type = types.bool;
          description = "Enable bash-language-server";
        };
      };
    };

  };
  
  config = mkIf cfg.enable (
    let
      writeIf = cond: msg: if cond then msg else "";
      sourcesManipulator = sources: concatStringsSep ", " (map (source: "null_ls.${source}") sources);
    in {
      vim.startPlugins = [
        "nvim-lspconfig"
        "nvim-fidget"
        "inc-rename"
        "null-ls"

        (if cfg.signatures then "lsp-signature" else null)
        (if cfg.lightbulb  then "nvim-lightbulb" else null )

        (if cfg.lang.clang.enable then "clangd_extensions" else null)


        (if (config.vim.autocomplete.enable && (config.vim.autocomplete.type == "nvim-cmp"))
         then "cmp-nvim-lsp"
         else null)
      ];

      vim.configRC.lightbulb = mkIf cfg.lightbulb (nvim.dag.entryAnywhere ''
              autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
      '');

      vim.luaConfigRC.lsp = nvim.dag.entryAnywhere ''
        --- LSP SETUP ---

        ${writeIf cfg.signatures ''
        -- [lsp_signature setup] --
        require'lsp_signature'.setup()
        ''}

        ${writeIf cfg.lightbulb ''
        -- [nvim-lightbulb setup] --
        require'nvim-lightbulb'.setup()
        ''}

        -- [null-ls setup] --
        local on_attach = function(client,buffer)
            ${toString cfg.onAttach}
        end
        local null_ls = require("null-ls")

        local sources =  { ${sourcesManipulator cfg.null-ls.sources} }

        null_ls.setup({
            sources = sources,
            on_attach = on_attach
        })

        ${writeIf cfg.diagnosticSignCustomization ''
        -- [diagnostic signs setup] --
        vim.fn.sign_define('DiagnosticSignError', {text = 'ﮢ', texthl='DiagnosticSignError'})

        vim.fn.sign_define('DiagnosticSignWarn',  {text = '', texthl='DiagnosticSignWarn'})

        vim.fn.sign_define('DiagnosticSignInfo',   {text = '', texthl='DiagnosticSignInfo'})

        vim.fn.sign_define('DiagnosticSignOther', {text = '', texthl='DiagnosticSignOther'})

        vim.fn.sign_define('DiagnosticSignHint',   {text = '', texthl='DiagnosticSignHint'})
        ''}

        -- [nvim-cmp setup] --

        local capabilities = vim.lsp.protocol.make_client_capabilities()

        capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- [lspconfig bash setup] --
        require("lspconfig")["bashls"].setup({
            settings = {},
            capabilities = capabilities,
            on_attach = on_attach
        });

        -- [lspconfig nix setup] --
        require("lspconfig")["nil_ls"].setup({
            settings = {},
            cmd = {"${cfg.lang.nix.pkg}/bin/nil"},
            capabilities = capabilities,
            on_attach = default_on_attach
        });
        -- [fidget setup] --
        require"fidget".setup{}

        -- [lspconfig clangd setup] --
        function table.shallow_copy(t)
          local t2 = {}
          for k,v in pairs(t) do
            t2[k] = v
          end
          return t2
        end


        --require("lspconfig")["ccls"].setup({
        --    capabilities = capabilities,
        --    on_attach = on_attach
        --});


        local clangd_caps = table.shallow_copy(capabilities)
        clangd_caps.offsetEncoding = { "utf-16" }

        require("clangd_extensions").setup {
            server = {
                capabilities = clangd_caps,
                on_attach = on_attach,
                init_options = {clangFileStatus = true}
            }
        }

      '';
      
    }

  );
}
